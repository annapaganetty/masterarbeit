import Makie
import GLMakie
import WGLMakie
import CairoMakie
import CairoMakie: 
    activate!, set_theme!, theme_minimal, update_theme!,
    Figure,Axis, Axis3, scatter!, lines, DataAspect, 
    hidedecorations!, hidespines!, Colorbar

using MMJMesh
using MMJMesh.Plots
using MMJMesh.Meshes
using MMJMesh.MMJBase
using MMJMesh.Utilities
using MMJMesh.Topologies
using MMJMesh.Mathematics

using MMJMesh.Utilities: makemeshonrectangle

using Revise
using Latexify
using Symbolics
using VarStructs
using LaTeXStrings
using SparseArrays
using LinearAlgebra

activate!()
set_theme!(theme_minimal())
update_theme!(faceplotmesh = 5)
update_theme!(edgelinewidth = 2.5)
update_theme!(colormap = (:aquamarine, 1.0))
# H-Funktionen aus dem Batoz Tahar Paper
include("h-functions/BTP-gen-H-functions.jl")
include("h-functions/BTP-H-functions.jl")

# Formfunktionen unterschiedlicher Elementansätze

include("shapefunctions/hermitefunctions-1D.jl")
include("shapefunctions/hermitefunctions.jl")
include("shapefunctions/lagrangefunctions.jl")
include("shapefunctions/serendipityfunctions.jl")

# Berechnungen Gesamtsteifigkeitsmatrix, Schnittgrößen 
include("calculation/internal-forces.jl")
include("calculation/assembleKr.jl")

# System Geometrie, Netz, Randbedinungen (Einspannungen etc.)
include("system/boundary-conditions.jl")
include("system/generate-plate.jl")
include("system/make-mesh.jl")
include("system/geo-element.jl")

# Elementsteifigkeitmatrizen unterschiedlicher Elementansätze
include("stiffness_matrix/ke-batoz-tahar.jl")
include("stiffness_matrix/weak_form-kirchhoff.jl") ####
include("stiffness_matrix/ke-hartmann-conforming.jl")
include("stiffness_matrix/ke-hartmann-nonconforming.jl")
include("stiffness_matrix/ke-kirchhoff-conforming.jl")
include("stiffness_matrix/ke-kirchhoff-nonconforming.jl")

# Ausgabe der Ergebnisse und Zwischenergebnisse
include("plots/plot.jl")
include("plots/print-stiffness-matrix.jl")
include("plots/plot-BTP.jl")


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


Base.setindex!(d::MMJMesh.Meshes.Data, x, s::Symbol) = setdata!(d.mesh, s, x)
Base.getindex(d::MMJMesh.Meshes.Data, s::Symbol) = data(d.mesh, s)