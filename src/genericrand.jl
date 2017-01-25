### Generic rand methods

# univariate

function _rand!(s::Sampleable{Univariate}, A::AbstractArray)
    for i in 1:length(A)
        @inbounds A[i] = rand(s)
    end
    return A
end
rand!(s::Sampleable{Univariate}, A::AbstractArray) = _rand!(s, A)

rand(s::Sampleable{Univariate}, dims::Dims) =
    _rand!(s, Array{eltype(s)}(dims))

rand(s::Sampleable{Univariate}, dims::Int...) =
    _rand!(s, Array{eltype(s)}(dims))


# multivariate

function _rand!(s::Sampleable{Multivariate}, A::AbstractMatrix)
    for i = 1:size(A,2)
        _rand!(s, view(A,:,i))
    end
    return A
end

function rand!(s::Sampleable{Multivariate}, A::AbstractVector)
    length(A) == length(s) ||
        throw(DimensionMismatch("Output size inconsistent with sample length."))
    _rand!(s, A)
end

function rand!(s::Sampleable{Multivariate}, A::AbstractMatrix)
    size(A,1) == length(s) ||
        throw(DimensionMismatch("Output size inconsistent with sample length."))
    _rand!(s, A)
end

rand(s::Sampleable{Multivariate}) =
    _rand!(s, Vector{eltype(s)}(length(s)))

rand(s::Sampleable{Multivariate}, n::Int) =
    _rand!(s, Matrix{eltype(s)}(length(s), n))


# matrix-variate

function _rand!{M<:Matrix}(s::Sampleable{Matrixvariate}, X::AbstractArray{M})
    for i in 1:length(X)
        X[i] = rand(s)
    end
    return X
end

rand!{M<:Matrix}(s::Sampleable{Matrixvariate}, X::AbstractArray{M}) =
    _rand!(s, X)

rand(s::Sampleable{Matrixvariate}, n::Int) =
    rand!(s, Vector{Matrix{eltype(s)}}(n))


# sampler

# one can specialize this function to provide more efficient samplers
# for certain distributions
sampler(d::Distribution) = d
