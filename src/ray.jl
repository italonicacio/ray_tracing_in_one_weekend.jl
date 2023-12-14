

struct Ray{T <: AbstractFloat}
    origin::Vec3{T}
    direction::Vec3{T}

    function Ray{T}(origin::Vec3{T}, direction::Vec3{T}) where T
        new(origin, unitvector(direction))
    end

end

function Ray(origin::Vec3{T}, direction::Vec3{T}) where T
    Ray{T}(origin, direction)    
end 

RayAt(ray::Ray, t::AbstractFloat) = ray.origin + t*ray.direction
    
