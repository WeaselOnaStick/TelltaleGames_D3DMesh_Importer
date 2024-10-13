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
from bpy.props import StringProperty
from bpy_extras.io_utils import ImportHelper

class D3DMesh_ImportOperator(bpy.types.Operator, ImportHelper):
    bl_idname = "import_scene.d3dmesh"
    bl_label = "Import D3DMesh"
    # WOAS: I hate how blender api online docs don't have ImportHelper templates or any explanation 
    # so you have to dig through templates built into blender's text editor

    directory: bpy.props.StringProperty(subtype='FILE_PATH', options={'SKIP_SAVE', 'HIDDEN'})
    files: bpy.props.CollectionProperty(type=bpy.types.OperatorFileListElement, options={'SKIP_SAVE', 'HIDDEN'})

    # filename_ext = ".d3dmesh"

    # filter_glob : bpy.props.StringProperty(
    #     default="*.d3dmesh;*.skl",
    #     options={'HIDDEN'},
    #     maxlen=255,  
    # )

    parse_skel : bpy.props.BoolProperty(
        name="Import Skeleton Files (WIP)",
        default=False,
        description="Parse Skeleton Files (*.skl)\nNot Yet Implemented"
    )

    UV_layers : bpy.props.EnumProperty(
        name="UV Layers",
        items=[
            ("MERGE",   "Merge", "", 0),
            ("SPLIT",   "Split", "", 1),
            ("NO",      "Ignore UVs", "", 2)
        ]
    )

    EarlyGameFix : bpy.props.EnumProperty(
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

    Verbose: bpy.props.BoolProperty(
        name="Verbose",
        description="Output extra info to the console",
        default=False,
    )

    def execute(self, context):
        print(f"{context}")
        if not self.directory:
            return {'CANCELLED'}      
        
        for f in self.files:            
            fpath = os.path.join(self.directory, f.name)
            print(f"Processing {fpath}...")
            match os.path.splitext(f.name)[1]:
                case ".d3dmesh":
                    import_d3dmesh(fpath, self.Verbose, self.UV_layers, self.EarlyGameFix)
                case ".skl":
                    self.report({'WARNING'},f".skl files not supported yet")


        
        return {"FINISHED"}
    
    
    # def invoke(self, context, event):
    #     return self.invoke_popup(context)
    
    
    def draw(self, context):
        layout = self.layout
        box = layout.box()
        box.label(text="Supports selecting multiple files", icon='DOCUMENTS')
        layout.prop(self, "UV_layers")
        r = layout.row()
        r.prop(self, "parse_skel")
        r.enabled = False
        r = layout.row()
        r.prop(self, "EarlyGameFix")
        r.enabled = False


def menu_func_import(self, context):
    self.layout.operator(D3DMesh_ImportOperator.bl_idname, text="D3DMesh (.d3dmesh)")

def register():
    bpy.utils.register_class(D3DMesh_ImportOperator)
    bpy.types.TOPBAR_MT_file_import.append(menu_func_import)


def unregister():
    bpy.utils.unregister_class(D3DMesh_ImportOperator)
    bpy.types.TOPBAR_MT_file_import.remove(menu_func_import)
