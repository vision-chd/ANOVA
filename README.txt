# ============================ DBIC dataset ============================ #
DBIC dataset is utilized to evaluate the performance of FMs in sensitivity to defocus or independence from image content.

Defocus blur is performed on these focused images of different subsets in DBIC dataset with Gaussian blur standard deviations ranging from 0 to 1.5, incrementing by 0.5 each time.
Gaussian white noise with a variance of 0.001 is added to images, and a total of 5 replications are performed to simulate random noise in images captured by low-performance cameras.
Five groups of actual multi-focus images are captured from different objects at four levels of focus value.
Five images are repeatedly captured at each focus value. 

DBIC dataset has five subsets.
The subsets of DBIC dataset are as follows:

DBIC dataset
     |___ Simulated images
          |___ focused_images
          |___ Gaussian_blur_standard_deviation=0
          |___ Gaussian_blur_standard_deviation=0.5
          |___ Gaussian_blur_standard_deviation=1
          |___ Gaussian_blur_standard_deviation=1.5
     |___ LIVE Database
           |___ source images
           |___ Gaussian_blur_standard_deviation=0
           |___ Gaussian_blur_standard_deviation=0.5
           |___ Gaussian_blur_standard_deviation=1
           |___ Gaussian_blur_standard_deviation=1.5
     |___ TID2013 Database
           |___ reference images
           |___ Gaussian_blur_standard_deviation=0
           |___ Gaussian_blur_standard_deviation=0.5
           |___ Gaussian_blur_standard_deviation=1
           |___ Gaussian_blur_standard_deviation=1.5
     |___ IVC Database
           |___ original images
           |___ Gaussian_blur_standard_deviation=0
           |___ Gaussian_blur_standard_deviation=0.5
           |___ Gaussian_blur_standard_deviation=1
           |___ Gaussian_blur_standard_deviation=1.5
     |___ Actual multi-focus images



# ============================ Source Codes ============================ #
The provided source codes are implemented in Matlab.

# ------------------- FMsCalculation.m ------------------- #
FMsCalculation.m is utilized to calculate the focus measure value.
Focus measures, Ten, SpF, EOL, SML, Bre, SWC, VWC, Var, Ent, Eig, DER, AC, StF are included in this file.
They are cited from as follows:
Said Pertuz, Domenec Puig, Miguel Angel Garcia, Analysis of focus measure operators for shapefrom-focus, Pattern Recognition, 46 (5) (2013) 1415-1432.
Chun-Hung Shen, H. H. Chen, Robust focus measure for low-contrast Images, in 2006 Digest of Technical Papers International Conference on Consumer Electronics, 2006, pp. 69 -70.
Xiaohua Xia, Lijuan Yin, Yunshi Yao, et al., Combining two focus measures to improve performance, Measurement Science and Technology, 28 (10) (2017) 105401.
Yu Sun, Stefan Duthaler, Bradley J. Nelson, Autofocusing in computer microscopy: selecting the optimal focus algorithm, Microscopy Research and Technique, 65 (3) (2004) 139–149.
Rashid Minhas, Abdul A. Mohammed, Q. M. Jonathan Wu, et al., 3D shape from focus and depth map computation using steerable filters, in International Conference Image Analysis and Recognition, 2009, pp. 573-583.
Ge Yang, Bradley J Nelson, Wavelet-based autofocusing and unsupervised segmentation of microscopic images, in 2003 IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS 2003), 2003, pp. 2143-2148.
Hui Xie, Weibin Rong, Lining Sun, Wavelet-based focus measure and 3-D surface reconstruction method for microscopy images, in 2006 IEEE/RSJ International Conference on Intelligent Robots and Systems, 2006, pp. 229-234.

The source code of EMBM, MGVG, and FocusNet can be download from
https://github.com/GUAN3737/EMBM.git.
https://github.com/Atmegal/Sharpness-evaluation.
https://github.com/mmonto95/focusnet.

Focus measures, EMBM, MGVG, and FocusNet are cited from as follows:
Jingwei Guan, Wei Zhang, Jason Gu, et al., No-reference blur assessment based on edge modeling, Journal of Visual Communication and Image Representation, 29 (2015) 1-7. 
Yibing Zhan, Rong Zhang, No-Reference Image Sharpness Assessment Based on Maximum Gradient and Variability of Gradients, IEEE Transactions on Multimedia, 20 (7) (2018) 1796 - 1808
Manuel Montoya, Maria J. Lopera, Alejandra Gómez-Ramírez, et al., FocusNET: An autofocusing learning‐based model for digital lensless holographic microscopy, Optics and Lasers in Engineering, 165 (2023) 107546.

We thank all these papers and their code since they inspire our work a lot.

# ------------------- ANOVA.m  ------------------- #
ANOVA.m is used to determin whether the focus measure is independent of the image content or sensitive to defocus by analyzing the evaluation results of a focus measure under different image contents.
It needs to to manually change some parameters, including focus measure (FM), the number of defocus blur levels (r), the number of different image contents (s), and the number of repetitions (c).
r --> It is set according to the number of the defocus blur levels (A). 4 levels of defocus blur (0, 0.5, 1, 1.5) are adopted, so r is equal to 4. 
s --> It is set according to the number of different image contents (B). The number of images in DBIC dataset for simulated images, TID2013 Database, LIVE Database, and IVC Database are 12, 25, 29, and 10, respectively. Thus, s is equal to 12, 25, 29, and 10.
c --> It is set according to the total number of repeated experiments at each level pair (Ai, Bj). 5 repetitions of experiments are conducted. Thus, c is equal to 5.
FM --> Focus measure. Focus measure available for selection include: Ten, SpF, EOL, SML, Bre, SWC, VWC, Var, Ent, Eig, DER, AC, StF. EMBM, MGVG, and FocusNet can be found in the corresponding references.
Other parameters are described in detail in ANOVA.m.

Output: F_defocus and F_content.

Query the statistical distribution about F-distribution to find the critical value. 
F_defocus obeys F𝛼(r-1, r*s*(c-1)); F_content obeys F𝛼(s-1, r*s*(c-1)).

Results: 
if F_defocus is greater than the critical value F𝛼(r-1, r*s*(c-1)), it is considered that defocus blur has a significant impact on the focus measure. Otherwise, it has no significant impact.
if F_content is greater than the critical value F𝛼(s-1, r*s*(c-1)), it is considered that image content has a significant impact on the focus measure. Otherwise, it has no significant impact.
