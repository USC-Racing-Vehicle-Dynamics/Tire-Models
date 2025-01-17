# Tire Models

This repository contains multiple tire model scripts based on tire fitting tool and ```magicformula()``` function

## Things to do Before Running

1. Download tire fitting tool: [MagicFormulaTyreTool](https://www.mathworks.com/matlabcentral/fileexchange/111375-magic-formula-tyre-tool). 
Note: This repository contains some fitted tire data files, so you won't need this tool for those set of data.

2. Add [Magic Formula Tyre Tool](https://www.mathworks.com/matlabcentral/fileexchange/111375-magic-formula-tyre-tool) to your MATLAB Toolbox, this will make ```magicformula()``` function available.

3. Place the fitted tire data and the scripts in the same path in your MATLAB, and run the scripts.

## Tire Data Explained

### Run Data

Discrete data points obtained from the main process of the tire test. Often used for fitting.

### Raw Data

Discrete data points obtained from the entire tire test. By extracting some data points it can conduct analyses that Run Data cannot do, but won't fit as well as Run Data.

### Fitted Data

Data processed by MagicFormulaTyreTool that fit discrete data points into lines. When the .mat file is assigned to a MATLAB structure array, you can take this array as an input to the ```magicformula()``` function to obtain results from custom parameter inputs.

## List of Tire Models

### FYvsSA_fitted.m

Generates a lateral force (FY) vs. slip angle (SA) graph based on fitted tire data. <br/>
Needs to use files from "Fitted Data" folder or fit yourself using MagicFormulaTyreTool.

### camberStiffness_loadSensitivity.m

Plots the slope between the difference in lateral force (FY) and the difference in camber (IA).

### tireCorneringStiffness_loadSensitivity.m

Plots the slope between the difference in lateral force (FY) and the difference in slip angles (SA).

### tireFrictionEllipse.m

Generates a friction ellipse based on selected fitted tire data with varying slip angles/ratios. <br/>
Fit the furthest data points from origin with curve to represent the maximum possible friction ellipse.

### tireRelaxationLength_cornering.m

Plots the point where lateral force (FY) reaches 63% of the steady-state after a step steer.

### tireSpringRate_cornering.m

Models tire as a compression spring, and plots the relationship between change in tire radius and normal load (FZ).

### tireTemperatureAnalysis.m

Compares the lateral force (FY) and coeffcient of friction with respect to temperature of two selected tire models. <br/>
Also compares the tire temperature vs. time during the heating process.

### tireWearAnalysis.m

Plots and compares the grip level (coefficient of friction) change of different tires between repeated tests.
