# Criticality in RBM

To install:

```
git clone --recursive https://github.com/tambetm/criticality.git
cd criticality
wget http://www.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/BSR/BSR_bsds500.tgz
tar xzvf BSR_bsds500.tgz
```

Then run `medal_grbm_sample.m`. This should produce following figures:

**Figure 1: example patches**
![](https://github.com/tambetm/criticality/blob/master/images/example_patches.png)

**Figure 2: training statistics**
![](https://github.com/tambetm/criticality/blob/master/images/medal_grbm_training.png)

**Figure 3: filters after training**
![](https://github.com/tambetm/criticality/blob/master/images/medal_grbm_filters.png)

**Figure 4: original image**
![](https://github.com/tambetm/criticality/blob/master/images/original_image.png)

**Figure 5: reconstruction from sampled binary hidden units**
![](https://github.com/tambetm/criticality/blob/master/images/medal_grbm_reconstruction_from_binary.png)

**Figure 6: reconstruction from hidden unit probabilities**
![](https://github.com/tambetm/criticality/blob/master/images/medal_grbm_reconstruction_from_probs.png)

**Figure 7: energy variance vs temperature**
![](https://github.com/tambetm/criticality/blob/master/images/energy_variance_vs_temperature.png)

**Figure 8: heat capacity vs temperature**
![](https://github.com/tambetm/criticality/blob/master/images/heat_capacity_vs_temperature.png)
