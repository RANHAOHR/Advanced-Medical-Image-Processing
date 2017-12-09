# Advanced-Medical-Image-Processing

Package for classic image processing techniques:

- Thresholding package: containing Ostu and Reddi thresholding.

- Classification package and Param_estimate package: using Maximum likelihood estimate, estimating the bias field (and the tissue classification of an MR image) based on maximum likelihood parameter estimation using the EM algorithm. (see Van Leemput's paper: Automated Model-Based Bias Field Correction of MR Images of the Brain)

- Point_registration package: Containing point based registration using Optimization apporach (fminsearch) and ICP (see Dr. Fitzpatrick's paper)

- Nonrigid_registration package: using thin-plate spline,

![Alt text](/result images/nonrigid_registration.jpg?raw=true "nonrigid registration using thin-plate spline")

- Intensity based registration package: using Mutual information (joint-entropy):

![Alt text](/result images/mutual_information.jpg?raw=true "MI nonrigid registration")

-Snake shape package: see paper Snake: Active Contour Models. A segmentation technique using snake models, minimizing the energy function defined by internal and external force which is driven by the edge map (the target contour). Using three types of forces: gradient map, distance map and GVF (Gradient Vector Flow: A New External Force for Snakes),

![Alt text](/result images/snake.jpg?raw=true "snake shape segmentation")

- demon_matching package: using demons algorithm (Thirion's paper: Image matching as a diffusion process: an analogy with Maxwell’s demons) with image pyramid to perform the segmentation. An atlas-based segmentation of the ventricles,the intracranial cavity and the head contours of human brains:

![Alt text](/result images/demons_matching.jpg?raw=true "demons matching of the MRI brain image")

![Alt text](/result images/atlas_based_segmentation.jpg?raw=true "atlas based segmenation of the brain ventricle, intracranial cavity and head contours")

- Active shape models package: containing hand segmentation using PCA algorithm.

![Alt text](/result images/first 4 eigen vector.jpg?raw=true "4 of the main eigen vecs of the mean hand space")

![Alt text](/result images/hand fitting results .jpg?raw=true "red hand is the target hand contour and the green contours are the initial, first iteration and the final fitting hand results")
