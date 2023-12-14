
abstract type Material end

struct Metal <: Material
    albedo::RGB
    fuzz::Float64

end

struct Lambertian <: Material
    albedo::RGB
end

struct Dielectric <: Material
    refraction_index::AbstractFloat
end


function Reflect(dir::Vec3, normal::Vec3)
    return dir - 2.0 * dot(dir, normal) * normal
end

# Metal
function RandomInSphere()
    theta = rand(0.0:0.001:2*π)
    phi = rand(0.0:0.001:π)
    r = rand()
    return r * Vec3(cos(theta)*sin(phi), sin(theta)*sin(phi), cos(phi))
end

function Scatter(material::Metal, ray::Ray, record::HitRecord)
    

    reflected_dir = Reflect(ray.direction, record.normal) + material.fuzz * RandomInSphere()

    should_scatter = dot(reflected_dir, record.normal) > 0
    return should_scatter, material.albedo, reflected_dir 
end

# Lambertian
function RandomUnitVector()
    theta = rand(0.0:0.001:2*π)
    phi = rand(0.0:0.001:π)
    return Vec3(cos(theta)*sin(phi), sin(theta)*sin(phi), cos(phi))
end

function Scatter(material::Lambertian, ray::Ray, record::HitRecord)
    scatter_dir = record.normal + RandomUnitVector()
    
    if all(map( x -> isapprox(x, 0; atol = 1e-8), scatter_dir ))
        scatter_dir = record.normal
    end

    
    return true, material.albedo, scatter_dir
end


# Dielectric



function Refract(dir::Vec3, normal::Vec3, refraction_ratio::AbstractFloat )
    cos_theta = dot(-dir, normal)
    perp = refraction_ratio * (dir + cos_theta*normal)
    parallel = - sqrt(1 - normsquared(perp)) * normal
    return perp + parallel
end

function Reflectance(cosine, ref_idx)
    r_theta = (1 - ref_idx) / (1 + ref_idx)
    r_theta = r_theta^2

    return r_theta + (1 - r_theta)*((1-cosine)^5)
    
end

function Scatter(material::Dielectric, ray::Ray, record::HitRecord)
    ir = material.refraction_index
    refraction_ratio = record.front_face ? 1.0/ir : ir    
    unit_direction = unitvector(ray.direction)

    cos_theta = dot(-unit_direction, record.normal)
    sin_theta = sqrt(1 - cos_theta^2)
    
    cannot_refract = refraction_ratio * sin_theta > 1.0

    if cannot_refract || Reflectance(cos_theta, refraction_ratio) > rand()
        scatter_dir = Reflect(unit_direction, record.normal)
    else
        scatter_dir = Refract(unit_direction, record.normal, refraction_ratio)
    end
    
    return true, RGB(1.0, 1.0, 1.0), scatter_dir
end

