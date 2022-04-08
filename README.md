# COVID19_SyndromicRATDiagnosis_public

This repository contains the code necessary to reproduce the analysis in our paper "Combining Rapid Antigen Testing and Syndromic Surveillance Improves Sensitivity and Specificity of COVID-19 Detection: a Community-Based Prospective Diagnostic Study".
Please note: 1) the code was developed for this analysis - we cannot recommend it for more general usage! and 2) to make the repo more easily downloadable we have not included full Stan output for every model tested - these can be generated from the provided code.

The code is divided into 5 folders:

#### 0000_HelperCode_Libraries

These scripts include the library calls, global model parameters and helper functions necessary for all subsequent scripts.

#### 0100_Data

Here we store the raw data used in the analysis and extract the population characteristics.

#### 0200_ModelDefinitions

The code defining each model in Stan syntax.

#### 0300_ModelSelection

Scripts to run Stan models and conduct variable selection.

#### 0400_ModelAssessment

Calculate receiver operating characteristics (ROC) and cross entropy scores.
