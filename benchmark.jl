nthreads = Base.Threads.nthreads()

ENV["OPENBLAS_NUM_THREADS"] = nthreads
ENV["OMP_NUM_THREADS"] = nthreads
ENV["MKL_NUM_THREADS"] = nthreads

using LinearAlgebra
using BenchmarkTools

include("wrapper.jl")
using .faer

using Random
Random.seed!(314)

ma = 20_000
na = 8_000

mb = na
nb = 4_000

a = rand(Float64, ma, na)
b = rand(Float64, mb, nb)

# --- OpenBLAS ---
println("--- OpenBLAS ---")
c = Matrix{Float64}(undef, ma, nb)
@btime mul!($c, $a, $b)

# --- MKL ---
using MKL
println("--- MKL ---")
c = Matrix{Float64}(undef, ma, nb)
@btime mul!($c, $a, $b)

# --- faer ---
println("--- faer ---")
c = Matrix{Float64}(undef, ma, nb)
@btime mult!($c, $a, $b; nthreads=$nthreads)

