import GLMakie
import CairoMakie
import CairoMakie: Figure,Axis, Axis3, scatter!, lines

# import Pkg
# Pkg.add(url="https://github.com/matthiasbaitsch/mmjmesh.git")

using CairoMakie

using MMJMesh
using MMJMesh.Plots
using MMJMesh.Meshes
using MMJMesh.MMJBase
using MMJMesh.Utilities
using MMJMesh.Topologies
using MMJMesh.Mathematics

using DomainSets: ×, (..)

using Makie
using Revise
using Latexify
using GLMakie
using WGLMakie
using VarStructs
using SparseArrays
using LinearAlgebra
using Symbolics

# GLMakie.activate!()
set_theme!(theme_minimal())
update_theme!(faceplotmesh=0.5)
update_theme!(edgelinewidth=0.5)
update_theme!(colormap=:aquamarine)

function _fsize(face)
	x = coordinates(face)
	p = x[:, 1]
	l1 = x[1, 2] - x[1, 1]
	l2 = x[2, 3] - x[2, 2]
	return p, l1, l2
end

include("plate.jl")
include("fem.jl")
include("plots/plot.jl")
include("plots/print.jl")
include("mathematics/hermite4.jl")
include("internal-forces.jl")
include("stiffness_matrix/weak_form.jl")
include("stiffness_matrix/element_stiffness_matrix.jl")
include("mesh/makemesh.jl")
include("generated/plate-hartmann-conforming.jl")
include("generated/plate-hartmann-nonconforming.jl")
include("generated/plate-kirchhoff-conforming.jl")
include("generated/plate-kirchhoff-nonconforming.jl")

p1 = @var Params()
p1.lx = 8
p1.ly = 8
p1.q = 5e3
p1.ν = 0.0
p1.h = 0.2
p1.E = 31000e6;

p2 = @var Params()
p2.lx = 8
p2.ly = 8
p2.q = 5e3
p2.ν = 0.2
p2.h = 0.2
p2.E = 31000e6;