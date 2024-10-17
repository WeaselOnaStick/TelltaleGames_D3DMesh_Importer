# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTIBILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

import bpy
import os
from .import_d3dmesh import import_d3dmesh
from .import_skl import import_skl
from bpy.props import StringProperty
from bpy_extras.io_utils import ImportHelper
from math import pi

class D3DMesh_ImportOperator(bpy.types.Operator, ImportHelper):
    bl_idname = "import_scene.d3dmesh"
    bl_label = "Import D3DMesh"
    bl_options = {'REGISTER', 'PRESET'}
    # WOAS: I hate how blender api online docs don't have ImportHelper templates or any explanation 
    # so you have to dig through templates built into blender's text editor

    directory: bpy.props.StringProperty(subtype='FILE_PATH', options={'SKIP_SAVE', 'HIDDEN'})
    files: bpy.props.CollectionProperty(type=bpy.types.OperatorFileListElement, options={'SKIP_SAVE', 'HIDDEN'})

    rotation : bpy.props.FloatVectorProperty(
        name="Rotation",
        subtype='EULER',
        unit='ROTATION',
        default=(pi/2,0,0)
    )

    scale : bpy.props.FloatVectorProperty(
        name="Scale",
        default=(1,1,1)
    )

    parse_skeleton : bpy.props.BoolProperty(
        name="Import Skeleton Files (WIP)",
        default=False,
        description="Parse Skeleton Files (*.skl)\nNot Yet Implemented"
    )

    parse_materials : bpy.props.BoolProperty(
        name="Parse Materials",
        default=True,
        description=""
    )

    parse_textures : bpy.props.BoolProperty(
        name="Parse Textures",
        default=True,
        description=""
    )

    uv_layers : bpy.props.EnumProperty(
        name="UV Layers",
        items=[
            ("MERGE",   "Merge", "", 0),
            ("SPLIT",   "Split", "", 1),
            ("NO",      "Ignore UVs", "", 2)
        ]
    )
    
    parse_lods: bpy.props.BoolProperty(
        name="Parse LODs",
        description="If unchecked only first LOD is going to be imported",
        default=False,
    )

    early_game_fix : bpy.props.EnumProperty(
        name="Early Game Fix",
        items=[
            ("OLD",         "Texas Hold'em / Bone / CSI 3/4 / Sam and Max S1/S2 (Ep. 1/2)",""),
            ("SM2-34",      "Sam and Max Season 2 (Ep. 3/4)",""),
		    ("SM2-5",       "Sam and Max Season 2 (Ep. 5 - What's New, Beelzebub?)",""),
            ("SBCG4AP-1",   "Strong Bad's CG4AP (Ep. 1 - Homestar Ruiner)",""),
            ("SBCG4AP-2",   "Strong Bad's CG4AP (Ep. 2 - Strong Badia the Free)",""),
            ("SBCG4AP-3",   "Strong Bad's CG4AP (Ep. 3 - Baddest of the Bands)",""),
            ("SBCG4AP-4",   "Strong Bad's CG4AP (Ep. 4 - Dangeresque 3)",""),
            ("SBCG4AP-5",   "Strong Bad's CG4AP (Ep. 5 - 8-Bit is Enough)",""),
            ("WG",          "Wallace and Gromit (Ep. 1-3)",""),
        ],
        description="Early Game Fix\nNot Yet Implemented"
    )

    verbose: bpy.props.BoolProperty(
        name="Verbose Console Output",
        description="Output extra info to the console",
        default=True,
    )
    
    filter_glob: StringProperty(
        default="*.d3dmesh;*.skl",
        options={'HIDDEN'},
        maxlen=255,  # Max internal buffer length, longer would be clamped.
    )

    def execute(self, context):
        if not self.directory:
            return {'CANCELLED'}

        if self.parse_skeleton and context.preferences.addons[__name__].preferences.bone_names_cached_amt == 0:
            context.preferences.addons[__name__].preferences.load_databases(force = False)
        
        if (self.parse_textures or self.parse_materials) and context.preferences.addons[__name__].preferences.tex_names_cached_amt == 0:
            context.preferences.addons[__name__].preferences.load_databases(force = False)
        
        for f in self.files:            
            fpath = os.path.join(self.directory, f.name)
            print(f"Processing {fpath}...")
            new_objs = []
            match os.path.splitext(f.name)[1]:
                case ".d3dmesh":
                    new_objs = import_d3dmesh(
                        filepath=fpath,
                        verbose=self.verbose,
                        uv_layers=self.uv_layers,
                        early_game_fix=self.early_game_fix,
                        parse_lods=self.parse_lods,
                        bone_db=context.preferences.addons[__name__].preferences.get_bone_database(),
                        tex_db=context.preferences.addons[__name__].preferences.get_tex_database(),
                    )
                case ".skl":
                    self.report({'WARNING'},f".skl files not supported yet")
                    import_skl(
                        #params would go here
                    )
            for new_obj in new_objs:
                match type(new_obj):
                    case bpy.types.Object:              
                        context.scene.collection.objects.link(new_obj)
                        new_obj.rotation_euler = self.rotation
                        new_obj.scale = self.scale
                    case _:
                        print(new_obj)


        self.report({'INFO'}, "Finished!")
        return {"FINISHED"}
    
    
    # def invoke(self, context, event):
    #     return self.invoke_popup(context)
    
    
    def draw(self, context):
        layout = self.layout
        box = layout.box()
        box.label(text="Supports selecting multiple files", icon='DOCUMENTS')
        layout.prop(self, "rotation")
        layout.prop(self, "scale")
        layout.prop(self, "parse_materials", icon='MATERIAL_DATA')
        layout.prop(self, "parse_textures", icon='TEXTURE')
        r = layout.row()
        r.label(text="UV Layers: ", icon='UV_DATA')
        r.prop(self, "uv_layers", text="")
        layout.prop(self, "parse_lods", icon='MOD_MULTIRES')
        r = layout.row()
        r.prop(self, "parse_skeleton", icon='ARMATURE_DATA')
        r.enabled = False
        r = layout.row()
        r.label(text="Early Game Fix:", icon='GHOST_DISABLED')
        r.prop(self, "early_game_fix", text="")
        r.enabled = False
        layout.prop(self, "verbose", icon='CONSOLE')
        cache_box = layout.box()
        cache_box = cache_box.column()

        bone_names_cached_amt  =   context.preferences.addons[__name__].preferences.bone_names_cached_amt
        tex_names_cached_amt =      context.preferences.addons[__name__].preferences.tex_names_cached_amt

        if bone_names_cached_amt == 0:
            cache_box.label(text="Bone Names DB not loaded",icon='CHECKBOX_DEHLT')
        else:
            cache_box.label(text=f"Bone Names DB loaded ({bone_names_cached_amt}) items)",icon='CHECKBOX_HLT')

        if tex_names_cached_amt == 0:
            cache_box.label(text="Texture Names DB not loaded",icon='CHECKBOX_DEHLT')
        else:
            cache_box.label(text=f"Texture Names DB loaded ({tex_names_cached_amt} items)",icon='CHECKBOX_HLT')

        cache_box.operator("import.ttg_hashdb", icon='IMPORT')



class Manual_db_import(bpy.types.Operator):
    bl_idname = "import.ttg_hashdb"
    bl_label = "Manually Load Databases"
    bl_description = "Loading entire database can be slow, so it's cached internally\n\
Hash databases are loaded on first import automatically\n\
This operator is made to force reload the databases (in case RTB updates them)\n\
Keep in mind loading the databases takes a while. Disabling the addon or closing Blender will unload the cache"

    def execute(self, context):
        context.preferences.addons[__name__].preferences.load_databases(force = True)
        return {"FINISHED"}


class AddonPreferences(bpy.types.AddonPreferences):
    bl_idname = __name__

    bone_names_cache_pickled : bpy.props.StringProperty(
        name="Bone Names DB pickled"
    )    

    texture_names_cache_pickled :  bpy.props.StringProperty(
        name="Texture Names DB pickled"
    )

    bone_names_cached_amt : bpy.props.IntProperty(default=0)
    tex_names_cached_amt : bpy.props.IntProperty(default=0)
    
    def load_databases(self, force = False):
        import pickle
        from .import_d3dmesh import load_bones_db, load_tex_db
        if self.bone_names_cache_pickled == "" or force:
            bones_db = load_bones_db(verbose=True)
            self.bone_names_cached_amt = len(bones_db)
            self.bone_names_cache_pickled = pickle.dumps(bones_db).hex()
        if self.texture_names_cache_pickled == "" or force:
            tex_db = load_tex_db(verbose=True)
            self.tex_names_cached_amt = len(tex_db)
            self.texture_names_cache_pickled = pickle.dumps(tex_db).hex()

    def get_bone_database(self):
        if self.bone_names_cache_pickled == "":
            return
        import pickle
        return pickle.loads(bytes.fromhex(self.bone_names_cache_pickled))
    
    def get_tex_database(self):
        if self.texture_names_cache_pickled == "":
            return
        import pickle
        return pickle.loads(bytes.fromhex(self.texture_names_cache_pickled))

    


    def draw(self, context):
        layout = self.layout
        cache_box = layout.column()
        
        bone_names_cached_amt = self.bone_names_cached_amt
        tex_names_cached_amt = self.tex_names_cached_amt

        if bone_names_cached_amt == 0:
            cache_box.label(text="Bone Names DB not loaded",icon='CHECKBOX_DEHLT')
        else:
            cache_box.label(text=f"Bone Names DB loaded ({bone_names_cached_amt}) items)",icon='CHECKBOX_HLT')

        if tex_names_cached_amt == 0:
            cache_box.label(text="Texture Names DB not loaded",icon='CHECKBOX_DEHLT')
        else:
            cache_box.label(text=f"Texture Names DB loaded ({tex_names_cached_amt} items)",icon='CHECKBOX_HLT')

        cache_box.operator("import.ttg_hashdb", icon='IMPORT')
    



classes_to_register = [D3DMesh_ImportOperator, Manual_db_import, AddonPreferences]

def menu_func_import(self, context):
    self.layout.operator(D3DMesh_ImportOperator.bl_idname, text="D3DMesh (.d3dmesh)")

def register():
    for cls in classes_to_register:
        bpy.utils.register_class(cls)
    bpy.types.TOPBAR_MT_file_import.append(menu_func_import)


def unregister():
    for cls in classes_to_register:
        bpy.utils.unregister_class(cls)
    bpy.types.TOPBAR_MT_file_import.remove(menu_func_import)
