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

# Generierung Eingespannte Platte
include("fixed-plate.jl")
# Erzeugung unterschiedlicher meshes
include("mesh.jl")
# Geometrieeigenschaften Elemente
include("geometry.jl")
# Formfunktionen unterschiedlicher Elementansätze
include("shapefunctions.jl")
# H-Funktionen aus dem Batoz Tahar Paper
include("DKQ-H-functions.jl")
# Elementsteifigkeitmatrizen DKQ und konformer Hermite Ansatz
include("stiffness_matrix/ke-DKQ.jl")
include("stiffness_matrix/ke-kirchhoff-conforming.jl")
# Assemblierung Gesamtsteifigkeitsmatrix + Randbedingungne
include("fem.jl")
# Berechnungen Schnittgrößen 
include("internal-forces.jl")

# Ausgabe der Ergebnisse und Zwischenergebnisse
include("plots/plot.jl")
include("plots/print-stiffness-matrix.jl")
include("plots/plot-BTP.jl")


p1 = @var Params()
p1.lx = 8		# [m]
p1.ly = 8		# [m]
p1.q = 5e3		# [N/m^2]
p1.ν = 0
p1.h = 0.2		# [m]
p1.r = 8
p1.E = 31000e6;	# [N/m^2]


p2 = @var Params()
p2.lx = p1.lx
p2.ly = p1.lx
p2.q = p1.q
p2.ν = 0.2
p2.h = p1.h
p2.r = p1.r
p2.E = p1.E;

Base.setindex!(d::MMJMesh.Meshes.Data, x, s::Symbol) = setdata!(d.mesh, s, x)
Base.getindex(d::MMJMesh.Meshes.Data, s::Symbol) = data(d.mesh, s)

# Files zum generieren der H funktionen und von Ke der Kirchhoffplatte
include("generate/BTP-H-functions.jl")
include("generate/weak_form-kirchhoff.jl")