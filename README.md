# FAST
> Far-field Amplitude-only Speckle Transfer (FAST) algorithm for quantitative phase imaging through a multi-core fiber bundle.
> 14 April 2022

## Table of Contents
* [General Info](#general-information)
* [Sample data](#sample-data)
* [How to use](#how-to-use)
* [Setup](#setup)
* [Contact](#contact)
<!-- * [License](#license) -->


## General Information
- The Matlab code is ulilized for quantitative phase imaging through a multi-core fiber bundle.
- The far-field speckle images are used to retireve the phase information on the facet of the fiber bundle.
- You can read our paper for detailed information [1]. Please cite our paper if you used this code for your project.
- [1] Sun J, Wu J, Wu S, et al. Quantitative phase imaging through an ultra-thin lensless fiber endoscope[J]. Light: Science & Applications, 2022..
- https://doi.org/10.1038/s41377-022-00898-2

## Sample Data
- A sample dataset can be downloaded from the link below
- https://cloudstore.zih.tu-dresden.de/index.php/s/yQq4FsWN6bFaZRQ
- The dataset contains the system response (speckle images) of a phase target
- Two far-field speckles are used to reconstruct the intrinsic phase distortion of the fiber bundle
- Another far-field speckle measured with the sample is used to reconstruct the quantitative phase information of the sample

## How to use
- Requirements: Matlab 2017b or later version and at least one Nvidia GPU
- How to run the code?
1. Download and unzip the code
2. Download the sample data from the link above
3. Copy the "data.mat" to the folder where you store the code or the matlab path
4. Run the "main.m"
- Note: the phase reconstruction for the intrinsic phase distortion can take a very long time on a normal laptop, plase be patient.


## Setup
- "Main.m" Main code for the reconstruction
- "prop.m" Numerical propagation function
- "tiltPhase" Generate a tilted phase image for wavefront correction


## Contact
Created by Jiawei Sun (jiawei.sun@tu-dresden.de) from TU Dresden - feel free to contact me!
