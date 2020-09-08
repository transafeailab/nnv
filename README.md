# nnv
Matlab Toolbox for Neural Network Verification

I developed this toolbox when I was a Ph.D student at Vanderbilt University. This toolbox implements reachability methods for analyzing neural networks and learning-enabled autonomous Cyber-Physical Systems.

The original repository of nnv is: https://github.com/verivital/nnv

Please use https://github.com/transafeailab/nnv for the newest updates of nnv.

# User manual: 

[A first draft of user manual](https://github.com/transafeailab/nnv/blob/master/manual.pdf)

I will update the user manual frequently. 

# Installation:

    1) Install Matlab with at least the following toolboxes:
       Control Systems
       Optimization (need to be installed)
       Parallel Processing
       Deep Learning
       System Identification

    2) Clone or download the nnv toolbox from (https://github.com/transafeailab/nnv)
    
    git clone https://github.com/transafeailab/nnv.git

    3) Open Matlab, then go to the directory where nnv exists on your machine, then run the `install.m` script located at /nnv/

    4) To run verification for convolutional neural networks you may need additional packages installed

       4-1) https://www.mathworks.com/matlabcentral/fileexchange/61733-deep-learning-toolbox-model-for-vgg-16-network  

       4-2) https://www.mathworks.com/help/deeplearning/ref/vgg19.html

# Uninstallation:

    1) Open matlab, then go to `/nnv/` and execute the `uninstall.m` script

# An introduction to nnv

[![Alt text](https://img.youtube.com/vi/Wx8xso9KbQU/0.jpg)](https://www.youtube.com/watch?v=Wx8xso9KbQU)

# Running tests and examples:

    Go into the `tests/examples` folders to execute the scripts for testing/analyzing examples.

# Artifacts:

   Go into the 'examples/artifact' for the codes used in nnv's publications. 

# Contributors

* [Hoang-Dung Tran (main developer)](https://scholar.google.com/citations?user=_RzS3uMAAAAJ&hl=en)
* [Weiming Xiang](https://scholar.google.com/citations?user=Vm_7JP8AAAAJ&hl=en)
* [Stanley Bak](http://stanleybak.com/)
* [Patrick Musau](https://scholar.google.com/citations?user=C2RS3i8AAAAJ&hl=en)
* [Diego Manzanas Lopez](https://scholar.google.com/citations?user=kgpZCIAAAAAJ&hl=en)
* Xiaodong Yang
* Neelanjana Pal
* [Luan Viet Nguyen](https://luanvietnguyen.github.io)
* [Taylor T. Johnson](http://www.taylortjohnson.com)

# References

The methods implemented in nnv are based upon the following papers.

* Hoang-Dung Tran, Patrick Musau, Diego Manzanas Lopez, Xiaodong Yang, Luan Viet Nguyen, Weiming Xiang, Taylor T.Johnson, "NNV: A Tool for Verification of Deep Neural Networks and Learning-Enabled Autonomous Cyber-Physical Systems", 32nd International Conference on Computer-Aided Verification (CAV), 2020. [http://taylortjohnson.com/research/tran2020cav_tool.pdf]

* Hoang-Dung Tran, Stanley Bak, Weiming Xiang, Taylor T.Johnson, "Towards Verification of Large Convolutional Neural Networks Using ImageStars", 32nd International Conference on Computer-Aided Verification (CAV), 2020. [http://taylortjohnson.com/research/tran20120cav.pdf]

* Stanley Bak, Hoang-Dung Tran, Kerianne Hobbs, Taylor T. Johnson, "Improved Geometric Path Enumeration for Verifying ReLU Neural Networks", In 32nd International Conference on Computer-Aided Verification (CAV), 2020. [http://www.taylortjohnson.com/research/bak2020cav.pdf]

* Hoang-Dung Tran, Weiming Xiang, Taylor T.Johnson, "Verification Approaches for Learning-Enabled Autonomous Cyber-Physical Systems", The IEEE Design & Test 2019, (Under review). 

* Hoang-Dung Tran, Patrick Musau, Diego Manzanas Lopez, Xiaodong Yang, Luan Viet Nguyen, Weiming Xiang, Taylor T.Johnson, "Star-Based Reachability Analsysis for Deep Neural Networks", The 23rd International Symposium on Formal Methods (FM), Porto, Portugal, 2019, Acceptance Rate 30%. . [http://taylortjohnson.com/research/tran2019fm.pdf]

* Hoang-Dung Tran, Feiyang Cei, Diego Manzanas Lopez, Taylor T.Johnson, Xenofon Koutsoukos, "Safety Verification of Cyber-Physical Systems with Reinforcement Learning Control",  The International Conference on Embedded Software (EMSOFT), New York, October, 2019. Acceptance Rate 25%. [http://taylortjohnson.com/research/tran2019emsoft.pdf]

* Hoang-Dung Tran, Patrick Musau, Diego Manzanas Lopez, Xiaodong Yang, Luan Viet Nguyen, Weiming Xiang, Taylor T.Johnson, "Parallelzable Reachability Analsysis Algorithms for FeedForward Neural Networks", In 7th International Conference on Formal Methods in Software Engineering (FormaLISE), 27, May, 2019 in Montreal, Canada, Acceptance Rate 28%. [http://taylortjohnson.com/research/tran2019formalise.pdf]

* Weiming Xiang, Hoang-Dung Tran, Taylor T. Johnson, "Output Reachable Set Estimation and Verification for Multi-Layer Neural Networks", In IEEE Transactions on Neural Networks and Learning Systems (TNNLS), 2018, March. [http://taylortjohnson.com/research/xiang2018tnnls.pdf]

* Weiming Xiang, Hoang-Dung Tran, Taylor T. Johnson, "Reachable Set Computation and Safety Verification for Neural Networks with ReLU Activations", In In Submission, IEEE, 2018, September. [http://www.taylortjohnson.com/research/xiang2018tcyb.pdf]

* Weiming Xiang, Diego Manzanas Lopez, Patrick Musau, Taylor T. Johnson, "Reachable Set Estimation and Verification for Neural Network Models of Nonlinear Dynamic Systems", In Unmanned System Technologies: Safe, Autonomous and Intelligent Vehicles, Springer, 2018, September. [http://www.taylortjohnson.com/research/xiang2018ust.pdf]

* Reachability Analysis and Safety Verification for Neural Network Control Systems, Weiming Xiang, Taylor T. Johnson [https://arxiv.org/abs/1805.09944]

* Weiming Xiang, Patrick Musau, Ayana A. Wild, Diego Manzanas Lopez, Nathaniel Hamilton, Xiaodong Yang, Joel Rosenfeld, Taylor T. Johnson, "Verification for Machine Learning, Autonomy, and Neural Networks Survey," October 2018, [https://arxiv.org/abs/1810.01989]

* Specification-Guided Safety Verification for Feedforward Neural Networks, Weiming Xiang, Hoang-Dung Tran, Taylor T. Johnson [https://arxiv.org/abs/1812.06161]

* Diego Manzanas Lopez, Patrick Musau, Hoang-Dung Tran, Taylor T.Johnson, "Verification of Closed-loop Systems with Neural Network Controllers (Benchmark Proposal)", The 6th International Workshop on Applied Verification of Continuous and Hybrid Systems (ARCH2019). Montreal, Canada, 2019. [http://taylortjohnson.com/research/lopez2019arch.pdf]

* Diego Manzanas Lopez, Patrick Musau, Hoang-Dung Tran, Souradeep Dutta, Taylor J. Carpenter, Radoslav Ivanov, Taylor T.Johnson, "ARCH-COMP19 Category Report: Artificial Intelligence / Neural Network Control Systems (AINNCS) for Continuous and Hybrid Systems Plants", 3rd International Competition on Verifying Continuous and Hybrid Systems (ARCH-COMP2019), The 6th International Workshop on Applied Verification of Continuous and Hybrid Systems (ARCH2019). Montreal, Canada, 2019. [http://taylortjohnson.com/research/lopez2019archcomp.pdf]

# acknowledgements

This work is supported in part by the [DARPA Assured Autonomy](https://www.darpa.mil/program/assured-autonomy) program.

 