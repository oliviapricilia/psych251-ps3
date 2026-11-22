# --------------------------------------------------------------------------------------------------
# Notes:
# To run models using brms in windows -- download RTools and put in path of R
# To run models using brms in mac -- download xcode from app store and open app at least once
# --------------------------------------------------------------------------------------------------

require(brms)
require(rstan)
require(Rcpp)
require(scales)
require(gridExtra)
require(tidyverse)
require(effects)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

####################################
####   STUDY 1    ##################
####################################


Study1 <- read.csv("C:\\Study1.csv")


model_Study1 <- brm(nominated_woman ~ brilliance_c*female_c*stereotype_c + (1|subj),
                    data=Study1,
                    family="bernoulli", 
                    chains=4, 
                    sample_prior=TRUE,
                    iter=5000, 
                    warmup=2500, 
                    control = list(adapt_delta = .99),
                    prior = c(set_prior("normal(0,1)", class = "b"))) 

print(summary(model_Study1), digits=4)
# > print(summary(model_Study1), digits=4)
# Family: bernoulli 
# Links: mu = logit 
# Formula: nominated_woman ~ brilliance_c * female_c * stereotype_c + (1 | subj) 
# Data: Study1 (Number of observations: 691) 
# Samples: 4 chains, each with iter = 5000; warmup = 2500; thin = 1; 
# total post-warmup samples = 10000
# ICs: LOO = NA; WAIC = NA; R2 = NA
# 
# Group-Level Effects: 
#   ~subj (Number of levels: 347) 
#                Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# sd(Intercept)   0.1829    0.1332   0.0080   0.4929       3246 1.0002
# 
# Population-Level Effects: 
#                                               Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# Intercept                                     -0.1355    0.0830  -0.2977   0.0267      10000 1.0001
# brilliance_c                                  -0.4834    0.1640  -0.8066  -0.1651      10000 1.0000
# female_c                                       0.9665    0.1670   0.6350   1.3009      10000 0.9999
# stereotype_c                                  -0.0873    0.0473  -0.1806   0.0071      10000 0.9999
# brilliance_c:female_c                         -0.1468    0.3271  -0.7903   0.4899      10000 0.9999
# brilliance_c:stereotype_c                     -0.0800    0.0918  -0.2606   0.1000      10000 0.9997
# female_c:stereotype_c                          0.0053    0.0955  -0.1832   0.1929      10000 1.0001
# brilliance_c:female_c:stereotype_c            -0.2740    0.1863  -0.6369   0.0844      10000 0.9998


# PREDICTED MARGINAL MEANS

# PREDICTED MARGINAL MEANS BY CONDITION
m_study1 <- marginal_effects(model_Study1,resolution=2)
str(m_study1)
m_study1$'brilliance_c'
# > m_study1$'brilliance_c'
# brilliance_c nominated_woman     female_c stereotype_c subj cond__             estimate__       se__   lower__
# 1   -0.4862518       0.4703329 1.519537e-08          -2.289436e-09   NA      1  0.5249237 0.02839404 0.4680123
# 2    0.5137482       0.4703329 1.519537e-08          -2.289436e-09   NA      1  0.4052276 0.02836277 0.3505585
# upper__
# 1 0.5800900
# 2 0.4612173

# PREDICTED MARGINAL MEANS BY GENDER
m_study1$'female_c'
# > m_study1$'female_c'
# female_c nominated_woman  brilliance_c stereotype_c subj cond__               estimate__       se__   lower__
# 1 -0.5976845       0.4703329 -5.615051e-09          -2.289436e-09   NA      1  0.3294878 0.03000565 0.2732951
# 2  0.4023155       0.4703329 -5.615051e-09          -2.289436e-09   NA      1  0.5629401 0.02565588 0.5124114
# upper__
# 1 0.3879767
# 2 0.6119473



####################################
####   STUDY 2    ##################
####################################


Study2 <- read.csv("C:\\Study2.csv")

model_Study2 <- brm(nominated_woman ~ brilliance_c*female_c*white_c*stereotype_c + (1|subj),
                            data=Study2,
                            family="bernoulli", 
                            chains=4, 
                            sample_prior=TRUE,
                            iter=5000, 
                            warmup=2500, 
                            control = list(adapt_delta = .99),
                            prior = c(set_prior("normal(0,1)", class = "b"))) 

print(summary(model_Study2),digits=4)
# > print(summary(model_Study2),digits=4)
# Family: bernoulli 
# Links: mu = logit 
# Formula: nominated_woman ~ brilliance_c * female_c * white_c * stereotype_c + (1 | subj) 
# Data: Study2 (Number of observations: 1597) 
# Samples: 4 chains, each with iter = 5000; warmup = 2500; thin = 1; 
# total post-warmup samples = 10000
# ICs: LOO = NA; WAIC = NA; R2 = NA
# 
# Group-Level Effects: 
#   ~subj (Number of levels: 811) 
#                Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# sd(Intercept)   0.1296    0.0969   0.0047   0.3531       2550 1.0009
# 
# Population-Level Effects: 
#                                                       Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# Intercept                                             -0.0956    0.0556  -0.2021   0.0127      10000 1.0000
# brilliance_c                                          -0.2224    0.1097  -0.4438  -0.0067      10000 0.9997
# female_c                                               1.1965    0.1127   0.9753   1.4173      10000 0.9998
# white_c                                               -0.3334    0.1119  -0.5500  -0.1163      10000 1.0001
# stereotype_c                                          -0.0510    0.0298  -0.1091   0.0082      10000 0.9998
# brilliance_c:female_c                                 -0.3647    0.2186  -0.7861   0.0650      10000 0.9998
# brilliance_c:white_c                                   0.2431    0.2176  -0.1796   0.6742      10000 0.9999
# female_c:white_c                                      -0.0382    0.2297  -0.4850   0.4032      10000 0.9999
# brilliance_c:stereotype_c                              0.0411    0.0579  -0.0735   0.1538      10000 0.9998
# female_c:stereotype_c                                  0.1170    0.0592   0.0010   0.2334      10000 1.0000
# white_c:stereotype_c                                   0.0109    0.0584  -0.1052   0.1248      10000 0.9997
# brilliance_c:female_c:white_c                         -0.4784    0.4207  -1.2946   0.3534      10000 0.9999
# brilliance_c:female_c:stereotype_c                    -0.1558    0.1144  -0.3816   0.0679      10000 0.9997
# brilliance_c:white_c:stereotype_c                     -0.0663    0.1138  -0.2925   0.1617      10000 0.9998
# female_c:white_c:stereotype_c                          0.1558    0.1167  -0.0736   0.3864      10000 0.9999
# brilliance_c:female_c:white_c:stereotype_c            -0.2798    0.2286  -0.7245   0.1711      10000 0.9998



# PREDICTED MARGINAL MEANS

# PREDICTED MARGINAL MEANS BY CONDITION
m_Study2 <- marginal_effects(model_Study2, resolution = 2)
str(m_Study2)
m_Study2$'brilliance_c'
# > m_Study2$'brilliance_c'
#   brilliance_c nominated_woman     female_c       white_c stereotype_c subj cond__             estimate__       se__
# 1   -0.4571071       0.4752661 1.315592e-08 -5.247339e-09           6.327113e-08   NA      1  0.5014107 0.01902996
# 2    0.5428929       0.4752661 1.315592e-08 -5.247339e-09           6.327113e-08   NA      1  0.4462106 0.01945763
# lower__   upper__
# 1 0.4642609 0.5400946
# 2 0.4085912 0.4849233


# PREDICTED MARGINAL MEANS BY GENDER
m_Study2$'female_c'
# > m_Study2$'female_c'
# female_c nominated_woman brilliance_c       white_c stereotype_c subj cond__               estimate__       se__
# 1 -0.5560426       0.4752661 5.767063e-09 -5.247339e-09           6.327113e-08   NA      1  0.3187379 0.01865158
# 2  0.4439574       0.4752661 5.767063e-09 -5.247339e-09           6.327113e-08   NA      1  0.6069888 0.01704365
# lower__   upper__
# 1 0.2820810 0.3564264
# 2 0.5731051 0.6407987


# PREDICTED MARGINAL MEANS BY ETHNICITY
m_Study2$'white_c'
# > m_Study2$'white_c'
# white_c nominated_woman brilliance_c     female_c stereotype_c subj cond__                estimate__       se__
# 1 -0.5516593       0.4752661 5.767063e-09 1.315592e-08           6.327113e-08   NA      1  0.5221070 0.02113186
# 2  0.4483406       0.4752661 5.767063e-09 1.315592e-08           6.327113e-08   NA      1  0.4389824 0.01814659
# lower__   upper__
# 1 0.4805765 0.5634047
# 2 0.4037357 0.4743353



#############################################################
####   META-ANALYSIS OF STUDIES 1 and 2    ##################
#############################################################


Study12 <- read.csv("C:\\Study12.csv")


model_Study12 <- brm(nominated_woman ~ brilliance_c*female_c*stereotype_c + (1 | subj) + (1 + brilliance_c | subj:study),
                     data=Study12,
                     family="bernoulli", 
                     chains=4, 
                     sample_prior=TRUE,
                     iter=5000, 
                     warmup=2500, 
                     control = list(adapt_delta = .99),
                     prior = c(set_prior("normal(0,1)", class = "b"))) 

print(summary(model_Study12),digits=4)
# > print(summary(model_Study12),digits=4)
# Family: bernoulli 
# Links: mu = logit 
# Formula: nominated_woman ~ brilliance_c * female_c * stereotype_c + (1 | subj) + (1 + brilliance_c | subj:study) 
# Data: Study12 (Number of observations: 2288) 
# Samples: 4 chains, each with iter = 5000; warmup = 2500; thin = 1; 
# total post-warmup samples = 10000
# ICs: LOO = NA; WAIC = NA; R2 = NA
# 
# Group-Level Effects: 
#   ~subj (Number of levels: 1158) 
#                                    Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# sd(Intercept)                       0.1015    0.0770   0.0035   0.2897       2757 1.0020
# sd:study(Intercept)                 0.1012    0.0767   0.0043   0.2805       2423 1.0004
# sd:study(brilliance_c)              0.2037    0.1528   0.0096   0.5703       2476 1.0004
# cor:study(Intercept,brilliance_c)   0.0143    0.5752  -0.9423   0.9484       4887 1.0001
# 
# ~subj:study (Number of levels: 1158) 
#                             Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# sd(Intercept)                 0.1012    0.0767   0.0043   0.2805       2423 1.0004
# sd(brilliance_c)              0.2037    0.1528   0.0096   0.5703       2476 1.0004
# cor(Intercept,brilliance_c)   0.0143    0.5752  -0.9423   0.9484       4887 1.0001
# 
# Population-Level Effects: 
#                                               Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# Intercept                                     -0.1054    0.0453  -0.1940  -0.0152      10000 0.9997
# brilliance_c                                  -0.2915    0.0905  -0.4703  -0.1114      10000 0.9998
# female_c                                       1.1591    0.0923   0.9770   1.3414      10000 0.9998
# stereotype_c                                  -0.0536    0.0242  -0.1008  -0.0067      10000 0.9998
# brilliance_c:female_c                         -0.3293    0.1843  -0.6841   0.0276      10000 1.0000
# brilliance_c:stereotype_c                      0.0164    0.0478  -0.0765   0.1099      10000 0.9998
# female_c:stereotype_c                          0.0867    0.0481  -0.0063   0.1807      10000 0.9998
# brilliance_c:female_c:stereotype_c            -0.1758    0.0964  -0.3670   0.0150      10000 0.9997


# PREDICTED MARGINAL MEANS

m_study12 <- marginal_effects(model_Study12, resolution = 2)
str(m_study12)
m_study12$'brilliance_c'
# > m_study12$'brilliance_c'
# brilliance_c nominated_woman      female_c 		stereotype_c subj study cond__ 	estimate__       se__   lower__
# 1   -0.4659091       0.4737762 -8.881119e-09           2.212719e-08   NA    NA      1   0.507597 0.01548497 0.4770072
# 2    0.5340909       0.4737762 -8.881119e-09           2.212719e-08   NA    NA      1   0.435147 0.01586816 0.4037341
# upper__
# 1 0.5382586
# 2 0.4669658



####################################
####   STUDY 3    ##################
####################################



Study3 <- read.csv("C:\\Study3.csv")


model_Study3 <- brm(chose_girl ~ brilliance_c*female_c*age_c*stereotype_c*trial_c + (1|subj),
                              data=Study3,
                              family="bernoulli", 
                              chains=4, 
                              sample_prior=TRUE,
                              iter=5000, 
                              warmup=2500, 
                              control = list(adapt_delta = .99),
                              prior = c(set_prior("normal(0,1)", class = "b"))) 

print(summary(model_Study3),digits=4)
# > print(summary(model_Study3),digits=4)
# Family: bernoulli 
# Links: mu = logit 
# Formula: chose_girl ~ brilliance_c * female_c * age_c * stereotype_c * trial_c + (1 | subj) 
# Data: Study3 (Number of observations: 1149) 
# Samples: 4 chains, each with iter = 5000; warmup = 2500; thin = 1; 
# total post-warmup samples = 10000
# ICs: LOO = NA; WAIC = NA; R2 = NA
# 
# Group-Level Effects: 
#   ~subj (Number of levels: 192) 
#               Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# sd(Intercept)   1.2364    0.1501   0.9647   1.5459       3843 1.0000
# 
# Population-Level Effects: 
#                                                Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# Intercept                                        0.1671    0.1250  -0.0798   0.4150       6056 1.0000
# brilliance_c                                    -0.2253    0.2419  -0.6994   0.2463       6431 0.9999
# female_c                                         2.3654    0.2545   1.8789   2.8714       6437 1.0003
# age_c                                           -0.3053    0.1424  -0.5878  -0.0259       6383 0.9999
# stereotype_c                                    -1.4301    0.4576  -2.3232  -0.5423       7754 1.0011
# trial_c                                         -0.3531    0.0985  -0.5485  -0.1615      10000 1.0000
# brilliance_c:female_c                           -0.7036    0.4417  -1.5606   0.1598       7806 0.9997
# brilliance_c:age_c                               0.0824    0.2714  -0.4473   0.6175       6881 1.0000
# female_c:age_c                                  -0.0255    0.2813  -0.5636   0.5294       6709 1.0003
# brilliance_c:stereotype_c                        0.4668    0.7171  -0.9463   1.8696      10000 0.9999
# female_c:stereotype_c                           -0.1852    0.7189  -1.5952   1.2150      10000 0.9999
# age_c:stereotype_c                               0.8575    0.5103  -0.1603   1.8533       7887 0.9999
# brilliance_c:trial_c                            -0.4167    0.1946  -0.8054  -0.0372      10000 0.9998
# female_c:trial_c                                -0.6165    0.1899  -0.9905  -0.2443      10000 0.9998
# age_c:trial_c                                    0.2175    0.1144  -0.0042   0.4451      10000 0.9997
# stereotype_c:trial_c                             0.5716    0.3881  -0.1697   1.3378      10000 1.0000
# brilliance_c:female_c:age_c                     -0.4855    0.4994  -1.4646   0.5007       8199 1.0002
# brilliance_c:female_c:stereotype_c               0.2746    0.8918  -1.5175   2.0123      10000 0.9998
# brilliance_c:age_c:stereotype_c                 -0.6408    0.7609  -2.1126   0.8706      10000 1.0000
# female_c:age_c:stereotype_c                      0.2796    0.7545  -1.2069   1.7501      10000 0.9999
# brilliance_c:female_c:trial_c                   -0.1985    0.3683  -0.9161   0.5277      10000 1.0000
# brilliance_c:age_c:trial_c                      -0.3118    0.2187  -0.7375   0.1135      10000 0.9998
# female_c:age_c:trial_c                          -0.2608    0.2209  -0.6921   0.1764      10000 0.9999
# brilliance_c:stereotype_c:trial_c               -0.1460    0.6346  -1.4054   1.1057      10000 1.0000
# female_c:stereotype_c:trial_c                   -0.7644    0.6430  -2.0274   0.4933      10000 0.9997
# age_c:stereotype_c:trial_c                       0.8134    0.4238  -0.0082   1.6407      10000 0.9998
# brilliance_c:female_c:age_c:stereotype_c         0.6151    0.9179  -1.1918   2.4096      10000 1.0000
# brilliance_c:female_c:age_c:trial_c              0.3543    0.4147  -0.4595   1.1692      10000 0.9998
# brilliance_c:female_c:stereotype_c:trial_c       0.0713    0.8687  -1.6610   1.7464      10000 0.9998
# brilliance_c:age_c:stereotype_c:trial_c          0.9142    0.6894  -0.4238   2.2638      10000 1.0000
# female_c:age_c:stereotype_c:trial_c             -0.4843    0.6895  -1.8464   0.8609      10000 0.9998
# brilliance_c:female_c:age_c:stereotype_c:trial_c 0.1752    0.9004  -1.5904   1.9821      10000 0.9997




# PREDICTED MARGINAL MEANS

# PREDICTED MARGINAL MEANS FOR THE CONDITION x SELECTION ROUND INTERACTION  (ALSO USED IN FIGURE 1)
conds <- data.frame(trial_c=unique(Study3$trial_c))
m_Study3_trialxbrill <- marginal_effects(model_Study3, "brilliance_c", conditions = conds)
str(m_Study3_trialxbrill)
subset(m_Study3_trialxbrill$'brilliance_c', brilliance_c==-.50 | brilliance_c==.50)
# > subset(m_Study3_trialxbrill$'brilliance_c', brilliance_c==-.50 | brilliance_c==.50)
#     brilliance_c trial_c chose_girl   female_c       age_c   stereotype_c subj cond__ estimate__       se__   lower__
# 1           -0.5      -1  0.5265448 -0.000435161 0.002163244 0.000484479   NA      1  0.6033456 0.05748986 0.4849507
# 100          0.5      -1  0.5265448 -0.000435161 0.002163244 0.000484479   NA      1  0.6483845 0.04993971 0.5455619
# 101         -0.5       0  0.5265448 -0.000435161 0.002163244 0.000484479   NA      2  0.5685146 0.04369326 0.4800259
# 200          0.5       0  0.5265448 -0.000435161 0.002163244 0.000484479   NA      2  0.5136131 0.04177718 0.4308520
# 201         -0.5       1  0.5265448 -0.000435161 0.002163244 0.000484479   NA      3  0.5338103 0.05364030 0.4278970
# 300          0.5       1  0.5265448 -0.000435161 0.002163244 0.000484479   NA      3  0.3758794 0.04877000 0.2855456
# upper__
# 1   0.7080242
# 100 0.7411257
# 101 0.6513858
# 200 0.5946452
# 201 0.6370953
# 300 0.4738721


# PREDICTED MARGINAL MEANS FOR FIGURE 2 (i.e., for the 3-way interaction between participant gender, condition, and selection round)
conditions<-data.frame(trial_c=unique(Study3$trial_c))
m_Study3_trialxbrillxgender<-marginal_effects(model_Study3,"female_c:brilliance_c", conditions=conditions)
str(m_Study3_trialxbrillxgender)
subset(m_Study3_trialxbrillxgender$'female_c', (female_c==-.50 | female_c==.50) & (brilliance_c==-.50 | brilliance_c==.50))
# > subset(m_Study3_trialxbrillxgender$'female_c', (female_c==-.50 | female_c==.50) & (brilliance_c==-.50 | brilliance_c==.50))
#     female_c brilliance_c trial_c chose_girl       age_c   stereo2_c subj cond__ estimate__       se__   lower__   upper__
# 1       -0.5         -0.5      -1  0.5265448 0.002163244 0.000484479   NA      1  0.2331068 0.05601359 0.1380552 0.3579991
# 3       -0.5          0.5      -1  0.5265448 0.002163244 0.000484479   NA      1  0.3217754 0.06407587 0.2086461 0.4506617
# 298      0.5         -0.5      -1  0.5265448 0.002163244 0.000484479   NA      1  0.8841041 0.03492403 0.7984962 0.9388363
# 300      0.5          0.5      -1  0.5265448 0.002163244 0.000484479   NA      1  0.8778037 0.03426544 0.7949964 0.9325124
# 301     -0.5         -0.5       0  0.5265448 0.002163244 0.000484479   NA      2  0.2544301 0.04584832 0.1721623 0.3491379
# 303     -0.5          0.5       0  0.5265448 0.002163244 0.000484479   NA      2  0.2787691 0.04676954 0.1948191 0.3765553
# 598      0.5         -0.5       0  0.5265448 0.002163244 0.000484479   NA      2  0.8363386 0.03473519 0.7586419 0.8947881
# 600      0.5          0.5       0  0.5265448 0.002163244 0.000484479   NA      2  0.7420109 0.04496524 0.6469408 0.8211944
# 601     -0.5         -0.5       1  0.5265448 0.002163244 0.000484479   NA      3  0.2760545 0.06036933 0.1742510 0.4030330
# 603     -0.5          0.5       1  0.5265448 0.002163244 0.000484479   NA      3  0.2401201 0.05314574 0.1484484 0.3583317
# 898      0.5         -0.5       1  0.5265448 0.002163244 0.000484479   NA      3  0.7745215 0.05468183 0.6541401 0.8631001
# 900      0.5          0.5       1  0.5265448 0.002163244 0.000484479   NA      3  0.5344823 0.07025056 0.3976126 0.6693634



### MODEL JUST FOR THE FIRST TRIAL

model_Study3_trial1 <- brm(chose_girl ~ brilliance_c*female_c*age_c*stereotype_c + (1|subj),
                           data=subset(Study3,trial==1),
                           family="bernoulli", 
                           chains=4, 
                           sample_prior=TRUE,
                           iter=5000, 
                           warmup=2500, 
                           control = list(adapt_delta = .99),
                           prior = c(set_prior("normal(0,1)", class = "b"))) 

print(summary(model_Study3_trial1),digits=4)
# > print(summary(model_Study3_trial1),digits=4)
# Family: bernoulli 
# Links: mu = logit 
# Formula: chose_girl ~ brilliance_c * female_c * age_c * stereotype_c + (1 | subj) 
# Data: subset(Study3, trial == 1) (Number of observations: 384) 
# Samples: 4 chains, each with iter = 5000; warmup = 2500; thin = 1; 
# total post-warmup samples = 10000
# ICs: LOO = NA; WAIC = NA; R2 = NA
# 
# Group-Level Effects: 
#   ~subj (Number of levels: 192) 
#                Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# sd(Intercept)   1.5460    0.3761   0.8388   2.3078       2156 1.0002
# 
# Population-Level Effects: 
#                                          Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# Intercept                                  0.6095    0.2039   0.2247   1.0320       6380 1.0010
# brilliance_c                               0.2270    0.3755  -0.5029   0.9555       7792 1.0003
# female_c                                   3.3221    0.4435   2.5186   4.2449       4760 1.0000
# age_c                                     -0.7045    0.2326  -1.1775  -0.2650       6807 1.0000
# stereotype_c                              -1.7444    0.6443  -3.0233  -0.4855      10000 1.0002
# brilliance_c:female_c                     -0.1781    0.6182  -1.3944   1.0349      10000 1.0000
# brilliance_c:age_c                         0.2473    0.4285  -0.5895   1.1000       8469 0.9997
# female_c:age_c                             0.3235    0.4208  -0.4988   1.1482       8366 0.9999
# brilliance_c:stereotype_c                  0.0779    0.8641  -1.6049   1.7344      10000 0.9997
# female_c:stereotype_c                      0.2411    0.8537  -1.4336   1.9415      10000 0.9998
# age_c:stereotype_c                         0.4567    0.7126  -0.9272   1.8747      10000 1.0001
# brilliance_c:female_c:age_c               -0.6791    0.6924  -2.0382   0.6895      10000 1.0003
# brilliance_c:female_c:stereotype_c         0.0111    0.9613  -1.9029   1.8993      10000 0.9998
# brilliance_c:age_c:stereotype_c           -0.9502    0.8864  -2.7262   0.7931      10000 0.9998
# female_c:age_c:stereotype_c                0.5712    0.8649  -1.1632   2.2598      10000 0.9998
# brilliance_c:female_c:age_c:stereotype_c   0.1408    0.9552  -1.6917   2.0095      10000 0.9999


### MODEL JUST FOR THE SECOND TRIAL

model_Study3_trial2 <- brm(chose_girl ~ brilliance_c*female_c*age_c*stereotype_c + (1|subj),
                           data=subset(Study3,trial==2),
                           family="bernoulli", 
                           chains=4, 
                           sample_prior=TRUE,
                           iter=5000, 
                           warmup=2500, 
                           control = list(adapt_delta = .99),
                           prior = c(set_prior("normal(0,1)", class = "b"))) 

print(summary(model_Study3_trial2),digits=4)
# > print(summary(model_Study3_trial2),digits=4)
# Family: bernoulli 
# Links: mu = logit 
# Formula: chose_girl ~ brilliance_c * female_c * age_c * stereotype_c + (1 | subj) 
# Data: subset(Study3, trial == 2) (Number of observations: 383) 
# Samples: 4 chains, each with iter = 5000; warmup = 2500; thin = 1; 
# total post-warmup samples = 10000
# ICs: LOO = NA; WAIC = NA; R2 = NA
# 
# Group-Level Effects: 
#   ~subj (Number of levels: 192) 
#               Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# sd(Intercept)   1.5315    0.3500   0.8630   2.2422       2256 1.0003
# 
# Population-Level Effects: 
#                                          Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# Intercept                                  0.1820    0.1834  -0.1645   0.5579       7431 1.0000
# brilliance_c                              -0.1673    0.3426  -0.8498   0.5016      10000 0.9999
# female_c                                   2.1244    0.3800   1.4208   2.9141       6130 1.0004
# age_c                                     -0.0829    0.2080  -0.4892   0.3249       7215 1.0005
# stereotype_c                              -1.0755    0.6071  -2.2908   0.0805      10000 0.9997
# brilliance_c:female_c                     -1.0043    0.5800  -2.1255   0.1220      10000 1.0001
# brilliance_c:age_c                         0.1014    0.3851  -0.6461   0.8567      10000 0.9998
# female_c:age_c                            -0.3129    0.3832  -1.0606   0.4331      10000 1.0001
# brilliance_c:stereotype_c                  0.6989    0.8169  -0.9105   2.3231      10000 0.9997
# female_c:stereotype_c                     -0.1103    0.8316  -1.7475   1.5112      10000 0.9998
# age_c:stereotype_c                         0.0449    0.6395  -1.2032   1.3250      10000 1.0001
# brilliance_c:female_c:age_c               -0.2912    0.6407  -1.5523   0.9638      10000 0.9997
# brilliance_c:female_c:stereotype_c         0.3237    0.9536  -1.5625   2.1998      10000 0.9997
# brilliance_c:age_c:stereotype_c           -0.1668    0.8454  -1.8120   1.4951      10000 0.9998
# female_c:age_c:stereotype_c               -0.0437    0.8487  -1.7062   1.6138      10000 0.9999
# brilliance_c:female_c:age_c:stereotype_c   0.5801    0.9560  -1.2876   2.4420      10000 1.0001


### MODEL JUST FOR THE THIRD TRIAL

model_Study3_trial3 <- brm(chose_girl ~ brilliance_c*female_c*age_c*stereotype_c + (1|subj),
                                        data=subset(Study3,trial==3),
                                        family="bernoulli", 
                                        chains=4, 
                                        sample_prior=TRUE,
                                        iter=5000, 
                                        warmup=2500, 
                                        control = list(adapt_delta = .99),
                                        prior = c(set_prior("normal(0,1)", class = "b"))) 

print(summary(model_Study3_trial3),digits=4)
# > print(summary(model_Study3_trial3),digits=4)
# Family: bernoulli 
# Links: mu = logit 
# Formula: chose_girl ~ brilliance_c * female_c * age_c * stereotype_c + (1 | subj) 
# Data: subset(Study3, trial == 3) (Number of observations: 382) 
# Samples: 4 chains, each with iter = 5000; warmup = 2500; thin = 1; 
# total post-warmup samples = 10000
# ICs: LOO = NA; WAIC = NA; R2 = NA
# 
# Group-Level Effects: 
#   ~subj (Number of levels: 192) 
#               Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# sd(Intercept)   1.8458    0.3741   1.1591   2.6175       2395 1.0015
# 
# Population-Level Effects: 
#                                           Estimate Est.Error l-95% CI u-95% CI Eff.Sample   Rhat
# Intercept                                 -0.1850    0.2047  -0.5905   0.2191       6971 1.0000
# brilliance_c                              -0.7221    0.3758  -1.4968  -0.0069       7250 1.0001
# female_c                                   2.0486    0.4039   1.3019   2.8780       6004 1.0003
# age_c                                     -0.2411    0.2272  -0.6943   0.1947       6851 1.0001
# stereotype_c                              -0.9183    0.6548  -2.2305   0.3819      10000 1.0009
# brilliance_c:female_c                     -0.6144    0.6191  -1.8237   0.6022      10000 1.0003
# brilliance_c:age_c                        -0.2722    0.4133  -1.0850   0.5292       7905 1.0003
# female_c:age_c                            -0.1205    0.4258  -0.9611   0.6987       7439 1.0005
# brilliance_c:stereotype_c                  0.0056    0.8461  -1.6327   1.6535      10000 1.0000
# female_c:stereotype_c                     -0.5616    0.8470  -2.2173   1.0903      10000 0.9999
# age_c:stereotype_c                         1.6049    0.6834   0.2510   2.9286      10000 0.9998
# brilliance_c:female_c:age_c               -0.2500    0.6798  -1.5889   1.0755      10000 0.9999
# brilliance_c:female_c:stereotype_c         0.0816    0.9599  -1.7765   1.9567      10000 0.9998
# brilliance_c:age_c:stereotype_c            0.0256    0.8797  -1.7140   1.7666      10000 0.9999
# female_c:age_c:stereotype_c                0.0695    0.8778  -1.6191   1.7525      10000 1.0000
# brilliance_c:female_c:age_c:stereotype_c   0.2100    0.9519  -1.6639   2.1070      10000 0.9999



