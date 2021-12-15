# Cryptocurrency Pairs Analysis
This project will focus on cryptocurrency pairs candledisk data from kaggle, and our targets for this project include: finding the most stable and most volatile pair from 1000 cryptocurrency pairs, forecasting the trend of cryptocurrency pairs by arima model and proposing investment suggestions.
***

## Table of Contents
  - [Dependencies](#dependencies)

  - [Installation](#installation)

  - [File Description in Code Folder](#file-description-in-code-folder)

  - [Acknowledgements](#acknowledgements)
  
  - [Contributors](#contributors)


***
## Dependencies
- [R 4.0+](https://www.r-project.org/)


## Installation
This project depends upon a knowledge of  the packages in R, You can install with:
```bash
# [OPTIONAL] Activate a R virtual environment and install tensorflow
install.packages("forecast")
install.packages("TSA")
install.packages("arrow")
install.packages("zoo")
install.packages("tensorflow")
install.packages("keras")
install_tensorflow(method = 'conda', envname = 'r-reticulate')

```

## File Description in Code Folder
- [arima_plot.R](code/time_series_code/arima_plot.R) - R code for testing the arima model and drawing the plots.
- [RNN_plot.R](code/time_series_code/RNN_plot.R) - R code for testing the RNN model and drawing the plots.
- [1000jobs.sh](code/time_series_code/1000jobs.sh) -  extract file names.
- [install_R.sh](code/time_series_code/install_R.sh) -  interactive.sub: download R packages myscript.sh, myscript.sub: run paralleljob.R.
- [paralleljob.R](code/time_series_code/paralleljob.R) - R code for predicting cryptocurrency pairs' trend and getting choices.
- [RNN_plot.R](code/time_series_code/score.R) - R code for calculating scores based on choices and filenames.



## Acknowledgements
This is a project of STAT 605 Fall 2021 at UW-Madison, supervised by Prof. John Gillett.


## Contributors
- **Shuren He** - (she249@wisc.edu) : Contribute to the code for time series model including Arima and RNN, plots for demonstration, report writing and tidy the github.  
- **Suhui Liu** - (sliu736@wisc.edu) : Contribute to configure the CHTC enviornment, revise the paralleljob.R into executable format, run 1000 predicting parallel jobs, write part of the report, calculated the score value. 
- **Jiaying Jia** - (jjia35@wisc.edu) : Contribute to Contribute to uploading 25G datafile on CHTC platform and the background, data introduction and computational steps part in report.
- **Zihan(Kelly) Zhao** - (zzhao387@wisc.edu) : Contribute to .  

