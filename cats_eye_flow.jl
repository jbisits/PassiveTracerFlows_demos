# Using a cat-s eye flow from [Scalar transport and alpha-effect for a family of cat’s-eye flows](https://www.cambridge.org/core/journals/journal-of-fluid-mechanics/article/abs/scalar-transport-and-alphaeffect-for-a-family-of-catseye-flows/A649BCF133BB25DA3B80239024945C77)

using PassiveTracerFlows, LinearAlgebra

## Setting up the probelem
dev = CPU()

nsteps = 18000
Δt = 0.005
Lx = 32
nx = 64
κ = 0.1
stepper = "RK4"
ϵ = 0.1
# Streamfunction
ψ(x, y) = sin(x) * sin(y) + ϵ * cos(x) * cos(y)
# u = -∂ψ/∂y, v = ∂ψ/∂x
u(x, y) = -sin(x) * cos(y) + ϵ * cos(x) * sin(y)
v(x, y) =  cos(x) * sin(y) - ϵ * sin(y) * cos(x)

advecting_flow = TwoDAdvectingFlow(; u, v, steadyflow = true)

prob = TracerAdvectionDiffusion.Problem(dev, advecting_flow; nx = nx, Lx = Lx, κ, dt = Δt, stepper)

sol, clock, vars, params, grid = prob.sol, prob.clock, prob.vars, prob.params, prob.grid
x, y = grid.x, grid.y
xgrid, ygrid = gridpoints(grid)
## Initial condition

gaussian(x, y, σ) = exp(-(x^2 + y^2) / 2σ^2)

amplitude, spread = 1, 0.15
c₀ = [amplitude * gaussian(x[i], y[j], spread) for i in 1:grid.nx, j in 1:grid.ny]

TracerAdvectionDiffusion.set_c!(prob, c₀)

## Saving output
function get_concentration(prob)
    ldiv!(prob.vars.c, prob.grid.rfftplan, deepcopy(prob.sol))
  
    return prob.vars.c
end
  
output = Output(prob, "Data/adv-diff_catseye_2D.jld2",
                (:concentration, get_concentration))
saveproblem(output)

## Step the problem forward and save data
save_frequency = 100 # frequency at which output is saved

startwalltime = time()
while clock.step <= nsteps
    if clock.step % save_frequency == 0
    saveoutput(output)
    log = @sprintf("Output saved, step: %04d, t: %.2f, walltime: %.2f min",
                    clock.step, clock.t, (time()-startwalltime) / 60)

    println(log)
    end

    stepforward!(prob)
end

## Create an animation

tracer_data = jldopen("Data/adv-diff_catseye_2D.jld2")

iterations = parse.(Int, keys(tracer_data["snapshots/t"]))
t = round.([tracer_data["snapshots/t/$i"] for i ∈ iterations])
x, y = tracer_data["grid/x"], tracer_data["grid/y"]
c = [abs.(tracer_data["snapshots/concentration/$i"]) for i ∈ iterations]

close(tracer_data)

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
contour!(ax, x, y, ψ.(xgrid, ygrid); color = :black)
Colorbar(fig[2, 1], hm; label = "Concentration", vertical = false, flipaxis = false)
rowsize!(fig.layout, 1, Aspect(1, 1.0))

snapshots = 1:length(t)
record(fig, "Animations/avd-diff_catseye_tracer.mp4", snapshots, framerate = 15) do i
    n[] = i
end
