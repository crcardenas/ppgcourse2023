# MAXIMUM LIKELIHOOD

**Instructors**: Jesus Lozano-Fernandez & Mattia Giacomelli

If you have any questions, contact us at jesus.lozano@ub.edu or mattia.giacomelli@bristol.ac.uk

***
## Context

We will be working with an alignment composed by 50 orthologous genes concatenated from 16 bears, 4 individuals for each of the 4 species.

![data](../Sensitivity_Analysis.Rosa_Fernandez_Gemma_Martinez/img/data.PNG)
![bear_names](../Sensitivity_Analysis.Rosa_Fernandez_Gemma_Martinez/img/bear_names.png)

***
## Data files

For Maximum likelihood tree reconstruction, we will use the software IQ-TREE which you have already installed in the cloud. For executing all the commands, we will use SLURM scripts.

All files for this hands-on class are in the folder **Bear_dataset_ML** provided in the github repository. We will use a separate folder for each analysis to avoid overwritting any files.

You can download the data executing the following command from your home directory:

```
svn export https://github.com/ppgcourseUB/ppgcourse2022/trunk/Maximum_Likelihood.Miquel_Arnedo_Gemma_Martinez_Rosa_Fernandez/Bear_dataset_ML
cd Bear_dataset_ML
```

***

## Model selection

First, we will find which is the best substitution model for our data using the model selection option from IQ-TREE. 

1.- From the `Bear_dataset_ML` folder, go to the folder for model selection:

`cd model_selection`

If you take at look at the **`model_finder.sh`** file you can see the whole list of models that we are going to test:

`iqtree -s 50_genes.fa -m MF -mset LG+F+G,WAG+F+G,JTT+F+G,GTR20 -madd LG+C20+F+G,LG+C10+F+G,LG+C30+F+G,LG+C40+F+G,LG+C50+F+G,LG+C60+F+G,C10,C20,C30,C40,C50,C60,EX2,EX3,EHO,LG4M,LG4X -redo`

We are including the four most common site-homogeneous models and almost all the mixture models available.

2.- For executing the analysis run:

`sbatch model_finder.sh`

3.- Check the 50_genes.fa.iqtree file.

>- **Which is the best model?**
>- **Which kind of model is it?**

You can take a look at the models in: http://www.iqtree.org/doc/Substitution-Models

***

## Bootstrap

Let’s test now the differences in the bootstrap value assignment methods to assess the support of nodes. We will first compare the execution time of 3 methods: ultrafast bootstrap, SH-alrt (Shimodaira-Hasegawa approximate likelihood-ratio test) and non-parametric bootstrap.

We will use the concatenated alignment of our 50 genes and use the model we obtained as the best one in the previous exercise.

### Ultrafast bootstrap

1.- Go to the folder for ultrafast bootstrap:

`cd ../ultrafast_bootstrap`

2.- Modify the **`ultrafast_iqtree.sh`** script to include the best substitution model where it says **MODEL**.

`vim ultrafast_iqtree.sh`

Press **a** to start modifying the file. When you're finished, press **Escape** to exit the edit mode. To exit vim, type: **:wq**.

`iqtree -s 50_genes.fa -m MODEL -bb 1000 -nt 8 -redo`

Once modified, you are ready to run the analysis:

`sbatch ultrafast_iqtree.sh`

More information on the ultrafast bootstrap in: http://www.iqtree.org/doc/Tutorial#assessing-branch-supports-with-ultrafast-bootstrap-approximation and http://www.iqtree.org/doc/Frequently-Asked-Questions#how-do-i-interpret-ultrafast-bootstrap-ufboot-support-values

### SH-alrt

1.- Go to the folder for SH-alrt::

`cd ../shalrt`

2.- Modify the **`shalrt_iqtree.sh`** script to include the best substitution model where it says **MODEL**.

`iqtree -s 50_genes.fa -m MODEL -alrt 1000 -nt 8 -redo`

For executing the analysis run:

`sbatch shalrt_iqtree.sh`

## Bootstrap

Let’s test now the differences in the bootstrap value assignment methods. We will first compare the execution time of 3 methods: ultrafast bootstrap, SH-alrt and non-parametric bootstrap.

We will use the concatenated alignment of our 50 genes and use the model we obtained as the best one in the previous exercise.

### Non-parametric bootstrap

1.- Go to the folder for non-parametric bootstrap:

`cd ../non_parametric`

2.- Modify the **`non_parametric_iqtree.sh`** script to include the best substitution model where it says **MODEL**.

`iqtree -s 50_genes.fa -m MODEL -b 10 -nt 8 -redo`

For executing the analysis run:

`sbatch non_parametric_iqtree.sh`

More information on non-parametric bootstrap in: http://www.iqtree.org/doc/Tutorial#assessing-branch-supports-with--standard-nonparametric-bootstrap

***
You can check how long your running analyses have been executing in the queue system of the cloud using:

`squeue`

Once finished (this may take a while), you can check the execution time in the **.log** files in each of the above folders. You can visualize the output trees in your preferred visualization software.

>- **Which bootstrap method is the slowest?**
>- **Which differences can you see in the bootstrap values?**

***

## Topology test

Another interesting feature of IQ-TREE are the tree toplogy tests. IQ-TREE can compute the log-likelihoods of some tree topologies. In this case, we will test which of the 3 topologies of the species tree is more probable given our dataset of 50 genes. Besides just comparing the log-likelihoods of different topologies, as we are doing here, there are tests that can significantly reject certain topologies (outputing p-values), such as KH, SH and AU tests.

 ![topologies](../Sensitivity_Analysis.Rosa_Fernandez_Gemma_Martinez/img/topologies.png)

More information here: http://www.iqtree.org/doc/Advanced-Tutorial#tree-topology-tests

IQ-TREE first reconstructs a ML tree and then computes the log-likelihood of the tree topologies based on the estimated parameters for the ML tree.

Parameters for the ML tree can be estimated in 3 different ways, that we will compare.

1.- First, let’s IQ-TREE reconstruct the tree **given the best model estimated before**.

Go to the folder:

`cd ../topology_test_model`

Modify the **`topology_test_model.sh`** script to include the best substitution model where it says **MODEL**. You can use any command-line tool you know (such as emacs or vim) or any text editor.

`iqtree -s 50_genes.fa -z ../bear_species_trees_topologies.tre -m MODEL -redo`

For executing the analysis run:

`sbatch topology_test_model.sh`

2.- Then, let’s IQ-TREE estimate the parameters from an **initial parsimony tree**.

Go to the folder:

`cd ../topology_test_parsimony`

If you look at the **`topology_test_parsimony.sh`** file you can see the command you are executing.

`iqtree -s 50_genes.fa -z ../bear_species_trees_topologies.tre -n 0 -redo`

For executing the analysis run:

`sbatch topology_test_parsimony.sh`

3.- Last, instead of estimating the parameters from a parsimony tree, let’s based the estimation on a **tree that we have reconstructed before**.

Go to the folder:

`cd ../topology_test_tree`

Modify the **`topology_test_using_tree.sh`** script to include a previously reconstructed tree where it says **PREVIOUS_TREE**.

`iqtree -s 50_genes.fa -z ../bear_species_trees_topologies.tre -te PREVIOUS_TREE -redo`

For executing the analysis run:

`sbatch topology_test_using_tree.sh`

>- **Which of the 3 topologies is more probable?**
>- **Does this result change with the different analyses?**

***
