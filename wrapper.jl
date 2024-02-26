module faer

export make_zero!
export mult!

using Libdl
using LinearAlgebra

lib = dlopen("target/debug/libfaer_api.so")
fun_make_zero = dlsym(lib, "make_zero")
fun_mult = dlsym(lib, "mult")

function make_zero!(a::StridedMatrix{Float64})
  ccall(fun_make_zero, Cvoid, (Ptr{Cdouble}, Culonglong, Culonglong, Culonglong, Culonglong), a, size(a)[1], size(a)[2], strides(a)[1], strides(a)[2])
  return a
end

function mult!(c::T, a::T, b::T) where {T<:StridedMatrix{<:Float64}}
  (size(a)[2] == size(b)[1]) || throw(DimensionMismatch("a versus b"))
  (size(c) == (size(a)[1], size(b)[2])) || throw(DimensionMismatch("c versus a and b"))

  ccall(
    fun_mult,
    Cvoid,
    (
      Ptr{Cdouble},
      Culonglong,
      Culonglong,
      Culonglong,
      Culonglong,
      Ptr{Cdouble},
      Culonglong,
      Culonglong,
      Culonglong,
      Culonglong,
      Ptr{Cdouble},
      Culonglong,
      Culonglong,
      Culonglong,
      Culonglong,
    ),
    c,
    size(c)[1],
    size(c)[2],
    strides(c)[1],
    strides(c)[2],
    a,
    size(a)[1],
    size(a)[2],
    strides(a)[1],
    strides(a)[2],
    b,
    size(b)[1],
    size(b)[2],
    strides(b)[1],
    strides(b)[2]
  )

  return c
end

end # module

