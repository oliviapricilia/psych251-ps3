# Psych 251 PS3: Reproducibility checks

- `partA/partA_joel2014.qmd`: Part A, a known case (Joel, Teper, & MacDonald, 2014, Study 1)
- `partB/`: Part B, the original paper behind a classmate's project
- `transcripts/`: agent prompts, logs and exported session transcripts

## Render and publish (run in Terminal from this folder)

```bash
quarto --version                      # needs 1.9 or newer
Rscript -e 'install.packages(c("tidyverse","haven","knitr","brms"))'   # brms needs Xcode CLT: xcode-select --install

cd partA && quarto render partA_joel2014.qmd && cd ..
cd partB && quarto render partB_bian2018.qmd && cd ..   # first render fits the brms model (a few minutes)

git init && git add . && git commit -m "PS3 reproducibility checks"
# create an empty public repo on GitHub, then:
git remote add origin https://github.com/<you>/psych251-ps3.git && git push -u origin main

cd partA && quarto publish posit-connect-cloud partA_joel2014.qmd && cd ..
cd partB && quarto publish posit-connect-cloud partB_bian2018.qmd && cd ..
```
