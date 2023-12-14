import Base.push!


abstract type SceneObject end

struct SceneList <: SceneObject
    objects::Vector{SceneObject}

    function SceneList(objects::Vector{SceneObject})
        new(objects) 
    end
end

SceneList() = SceneList(Vector{SceneObject}())    

function push!(scene_list::SceneList, object::SceneObject)
    push!(scene_list.objects, object)
end

function Hit!(scene_list::SceneList, ray::Ray, t_min, t_max, record::HitRecord)
    hit_anything = false
    aux_record = HitRecord()
    closest_so_far = t_max


    for object in scene_list.objects
        if Hit!(object, ray::Ray, t_min, closest_so_far, aux_record)
            hit_anything = true
            closest_so_far = aux_record.t

            record.p = aux_record.p
            record.t = aux_record.t
            record.normal = aux_record.normal
            record.front_face = aux_record.front_face
            record.material = aux_record.material
        end
    end

    return hit_anything
end

