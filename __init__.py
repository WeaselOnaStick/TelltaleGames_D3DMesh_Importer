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

        texture_names_cache =   context.preferences.addons[__name__].preferences.texture_names_cache
        bone_names_cache =      context.preferences.addons[__name__].preferences.bone_names_cache

        if texture_names_cache is None:
            cache_box.label(text="Texture Names DB not loaded",icon='CHECKBOX_DEHLT')
        else:
            cache_box.label(text=f"Texture Names DB loaded ({len(texture_names_cache)} items)",icon='CHECKBOX_HLT')

        if bone_names_cache is None:
            cache_box.label(text="Bone Names DB not loaded",icon='CHECKBOX_DEHLT')
        else:
            cache_box.label(text=f"Bone Names DB loaded ({len(bone_names_cache)} items)",icon='CHECKBOX_HLT')

        cache_box.operator("import.ttg_hashdb", icon='IMPORT')



class Manual_db_import(bpy.types.Operator):
    bl_idname = "import.ttg_hashdb"
    bl_label = "Manually Load Databases"
    bl_description = "Loading entire database can be slow, so it's cached internally\n\
Hash databases are loaded on first import automatically\n\
This operator is made to force reload the databases (in case RTB updates them)\n\
Keep in mind loading the databases takes a while. Disabling the addon or even closing Blender will unload the cache"

    def execute(self, context):
        print(context.preferences.addons[__name__].preferences.load_databases(force = True))
        # if isinstance(context.active_operator, D3DMesh_ImportOperator):
        #     context.active_operator.load_databases(force=True)
        return {"FINISHED"}


class AddonPreferences(bpy.types.AddonPreferences):
    bl_idname = __name__

    texture_names_cache = None
    bone_names_cache = None
    
    def load_databases(self, force = False):
        from .import_d3dmesh import load_bones_db, load_tex_db
        if self.bone_names_cache is None or force:
            self.bone_names_cache = load_bones_db(verbose=True)
        if self.texture_names_cache is None or force:
            self.texture_names_cache = load_tex_db(verbose=True)
            pass
    
    def draw(self, context):
        layout = self.layout
        cache_box = layout.column()
        if self.texture_names_cache is None:
            cache_box.label(text="Texture Names DB not loaded",icon='CHECKBOX_DEHLT')
        else:
            cache_box.label(text=f"Texture Names DB loaded ({len(self.texture_names_cache)} items)",icon='CHECKBOX_HLT')

        if self.bone_names_cache is None:
            cache_box.label(text="Bone Names DB not loaded",icon='CHECKBOX_DEHLT')
        else:
            cache_box.label(text=f"Bone Names DB loaded ({len(self.bone_names_cache)} items)",icon='CHECKBOX_HLT')

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
