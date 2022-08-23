### A Pluto.jl notebook ###
# v0.19.11

using Markdown
using InteractiveUtils

# ╔═╡ 15bb6500-b175-422d-b2a5-2b66aae0af41
begin
	using Pkg
	Pkg.activate(".")
end

# ╔═╡ 84e02c5a-a436-4ecf-bc05-5c23ffa32f1a
using HypertextLiteral, PlutoUI

# ╔═╡ 068fc5c9-2077-4ca4-ae7b-7a09cf0a012c
md"""
# Pluto notebook for dashboard display

I am hoping to create a dashboard using Pluto.jl featuring some animations and information about passive tracer flows.
"""

# ╔═╡ 003ae29b-3e89-4369-bd9b-8cfd9889421d
begin
	adv_diff_url = "https://github.com/jbisits/PassiveTracerFlows_demos/blob/main/Animations/avd-diff_tracer.mp4"
	cats_eye_url = "https://github.com/jbisits/PassiveTracerFlows_demos/blob/main/Animations/avd-diff_catseye_tracer.mp4"
	turb_ad_url = "https://github.com/jbisits/PassiveTracerFlows_demos/blob/main/Animations/turb_avd-diff_tracer.mp4"
end

# ╔═╡ 65fb8ee6-eaac-48d8-8b35-35747729d5b1
Resource(adv_diff_url)

# ╔═╡ 84614b56-42e6-4ec0-9ca1-789d09911ddc
md"""
I have not been able to get these `Resource`s to appear in the notebook so instead i will use a `LocalResource`.
"""

# ╔═╡ 3a22c38a-f530-487a-ba6f-1e9faeca6f36
md"""
# Images as `LocalResource`

Thus far cannot make the `Resource` work.
Not sure if this is a GitHub issue to do with how the files are saved or just have the address wrong.
"""

# ╔═╡ 171d64c3-caf0-4425-ac65-ff034770d920
path_to_anims = "/Users/Joey/Documents/GitHub/PassiveTracerFlows_demos/Animations"

# ╔═╡ f37333ef-5b7d-4e4a-922d-32298fd05c35
begin
	adv_diff = joinpath(path_to_anims, "avd-diff_tracer.mp4")
	cats_eye = joinpath(path_to_anims, "avd-diff_catseye_tracer.mp4")
	turb_ad = joinpath(path_to_anims, "turb_avd-diff_tracer.mp4")
end

# ╔═╡ 61b91bdf-ead5-4aa1-a4d5-1e1cda8c50cd
begin
	cats_eye_cell = PlutoRunner.currently_running_cell_id[] |> string
	local_cats_eye = LocalResource(cats_eye, :autoplay => "", :loop => "", :width => 500, :height => 500)
end

# ╔═╡ 2090be93-dc9e-4f1b-a0ef-b337f556a32d
begin
	avd_diff_cell = PlutoRunner.currently_running_cell_id[] |> string
	local_adv_diff = LocalResource(adv_diff, :autoplay => "", :loop => "", :width => 500, :height => 500)
end

# ╔═╡ 8f5a8658-d2cd-4e13-8423-3217c616ca44
begin
	turb_ad_cell = PlutoRunner.currently_running_cell_id[] |> string
	local_turb_ad = LocalResource(turb_ad, :autoplay => "", :loop => "", :width => 500, :height => 500)
end

# ╔═╡ 3f51870b-c4b7-405a-9e1e-f35dd70aac8f
md"""
# Create the dashboard from the cells
"""

# ╔═╡ 88abdf87-52ec-4141-8fb6-3170d46e77ee
begin
	setup_cell = PlutoRunner.currently_running_cell_id[] |> string
	PlutoUI.ExperimentalLayout.vbox(
		[
			@htl("""<h1 {text-align: center}>Passive tracer animations using the advection diffusion equation </h1>"""),
			PlutoUI.ExperimentalLayout.hbox([local_adv_diff, local_cats_eye, local_turb_ad], 
			style=Dict("justify-content" => "center", "align-items" => "center", "gap" => "5em"))
		],
		style=Dict("background" => "border-radius" => "50px", "padding" => "20px", "margin" => "20px"))
end

# ╔═╡ 2a776370-2764-4ff0-ab2e-c1162f032bad
begin
	md_cell = PlutoRunner.currently_running_cell_id[] |> string
	md"""
	The advection-diffusion equation
	```math
	\frac{\partial C}{\partial t} + \mathbf{u} \cdot \nabla C = \kappa \nabla^{2}C
	```
	allows simulations of passive tracer experiments to be carried out in one, two or three dimensions for a flow field ``\mathbf{u}``.
	The boundary conditions are *doubly periodic*, so that what leaves through the eastern/western boundary enters through the western/eastern boundary and what leaves throught the northern/southern boundary enters through the southern/northern boundary.
	Here we have simulations run in two dimensions with three different kinds of flows.
	
	The first (top left animation) has a **positive constant background zonal flow** (zonal here is the left to right direction while meridional is the top to bottom).
	The effect of this is to move the *blob* of concentration from left to right.
	
	The second (middle) uses a steady flow (not changing in time) where we define the streamfunction ``\psi(x, y) = \sin{x}\sin{y} + 0.5\cos{x}\cos{y}`` (plotted as the contour lines).
	From the streamfunction we get the zonal and meridional componenets of the flow ``u(x, y) = -\partial_{y}\psi`` and ``v(x, y) = \partial_{x} \psi`` respectively.

	Lastly we use a flow that has a *baroclinic instability* to mimic the effect of mesoscale eddies.
	Another model (the two layer quasi-geostrophic model) is used to generate the flow field which is then used to advect the passive tracer.

	All the simulations were generated using the Julia package `PassiveTracerFlows.jl`.
	The code repository to generate these simulations and this dashboard can be found here https://github.com/jbisits/PassiveTracerFlows_demos.
	"""
end

# ╔═╡ fe3e08f8-3dd0-4ebe-a1e7-7ec063222aba
cells = [setup_cell, md_cell]

# ╔═╡ 092a445d-7ece-4eb5-844b-c6032e6e4c09
notebook = PlutoRunner.notebook_id[] |> string

# ╔═╡ f4a2dbcf-e134-4530-b464-d1dc38236e53
dash_final_url = "http://localhost:1234/edit?" * "id=$notebook&" * join(["isolated_cell_id=$cell" for cell ∈ cells], "&")

# ╔═╡ 8f410075-033a-4cdf-827e-3e89d4db3762
@htl("""<a href="$dash_final_url" style="font-size: 30px">Click here to get to the dashboard!</a>""")

# ╔═╡ Cell order:
# ╟─068fc5c9-2077-4ca4-ae7b-7a09cf0a012c
# ╟─15bb6500-b175-422d-b2a5-2b66aae0af41
# ╠═84e02c5a-a436-4ecf-bc05-5c23ffa32f1a
# ╠═003ae29b-3e89-4369-bd9b-8cfd9889421d
# ╠═65fb8ee6-eaac-48d8-8b35-35747729d5b1
# ╟─84614b56-42e6-4ec0-9ca1-789d09911ddc
# ╟─3a22c38a-f530-487a-ba6f-1e9faeca6f36
# ╠═171d64c3-caf0-4425-ac65-ff034770d920
# ╠═f37333ef-5b7d-4e4a-922d-32298fd05c35
# ╠═61b91bdf-ead5-4aa1-a4d5-1e1cda8c50cd
# ╠═2090be93-dc9e-4f1b-a0ef-b337f556a32d
# ╠═8f5a8658-d2cd-4e13-8423-3217c616ca44
# ╟─3f51870b-c4b7-405a-9e1e-f35dd70aac8f
# ╟─88abdf87-52ec-4141-8fb6-3170d46e77ee
# ╟─2a776370-2764-4ff0-ab2e-c1162f032bad
# ╟─fe3e08f8-3dd0-4ebe-a1e7-7ec063222aba
# ╟─092a445d-7ece-4eb5-844b-c6032e6e4c09
# ╟─f4a2dbcf-e134-4530-b464-d1dc38236e53
# ╟─8f410075-033a-4cdf-827e-3e89d4db3762
