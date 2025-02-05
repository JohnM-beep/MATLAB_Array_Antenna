%MATLAB Code for Circular Array Performance Evaluation
clc; clear; close all;

%% Parameters
freq = 1.5e9;  % Operating frequency (1.5 GHz)
lambda = 3e8 / freq;  % Wavelength
numElements = 19;  % Number of elements in the array
radius = lambda / 3;  % Radius of circular placement (tight packing)

%% Create Single Element Antenna (Patch Microstrip)
element = design(patchMicrostrip, freq);
element.GroundPlaneLength = lambda;
element.GroundPlaneWidth = lambda;

%% Define Custom Circular Array Placement
theta = linspace(0, 2*pi, numElements+1);  
theta(end) = [];  % Remove duplicate last point

% Define element positions
x = radius * cos(theta);
y = radius * sin(theta);
z = zeros(1, numElements);  % Keep elements on the same plane
positions = [x; y; z];

%% Create Phased Array System
array = phased.ConformalArray('Element', element, 'ElementPosition', positions);

%% Plot Array Geometry
figure;
show(array);
title('Circular Antenna Array Geometry');

%% Radiation Pattern Analysis
figure;
pattern(array, freq, 'Type', 'directivity');
title('Radiation Pattern of Circular Array');

%% Beamforming Performance Evaluation
steeringAngle = [30; 0];  % Steering the beam to 30 degrees elevation
beamformer = phased.PhaseShiftBeamformer('SensorArray', array, ...
    'OperatingFrequency', freq, 'Direction', steeringAngle);
beamformedPattern = pattern(array, freq, 'PropagationSpeed', 3e8, ...
    'Weights', getWeights(beamformer), 'Type', 'directivity');

%% Directivity Calculation
D = directivity(array, freq);
disp(['Array Directivity: ', num2str(D), ' dBi']);

%% Conclusion
% The circular array's performance can now be evaluated by varying
% element positions, spacing, and beamforming techniques.
