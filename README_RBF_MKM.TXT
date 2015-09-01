Radial Basis Function (RBF) Training Program
============================================

Image Processing and Neural Networks Lab,
The University of Texas at Arlington.
http://www.uta.edu/faculty/manry/

This program trains a RBF classifier.
The training algorithm used is MULTI-KERNEL-MACHINE. See: 
"TRAINING ALGORITHM FOR MULTI-CLASS RADIAL BASIS FUNCTION CLASSIFIERS" by
Yilong Hao

Classification case
-------------------
The training data has N inputs x and M classes ic. Patterns are arranged in rows
with a tab or space separating the elements. The class numbers ic must start 
from 1, going all the way to M.

x_1 x_2 ... x_N ic

Example data file with N = 4, Nc = 2
    0.6020    0.0838    0.9961    0.7749    2.0000
    0.2630    0.2290    0.0782    0.8173    1.0000
    0.6541    0.9133    0.4427    0.8687    2.0000
    0.6892    0.1524    0.1067    0.0844    2.0000
    0.7482    0.8258    0.9619    0.3998    1.0000
    0.4505    0.5383    0.0046    0.2599    1.0000
The first four columns are the inputs and the last column has the class numbers.

Validation data
---------------
This program uses validation data for network sizing. If you have already split
your data into training and validation files, supply both files to the program.
If you did not, the program can automatically split the training file to
generate validation data.

Other inputs
------------
N: inputs, M: outputs, Nit: the maximum number of training iterations/epochs. 
During training, the number of hidden units and iterations is optimized to 
minimize the internally generated validation error.

Running the GUI
---------------
Run the program: "run_training.m"
Configure all the parameters in the GUI and press the "Train" button.
The program outputs can be seen in the MATLAB console. The network weights are 
stored in the file weights.txt.

Running the console version
---------------------------
The console version of the program is provided in the merge_hidden_units folder.
please run the program "rbf_train.m" to train a regression
or a classification model. Running this program without any arguments prompts
the user for input on the command line. To invoke as functions, their 
prototypes are given below:

[Pe_train Nh_best] = rbf_train(training_file, N, M, Nit_beta)

ftype = 1 for approximation, and = 2 for classification files.
The best network size is returned as Nh_best. 
The training error for the best network is returned as Pe_train.
The weights are stored in "rbf_weights.txt".

Processing or Testing
---------------------
Please run "rbf_test.m" to obtain processing results on new data. 
If the new data has the correct outputs available, a testing error
is calculated and displayed. 
The GUI for the testing program is "run_testing.m".


README version 1
Rohit Rawat 08/26/2015


