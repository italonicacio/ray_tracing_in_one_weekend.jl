using Base: AbstractFloat
using Images
using ProgressMeter
import LinearAlgebra.cross
import Base.*

include("vector.jl")
include("ray.jl")
include("material.jl")
include("hit_record.jl")
include("scene.jl")
include("sphere.jl")
include("camera.jl")


function *(c1::RGB, c2::RGB)
    return RGB(c1.r*c2.r, c1.g*c2.g, c1.b*c2.b)
end

function GammaCorrection(color::RGB)
    corrected_color = sqrt.([color.r, color.g, color.b])
    return RGB(corrected_color...)
end

Clamp(value::AbstractFloat, v_min=0.0, v_max= 1.0) = min(max(value, v_min), v_max) 

function Clamp(color::RGB, v_min=0.0, v_max=1.0)
    corrected_color = Clamp.([color.r, color.g, color.b], v_min, v_max)
    return RGB(corrected_color...)
end


function background_color(dir::Vec3)
    t = 0.5 * (dir[2] + 1.0)
    return (1.0 - t)*RGB(1.0, 1.0, 1.0) + t*RGB(0.5, 0.7, 1.0)
end



function RayColor(ray::Ray, scene_list::SceneList, depth::Int)
    record = HitRecord()

    if depth <= 0
        return RGB(0.0, 0.0, 0.0)
    end


    if Hit!(scene_list, ray, 0.0001, Inf, record)
        should_scatter, attenuation, direction = Scatter(record.material, ray, record)    
        
        if should_scatter 
            new_ray = Ray(record.p, direction)
            return attenuation * RayColor(new_ray , scene_list, depth-1)
        else 
            return RGB(0.0, 0.0, 0.0)
        end
    end 

    return background_color(ray.direction)
end




function RayTracer(camera::Camera, world::SceneList, height::Integer, width::Integer, samples_per_pixel::Integer = 100, max_depth::Integer = 50)

    image = RGB.( zeros(height, width) )
    @showprogress 1 "Computing..." for j = 1:height
        for i = 1:width
            pixel_color = RGB(0.0, 0.0, 0.0)
            for n = 1:samples_per_pixel
                
                u =  (i - 1 + rand()) / (width - 1)
                v = 1.0 - (j - 1 + rand()) / (height - 1)
                ray = GetRay(camera, u, v)
                
                pixel_color += RayColor(ray, world, max_depth)
            end

            image[j , i] = Clamp(pixel_color/samples_per_pixel)
        end
    end

    return GammaCorrection.(image)
end

