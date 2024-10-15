import bpy

def buildModel(name, 
               verts, 
               faces, 
               uvs=[], 
               bones=[], 
               weights=[], 
               colors=[],
               verbose=False,
               offset_face_idxs = 0) -> bpy.types.Object: 
    m = bpy.data.meshes.new(name)
    if offset_face_idxs != 0:
        offset_faces = []
        for f in faces:
            new_f = []
            for fv in f:
                new_f.append(fv+offset_face_idxs)
            offset_faces.append(new_f)
        faces = offset_faces
    
    m.from_pydata(verts, [], faces)
    mo = bpy.data.objects.new(name,m)
    return mo

def buildSkeleton(name, bones) -> bpy.types.Object:
    pass