

struct Camera
    
    origin::Vec3
    horizontal::Vec3
    vertical::Vec3
    lower_left_corner::Vec3
    lens_radius::AbstractFloat
    u::Vec3
    v::Vec3
    w::Vec3


    function Camera(vfov, look_from::Vec3, look_at::Vec3,up::Vec3, aspect_ratio, aperture=0.0, focus_dist=1.0)

        w = unitvector(look_from - look_at)
        u = unitvector(cross(up, w))
        v = unitvector(cross(w, u))

        theta = deg2rad(vfov)
        h = tan(theta/2)
        
        viewport_height = 2.0 * h
        viewport_width = viewport_height * aspect_ratio
        
        horizontal = u * viewport_width * focus_dist
        vertical = v * viewport_height * focus_dist
        
        lens_radius = aperture/2
        
       
        lower_left_corner = look_from - horizontal/2 - vertical/2 - w * focus_dist

        new(look_from, horizontal, vertical, lower_left_corner, lens_radius, u, v, w)
    end
end

function RandomInDisc()
    while true
        theta = rand(0.0:0.001:2*π)
        p = Vec3(cos(theta), sin(theta), 0.0)
        if norm(p) < 1.0
            return p
        end 
    end
    
end


function GetRay(camera::Camera, s::Float64, t::Float64)
    random_direction = camera.lens_radius * RandomInDisc()
    offset = camera.u * random_direction[1] + camera.v * random_direction[2]

    origin = camera.origin + offset
    dir = camera.lower_left_corner + s*camera.horizontal + t*camera.vertical - origin - offset
    return Ray(origin, dir)
end

