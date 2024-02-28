module faer

export mult!

using Libdl # dynamic linker
using LinearAlgebra

lib = dlopen("target/release/libfaer_api.so") # lib pointer
fun_mult = dlsym(lib, "mult") # function pointer

# size and strides cost is negligeable
function mult!(c::T, a::T, b::T; nthreads::Integer=Base.Threads.nthreads()) where {T<:StridedMatrix{<:Float64}}
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
      Culong,
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
    strides(b)[2],
    nthreads
  )

  return c
end

end # module

