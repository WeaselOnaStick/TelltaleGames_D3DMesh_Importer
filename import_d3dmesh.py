from .wbr import WBR

def import_d3dmesh(Filepath, Verbose=False, UV_layers='MERGE', EarlyGameFix=0):
    f = open(Filepath, 'rb')
    f = WBR(f)

    def printifv(x):
        if Verbose:
            print(x)

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
            #TODO parse Material Params
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

    if (VertCount != 0):
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
            printifv(f"Vertex Type = {VertType}, Format = {VertFormat},  Layer = {VertLayer}, Buffer Number = {VertBuffNum}, Offset = {VertOffset}")
            match (VertType, VertLayer):
                case (1,1): HasVertex = VertBuffNum; VertexFmt = VertFormat
                case (4,1): HasWeights = VertBuffNum; WeightsFmt = VertFormat
                case (5,1): HasBones = VertBuffNum; BonesFmt = VertFormat
                case (2,1): HasNormals = VertBuffNum; NormalsFmt = VertFormat
                case (3,1): HasTangents = VertBuffNum; TangentsFmt = VertFormat
                case (2,2): HasBinormals = VertBuffNum; BinormalsFmt = VertFormat
                case (7,5): HasUV5 = VertBuffNum; UV5Fmt = VertFormat
                case (7,6): HasUV6 = VertBuffNum; UV6Fmt = VertFormat
                case (6,1): HasColors = VertBuffNum; ColorsFmt = VertFormat
                case (6,2): HasColors2 = VertBuffNum; Colors2Fmt = VertFormat
                case (7,1): HasUV1 = VertBuffNum; UV1Fmt = VertFormat
                case (7,2): HasUV2 = VertBuffNum; UV2Fmt = VertFormat
                case (7,3): HasUV3 = VertBuffNum; UV3Fmt = VertFormat
                case (7,4): HasUV4 = VertBuffNum; UV4Fmt = VertFormat
                case _: print("Unknown vertex buffer combo")
        
        for fb in range(FaceBufferCount):
            FaceBuffUnk1,FaceBuffUnk2,FaceBuffUnk3,FaceBuffCount,FaceBuffLength = f.readLongs(5)
            match fb:
                case 1: FacePointCount = FaceBuffCount; FaceLength = FaceBuffLength
                case 2: FacePointCountB = FaceBuffCount; FaceLengthB = FaceBuffLength

        for buff in range(BufferCount2):
            Buff2Unk1,Buff2Format,Buff2Unk2,Buff2Count,Buff2Length = f.readLongs(5)




    f.close()