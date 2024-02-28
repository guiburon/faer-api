using LinearAlgebra

nthreads = Base.Threads.nthreads()
BLAS.set_num_threads(nthreads)
ENV["MKL_NUM_THREADS"] = nthreads

include("wrapper.jl")
using .faer

using BenchmarkTools
using Random
Random.seed!(314)

ma = 20_000
na = 8_000

mb = na
nb = 4_000

a = rand(Float64, ma, na)
b = rand(Float64, mb, nb)

# --- faer ---
println("--- faer ---")
c = Matrix{Float64}(undef, ma, nb)
@btime mult!($c, $a, $b; nthreads=$nthreads)

# --- Octavian ---
using Octavian
println("--- Octavian ---")
c = Matrix{Float64}(undef, ma, nb)
@btime matmul!($c, $a, $b)

# --- OpenBLAS ---
println("--- OpenBLAS ---")
c = Matrix{Float64}(undef, ma, nb)
@btime mul!($c, $a, $b)

# --- MKL ---
using MKL
println("--- MKL ---")
c = Matrix{Float64}(undef, ma, nb)
@btime mul!($c, $a, $b)

