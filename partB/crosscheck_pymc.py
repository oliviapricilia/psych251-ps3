"""Independent cross-check (Python/PyMC) of Bian et al. (2018) Study 1 brms model.

Not the primary reproduction (that is the R/brms code in partB_bian2018.qmd); this
re-implements the same model in a different MCMC engine as a sanity check, because R
was not available in the agent's sandbox.

Model (as in _syntax_and_output.R and the paper):
  nominated_woman ~ bernoulli(logit^-1(a + X b + u_subj))
  X = brilliance_c * female_c * stereotype_c (all 2- and 3-way interactions)
  b ~ Normal(0, 1); a ~ StudentT(3, 0, 10) [brms 2018 default]; u_subj ~ Normal(0, sd)
  sd ~ HalfStudentT(3, 0, 10) [brms 2018 default, per paper]
Usage: python3 crosscheck_pymc.py path/to/Study1.csv
"""
import sys
import numpy as np
import pandas as pd
import pymc as pm
import arviz as az
import statsmodels.formula.api as smf

d = pd.read_csv(sys.argv[1])
subj_idx, subj_levels = pd.factorize(d["subj"])
B, F, S = d["brilliance_c"].values, d["female_c"].values, d["stereotype_c"].values
X = np.column_stack([B, F, S, B * F, B * S, F * S, B * F * S])
names = ["brilliance_c", "female_c", "stereotype_c", "brilliance_c:female_c",
         "brilliance_c:stereotype_c", "female_c:stereotype_c", "brilliance_c:female_c:stereotype_c"]

# 1) Frequentist fixed-effects logistic regression (no random intercept), for orientation
glm = smf.logit("nominated_woman ~ brilliance_c*female_c*stereotype_c", data=d).fit(disp=0)
print("Plain logistic regression (no random effect):")
print(glm.params.round(4).to_string(), "\n")

# 2) Bayesian mixed model mirroring brms
with pm.Model() as m:
    a = pm.StudentT("Intercept", nu=3, mu=0, sigma=10)
    b = pm.Normal("b", 0, 1, shape=X.shape[1])
    sd = pm.HalfStudentT("sd_subj", nu=3, sigma=10)
    z = pm.Normal("z", 0, 1, shape=len(subj_levels))
    eta = a + pm.math.dot(X, b) + sd * z[subj_idx]
    pm.Bernoulli("y", logit_p=eta, observed=d["nominated_woman"].values)
    idata = pm.sample(draws=2500, tune=2500, chains=4, target_accept=0.99,
                      random_seed=251, progressbar=False)

post_b = idata.posterior["b"].values.reshape(-1, X.shape[1])
post_a = idata.posterior["Intercept"].values.ravel()
print("Bayesian mixed model (PyMC), posterior mean [95% CrI]:")
for i, n in enumerate(names):
    lo, hi = np.percentile(post_b[:, i], [2.5, 97.5])
    print(f"  {n:38s} {post_b[:, i].mean(): .4f} [{lo: .4f}, {hi: .4f}]")
sdv = idata.posterior["sd_subj"].values.ravel()
print(f"  sd(Intercept) {sdv.mean():.4f} [{np.percentile(sdv,2.5):.4f}, {np.percentile(sdv,97.5):.4f}]")
print("  max R-hat:", float(az.rhat(idata, var_names=["Intercept", "b", "sd_subj"]).to_array().max()))

# Marginal means as brms marginal_effects(): other predictors at their mean (~0), random effect = 0
def margin(lin):
    p = 1 / (1 + np.exp(-lin))
    return f"{100*np.median(p):.1f}% [{100*np.percentile(p,2.5):.1f}, {100*np.percentile(p,97.5):.1f}]"

bvals = sorted(d["brilliance_c"].unique()); fvals = sorted(d["female_c"].unique())
fm, sm = d["female_c"].mean(), d["stereotype_c"].mean()
bm = d["brilliance_c"].mean()
def lin(bv, fv, sv):
    x = np.array([bv, fv, sv, bv*fv, bv*sv, fv*sv, bv*fv*sv])
    return post_a + post_b @ x
print("\nMarginal means (% female referrals):")
print("  control     ", margin(lin(bvals[0], fm, sm)))
print("  experimental", margin(lin(bvals[1], fm, sm)))
print("  men         ", margin(lin(bm, fvals[0], sm)))
print("  women       ", margin(lin(bm, fvals[1], sm)))
print("\nOdds change, condition: {:.1f}%".format(100 * (np.exp(post_b[:, 0].mean()) - 1)))
print("Odds change, stereotype: {:.1f}%".format(100 * (np.exp(post_b[:, 2].mean()) - 1)))
