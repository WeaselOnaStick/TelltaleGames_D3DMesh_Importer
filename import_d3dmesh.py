from .wbr import WBR

def import_d3dmesh(filepath, VerboseLevel = 1):
    f = open(r"C:\Users\woas\Downloads\d3d\input\obj_carTaxiA.d3dmesh", 'rb')
    f = WBR(f)

    header = f.readLong()
    HeaderMagic = header.to_bytes(4).decode('ascii')
    print(f"HeaderMagic = {HeaderMagic}")
    FileSize = f.readLong()
    print(f"FileSize = {FileSize}")
    f.seek_rel(0x08)
    ParamCount = f.readLong()
    print(f"ParamCount = {ParamCount}")
    for x in range(ParamCount):
        if VerboseLevel > 2:
            print(f"Unknown param {f.read(0x0C).decode('ansi')}")
        else:
            f.seek_rel(0x0C)
    D3DNameHeaderLength = f.readLong()
    D3DNameLength = f.readLong()
    if D3DNameLength > D3DNameHeaderLength:
        f.seek_rel(-0x04)
        D3DNameLength = D3DNameHeaderLength

    print(f"D3DNameHeaderLength {D3DNameHeaderLength}, D3DNameLength {D3DNameLength}")
    D3DName = f.readString(D3DNameLength)
    VerNum = f.readByte()
    print(f"Importing {D3DName} (Version {VerNum})...")
    #Skipping Section 1 (Model Info)
    
    MatInfoStart = f.tell() + 0x13 

    # Section 2 (Material Info)
    f.seek_abs(MatInfoStart)
    print(f"Section 2 (Material Info) start @{f.tell()}")
    MatCount = f.readLong()
    print(f"Material Count = {MatCount}")

    #Parsing Material Info
    for x in range(MatCount):
        print(f"Material #{x} @{f.tell()}")
        MatHash2 = f.readLong()
        MatHash1 = f.readLong()
        UnkHash2 = f.readLong()
        UnkHash1 = f.readLong()
        MatHeaderSize = f.tell() + f.readLong()

        MatUnk1 = f.readLong()
        MatUnk2 = f.readLong()
        MatHeaderSizeB = f.readLong()

        MatUnk3Count = f.readLong()
        for m in range(MatUnk3Count):
            MatUnk3Hash2 = f.readLong()
            MatUnk3Hash1 = f.readLong()

        MatParamCount = f.readLong()
        TexDifName = "undefined"
        print(f"Material Parameter Count = {MatParamCount}")
        for x in range(MatCount):
            #TODO parse Material Params
            pass

        f.seek(MatHeaderSize)
    print(f"Section 2 (Material Info) end @{f.tell()}")

    #FaceDataStart + Section 3 (LOD)
    unk = f.readLong()
    pad = f.readLong()
    FaceDataStart = f.tell() + f.readLong() #WOAS: I'd just like to point out how random it is for this pointer to be here of all places, can't imagine how RTB figured this out

    Sect3End = f.tell() + f.readLong()
    Sect3Count = f.readLong()
    print(f"Section 3 (LOD info) start @ {f.tell()-8}, Count = {Sect3Count}")

    #TODO Parse LOD Info

    f.seek(Sect3End)
    Sect4End = f.tell() + f.readLong()

    f.close()