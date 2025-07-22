# Generating OSWW on CMSConnect

This is a fork of genproductions for me to test generating semileptonic opposite signed WW samples with MadGraph.
We've found that MadGraph without MadSpin generates final state particles with kinematics closer to previously
generated leptonic samples, but MadGraph alone requires large amounts of memory to generate all of the appropriate
diagrams. This memory requirement is too large for a single condor submission, so I've been trying to farm it
out across multiple jobs on cmsconnect.

## Workflow

For ease of reference, I use the `make_gridpack_cmsconnect.sh` script (without arguments) to have a record of
the specific command used to generate the gridpacks. It runs the cards in `cards/vbs_lvjj/simpletest` which has
an unpolarized leptonic VBS event (much faster to generate and removes possible polarization issues from debugging)
```
generate p p > w+{0} w+{0} j j QED=4 QCD=0, w+ > l+ vl @ 1
add process p p > w-{0} w-{0} j j QED=4 QCD=0, w- > l- vl~ @ 2
```
Running this script will run `submit_cmsconnect_gridpack_generation.sh` with a nohup command and pipe the output
to `mysubmit_simpletest.debug`.

## Modifications and Issues

You may see the changes in the initial commit via: https://github.com/hhollenb/genproductions/commit/30f032925790829e4ae74ce61f3ff935d5f318fe

For debugging purposes, print statements have been added to `PLUGIN/CMS_CLUSTER/__init__.py` to check that it is
indeed being used to submit jobs, and to also print some of the job cards and scripts used being submitted.
The working directory used by `gridpack_generation.sh` is also no longer deleted so its files may be examined
after failure.

For architecture, I've been trying to use `el9_amd64_gcc12` with `CMSSW_15_0_9` across all jobs to
have a consistent setup. The singularity wrapper in `PLUGIN/CMS_CLUSTER/__init__.py` is modified to add 
```
+REQUIRED_OS = "rhel9"\n
```
while `gridpack_generation.sh` was modified to override `scram_arch` with rhel9. The native architecture
for the login nodes of cmsconnect are `el9_amd64_gcc12`, and the compute nodes match this when the required
OS is requested as rhel9.


Currently the GENERATE step works fine and executables are setup on the login node, but during the INTEGRATION
mode where grid points are farmed out for `survey.sh` to different jobs, they all report that glibc 2.29 (among
other versions) are missing. This might be alleviated with some correct link / environment variable setting so
that the jobs have access to the appropriate library versions in their singularity container, but I'm not experience
with containers nor with versioning in cvmfs.
