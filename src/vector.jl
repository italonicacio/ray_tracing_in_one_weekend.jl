

const Vec3{T <: Real} = Array{T, 1}

function Vec3{T}(x::T, y::T, z::T) where T
    [x, y ,z]
end

function Vec3(x::T, y::T, z::T) where T
    Vec3{T}(x, y, z)
end

normsquared(vector::Vec3) = sum(map(v -> v^2, vector))

norm(vector::Vec3) = sqrt(normsquared(vector))

dot(v1::Vec3, v2::Vec3) = v1'*v2

unitvector(vector::Vec3) = vector/ norm(vector)


