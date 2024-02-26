module faer

export make_zero!

using Libdl
using LinearAlgebra

lib = dlopen("target/debug/libfaer_api.so")
fun = dlsym(lib, "make_zero")

function make_zero!(a::StridedMatrix{Float64})
  ccall(fun, Cvoid, (Ptr{Cdouble}, Culonglong, Culonglong, Culonglong, Culonglong), a, size(a)[1], size(a)[2], strides(a)[1], strides(a)[2])
  return a
end

end # module

