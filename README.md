# Synergy-Based-Foot-Model
This repository contains a multi-body model of the foot that track the spatial kinematics of all the bones with only 5 DOF, exploiting experimentally derived motion coupling (or synergies). The theoretical background in described in the publication:

@article{Conconi2026foot,
  title={A novel, synergy-based kinematic model of the foot and ankle for gait analysis},
  author={Michele Conconi, Luca Modenese, Gian Marco Barbieri, Alberto Leardini, Claudio Belvedere, Nicola Sancisi},
  journal={submitted},
  year={2026},
  publisher={NA}
  doi={NA}
}

<!-- The paper is open access and freely available [from the Journal website](https://link.springer.com/article/10.1007%2Fs10439-020-02490-4) or [this repository](https://github.com/modenaxe/3d-muscles/tree/master/docs).
-->
Please cite the manuscript if you make use of these materials for your research or presentations.

![synergies](./assets/Synergies.gif)

# CONTENT
The model is implemented in Matlab and relay on two steps:

1 - Anisotropic_scaling: The code scale all the model parameters that will be used to reconstruct. 
The code take as an input a .trc file describing the coordinates of the foot marker in a static trial, in which the subjected is standing still, and the side (left - L, or right - R) to be scaled.
Relevant markers and their name must defined according to the Rizzoli foot marker set proposed in "Leardini, A., Benedetti, M. G., Berti, L., Bettinelli, D., Nativo, R., & Giannini, S. (2007). Rear-foot, mid-foot and fore-foot motion during the stance phase of gait. Gait & posture, 25(3), 453-462".
The code will compute as output:
 - the scaled foot an ankle synergies
 - a new set of anatomical markers, resulting from back projection of experimental ones after scaling and fitting the model on the static trial
 - the scaled foot contact spheres
 - scaled stl files of the bones
 - all the model info will be saved in the folder "Scaled model"

2 - SynergyBased_MKO: The code assume the generic model of the foot has already been scaled on a static trial in a previous step
The code take as an input a .trc file describing the coordinates of the foot marker in a dynamic trial the side (left - L, or right - R) to be analyzed. From here, it will compute shank, foot and toes kinematics using Multibody Kinematic Optimization, exploiting synergies to describe the pose of all the bones in the complex using only 5 DOF.
The code will compute as output:
 - the absolute kinematic of each bone
 - the variation of synergy coefficients
 - the trajectory of the model markers
 - the trajectory of contact spheres approximating bone/ground interaction
All the output will be stored in the subfolder Scaled model


# NOTES
The folder Scaled model contain also a visualizer (SB-MKO_visualizer.exe) that provide multiple views of the analyzed motion.

At this page (https://github.com/modenaxe/SynergyFootModel-OpenSim) it is possible to find a Matlab script that generate an OpenSim implementation of the same model, once data have been scaled through step 1.
