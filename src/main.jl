include("ray_tracer.jl")

function RandomScene(world::SceneList)
    ground_material = Lambertian(RGB(0.5, 0.5, 0.5))
    push!(world, Sphere(Vec3(0.0, -1000.0, 0.0), 1000.0, ground_material))

    # for a = -11:1
    #     for b = -11:1 
    #         choose_mat = rand()
    #         center = Vec3(a + 0.9*rand(), 0.2, b + 0.9*rand())

    #         if norm(center - Vec3(4.0, 0.2, 0.0)) > 0.9 
                

    #             if choose_mat < 0.8 
    #                 #  diffuse
    #                 rd1 = rand()
    #                 rd2 = rand()
    #                 albedo = RGB(rd1, rd1, rd1) * RGB(rd2, rd2, rd2)
    #                 sphere_material = Lambertian(albedo);
    #                 push!(world, Sphere(center, 0.2, sphere_material))

    #             elseif choose_mat < 0.95 
    #                 #  metal
                    
    #                 albedo = rand(0.5:0.001:1)
    #                 fuzz = rand(0:0.001:0.5)
    #                 sphere_material = Metal(albedo, fuzz);
    #                 push!(world, Sphere(center, 0.2, sphere_material))
    #              else 
    #                 # glass
    #                 sphere_material = Dielectric(1.5);
    #                 push!(world, Sphere(center, 0.2, sphere_material))
    #              end
    #         end
    #     end
    # end
    

    material1 = Dielectric(1.5)
    
    material2 = Lambertian(RGB(0.4, 0.2, 0.1))

    material3 = Metal(RGB(0.7, 0.6, 0.5), 0.0)

    push!(world, Sphere(Vec3(0.0, 1.0, 0.0), 1.0, material1))
    push!(world, Sphere(Vec3(-4.0, 1.0, 0.0), 1.0, material2))
    push!(world, Sphere(Vec3(4.0, 1.0, 0.0), 1.0, material3))
end

material_floor = Lambertian(RGB(0.8, 0.8, 0.0))
material_center = Lambertian(RGB(0.1, 0.2, 0.5))
material_left = Metal(RGB(0.8, 0.8, 0.8), 0.3)
material_right = Metal(RGB(0.8, 0.6, 0.2), 1.0)


glass = Dielectric(1.5)

s1 = Sphere(Vec3(0.0, 0.0, -1.0), 0.5, material_center)
s2 = Sphere(Vec3(-1.0, 0.0, -1.0), 0.5, glass)
s3 = Sphere(Vec3(1.0, 0.0, -1.0), 0.5, material_right)
# s4 = Sphere(Vec3(2.5, 0.2, -1.0), 0.5)

s5 = Sphere(Vec3(-1.0, 0.0, -1.0), -0.4, glass)



big_radius = 100.0
floor = Sphere(Vec3(0.0, -big_radius - 0.5, -1.0), big_radius, material_floor)

println("Creating Random Scene")

world = SceneList()
# RandomScene(world)



push!(world, s1)
push!(world, s2)
push!(world, s3)
# push!(world, s4)
push!(world, s5)
push!(world, floor)

# Image
const aspect_ratio = 16/9
const width = 1200
const height = trunc(Int64, width / aspect_ratio)
samples = 100
max_depth = 50

# Camera
# degree = 20
# look_from = Vec3(13.0, 2.0, 3.0)
# look_at = Vec3(0.0, 0.0, -1.0)
# up = Vec3(0.0, 1.0, 0.0)
# aperture = 10.0
# focus_dist = 0.1

degree = 90
look_from = Vec3(0.0, 0.0, 0.0)
look_at = Vec3(0.0, 0.0, -1.0)
up = Vec3(0.0, 1.0, 0.0)
aperture = 0.0
focus_dist = 1.0


camera = Camera(degree, look_from, look_at, up, aspect_ratio,aperture, focus_dist)


println("Image size $width x $height")

frame = RayTracer(camera, world, height, width, samples, max_depth)

save("rendered/img21.png", frame)
