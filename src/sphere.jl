

struct Sphere{T <:AbstractFloat} <: SceneObject
    center::Vec3{T}
    radius::T
    material::Material

    function Sphere{T}(c::Vec3{T}, r::T, mat::Material) where T
        new(c, r, mat)
    end
end

function Sphere(c::Vec3{T}, r::T, mat::Material) where T <: AbstractFloat
    Sphere{T}(c, r, mat)
end

function  Hit!(sphere::Sphere, ray::Ray, t_min, t_max, record::HitRecord)
    oc = ray.origin - sphere.center
    a = normsquared(ray.direction)
    half_b = dot(ray.direction, oc)
    c = normsquared(oc) - sphere.radius^2
    discriminant = half_b^2 - a*c

    if discriminant < 0.0
        return false

    else
        sqrd = sqrt(discriminant)
        t = (-half_b - sqrd) / a

        if t < t_min || t > t_max
            t = (-half_b + sqrd) / a
            if t < t_min || t > t_max
                return false

            end
        end
        record.t = t
        record.p = RayAt(ray, t)
        outward_normal = (record.p - sphere.center) / sphere.radius
        record.front_face = dot(ray.direction, outward_normal) < 0
        record.normal = record.front_face ? outward_normal : -outward_normal
        record.material = sphere.material
            
        return true
    end
end