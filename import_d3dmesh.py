from .wbr import WBR
from .bpy_build import buildModel
from .bpy_build import buildSkeleton
import bpy

def load_db(db_name : str, verbose = True):
    import os, struct

    def printifv(x, end="\n"):
        if verbose: print(x, end=end)

    #TODO Handle missing DB
    names_txt_fp = os.path.join(os.path.dirname(__file__), f"Original Scripts\\TelltaleHashDBs\\{db_name}")
    db = {}
    data = bytearray()
    with WBR(open(names_txt_fp, "rb")) as f:
        data = f.read()
    
    pairs_num = struct.unpack('L', data[:4])[0]
    data_len = len(data)
    printifv(f"importing {db_name} with {pairs_num} hash-name pairs, please be patient...")
    cursor = 4
    for n in range(pairs_num):
        if cursor+9 > len(data):
            break
        hash2, hash1 = struct.unpack('LL', data[cursor:cursor+8])
        cursor += 8
        name_bytes = bytearray()
        next_byte = data[cursor]
        while (next_byte != 0):
            name_bytes.append(next_byte)
            cursor += 1
            next_byte = data[cursor]
        cursor += 1
        name = name_bytes.decode('ansi')
        db[(hash1,hash2)] = name
    
    return db

def load_bones_db(verbose):
    return load_db("BoneNames.HashDB", verbose)

def load_tex_db(verbose):
    return load_db("TexNames.HashDB", verbose)

def import_d3dmesh(filepath,
                   verbose=False,
                   uv_layers='MERGE',
                   early_game_fix=0,
                   parse_lods = False,
                   join_submeshes = True,
                   tex_db = None,
                   bone_db = None,
                   ) -> list[bpy.types.Object]:
    f = open(filepath, 'rb')
    f = WBR(f)
    res = []

    def printifv(x, end="\n"):
        if verbose: print(x, end=end)

    AllFace_array = []
    FaceB_array = []
    AllVert_array = []
    Normal_array = []
    UV_array = []
    UV2_array = []
    UV3_array = []
    UV4_array = []
    UV5_array = []
    UV6_array = []
    B1_array = []
    W1_array = []
    Color_array = []
    Alpha_array = []
    FixedBoneID_array = []
    BoneIDOffset_array = []
    PolyStruct_array = []
    MatHash_array = []
    TexName_array = []
    FacePointCount = 0
    FacePointCountB = 0


    header = f.readLong()
    HeaderMagic = header.to_bytes(4).decode('ascii')
    printifv(f"HeaderMagic = {HeaderMagic}")
    FileSize = f.readLong()
    printifv(f"FileSize = {FileSize}")
    f.seek_rel(0x08)
    ParamCount = f.readLong()
    printifv(f"ParamCount = {ParamCount}")
    for x in range(ParamCount):
        f.seek_rel(0x0C)
    D3DNameHeaderLength = f.readLong()
    D3DNameLength = f.readLong()
    if D3DNameLength > D3DNameHeaderLength:
        f.seek_rel(-0x04)
        D3DNameLength = D3DNameHeaderLength

    printifv(f"D3DNameHeaderLength {D3DNameHeaderLength}, D3DNameLength {D3DNameLength}")
    D3DName = f.readString(D3DNameLength)
    VerNum = f.readByte()
    print(f"Importing {D3DName} Version {VerNum}...")
    if VerNum != 55:
        print("Model format version 55 not supported!")
        return

    #Skipping Section 1 (Model Info) skipping
    printifv(f"Section 1 (Model Info) start @{f.tell()-1}")
    f.seek_rel(0x14)

    # Section 2 (Material Info)
    printifv(f"Section 2 (Material Info) start @{f.tell()}")
    
    MatCount = f.readLong()
    printifv(f"Material Count = {MatCount}")

    MatHash_array = []
    #Parsing Material Info
    for m in range(MatCount):
        MatStart = f.tell()
        MatHash2 = f.readLong()
        MatHash1 = f.readLong()
        UnkHash2 = f.readLong()
        UnkHash1 = f.readLong()
        MatHeaderSize = f.tell() + f.readLong()

        MatUnk1 = f.readLong()
        MatUnk2 = f.readLong()
        MatHeaderSizeB = f.readLong()

        MatUnk3Count = f.readLong()
        for x in range(MatUnk3Count):
            MatUnk3Hash2 = f.readLong()
            MatUnk3Hash1 = f.readLong()

        MatParamCount = f.readLong()
        printifv(f"Material #{m+1} start @{MatStart}, MatHeaderSize = {MatHeaderSize}, MatHeaderSizeB = {MatHeaderSizeB}")
        TexDifName = "undefined"
        printifv(f"Material Parameter Count = {MatParamCount}")
        for mp in range(MatParamCount):
            #TODO parse all MatSectHash
            MatSectHash2 = f"{f.readLong():x}"
            MatSectHash1 = f"{f.readLong():x}"
            MatSectCount = f.readLong()
            printifv(f"Material Param #{mp+1} Hash: {MatSectHash1.rjust(8)} {MatSectHash2.rjust(8)}, Count = {MatSectCount:12d}, \t@{f.tell()}")
            match (MatSectHash1, MatSectHash2):
                case ("4f0234","63d89fb0"):
                    for y in range(MatSectCount):
                        MatUnkHashs = f.readLongs(4)
                case ("bae4cbd7", "7f139a91"):
                    for y in range(MatSectCount):
                        MatUnkHash2, MatUnkHash1 = f.readLongs(2)
                        MatUnkFloat = f.readFloat()
                case ("9004c558","7575d6c0"):
                    for y in range(MatSectCount):
                        MatUnkHash2, MatUnkHash1 = f.readLongs(2)
                        MatUnkBytePad = f.readByte()

        f.seek_abs(MatHeaderSize)
    
    printifv(f"Section 2 (Material Info) end @{f.tell()}")
    unk = f.readLong()
    pad = f.readByte()
    FaceDataStart = f.tell() + f.readLong() #WOAS: I'd just like to point out how random it is for this pointer to be here of all places, can't imagine how RTB figured this out
    printifv(f"FaceDataStart @{FaceDataStart}")

    Sect3End = f.tell() + f.readLong()
    Sect3Count = f.readLong()
    #f.debugNreads("L", n=32)
    printifv(f"Section 3 (LOD info) start @{f.tell()}, Count = {Sect3Count}")

    #TODO Parse LOD Info
    for lodc in range(Sect3Count):
        Sect3AEnd = f.tell() + f.readLong()
        PolyTotal = f.readLong()
        printifv(f"LOD #{lodc+1} start @{f.tell()-0x4*2}, Count = {PolyTotal}")
        for polt in range(PolyTotal):
            BoundingMinX = f.readFloat(); BoundingMinY = f.readFloat(); BoundingMinZ = f.readFloat()
            BoundingMaxX = f.readFloat(); BoundingMaxY = f.readFloat(); BoundingMaxZ = f.readFloat()
            HeaderLength = f.readLong()
            unknown1 = f.readLong()
            UnkFloat2 = f.readFloat()
            UnkFloat3 = f.readFloat()
            UnkFloat4 = f.readFloat()
            unknown2 = f.readLong()
            VertexMin = f.readLong() + 1
            VertexMax = f.readLong() + 1
            VertexStart = f.readLong()
            FacePointStart = f.readLong()
            PolygonStart = int(FacePointStart / 3) + 1
            PolygonCount = f.readLong()
            FacePointCount = f.readLong()
            HeaderLength2 = f.readLong()
            if HeaderLength2 == 0x10:
                unknown2A = f.readLong()
                unknown2B = f.readLong()
            unknown3 = f.readLong()
            MatNum = f.readLong() + 1
            unknown4 = f.readLong() + 1
            if lodc == 0 or (lodc >= 1 and parse_lods):
                PolyStruct_array.append({
                        "VertexStart" : VertexStart,
                        "VertexMin" : VertexMin,
                        "VertexMax" : VertexMax,
                        "PolygonStart" : PolygonStart,
                        "PolygonCount" : PolygonCount,
                        "FacePointCount" : FacePointCount,
                        "MatNum" : MatNum,
                        "LODNum" : lodc,
                        }
                )
            printifv(f"Bounding Box = {BoundingMinX, BoundingMinY, BoundingMinZ}|{BoundingMaxX, BoundingMaxY, BoundingMaxZ}")
            printifv(f"VertStart @ {VertexStart}, Vertminmax = {VertexMin,VertexMax}, Polystart @{PolygonStart}, PolyCount = {PolygonCount}, FacePointCount = {FacePointCount}, Matnum {MatNum}, Unknowns = {unknown1, unknown2, unknown3, unknown4}")
        f.seek_abs(Sect3AEnd)

        printifv(f"Section 3B start @{f.tell()}")
        Sect3BEnd = f.tell() + f.readLong()
        Poly2Total = f.readLong()
        for polt2 in range(Poly2Total):
            BoundingMinX = f.readFloat(); BoundingMinY = f.readFloat(); BoundingMinZ = f.readFloat()
            BoundingMaxX = f.readFloat(); BoundingMaxY = f.readFloat(); BoundingMaxZ = f.readFloat()
            HeaderLength = f.readLong()
            unknown1 = f.readLong()
            UnkFloat2 = f.readFloat()
            UnkFloat3 = f.readFloat()
            UnkFloat4 = f.readFloat()
            unknown2 = f.readLong()
            VertexMin = f.readLong() + 1
            VertexMax = f.readLong() + 1
            VertexStart = f.readLong()
            FacePointStart = f.readLong()
            PolygonStart = int(FacePointStart / 3) + 1
            PolygonCount = f.readLong()
            FacePointCount = f.readLong()
            HeaderLength2 = f.readLong()
            if HeaderLength2 == 0x10:
                unknown2A = f.readLong()
                unknown2B = f.readLong()
            unknown3 = f.readLong()
            MatNum = f.readLong() + 1
            unknown4 = f.readLong() + 1
            
            printifv(f"Bounding Box = {BoundingMinX, BoundingMinY, BoundingMinZ}|{BoundingMaxX, BoundingMaxY, BoundingMaxZ}")
            printifv(f"VertStart @ {VertexStart}, Vertminmax = {VertexMin,VertexMax}, Polystart @{PolygonStart}, PolyCount = {PolygonCount}, FacePointCount = {FacePointCount}, Matnum {MatNum}, Unknowns = {unknown1, unknown2, unknown3, unknown4}")

        f.seek_abs(Sect3BEnd)

        printifv(f"Section 3C start @{f.tell()}")
        unknown1 = f.readLong()
        unknown2 = f.readLong()
        BoundingMinX = f.readFloat(); BoundingMinY = f.readFloat(); BoundingMinZ = f.readFloat()
        BoundingMaxX = f.readFloat(); BoundingMaxY = f.readFloat(); BoundingMaxZ = f.readFloat()
        unknown3 = (f.readLong()) - 4
        UnkFloat1 = f.readFloat()
        UnkFloat2 = f.readFloat()
        UnkFloat3 = f.readFloat()
        UnkFloat4 = f.readFloat()
        blank1 = f.readLong()
        blank2 = f.readLong()
        unknown4 = f.readLong()
        unknown5 = f.readLong()
        blank3 = f.readLong()
        unknown6 = f.readLong()
        unknown7 = f.readLong()
        unknown8 = f.readLong()
        unknown9 = f.readLong()
        unknown10 = f.readLong()

        printifv(f"Bounding Box = {BoundingMinX, BoundingMinY, BoundingMinZ}|{BoundingMaxX, BoundingMaxY, BoundingMaxZ}")
        #mostly unknowns here, skipping

        IDHeaderLen = f.readLong() - 4
        BoneIDOffset_array.append(f.tell())
        BoneIDCount = f.readLong()
        print(f"Section 3D (Bone IDs) start @{f.tell()}, Count = {BoneIDCount}")
        for bid in range(BoneIDCount):
            BoneHash2, BoneHash1 = f.readLongs(2)


    f.seek_abs(Sect3End)
    Sect4End = f.tell() + f.readLong()
    Sect4Count = f.readLong()
    printifv(f"Section 4 (Empty?) start @{f.tell()}, Count = {Sect4Count}")
    f.seek_abs(Sect4End)

    printifv(f"Section 5 (Material Groups) start @{f.tell()}")
    Sect5End = f.tell() + f.readLong()
    MatGroupCount = f.readLong()
    for mg in range(MatGroupCount):
        MatSectLength = f.readLong()
        MatHash2 = f.readLong()
        MatHash1 = f.readLong()
        MatUnkHash2 = f.readLong()
        MatUnkHash1 = f.readLong()
        blank1 = f.readFloat()
        blank2 = f.readFloat()
        MatFloatA = f.readFloat()
        MatFloatB = f.readFloat()
        MatFloatC = f.readFloat()
        MatFloatD = f.readFloat()
        MatFloatE = f.readFloat()
        MatFloatF = f.readFloat()
        MatFloats = [MatFloatA,MatFloatB,MatFloatC,MatFloatD,MatFloatE,MatFloatF,]
        MatSubHeaderLen = f.readLong()
        MatSubFloatA = f.readFloat()
        MatSubFloatB = f.readFloat()
        MatSubFloatC = f.readFloat()
        MatSubFloatD = f.readFloat()
        MatSubFloats = [MatSubFloatA,MatSubFloatB,MatSubFloatC,MatSubFloatD,]
        MatUnk = f.readLong()
        printifv(f"Floats = {MatFloats}, {MatSubFloats}")
        for y in range(len(MatHash_array)):
            pass
    f.seek_abs(Sect5End)

    Sect6End = f.tell() + f.readLong()
    Sect6Count = f.readLong()
    printifv(f"Section 6 start @{f.tell()}, Count = {Sect6Count}")
    for sx in range(Sect6Count):
        Sect6HeaderLen, Sect6Hash2, Sect6Hash1, Sect6Unk = f.readLongs(4)
    
    f.seek_abs(Sect6End)

    Sect7End = f.tell() + f.readLong()
    BoneIDCount = f.readLong()
    if BoneIDCount > 0: BoneIDSets = 1
    printifv(f"Section 7 (Bone IDs) start @{f.tell()}, Count = {BoneIDCount}")
    
    f.seek_abs(Sect7End)
    Sect8End = f.tell() + f.readLong()
    Sect8Count = f.readLong()
    printifv(f"Section 8 (Empty?) start @{f.tell()}, Count = {Sect8Count}")

    f.seek_abs(Sect8End)
    Sect9End = f.tell() + f.readLong()
    Sect9Count = f.readLong()
    printifv(f"Section 9 (Empty?) start @{f.tell()}, Count = {Sect9Count}")

    f.seek_abs(Sect9End)
    printifv(f"Section 10 (Model Clamps) start @{f.tell()}")
    if (True): # just for folding
        MeshUnk1 = f.readLong()
        MeshFlag1 = f.readByte()
        MeshFlag2 = f.readByte()
        MeshFlag3 = f.readByte()
        MeshFlag4 = f.readByte()
        MeshXMin = f.readFloat(); MeshYMin = f.readFloat(); MeshZMin = f.readFloat()
        MeshXMax = f.readFloat(); MeshYMax = f.readFloat(); MeshZMax = f.readFloat()
        MeshXMult = MeshXMax - MeshXMin; 
        MeshYMult = MeshYMax - MeshYMin; 
        MeshZMult = MeshZMax - MeshZMin

        MeshSubSectLength = f.readLong()
        MeshFloatA = f.readFloat()
        MeshFloatB = f.readFloat()
        MeshFloatC = f.readFloat()
        MeshFloatD = f.readFloat()
        MeshUnk3 = f.readLong()
        MeshFloat1 = f.readFloat()
        MeshFloat2 = f.readFloat()
        MeshFloat3 = f.readFloat()
        MeshFloatX = f.readFloat()
        MeshFloatY = f.readFloat()
        MeshFloatZ = f.readFloat()
        MeshFloat4 = f.readFloat()
        MeshFloat5 = f.readFloat()
        MeshFloat6 = f.readFloat()
        MeshUnk4 = f.readLong()
        MeshHash2 = f.readLong()
        MeshHash1 = f.readLong()
        MeshOrient = "Q"
        if (MeshFloatX != 0x00) : MeshOrient = "X"
        if (MeshFloatY != 0x00) : MeshOrient = "Y"
        if (MeshFloatZ != 0x00) : MeshOrient = "Z"
        printifv(f"Flags = 0x{MeshFlag1:x}, 0x{MeshFlag2:x}, 0x{MeshFlag3:x}, 0x{MeshFlag4:x}, Orientation = {MeshOrient}")
    
    printifv(f"Section 11 start @{f.tell()}")

    VertCount = f.readLong()
    VertFlags = f.readLong()
    Sect11AEnd = f.tell() + f.readLong()
    Sect11ACount = f.readLong()
    printifv(f"Flags: 0x{VertFlags:x}, Count = {Sect11ACount}")

    f.seek_abs(Sect11AEnd)
    printifv(f"Section 11B (UV Clamps) start @{f.tell()}")
    UVLayerCount = f.readLong()
    printifv(f"UV Clamp Count = {UVLayerCount}")
    
    UVMults = [[1,1]]*6
    UVStarts = [[0,0]]*6

    for uvl in range(UVLayerCount):
        UVLayer = f.readLong()
        UVXMult = f.readFloat(); UVYMult = f.readFloat()
        UVXStart = f.readFloat(); UVYStart = f.readFloat()
        if UVLayer not in [0,1,2,3,4,5]:
            print("Unknown UV Layer!")
            continue
        UVMults[UVLayer] = [UVXMult, UVYMult]
        UVStarts[UVLayer] = [UVXStart, UVYStart]
        printifv(f"UV Layer #{UVLayer+1} UV Mul = {UVMults[UVLayer]}, UV Start = {UVStarts[UVLayer]}")

    if (VertCount == 0):
        return

    printifv(f"Section 11C start @{f.tell()}")
    HasVertex       = False;    VertexFmt = 0
    HasNormals      = False;    NormalsFmt = 0
    HasTangents     = False;    TangentsFmt = 0
    HasBinormals    = False;    BinormalsFmt = 0
    HasWeights      = False;    WeightsFmt = 0
    HasBones        = False;    BonesFmt = 0
    HasColors       = False;    ColorsFmt = 0
    HasColors2      = False;    Colors2Fmt = 0
    HasUV1          = False;    UV1Fmt = 0
    HasUV2          = False;    UV2Fmt = 0
    HasUV3          = False;    UV3Fmt = 0
    HasUV4          = False;    UV4Fmt = 0
    HasUV5          = False;    UV5Fmt = 0
    HasUV6          = False;    UV6Fmt = 0

    match VertFlags:
        case 0x00 | 0x01 | 0x03 | 0x05 | 0x09 | 0x21: printifv(f"Unimportant VertexFlags")
        case 0x31:
            VertBuffUnk1 = f.readLong()
            VertBuffUnk2 = f.readLong()
            VertBuffUnk3 = f.readLong()
            VertBuffUnk4 = f.readLong()
            VertBuffUnk5 = f.readLong()
            VertBuffUnk6 = f.readLong()
            VertBuffUnk7 = f.readLong()
            VertBuffUnk8 = f.readLong()
            VertBuffUnk9 = f.readLong()
            VertParamStart = f.tell() + f.readLong()
            VertBuffSize = f.readLong()
            VertStart = f.tell()
            f.seek_abs(VertParamStart)
        case _: printifv("Unknown vertex flags")
    
    printifv(f"Section 12 (Vertex/Face Buffer Info) start @{f.tell()}")


    BuffUnk1 = f.readLong()
    BuffUnk2 = f.readLong()
    FaceBufferCount = f.readLong()
    BufferCount1 = f.readLong()
    BufferCount2 = f.readLong()

    for buf in range(BufferCount1):
        VertType = f.readLong() + 1
        VertFormat = f.readLong() + 1
        VertLayer = f.readLong() + 1
        VertBuffNum = f.readLong() + 1
        VertOffset = f.readLong() + 1
        printifv(f"Vertex Type = {VertType}, Format = {VertFormat},  Layer = {VertLayer}, Buffer Number = {VertBuffNum}, Offset = {VertOffset}", end=" ")
        match (VertType, VertLayer):
            case (1,1): HasVertex = VertBuffNum; VertexFmt = VertFormat     ; printifv(f"(Vertex Format)")
            case (4,1): HasWeights = VertBuffNum; WeightsFmt = VertFormat   ; printifv(f"(Weights Format)")
            case (5,1): HasBones = VertBuffNum; BonesFmt = VertFormat       ; printifv(f"(Bones Format)")
            case (2,1): HasNormals = VertBuffNum; NormalsFmt = VertFormat   ; printifv(f"(Normals Format)")
            case (3,1): HasTangents = VertBuffNum; TangentsFmt = VertFormat ; printifv(f"(Tangents Format)")
            case (2,2): HasBinormals = VertBuffNum; BinormalsFmt = VertFormat;printifv(f"(Binormals Format)")
            case (7,5): HasUV5 = VertBuffNum; UV5Fmt = VertFormat           ; printifv(f"(UV5 Format)")
            case (7,6): HasUV6 = VertBuffNum; UV6Fmt = VertFormat           ; printifv(f"(UV6 Format)")
            case (6,1): HasColors = VertBuffNum; ColorsFmt = VertFormat     ; printifv(f"(Colors Format)")
            case (6,2): HasColors2 = VertBuffNum; Colors2Fmt = VertFormat   ; printifv(f"(Colors2 Format)")
            case (7,1): HasUV1 = VertBuffNum; UV1Fmt = VertFormat           ; printifv(f"(UV1 Format)")
            case (7,2): HasUV2 = VertBuffNum; UV2Fmt = VertFormat           ; printifv(f"(UV2 Format)")
            case (7,3): HasUV3 = VertBuffNum; UV3Fmt = VertFormat           ; printifv(f"(UV3 Format)")
            case (7,4): HasUV4 = VertBuffNum; UV4Fmt = VertFormat           ; printifv(f"(UV4 Format)")
            case _: print("Unknown vertex buffer combo")
    
    printifv(f"Writing down FacePointCounts... FaceBufferCount = {FaceBufferCount}")
    for fb in range(FaceBufferCount):
        FaceBuffUnk1,FaceBuffUnk2,FaceBuffUnk3,FaceBuffCount,FaceBuffLength = f.readLongs(5)
        match fb:
            case 0: FacePointCount = FaceBuffCount; FaceLength = FaceBuffLength
            case 1: FacePointCountB = FaceBuffCount; FaceLengthB = FaceBuffLength

    for buff in range(BufferCount2+1):
        Buff2Unk1,Buff2Format,Buff2Unk2,Buff2Count,Buff2Length = f.readLongs(5)

    f.seek_abs(FaceDataStart)
    printifv(f"Facepoint buffer A start @{f.tell()}, Count = {FacePointCount} ({int(FacePointCount/3)})")

    for fp in range(int(FacePointCount/3)):
        fa = f.readShort() + 1
        fb = f.readShort() + 1
        fc = f.readShort() + 1
        AllFace_array.append((fa, fb, fc))
    
    if (FaceBufferCount == 2):
        printifv(f"Facepoint buffer B start @{f.tell()}, Count = {FacePointCountB}")
        
        for fpb in range(int(FacePointCountB/3)):
            fa = f.readShort() + 1
            fb = f.readShort() + 1
            fc = f.readShort() + 1
            FaceB_array.append((fa, fb, fc))
        
        printifv(f"Facepoint buffer B end @{f.tell()}")
    
    match VertFlags:
        case 0x00|0x01|0x03|0x05|0x09|0x21:
            print(f"Skipping useless VertFlags {VertFlags:x}")
        case 0x31:
            VertStartB = f.tell()
            f.seek_abs(VertStart)

            for v in range(VertCount):
                vx,vy,vz = f.readFloats(3)
                Bone1, Bone2, Bone3, Bone4 = f.readBytes(4)
                f.seek_rel(0x08)
                #AllVert_array.append((vx,vy,vz)) duplicate verts?
                B1_array.append((Bone1, Bone2, Bone3, Bone4))
            
            f.seek_abs(VertStartB)
    
    if not HasVertex:
        return
    
    printifv(f"Positions start @ {f.tell()}")
    match VertexFmt:
        case 4:
            for v in range(VertCount):
                vx,vy,vz = f.readFloats(3)
                AllVert_array.append((vx,vy,vz))
        case 27:
            for v in range(VertCount):
                vx = f.readShort()/65535 * MeshXMult + MeshXMin
                vy = f.readShort()/65535 * MeshYMult + MeshYMin
                vz = f.readShort()/65535 * MeshZMult + MeshZMin
                vq = f.readShort() / 65535
                AllVert_array.append((vx,vy,vz))
        case 42:
            for v in range(VertCount):
                PosVars = f.readLong() # for some reason RTB's script reads this as signed Long
                vx = (PosVars & 0x3FF) / 1023
                vy = ((PosVars >> 10) & 0x3FF) / 1023
                vz = ((PosVars >> 20) & 0x3FF) / 1023
                match MeshOrient:
                    case "X": vx = vx/4 + (PosVars >> 30)/4
                    case "Y": vy = vy/4 + (PosVars >> 30)/4
                    case "Z": vz = vz/4 + (PosVars >> 30)/4
                    case _: pass
                vx = vx * MeshXMult + MeshXMin
                vy = vy * MeshYMult + MeshYMin
                vz = vz * MeshZMult + MeshZMin

                AllVert_array.append((vx,vy,vz))
        case _: printifv(f"Unknown position format {VertexFmt}")
    
    if HasWeights > 0:
        pass
        #printifv(f"Weights start @ {f.tell()}")
        #TODO parse weights

    if HasBones > 0:
        #TODO parse bones
        pass
    if HasNormals > 0:
        #TODO parse normals
        pass
    if HasTangents > 0:
        #TODO parse tangents
        pass
    if HasBinormals > 0:
        #TODO parse binormals
        pass
    if HasUV5 > 0:
        #TODO parse UV5
        pass
    if HasUV6 > 0:
        #TODO parse UV6
        pass
    if HasColors > 0:
        #TODO parse col
        pass
    if HasColors2 > 0:
        #TODO parse col2
        pass
    if HasUV1 > 0:
        #TODO parse UV1
        pass
    if HasUV2 > 0:
        #TODO parse UV2
        pass
    if HasUV3 > 0:
        #TODO parse UV3
        pass
    if HasUV4 > 0:
        #TODO parse UV4
        pass

    for polystruct in PolyStruct_array:
        print(f"Polygon_Info_Dict {polystruct}")
    
    parse_lods = parse_lods and Sect3Count > 1

    for lodnum in range(Sect3Count):
        face_array = []
        mat_id_array = []
        if join_submeshes:
            joined_faces_array = []
            for polystruct in PolyStruct_array:
                if polystruct['LODNum'] == lodnum:
                    for y in range(polystruct['PolygonCount']):
                        Faces3 = AllFace_array[polystruct['PolygonStart']+y-2]
                        for fv in Faces3:
                            fv += polystruct['VertexStart']
                        joined_faces_array.append(Faces3)
                        #mat_id_array.append(polystruct['MatNum'])
            name = f"{D3DName}" + (f" (LOD #{lodnum})" if parse_lods else "")
            lodmodel_data = {
                "name": name,
                "verts" : AllVert_array,
                "faces" : joined_faces_array,
                "offset_face_idxs" : -1,
            }

            res.append(lodmodel_data)
        else:
            for polynum,polystruct in enumerate(PolyStruct_array):
                face_array = []
                if polystruct['LODNum'] == lodnum:
                    for y in range(polystruct['PolygonCount']):
                        Faces3 = AllFace_array[polystruct['PolygonStart']+y-1]
                        for fv in Faces3:
                            fv += polystruct['VertexStart']
                        face_array.append(Faces3)
                        mat_id_array.append(polystruct['MatNum'])
                        name = f"{D3DName}_" + f"{polynum}".zfill(3) + (f" (LOD #{lodnum})" if parse_lods else "")
                    lodmodel_data = {
                        "name": name,
                        "verts" : AllVert_array,
                        "faces" : face_array,
                        "offset_face_idxs" : -1,
                    }
                    res.append(lodmodel_data)

    f.close()
    res_models = []
    for res_data in res:
        res_models.append(buildModel(**res_data))
    return res_models
