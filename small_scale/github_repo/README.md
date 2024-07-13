# Axis XX

This package will allow you to create, manipulate and plot data on multiple additional X or Y axes. Similar to MATLAB's own plotyy function, but less limiting. 

# Features
Create any combination of X or Y axes, plot multiple lines on each X or Y axis 
Native argument styles and overloaded plot functions supported e.g: 
  axisyy(xdata, ydata, 'r-', 'LineWidth', 2, 'MarkerSize', 14); 
  axisyy(TimeSeriesObject, 'b-', 'LineWidth', 3); 
Use any plotting function you specify (plot, line, patch, etc) 
Set the limits of every axis independently 
Ability to update xdata/ydata directly without thinking about the transformation 
Compatible with MATLAB's zoom, pan and data cursor tools 
Figure is resizeable and rescales objects around colorbars if they are present 
The code has been completely rewritten using an object oriented approach. 
Originally inspired by AddAxis 5 by Harry Lee

Type 'help axisxx' at the command line for help
Check the example.m script for a worked example

If you find any bugs or have suggestions please write in the comments box or message me. If the submission was helpful, then please rate it.
