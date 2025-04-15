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
include("shapefunctions.jl")

# Berechnungen Gesamtsteifigkeitsmatrix, Schnittgrößen 
include("calculation/internal-forces.jl")
include("calculation/fem.jl")

# System Geometrie, Netz, Randbedinungen (Einspannungen etc.)
include("system/fixed-plate.jl")
include("system/mesh.jl")
include("system/geometry.jl")

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

a = 20 
b = 10 

p3 = @var Params()
p3.lx = 2*a #[m]
p3.ly = 2*b #[m]
p3.q = 0
p3.ν = 0
p3.h = 1 #[m]
p3.E = 1000; # [N/mm^2] [MN/m^2]

p4 = @var Params()
p4.lx = 2*a #[m]
p4.ly = 2*b #[m]
p4.q = 10
p4.ν = 0
p4.h = 1 #[m]
p4.E = 1000; # [N/mm^2] [MN/m^2]

Base.setindex!(d::MMJMesh.Meshes.Data, x, s::Symbol) = setdata!(d.mesh, s, x)
Base.getindex(d::MMJMesh.Meshes.Data, s::Symbol) = data(d.mesh, s)