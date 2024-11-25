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

include("generated/plate-hartmann-conforming.jl")
include("generated/plate-hartmann-nonconforming.jl")
include("generated/plate-kirchhoff-conforming.jl")
include("generated/plate-kirchhoff-nonconforming.jl")
include("generated/BTP-Hx-functions.jl")
include("generated/BTP-Hy-functions.jl")
include("generated/jacobianMatrix.jl")

include("mathematics/BTP-H-functions.jl")
include("mathematics/hermitefunctions-1D.jl")
include("mathematics/hermitefunctions.jl")
include("mathematics/jacobi-matrix.jl")
include("mathematics/lagrangefunctions.jl")
include("mathematics/serendipityfunctions.jl")

include("mesh/make-mesh.jl")
include("mesh/geometrie.jl")

include("plots/plot.jl")
include("plots/plot-functions.jl")
include("plots/print-stiffness-matrix.jl")
include("plots/print-BTP-H-functions.jl")

include("results/internal-forces.jl")
include("results/assembleKr.jl")

include("static-system/boundary-conditions.jl")
include("static-system/generate-plate.jl")

include("stiffness_matrix/weak_form.jl")

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