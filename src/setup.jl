import GLMakie
import CairoMakie
import CairoMakie: Figure,Axis, Axis3, scatter!, lines

import DomainSets

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

include("generated/plate-hartmann-conforming.jl")
include("generated/plate-hartmann-nonconforming.jl")
include("generated/plate-kirchhoff-conforming.jl")
include("generated/plate-kirchhoff-nonconforming.jl")
include("generated/BTP-gen-H-functions.jl")
include("generated/BTP-gen-H-functions-copy.jl")

include("mathematics/BTP-H-functions.jl")
include("mathematics/hermitefunctions-1D.jl")
include("mathematics/hermitefunctions.jl")
include("mathematics/jacobi-matrix.jl")
include("mathematics/lagrangefunctions.jl")
include("mathematics/serendipityfunctions.jl")

include("mesh/make-mesh.jl")
include("mesh/geometrie.jl")

include("plots/plot.jl")
include("plots/print-stiffness-matrix.jl")
include("plots/plot-BTP.jl")

include("results/internal-forces.jl")
include("results/assembleKr.jl")

include("static-system/boundary-conditions.jl")
include("static-system/generate-plate.jl")

include("stiffness_matrix/ke-BTP.jl")
include("stiffness_matrix/weak_form.jl")

p1 = @var Params()
p1.lx = 8		# [m]
p1.ly = 8		# [m]
p1.q = 5e3		# [N/m]
p1.ν = 0.0
p1.h = 0.2		# [m]
p1.E = 31000e6;	# [N/m^2]

p2 = @var Params()
p2.lx = 8
p2.ly = 8
p2.q = 5e3
p2.ν = 0.2
p2.h = 0.2
p2.E = 31000e6;