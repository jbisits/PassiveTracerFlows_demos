# Demos with [PassiveTracerFlows.jl](https://fourierflows.github.io/PassiveTracerFlowsDocumentation/stable/)

This repository contains some demonstrations of advecting-diffusing passive tracers.
To run the scripts, first clone the repository using the [desktop app](https://desktop.github.com/) or

```terminal
git clone https://github.com/jbisits/PassiveTracerFlows_demos.git
```

Change to the directory where the repo has been cloned to then open [Julia](https://julialang.org/), and activate and instantiate the project to build all the dependencies

```terminal
julia>]
(@v1.8) pkg> activate .
(PassiveTracerFlows_demo) pkg> instantiate
```

After this the scripts `Gaussian_diff_2D.jl` and `cats_eye_flow.jl` can be run.

To run the `animate_tracer.jl` script the tracer data first needs to be downloaded from [here](https://figshare.com/articles/dataset/Ensemble_member_simulation_data/20188739).
