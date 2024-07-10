import GLMakie
import CairoMakie
import CairoMakie: Figure, Axis3, scatter!, lines

using CairoMakie

using MMJMesh
using MMJMesh.Plots
#import MMJMesh.Plots: _fsize, _makegmap
using MMJMesh.Meshes
import MMJMesh.Meshes: entities
using MMJMesh.MMJBase
using MMJMesh.Utilities
using MMJMesh.Topologies
using MMJMesh.Mathematics

using DomainSets: ×, (..)

using Makie
using Revise
using Latexify
using GLMakie

using VarStructs
using SparseArrays
using LinearAlgebra
using Symbolics

GLMakie.activate!()
set_theme!(theme_minimal())
update_theme!(faceplotmesh=5)
update_theme!(edgelinewidth=2.5)
update_theme!(colormap=:aquamarine)

include("plate.jl")
include("fem.jl")
include("plot.jl")
include("hermite4.jl")
include("internal-forces.jl")
include("element_stiffness_matrix.jl")


p = @var Params()
p.lx = 8
p.ly = 8
p.q = 5e3
p.ν = 0.0
p.h = 0.2
p.E = 31000e6;