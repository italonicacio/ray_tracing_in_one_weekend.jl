mutable struct HitRecord{T <: AbstractFloat}
    p::Vec3{T}
    t::T
    normal::Vec3{T}
    front_face::Bool
    material::Material

    function HitRecord{T}(p::Vec3{T}, t::T, normal::Vec3{T}) where T
        new(p, t, normal, false, Metal(RGB(0.0, 0.0, 0.0), 0.0))
    end

end

function HitRecord(p::Vec3{T}, t::T, normal::Vec3{T}) where T <: AbstractFloat
    HitRecord{T}(p, t, normal)
end

function HitRecord()
    HitRecord(Vec3(0.0, 0.0, 0.0), 0.0, Vec3(0.0, 0.0, 0.0))
end