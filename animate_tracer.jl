## Animate saved tracer data using `CairoMakie`
# A link to the tracer data used for this animation can be found in the README

using CairoMakie, JLD2, Printf

## Path to where this is saved locally
data_path = joinpath(pwd(), "../QGTracerAdvection/Paper plots/")

## Extract data for the animation
tracer_data = jldopen(joinpath(data_path, "SimulationData.jld2"))

iterations = parse.(Int, keys(tracer_data["snapshots/t"]))
t = round.([tracer_data["snapshots/t/$i"] for i ∈ iterations])
x, y = tracer_data["grid/x"], tracer_data["grid/y"]
layer = 1
c = [abs.(tracer_data["snapshots/Concentration/$i"][:, :, layer]) for i ∈ iterations]

close(tracer_data)
## Make the animation

n = Observable(1)

c_anim = @lift c[$n]
title = @lift @sprintf("Time, t = %s", t[$n])

fig = Figure(resolution = (700, 800))
ax = Axis(fig[1, 1], 
            xlabel = "x",
            ylabel = "y",
            aspect = 1,
            title = title)

hm = heatmap!(ax, x, y, c_anim; colormap = :deep)
Colorbar(fig[2, 1], hm; label = "Concentration", vertical = false, flipaxis = false)
rowsize!(fig.layout, 1, Aspect(1, 1.0))

snapshots = 1:length(t)
record(fig, "turb_avd-diff_tracer.mp4", snapshots, framerate = 15) do i
    n[] = i
end
