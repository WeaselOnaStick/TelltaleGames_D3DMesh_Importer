enableSceneRedraw()
clearlistener()
BoneHash_array = #()
TexHash_array = #()
for x = 1 to 1 do
(
	struct BoneHash_Struct
	(
		BoneHash1,
		BoneHash2,
		BoneString
	)
	struct TexHash_Struct
	(
		TexHash1,
		TexHash2,
		TexString
	)
	fname = ( scriptsPath + "TelltaleHashDBs/BoneNames.HashDB" ) as string
	db = fopen fname "rb"
	if db == undefined do
	(
		print "Error: Bone database not found in 3DS Max's Scripts folder! Please manually locate it."
		fname = getOpenFileName caption: "Import Telltale Games Bone Hash Database" types: "Telltale Games Bone Hash Database (BoneNames.HashDB)|BoneNames.HashDB" historyCategory: "TelltaleHashDB"
		if fname != undefined do
		( db = fopen fname "rb" )
	)
	if db != undefined do
	(
		print "Parsing bone hashes..."
		BoneHashNum = readlong db
		for x = 1 to BoneHashNum do
		(
			BoneHash2 = readlong db
			BoneHash1 = readlong db
			BoneString = readstring db
			append BoneHash_array ( BoneHash_struct BoneHash1: BoneHash1 BoneHash2: BoneHash2 BoneString: BoneString )
		)
		fclose db
	)
	fname = ( scriptsPath + "TelltaleHashDBs/TexNames.HashDB" ) as string
	db = fopen fname "rb"
	if db == undefined do
	(
		print "Error: Texture database not found in 3DS Max's Scripts folder! Please manually locate it."
		fname = getOpenFileName caption: "Import Telltale Games Texture Hash Database" types: "Telltale Games Texture Hash Database (vALLTex.HashDB)|vALLTex.HashDB" historyCategory: "TelltaleHashDB"
		if fname != undefined do
		( db = fopen fname "rb" )
	)
	if db != undefined do
	(
		print "Parsing texture hashes..."
		TexHashNum = readlong db
		for x = 1 to TexHashNum do
		(
			TexHash2 = readlong db
			TexHash1 = readlong db
			TexString = readstring db
			append TexHash_array ( TexHash_struct TexHash1: TexHash1 TexHash2: TexHash2 TexString: TexString )
		)
		fclose db
	)
	print "Ready to import!"
	print ( "Bone hash total: " + BoneHash_array.count as string )
	print ( "Texture hash total: " + TexHash_array.count as string )
)
rollout TelltaleImporter "Telltale Games Almost-All-In-One Model Importer" width: 685 height: 290
(
	button btnImport "Import Model" pos: [8, 8] width: 370 height: 40
	groupBox OptionsBox "Options" pos: [8, 55] width: 370 height: 140
	label lblSamFix "Sam and Max Season 2 / Strong Bad's CG4AP fix mode:" pos: [17, 70]
	radiobuttons tglSamFix labels: #("None", "SaM: S2 Ep.3/4", "SaM: S2 Ep. 5", "SBCG4AP Ep. 1") pos: [17, 90]
	label lblUVLayers "UV Layers:" pos: [17, 110]
	radiobuttons tglUVLayers labels: #("Merge", "Split", "No") pos: [77, 110] tooltip: "Merge: Apply additional UV mapping layers to the same mesh. Split: Apply additional UV mapping layers to separate polygon groups. No: Ignore additional layers."
	spinner spnModelScale "Model Scale:" width: 80 pos: [290, 110] range: [1, 99999, 100]
	label lblTexFormat "Texture format:" pos: [17, 130]
	radiobuttons tglTexFormat labels: #("DDS", "PNG") pos: [102, 130]
	label lblTexPath "Texture path:" pos: [17, 150]
	radiobuttons tglTexPath labels: #("Relative", "'Textures' subfolder") pos: [92, 150] tooltip: "Relative means it'll read the DDS/PNG files from the same folder as the D3DMESH files, and the other option reads from a separate Textures folder, if you prefer it that way."
	checkbox tglLODs "Enable LoD models?" pos: [17, 170] tooltip: "Enable this to import the Level-of-Detail models from Batman S1/S2, The Walking Dead: Season 3 or Guardians of the Galaxy." checked: false
	checkbox tglVertColors "Vertex colours?" pos: [160, 170] tooltip: "Enable this to import the vertex colouring. Normally it's pure black, hence why it's disabled by default." checked: false
	checkbox tglDebug "Print debug?" pos: [280, 170] tooltip: "Enable this to print nonsense that only RTB will understand to the Listener window." checked: false
	groupBox SupportedGames "Supported Games:" pos: [388, 8] width: 290 height: 260
	label YesBTTFPS4 "Back to the Future: The Game (30th Anniversary) [PS4]" pos: [398, 23]
	label YesBatman "Batman: The Telltale Series + The Enemy Within" pos: [398, 38]
	label YesBone "Bone: Out from Boneville + The Great Cow Race" pos: [398, 53]
	label YesCSI "CSI: 3 Dimensions of Murder + Hard Evidence" pos: [398, 68]
	label YesGoT "Game of Thrones" pos: [398, 83]
	label YesJP "Jurassic Park: The Game" pos: [398, 98]
	label YesLaOL "Law and Order: Legacies" pos: [398, 113]
	label YesGotG "Marvel's Guardians of the Galaxy [PC]" pos: [398, 128]
	label YesMSM "Minecraft: Story Mode Seasons 1 + 2" pos: [398, 143]
	label YesPN2 "Poker Night 2" pos: [398, 158]
	label YesSaM "Sam and Max Seasons 1 + 2" pos: [398, 173]
	label YesSBCG4AP1 "Strong Bad's CG4AP Ep. 1 (Homestar Ruiner)" pos: [398, 188]
	label YesTftBL "Tales from the Borderlands" pos: [398, 203]
	label YesTTH "Telltale Texas Hold'em" pos: [398, 218]
	label YesTWD "The Walking Dead Seasons 1-4 + Michonne + Collection" pos: [398, 233]
	label YesTWAU "The Wolf Among Us" pos: [398, 248]
	label lblDisclaimer "This batch of scripts was written by Random Talking Bush, if you use it, please remember to give thanks to both me and especially Telltale Games. If something doesn't work right, please contact me on The VG Resource (Random Talking Bush), XeNTaX, Twitter or Steam (RandomTBush) and let me know, and I'll try to fix it." pos: [10, 200] width: 360 height: 85
	label lblUpdate "(Updated: 05-11-2019)" pos: [TelltaleImporter.width -120, TelltaleImporter.height -19] width: 115
	fn ReadFixedString bstream fixedLen =
	(
		local str = ""
		for i = 1 to fixedLen do
		( str += bit.intAsChar ( ReadByte bstream #unsigned ) )
		str
	)
	fn floatSwap2 f =
	(
		i = bit.floatAsInt f
		h = bit.intashex i
		while h.count < 8 do h = "0" + h
		s = ( substring h 7 2 ) + ( substring h 5 2 ) + ( substring h 3 2 ) + ( substring h 1 2 )
		bit.intAsFloat ( bit.hexasint s )
	)
	fn convertTo32 input16 =
	(
		inputAsInt = input16
		sign = bit.get inputAsInt 16
		exponent = ( bit.shift ( bit.and inputAsInt ( bit.hexasint "7C00" ) ) -10 ) as integer - 16
		fraction = bit.and inputAsInt ( bit.hexasint "03FF" )
		if sign == true then sign = 1 else sign = 0
		exponentF = exponent + 127
		outputAsFloat = bit.or ( bit.or ( bit.shift fraction 13 ) ( bit.shift exponentF 23 ) ) ( bit.shift sign 31 )
		return bit.intasfloat outputasfloat
	)
	fn readHalfFloat fstream =
	( return convertTo32 ( Readshort fstream ) )
	fn ReadBEShort fstream =
	( bit.swapBytes ( readshort fstream #unsigned ) 1 2 )
	fn ReadBELong fstream =
	( bit.swapBytes ( bit.swapBytes ( readlong f #unsignedstream #unsigned ) 1 4 ) 2 3 )
	fn ReadBEFloat fstream =
	( bit.intAsFloat ( bit.swapBytes ( bit.swapBytes ( readlong f #unsignedstream #unsigned ) 1 4 ) 2 3 ) )
	fn ReadBEHalfFloat fstream =
	( return convertTo32 ( ReadBEshort fstream ) )
	fn printDebug pr =
	( if tglDebug.state do print ( pr ) )
	on btnImport pressed do
	(
		local ModelScale = spnModelScale.value
		local VertColors = tglVertColors.checked
		local LODs = tglLODs.checked
		local UVLayers = tglUVLayers.state
		local TexFormat = tglTexFormat.state
		local TexPath = tglTexPath.state
		local SamFix = tglSamFix.state
		clearlistener()
		MultiD3DMeshImport = dotNetObject "System.Windows.Forms.OpenFileDialog"
		MultiD3DMeshImport.title = "Import Telltale Games D3DMESH file(s)"
		MultiD3DMeshImport.Multiselect = true
		MultiD3DMeshImport.Filter = "Telltale Games D3DMESH Files (*.d3dmesh)|*.d3dmesh"
		MultiD3DMeshImport.FilterIndex = 1
		result = MultiD3DMeshImport.showDialog()
		result.ToString()
		result.Equals result.OK
		result.Equals result.Cancel
		MultiD3DMeshFilenames = MultiD3DMeshImport.fileNames
		if MultiD3DMeshFilenames.count > 0 do
		(
			disableSceneRedraw()
			st = timestamp()
			struct Bone_Info_Struct
			(
				Bone1,
				Bone2,
				Bone3,
				Bone4
			)
			struct Weight_Info_Struct
			(
				Weight1,
				Weight2,
				Weight3,
				Weight4
			)
			struct weight_data
			(
				boneids,
				weights
			)
			struct MatHash_Struct
			(
				MatHash1,
				MatHash2,
				TexDifName
			)
			BoneName_array = #()
			BoneParent_array = #()
			BoneSetup = #()
			BoneCount = 0
			for q = 1 to MultiD3DMeshFilenames.count do
			(
				f = fopen MultiD3DMeshFilenames[q] "rb"
				fname = MultiD3DMeshFilenames[q]
				t = getFilenameType fname
				p = getFilenamePath fname
				h = getFilenameFile fname
				fseek f 0x00 #seek_set
				HeaderCheck = readlong f #unsigned
				case HeaderCheck of
				(
					default:(
						if HeaderCheck < 0 or HeaderCheck > 10000 then
						(
							ParamCount = readlong f #unsigned
							ParamHashCheck = readlong f #unsigned
							fseek f -0x04 #seek_cur
							if ParamHashCheck > 0 and ParamHashCheck < 128 then
							(
								for x = 1 to ParamCount do
								(
									ParamNameLength = readlong f #unsigned
									ParamName = ReadFixedString f ParamNameLength
									ParamUnk = readlong f #unsigned
								)
							)
						)
						else
						( fseek f 0x00 #seek_set )
					)
					1296189774 :(
						ParamCount = readlong f #unsigned
						ParamHashCheck = readlong f #unsigned
						fseek f -0x04 #seek_cur
						if ParamHashCheck > 0 and ParamHashCheck < 128 then
						(
							for x = 1 to ParamCount do
							(
								ParamNameLength = readlong f #unsigned
								ParamName = ReadFixedString f ParamNameLength
								ParamUnk = readlong f #unsigned
							)
						)
						else
						(
							for x = 1 to ParamCount do
							( fseek f 0x0C #seek_cur )
						)
					)
					1297371717 :(
						ParamCount = readlong f #unsigned
						ParamHashCheck = readlong f #unsigned
						fseek f -0x04 #seek_cur
						if ParamHashCheck > 0 and ParamHashCheck < 128 then
						(
							for x = 1 to ParamCount do
							(
								ParamNameLength = readlong f #unsigned
								ParamName = ReadFixedString f ParamNameLength
								ParamUnk = readlong f #unsigned
							)
						)
						else
						(
							for x = 1 to ParamCount do
							( fseek f 0x0C #seek_cur )
						)
					)
					1297307189 :(
						FileSize = readlong f #unsigned
						fseek f 0x08 #seek_cur
						ParamCount = readlong f #unsigned
						for x = 1 to ParamCount do
						( fseek f 0x0C #seek_cur )
					)
					1297307190 :(
						FileSize = readlong f #unsigned
						fseek f 0x08 #seek_cur
						ParamCount = readlong f #unsigned
						for x = 1 to ParamCount do
						( fseek f 0x0C #seek_cur )
					)
				)
				
				
				D3DNameHeaderLength = readlong f #unsigned
				D3DNameLength = readlong f #unsigned
				if D3DNameLength > D3DNameHeaderLength do
				(
					printDebug ( "Quietly fixing offset..." )
					fseek f -0x04 #seek_cur
					D3DNameLength = D3DNameHeaderLength
				)
				D3DName = ReadFixedString f D3DNameLength
				VerNum = readbyte f #unsigned
				if ( VerNum == 48 ) or ( VerNum == 49 ) do
				( VerNum = 0 )
				print ( "Importing " + D3DName + " (Version " + VerNum as string + ")..." )
				if q == 1 do
				(
					bname = getOpenFileName caption: "Import Telltale Games SKL file (hit Cancel for none)" types: "Telltale Games Skeleton Files (*.skl)|*.skl" historyCategory: "TelltaleD3DMesh"
					if bname != undefined do
					(
						g = fopen bname "rb"
						BttFFix = 0
						BoneHeaderCheck = readlong g
						case BoneHeaderCheck of
						(
							default:(
								if BoneHeaderCheck < 0 or BoneHeaderCheck > 10000000 then
								(
									print "Bone v2 apparently?"
									ParamCount = readlong g #unsigned
									ParamHashCheck = readlong g #unsigned
									fseek g -0x04 #seek_cur
									if ParamHashCheck > 0 and ParamHashCheck < 128 then
									(
										for x = 1 to ParamCount do
										(
											ParamNameLength = readlong g #unsigned
											ParamName = ReadFixedString g ParamNameLength
											ParamUnk = readlong g #unsigned
										)
									)
								)
								else
								( fseek g 0x00 #seek_set )
							)
							1296189774 :(
								print "MBIN"
								ParamCount = readlong g #unsigned
								ParamHashCheck = readlong g #unsigned
								fseek g -0x04 #seek_cur
								if ParamHashCheck > 0 and ParamHashCheck < 128 then
								(
									for x = 1 to ParamCount do
									(
										ParamNameLength = readlong g #unsigned
										ParamName = ReadFixedString g ParamNameLength
										ParamUnk = readlong g #unsigned
									)
								)
								else
								(
									for x = 1 to ParamCount do
									( fseek g 0x0C #seek_cur )
								)
							)
							1297371717 :(
								print "MTRE"
								ParamCount = readlong g #unsigned
								ParamHashCheck = readlong g #unsigned
								fseek g -0x04 #seek_cur
								if ParamHashCheck > 0 and ParamHashCheck < 128 then
								(
									for x = 1 to ParamCount do
									(
										ParamNameLength = readlong g #unsigned
										ParamName = ReadFixedString g ParamNameLength
										ParamUnk = readlong g #unsigned
									)
								)
								else
								(
									for x = 1 to ParamCount do
									( fseek g 0x0C #seek_cur )
								)
							)
							1297307189 :(
								print "MSV5"
								FileSize = readlong g #unsigned
								fseek g 0x08 #seek_cur
								ParamCount = readlong g #unsigned
								for x = 1 to ParamCount do
								( fseek g 0x0C #seek_cur )
							)
							1297307190 :(
								print "MSV6"
								FileSize = readlong g #unsigned
								fseek g 0x08 #seek_cur
								ParamCount = readlong g #unsigned
								for x = 1 to ParamCount do
								( fseek g 0x0C #seek_cur )
							)
						)
						
						
						BoneFileSize = readlong g #unsigned
						BoneCount = readlong g #unsigned
						if BoneCount != 0 do
						(
							for b = 1 to BoneCount do
							(
								if VerNum > 0 or SamFix == 4 then
								(
									BoneHash2 = readlong g #unsigned
									BoneHash1 = readlong g #unsigned
									BoneName = ( "0x" + bit.intAsHex ( BoneHash1 ) as string )
									for y = 1 to BoneHash_array.count do
									(
										if BoneHash1 == BoneHash_array[y].BoneHash1 and BoneHash2 == BoneHash_array[y].BoneHash2 do
										( BoneName = BoneHash_array[y].BoneString )
									)
									append BoneName_array BoneName
									if VerNum < 13 do
									( Padding = readfloat g )
								)
								else
								(
									BoneNameSectLength = readlong g
									BoneNameLength = readlong g
									BoneName = ReadFixedString g BoneNameLength
									append BoneName_array BoneName
								)
								if VerNum > 0 or SamFix == 4 then
								(
									BoneParentHash2 = readlong g #unsigned
									BoneParentHash1 = readlong g #unsigned
									BoneParentName = bit.intAsHex ( BoneParentHash1 ) as string
									if VerNum < 13 do
									( Padding = readfloat g )
								)
								else
								(
									BoneParentNameSectLength = readlong g
									BoneParentNameLength = readlong g
									BoneParentName = ReadFixedString g BoneParentNameLength
								)
								BoneParent = readlong g #unsigned
								if BoneParent < -1 do BoneParent = -1
								append BoneParent_array BoneParent
								if VerNum == 17 and b == 1 do
								(
									BttFFix = readlong g
									fseek g -0x04 #seek_cur
								)
								if VerNum >= 18 or BttFFix != 0 do
								(
									BoneUnk1 = readfloat g
									BoneUnk2 = readfloat g
									BoneUnk3 = readfloat g
								)
								BoneTX = readfloat g * ModelScale
								BoneTY = readfloat g * ModelScale
								BoneTZ = readfloat g * ModelScale
								BoneRX = readfloat g
								BoneRY = readfloat g
								BoneRZ = readfloat g
								BoneRW = readfloat g * -1
								MayBeHeader = readlong g
								nothing3 = readfloat g
								nothing4 = readfloat g
								nothing5 = readfloat g
								BoneQ = readfloat g
								nothing6 = readfloat g
								nothing7 = readfloat g
								nothing8 = readfloat g
								BoneXX = readfloat g
								BoneXY = readfloat g
								BoneXZ = readfloat g
								BoneYX = readfloat g
								BoneYY = readfloat g
								BoneYZ = readfloat g
								BoneZX = readfloat g
								BoneZY = readfloat g
								BoneZZ = readfloat g
								IKHeaderLength = readlong g
								IKAmount = readlong g
								for x = 1 to IKAmount do
								(
									if VerNum == 55 then
									(
										IKNameHash1 = readlong g
										IKNameHash2 = readlong g
									)
									else
									(
										IKNameLength = readlong g
										IKName = ReadFixedString g IKNameLength
									)
									IKInfluence = readfloat g
								)
								if VerNum > 1 do
								(
									landofpilength = readlong g
									piamountlength = readlong g
									for x = 1 to piamountlength do
									(
										float1 = readfloat g
										float2 = readfloat g
										float3 = readfloat g
									)
									piheaderlength = readlong g
									pinx = readfloat g
									pipx = readfloat g
									piny = readfloat g
									pipy = readfloat g
									pinz = readfloat g
									pipz = readfloat g
									piend = readfloat g
								)
								tfm = ( quat bonerx bonery bonerz bonerw ) as matrix3
								tfm.row4 = [bonetx, bonety, bonetz]
								if ( getNodeByName BoneName ) != undefined do
								( append BoneSetup ( getNodeByName BoneName ) )
								if ( getNodeByName BoneName ) == undefined do
								(
									if ( BoneParent != -1 ) do
									( tfm = tfm * BoneSetup[( boneparent + 1 )].objecttransform )
								)
								newBone = bonesys.createbone tfm.row4 ( tfm.row4 + 0.01 * ( normalize tfm.row1 ) ) ( normalize tfm.row3 )
								newBone.name = BoneName
								newBone.width = 0.01
								newBone.height = 0.01
								newBone.transform = tfm
								newBone.setBoneEnable false 0
								newBone.wirecolor = yellow
								newbone.showlinks = true
								newBone.pos.controller = TCB_position()
								newBone.rotation.controller = TCB_rotation()
								if ( BoneParent != -1 ) then newBone.parent = BoneSetup[( BoneParent + 1 )]
								append BoneSetup newBone
							)
						)
						fclose g
					)
				)
				if D3DName != "" do
				(
					case of
					(
						default:( print "Unknown version!" )
						( VerNum == 0 and SamFix == 1 ):(
							Face_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							B1_array = #()
							W1_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							TexName_array = #()
							MatPlus = 0
							FooterPlus = 0
							struct Polygon_Info_Struct
							(
								VertexMin,
								VertexMax,
								PolygonStart,
								PolygonCount,
								FacePointCount,
								MatName,
								BoneSetNum,
								SingleBindNode
							)
							fseek f -0x01 #seek_cur
							headercheck1 = readshort f #unsigned
							if headercheck1 != 0x3131 and headercheck1 != 0x3031 and headercheck1 != 0x3130 do
							( fseek f -0x01 #seek_cur )
							printDebug ( "Model start = " + ( ftell f as string ) )
							boundingminx = readfloat f
							boundingminy = readfloat f
							boundingminz = readfloat f
							boundingmaxx = readfloat f
							boundingmaxy = readfloat f
							boundingmaxz = readfloat f
							head3asubsize = readlong f #unsigned
							polytotal = readlong f #unsigned
							if polytotal > 1000 do
							(
								fseek f -0x21 #seek_cur
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								head3asubsize = readlong f #unsigned
								polytotal = readlong f #unsigned
							)
							printDebug ( "Count = " + polytotal as string )
							if polytotal > 1000 do
							( throw ( "Something went wrong! Contact RTB!" ) )
							for x = 1 to polytotal do
							(
								printDebug ( "Model info start = " + ( ftell f as string ) )
								nameheaderlength = readlong f #unsigned - 8
								if nameheaderlength > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								namelength = ( readlong f #unsigned ) - 4
								fseek f nameheaderlength #seek_cur
								nameheaderlength2 = readlong f #unsigned - 8
								if nameheaderlength2 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								namelength2 = ( readlong f #unsigned ) - 4
								fseek f nameheaderlength2 #seek_cur
								BoneSetNum = ( readlong f #unsigned ) + 1
								SingleBindNode = readlong f #unsigned
								VertexMin = readlong f #unsigned + 1
								VertexMax = readlong f #unsigned + 1
								FacepointStart = readlong f #unsigned
								PolygonStart = ( FacepointStart / 3 ) + 1
								PolygonCount = readlong f #unsigned
								FacepointCount = PolygonCount * 3
								nameheaderlength3 = readlong f #unsigned
								namelength3 = readlong f #unsigned
								fseek f namelength3 #seek_cur
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								materialheaderlength = readlong f #unsigned
								if materialheaderlength > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength = readlong f #unsigned - 6
								if materialnamelength > 0 do
								(
									MaterialName = ReadFixedString f ( materialnamelength )
									printDebug ( "Tex1 = " + MaterialName as string )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength2 = readlong f #unsigned
								if materialheaderlength2 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength2 = readlong f #unsigned - 6
								if materialnamelength2 > 0 do
								(
									MaterialName2 = ReadFixedString f ( materialnamelength2 )
									printDebug ( "Tex2 = " + MaterialName2 as string )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength3 = readlong f #unsigned
								if materialheaderlength3 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength3 = readlong f #unsigned - 6
								if materialnamelength3 > 0 do
								(
									MaterialName3 = ReadFixedString f ( materialnamelength3 )
									printDebug ( "Tex3 = " + MaterialName3 as string )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength4 = readlong f #unsigned
								if materialheaderlength4 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength4 = readlong f #unsigned - 6
								if materialnamelength4 > 0 do
								(
									MaterialName4 = ReadFixedString f ( materialnamelength4 )
									printDebug ( "Tex4 = " + MaterialName4 as string )
									fseek f 0x06 #seek_cur
								)
								if x == 1 do
								(
									matcheck = readshort f #unsigned
									fseek f -0x02 #seek_cur
									if matcheck < 256 do
									( MatPlus = 1 )
								)
								if MatPlus == 1 do
								(
									materialheaderlength4b = readlong f #unsigned
									materialnamelength4b = readlong f #unsigned - 6
									if materialnamelength4b > 0 do
									(
										MaterialName4b = ReadFixedString f ( materialnamelength4b )
										printDebug ( "Tex4B = " + MaterialName4b as string )
										fseek f 0x06 #seek_cur
									)
								)
								footercheck = readbyte f #unsigned
								if x == 1 do
								(
									if footercheck != 0x30 do
									( FooterPlus = 1 )
								)
								materialheaderlength5 = readlong f #unsigned
								if materialheaderlength5 > 1000 do
								(
									fseek f -0x05 #seek_cur
									materialheaderlength5 = readlong f #unsigned
									if materialheaderlength5 > 1000 do
									( throw ( "Something went wrong! Contact RTB!" ) )
								)
								materialnamelength5 = readlong f #unsigned - 6
								if materialnamelength5 > 0 do
								(
									MaterialName5 = ReadFixedString f ( materialnamelength5 )
									printDebug ( "Tex5 = " + MaterialName5 as string )
									fseek f 0x06 #seek_cur
								)
								unknownenvvalue = readlong f #unsigned
								fseek f 0x05 #seek_cur
								headercheck3 = readlong f #unsigned
								fseek f -0x09 #seek_cur
								if headercheck3 != 0x08 do
								( fseek f 0x01 #seek_cur )
								fseek f 0x01 #seek_cur
								float2 = readfloat f
								materialheaderlength6 = readlong f #unsigned
								if materialheaderlength6 > 1000 do
								(
									fseek f -0x05 #seek_cur
									materialheaderlength6 = readlong f #unsigned
									if materialheaderlength6 > 1000 do
									( throw ( "Something went wrong! Contact RTB!" ) )
								)
								materialnamelength6 = readlong f #unsigned - 6
								if materialnamelength6 > 0 do
								(
									MaterialName6 = ReadFixedString f ( materialnamelength6 )
									printDebug ( "Tex6 = " + MaterialName6 as string )
									fseek f 0x06 #seek_cur
								)
								floatx3 = readfloat f
								floaty3 = readfloat f
								floatz3 = readfloat f
								floatx4 = readfloat f
								floaty4 = readfloat f
								floatz4 = readfloat f
								floatx5 = readfloat f
								floaty5 = readfloat f
								floatz5 = readfloat f
								printDebug ( "Floats = " + floatx3 as string + ", " + floaty3 as string + ", " + floatz3 as string + ", " + floatx4 as string + ", " + floaty4 as string + ", " + floatz4 as string + ", " + floatx5 as string + ", " + floaty5 as string + ", " + floatz5 as string )
								fseek f 0x01 #seek_cur
								if MatPlus == 1 do
								(
									floatx6 = readfloat f
									floaty6 = readfloat f
									floatz6 = readfloat f
									floatx7 = readfloat f
									floaty7 = readfloat f
									floatz7 = readfloat f
									floatx8 = readfloat f
									floaty8 = readfloat f
									floatz8 = readfloat f
									printDebug ( "Floats2 = " + floatx6 as string + ", " + floaty6 as string + ", " + floatz6 as string + ", " + floatx7 as string + ", " + floaty7 as string + ", " + floatz7 as string + ", " + floatx8 as string + ", " + floaty8 as string + ", " + floatz8 as string )
								)
								float10 = readfloat f
								float11 = readfloat f
								if MatPlus == 1 do
								(
									unknown = readlong f #unsigned
									fseek f 0x01 #seek_cur
								)
								namelength = readlong f #unsigned
								if namelength > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								fseek f namelength #seek_cur
								if FooterPlus == 1 do
								(
									namelength2 = readlong f #unsigned
									if namelength2 > 1000 do
									( throw ( "Something went wrong! Contact RTB!" ) )
									fseek f namelength2 #seek_cur
								)
								append PolyStruct_array ( Polygon_Info_Struct VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatName: MaterialName BoneSetNum: BoneSetNum SingleBindNode: SingleBindNode )
							)
							printDebug ( "Header C (Bone IDs) start = " + ( ftell f as string ) )
							IDHeaderLength = ( readlong f #unsigned - 4 )
							BoneIDSets = readlong f #unsigned
							printDebug ( "Count = " + BoneIDSets as string )
							for x = 1 to BoneIDSets do
							(
								append BoneIDOffset_Array ( ftell f )
								boneidtotal = readlong f #unsigned
								for y = 1 to boneidtotal do
								(
									boneidheaderlength = readlong f #unsigned
									boneidnamelength = readlong f #unsigned
									bonename = ReadFixedString f boneidnamelength
									ffffffff = readlong f #unsigned
								)
							)
							footercheck = 0x30
							do ( footercheck = readbyte f #unsigned )
							while footercheck != 0x65
							fseek f 0x03 #seek_cur
							printDebug ( "Face info start = " + ( ftell f as string ) )
							facecount = readlong f #unsigned
							facelength = readlong f #unsigned
							printDebug ( "Count = " + facecount as string + ", Length = " + facelength as string )
							printDebug ( "Face start = " + ( ftell f as string ) )
							for x = 1 to facecount / 3 do
							(
								fa = readshort f #unsigned + 1
								fb = readshort f #unsigned + 1
								fc = readshort f #unsigned + 1
								append Face_array [fa, fb, fc]
							)
							fseek f 0x02 #seek_cur
							fseek f 0x08 #seek_cur
							BufferType = readlong f #unsigned
							fseek f -0x0C #seek_cur
							FileEnd = 0
							case of
							(
								default:( throw ( "Something went wrong! Contact RTB!" ) )
								( BufferType == 0 ):(
									printDebug ( "Vertex Buffer start = " + ( ftell f as string ) )
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									printDebug ( "Count = " + sectioncount as string + ", Length = " + sectionlength as string + ", Type = " + sectiontype as string )
									printDebug ( "Vertex start = " + ( ftell f as string ) )
									for x = 1 to sectioncount do
									(
										vx = readfloat f * ModelScale
										vy = readfloat f * ModelScale
										vz = readfloat f * ModelScale
										append Vert_array [vx, vy, vz]
									)
									fseek f 0x02 #seek_cur
									printDebug ( "Normals Buffer start = " + ( ftell f as string ) )
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									printDebug ( "Count = " + sectioncount as string + ", Length = " + sectionlength as string + ", Type = " + sectiontype as string )
									printDebug ( "Normals start = " + ( ftell f as string ) )
									for x = 1 to sectioncount do
									(
										nx = readfloat f
										ny = readfloat f
										nz = readfloat f
										append Normal_array [nx, ny, nz]
									)
									fseek f 0x02 #seek_cur
									if BoneIDSets > 0 do
									(
										printDebug ( "Weights Buffer start = " + ( ftell f as string ) )
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x01 #seek_cur
										printDebug ( "Count = " + sectioncount as string + ", Length = " + sectionlength as string + ", Type = " + sectiontype as string )
										printDebug ( "Weights start = " + ( ftell f as string ) )
										for x = 1 to sectioncount do
										(
											Weight1 = readfloat f
											Weight2 = readfloat f
											Weight3 = readfloat f
											Weight4 = 0
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										fseek f 0x02 #seek_cur
										printDebug ( "Bones Buffer start = " + ( ftell f as string ) )
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x01 #seek_cur
										printDebug ( "Count = " + sectioncount as string + ", Length = " + sectionlength as string + ", Type = " + sectiontype as string )
										printDebug ( "Bones start = " + ( ftell f as string ) )
										for x = 1 to sectioncount do
										(
											Bone1 = ( readbyte f #unsigned ) / 4
											Bone2 = ( readbyte f #unsigned ) / 4
											Bone3 = ( readbyte f #unsigned ) / 4
											Bone4 = ( readbyte f #unsigned ) / 4
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
										fseek f 0x02 #seek_cur
									)
									if BoneIDSets == 0 do
									( fseek f 0x02 #seek_cur )
									printDebug ( "UVs Buffer start = " + ( ftell f as string ) )
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									printDebug ( "Count = " + sectioncount as string + ", Length = " + sectionlength as string + ", Type = " + sectiontype as string )
									printDebug ( "UVs start = " + ( ftell f as string ) )
									for x = 1 to sectioncount do
									(
										tu = readfloat f
										tv = ( readfloat f * -1 ) + 1
										append UV_array [tu, tv, 0]
									)
									fseek f 0x02 #seek_cur
								)
								( BufferType == 1 ):(
									printDebug ( "Vertex Buffer start = " + ( ftell f as string ) )
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									printDebug ( "Count = " + sectioncount as string + ", Length = " + sectionlength as string + ", Type = " + sectiontype as string )
									printDebug ( "Vertex start = " + ( ftell f as string ) )
									for x = 1 to sectioncount do
									(
										vx = readfloat f * ModelScale
										vy = readfloat f * ModelScale
										vz = readfloat f * ModelScale
										append Vert_array [vx, vy, vz]
									)
									fseek f 0x02 #seek_cur
									printDebug ( "Normals Buffer start = " + ( ftell f as string ) )
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									printDebug ( "Count = " + sectioncount as string + ", Length = " + sectionlength as string + ", Type = " + sectiontype as string )
									printDebug ( "Normals start = " + ( ftell f as string ) )
									for x = 1 to sectioncount do
									( normVal = readshort f #unsigned )
									fseek f 0x02 #seek_cur
									if BoneIDSets > 0 do
									(
										printDebug ( "Weights Buffer start = " + ( ftell f as string ) )
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x01 #seek_cur
										printDebug ( "Count = " + sectioncount as string + ", Length = " + sectionlength as string + ", Type = " + sectiontype as string )
										printDebug ( "Weights start = " + ( ftell f as string ) )
										for x = 1 to sectioncount do
										(
											Weight1 = readfloat f
											Weight2 = readfloat f
											Weight3 = readfloat f
											Weight4 = 0
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										fseek f 0x02 #seek_cur
										printDebug ( "Bones Buffer start = " + ( ftell f as string ) )
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x01 #seek_cur
										printDebug ( "Count = " + sectioncount as string + ", Length = " + sectionlength as string + ", Type = " + sectiontype as string )
										printDebug ( "Bones start = " + ( ftell f as string ) )
										for x = 1 to sectioncount do
										(
											Bone1 = ( readbyte f #unsigned ) / 4
											Bone2 = ( readbyte f #unsigned ) / 4
											Bone3 = ( readbyte f #unsigned ) / 4
											Bone4 = ( readbyte f #unsigned ) / 4
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
										fseek f 0x02 #seek_cur
									)
									if BoneIDSets == 0 do
									( fseek f 0x02 #seek_cur )
									printDebug ( "UVs Buffer start = " + ( ftell f as string ) )
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									printDebug ( "Count = " + sectioncount as string + ", Length = " + sectionlength as string + ", Type = " + sectiontype as string )
									printDebug ( "UVs start = " + ( ftell f as string ) )
									for x = 1 to sectioncount do
									(
										tu = readfloat f
										tv = ( readfloat f * -1 ) + 1
										append UV_array [tu, tv, 0]
									)
									fseek f 0x05 #seek_cur
									printDebug ( "Unknown Buffer start = " + ( ftell f as string ) )
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									printDebug ( "Count = " + sectioncount as string + ", Length = " + sectionlength as string + ", Type = " + sectiontype as string )
									printDebug ( "Unknown start = " + ( ftell f as string ) )
									for x = 1 to sectioncount do
									( unknown = readshort f #unsigned )
								)
							)
							
							
							printDebug ( "End of file = " + ( ftell f as string ) )
							printDebug ( PolyStruct_array )
							for i = 1 to PolyStruct_array.count do
							(
								ProperBoneID_array = #()
								FixedBoneID_array = #()
								ActualB1_array = #()
								Weight_array = #()
								Weight_array2 = #()
								Face_array2 = #()
								Face_array3 = #()
								Vert_array2 = #()
								Normal_array2 = #()
								UV_array2 = #()
								if BoneCount != 0 and BoneIDSets > 0 do
								(
									fseek f BoneIDOffset_array[1 * PolyStruct_array[i].BoneSetNum] #seek_set
									boneidtotal = readlong f #unsigned
									ProperBoneID_array = #()
									for y = 1 to boneidtotal do
									(
										boneidheaderlength = readlong f #unsigned
										boneidnamelength = readlong f #unsigned
										bonename = ReadFixedString f boneidnamelength
										append ProperBoneID_array bonename
										ffffffff = readlong f #unsigned
									)
									for a = 1 to boneidtotal do
									(
										for b = 1 to BoneCount do
										(
											if ProperBoneID_array[a] == BoneName_array[b] do
											( append FixedBoneID_array b )
										)
									)
									for x = 1 to B1_array.count do
									(
										ImproperBone1 = B1_array[x].Bone1
										ImproperBone2 = B1_array[x].Bone2
										ImproperBone3 = B1_array[x].Bone3
										ImproperBone4 = B1_array[x].Bone4
										ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
										ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
										ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
										ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
										if ProperBone1 == undefined do
										( ProperBone1 = 1 )
										if ProperBone2 == undefined do
										( ProperBone2 = 1 )
										if ProperBone3 == undefined do
										( ProperBone3 = 1 )
										if ProperBone4 == undefined do
										( ProperBone4 = 1 )
										append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
									)
									for b = 1 to W1_array.count Do
									(
										w = ( weight_data boneids: #() weights: #() )
										maxweight = 0
										if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
										if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
										if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
										if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
										if ( maxweight != 0 ) then
										(
											if ( W1_array[b].Weight1 != 0 ) then
											(
												w1 = W1_array[b].Weight1 as float
												append w.boneids ( ActualB1_array[b].Bone1 )
												append w.weights ( w1 )
											)
											if ( W1_array[b].Weight2 != 0 ) then
											(
												w2 = W1_array[b].Weight2 as float
												append w.boneids ( ActualB1_array[b].Bone2 )
												append w.weights ( w2 )
											)
											if ( W1_array[b].Weight3 != 0 ) then
											(
												w3 = W1_array[b].Weight3 as float
												append w.boneids ( ActualB1_array[b].Bone3 )
												append w.weights ( w3 )
											)
											if ( W1_array[b].Weight4 != 0 ) then
											(
												w4 = W1_array[b].Weight4 as float
												append w.boneids ( ActualB1_array[b].Bone4 )
												append w.weights ( w4 )
											)
										)
										append Weight_array w
									)
								)
								for y = PolyStruct_array[i].PolygonStart to ( PolyStruct_array[i].PolygonCount + PolyStruct_array[i].PolygonStart ) do
								( append Face_array2 Face_array[y] )
								VertexMin = PolyStruct_array[i].VertexMin
								VertexMax = PolyStruct_array[i].VertexMax
								for x = VertexMin to VertexMax do
								(
									append Vert_array2 Vert_array[x]
									if Normal_array.count > 0 do
									( append Normal_array2 Normal_array[x] )
									append UV_array2 UV_array[x]
									append Weight_array2 Weight_array[x]
								)
								for x = 1 to PolyStruct_array[i].PolygonCount do
								(
									Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
									append Face_array3 Faces3
								)
								local PolyMat = standardMaterial()
								PolyMat.name = PolyStruct_array[i].MatName
								PolyMat.showinviewport = true
								PolyMat.twosided = false
								if TexFormat == 1 then
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + PolyStruct_array[i].MatName + ".dds" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + PolyStruct_array[i].MatName + ".dds" ) )
								)
								else
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + PolyStruct_array[i].MatName + ".png" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + PolyStruct_array[i].MatName + ".png" ) )
								)
								tm.alphasource = 0
								PolyMat.diffuseMap = tm
								PolyMat.opacityMap = tm
								PolyMat.opacityMap.monoOutput = 1
								msh = mesh vertices: Vert_array2 faces: Face_array3
								msh.numTVerts = Vert_array2.count
								defaultVCFaces msh
								buildTVFaces msh
								msh.name = ( h as string )
								msh.material = PolyMat
								for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
								for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
								max modify mode
								select msh
								for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
								if Normal_array2.count > 0 do
								(
									addmodifier msh ( Edit_Normals() ) ui: off
									msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
									EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
									EN_setNormal = msh.Edit_Normals.SetNormal
									normID = #{}
									for v = 1 to Normal_array2.count do
									(
										free normID
										EN_convertVS #{v} &normID
										for id in normID do EN_setNormal id Normal_array2[v]
									)
								)
								if BoneCount != 0 and BoneIDSets > 0 do
								(
									skinMod = skin()
									boneIDMap = #()
									addModifier msh skinMod
									for i = 1 to BoneCount do
									(
										maxbone = getnodebyname BoneSetup[i].name
										if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
									)
									local numSkinBones = skinOps.GetNumberBones skinMod
									for i = 1 to numSkinBones do
									(
										local boneName = skinOps.GetBoneName skinMod i 0
										for j = 1 to BoneCount do
										(
											if boneName == BoneSetup[j].Name then
											(
												boneIDMap[j] = i
												j = BoneCount + 1
											)
										)
									)
									modPanel.setCurrentObject skinMod
									for i = 1 to Vert_array2.count do
									(
										skinOps.SetVertexWeights skinMod i 1 1
										skinOps.unnormalizeVertex skinMod i true
										skinOps.SetVertexWeights skinMod i 1 0
									)
									skinOps.RemoveZeroWeights skinMod
									for i = 1 to Vert_array2.count do
									( skinOps.unnormalizeVertex skinMod i false )
									for i = 1 to Weight_array2.count do
									(
										w = Weight_array2[i]
										bi = #()
										wv = #()
										for j = 1 to w.boneids.count do
										(
											boneid = w.boneids[j]
											weight = w.weights[j]
											append bi boneIDMap[boneid]
											append wv weight
										)
										skinOps.ReplaceVertexWeights skinMod i bi wv
									)
								)
							)
							fclose f
						)
						( VerNum == 0 and SamFix == 2 ):(
							Face_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							B1_array = #()
							W1_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							TexName_array = #()
							MatPlus = 0
							FooterPlus = 0
							struct Polygon_Info_Struct
							(
								VertexMin,
								VertexMax,
								PolygonStart,
								PolygonCount,
								FacePointCount,
								MatName,
								BoneSetNum,
								SingleBindNode
							)
							fseek f -0x01 #seek_cur
							headercheck1 = readshort f #unsigned
							if headercheck1 != 0x3131 and headercheck1 != 0x3031 and headercheck1 != 0x3130 do
							( fseek f -0x01 #seek_cur )
							boundingminx = readfloat f
							boundingminy = readfloat f
							boundingminz = readfloat f
							boundingmaxx = readfloat f
							boundingmaxy = readfloat f
							boundingmaxz = readfloat f
							head3asubsize = readlong f #unsigned
							polytotal = readlong f #unsigned
							if polytotal > 1000 do
							(
								fseek f -0x21 #seek_cur
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								head3asubsize = readlong f #unsigned
								polytotal = readlong f #unsigned
							)
							if polytotal > 1000 do
							( throw ( "Something went wrong! Contact RTB!" ) )
							for x = 1 to polytotal do
							(
								nameheaderlength = readlong f #unsigned - 8
								if nameheaderlength > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								namelength = ( readlong f #unsigned ) - 4
								fseek f nameheaderlength #seek_cur
								nameheaderlength2 = readlong f #unsigned - 8
								if nameheaderlength2 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								namelength2 = ( readlong f #unsigned ) - 4
								fseek f nameheaderlength2 #seek_cur
								BoneSetNum = ( readlong f #unsigned ) + 1
								SingleBindNode = readlong f #unsigned
								VertexMin = readlong f #unsigned + 1
								VertexMax = readlong f #unsigned + 1
								if name == "obj_tvsitcom_fakehallway.d3dmesh" do
								(
									VertexMin = 1
									VertexMax = 28
								)
								FacepointStart = readlong f #unsigned
								PolygonStart = ( FacepointStart / 3 ) + 1
								PolygonCount = readlong f #unsigned
								FacepointCount = PolygonCount * 3
								nameheaderlength3 = readlong f #unsigned
								namelength3 = readlong f #unsigned
								fseek f namelength3 #seek_cur
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								materialheaderlength = readlong f #unsigned
								if materialheaderlength > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength = readlong f #unsigned - 6
								if materialnamelength > 0 do
								(
									MaterialName = ReadFixedString f ( materialnamelength )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength2 = readlong f #unsigned
								if materialheaderlength2 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength2 = readlong f #unsigned - 6
								if materialnamelength2 > 0 do
								(
									MaterialName2 = ReadFixedString f ( materialnamelength2 )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength3 = readlong f #unsigned
								if materialheaderlength3 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength3 = readlong f #unsigned - 6
								if materialnamelength3 > 0 do
								(
									MaterialName3 = ReadFixedString f ( materialnamelength3 )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength4 = readlong f #unsigned
								if materialheaderlength4 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength4 = readlong f #unsigned - 6
								if materialnamelength4 > 0 do
								(
									MaterialName4 = ReadFixedString f ( materialnamelength4 )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength5 = readlong f #unsigned
								if materialheaderlength5 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength5 = readlong f #unsigned - 6
								if materialnamelength5 > 0 do
								(
									MaterialName5 = ReadFixedString f ( materialnamelength5 )
									fseek f 0x06 #seek_cur
								)
								fseek f 0x01 #seek_cur
								materialheaderlength6 = readlong f #unsigned
								if materialheaderlength6 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength6 = readlong f #unsigned - 6
								if materialnamelength6 > 0 do
								(
									MaterialName6 = ReadFixedString f ( materialnamelength6 )
									fseek f 0x06 #seek_cur
								)
								unknownenvvalue = readlong f #unsigned
								fseek f 0x02 #seek_cur
								float2 = readfloat f
								materialheaderlength7 = readlong f #unsigned
								if materialheaderlength7 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength7 = readlong f #unsigned - 6
								if materialnamelength7 > 0 do
								(
									MaterialName7 = ReadFixedString f ( materialnamelength7 )
									fseek f 0x06 #seek_cur
								)
								floatx3 = readfloat f
								floaty3 = readfloat f
								floatz3 = readfloat f
								floatx4 = readfloat f
								floaty4 = readfloat f
								floatz4 = readfloat f
								floatx5 = readfloat f
								floaty5 = readfloat f
								floatz5 = readfloat f
								fseek f 0x01 #seek_cur
								floatx6 = readfloat f
								floaty6 = readfloat f
								floatz6 = readfloat f
								floatx7 = readfloat f
								floaty7 = readfloat f
								floatz7 = readfloat f
								floatx8 = readfloat f
								floaty8 = readfloat f
								floatz8 = readfloat f
								float10 = readfloat f
								float11 = readfloat f
								fseek f 0x02 #seek_cur
								unknown1 = readlong f #unsigned
								float12 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								fseek f 0x01 #seek_cur
								namelength = readlong f #unsigned
								if namelength > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								fseek f namelength #seek_cur
								namelength2 = readlong f #unsigned
								if namelength2 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								fseek f namelength2 #seek_cur
								append PolyStruct_array ( Polygon_Info_Struct VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatName: MaterialName BoneSetNum: BoneSetNum SingleBindNode: SingleBindNode )
							)
							IDHeaderLength = ( readlong f #unsigned - 4 )
							BoneIDSets = readlong f #unsigned
							for x = 1 to BoneIDSets do
							(
								append BoneIDOffset_Array ( ftell f )
								boneidtotal = readlong f #unsigned
								for y = 1 to boneidtotal do
								(
									boneidheaderlength = readlong f #unsigned
									boneidnamelength = readlong f #unsigned
									bonename = ReadFixedString f boneidnamelength
									ffffffff = readlong f #unsigned
								)
							)
							footercheck = 0x30
							do ( footercheck = readbyte f #unsigned )
							while footercheck != 0x65
							fseek f 0x03 #seek_cur
							facecount = readlong f #unsigned
							facelength = readlong f #unsigned
							for x = 1 to facecount / 3 do
							(
								fa = readshort f #unsigned + 1
								fb = readshort f #unsigned + 1
								fc = readshort f #unsigned + 1
								append Face_array [fa, fb, fc]
							)
							fseek f 0x02 #seek_cur
							fseek f 0x08 #seek_cur
							BufferType = readlong f #unsigned
							fseek f -0x0C #seek_cur
							FileEnd = 0
							case of
							(
								default:( throw ( "Something went wrong! Contact RTB!" ) )
								( BufferType == 0 ):(
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									for x = 1 to sectioncount do
									(
										vx = readfloat f * ModelScale
										vy = readfloat f * ModelScale
										vz = readfloat f * ModelScale
										append Vert_array [vx, vy, vz]
									)
									fseek f 0x02 #seek_cur
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									for x = 1 to sectioncount do
									(
										nx = readfloat f
										ny = readfloat f
										nz = readfloat f
										append Normal_array [nx, ny, nz]
									)
									fseek f 0x02 #seek_cur
									if BoneIDSets > 0 do
									(
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x01 #seek_cur
										for x = 1 to sectioncount do
										(
											Weight1 = readfloat f
											Weight2 = readfloat f
											Weight3 = readfloat f
											Weight4 = 0
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										fseek f 0x02 #seek_cur
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x01 #seek_cur
										for x = 1 to sectioncount do
										(
											Bone1 = ( readbyte f #unsigned ) / 4
											Bone2 = ( readbyte f #unsigned ) / 4
											Bone3 = ( readbyte f #unsigned ) / 4
											Bone4 = ( readbyte f #unsigned ) / 4
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
										fseek f 0x02 #seek_cur
									)
									if BoneIDSets == 0 do
									( fseek f 0x02 #seek_cur )
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									for x = 1 to sectioncount do
									(
										tu = readfloat f
										tv = ( readfloat f * -1 ) + 1
										append UV_array [tu, tv, 0]
									)
									fseek f 0x02 #seek_cur
								)
								( BufferType == 1 ):(
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									for x = 1 to sectioncount do
									(
										vx = readfloat f * ModelScale
										vy = readfloat f * ModelScale
										vz = readfloat f * ModelScale
										append Vert_array [vx, vy, vz]
									)
									fseek f 0x02 #seek_cur
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									for x = 1 to sectioncount do
									( NormVal = readshort f #unsigned )
									fseek f 0x02 #seek_cur
									if BoneIDSets > 0 do
									(
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x01 #seek_cur
										for x = 1 to sectioncount do
										(
											Weight1 = readfloat f
											Weight2 = readfloat f
											Weight3 = readfloat f
											Weight4 = 0
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										fseek f 0x02 #seek_cur
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x01 #seek_cur
										for x = 1 to sectioncount do
										(
											Bone1 = ( readbyte f #unsigned ) / 4
											Bone2 = ( readbyte f #unsigned ) / 4
											Bone3 = ( readbyte f #unsigned ) / 4
											Bone4 = ( readbyte f #unsigned ) / 4
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
										fseek f 0x02 #seek_cur
									)
									if BoneIDSets == 0 do
									( fseek f 0x02 #seek_cur )
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									for x = 1 to sectioncount do
									(
										tu = readfloat f
										tv = ( readfloat f * -1 ) + 1
										append UV_array [tu, tv, 0]
									)
									fseek f 0x02 #seek_cur
								)
							)
							
							
							for i = 1 to PolyStruct_array.count do
							(
								ProperBoneID_array = #()
								FixedBoneID_array = #()
								ActualB1_array = #()
								Weight_array = #()
								Weight_array2 = #()
								Face_array2 = #()
								Face_array3 = #()
								Vert_array2 = #()
								Normal_array2 = #()
								UV_array2 = #()
								if BoneCount != 0 and BoneIDSets > 0 do
								(
									fseek f BoneIDOffset_array[1 * PolyStruct_array[i].BoneSetNum] #seek_set
									boneidtotal = readlong f #unsigned
									ProperBoneID_array = #()
									for y = 1 to boneidtotal do
									(
										boneidheaderlength = readlong f #unsigned
										boneidnamelength = readlong f #unsigned
										bonename = ReadFixedString f boneidnamelength
										append ProperBoneID_array bonename
										ffffffff = readlong f #unsigned
									)
									for a = 1 to boneidtotal do
									(
										for b = 1 to BoneCount do
										(
											if ProperBoneID_array[a] == BoneName_array[b] do
											( append FixedBoneID_array b )
										)
									)
									for x = 1 to B1_array.count do
									(
										ImproperBone1 = B1_array[x].Bone1
										ImproperBone2 = B1_array[x].Bone2
										ImproperBone3 = B1_array[x].Bone3
										ImproperBone4 = B1_array[x].Bone4
										ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
										ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
										ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
										ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
										if ProperBone1 == undefined do
										( ProperBone1 = 1 )
										if ProperBone2 == undefined do
										( ProperBone2 = 1 )
										if ProperBone3 == undefined do
										( ProperBone3 = 1 )
										if ProperBone4 == undefined do
										( ProperBone4 = 1 )
										append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
									)
									for b = 1 to W1_array.count Do
									(
										w = ( weight_data boneids: #() weights: #() )
										maxweight = 0
										if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
										if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
										if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
										if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
										if ( maxweight != 0 ) then
										(
											if ( W1_array[b].Weight1 != 0 ) then
											(
												w1 = W1_array[b].Weight1 as float
												append w.boneids ( ActualB1_array[b].Bone1 )
												append w.weights ( w1 )
											)
											if ( W1_array[b].Weight2 != 0 ) then
											(
												w2 = W1_array[b].Weight2 as float
												append w.boneids ( ActualB1_array[b].Bone2 )
												append w.weights ( w2 )
											)
											if ( W1_array[b].Weight3 != 0 ) then
											(
												w3 = W1_array[b].Weight3 as float
												append w.boneids ( ActualB1_array[b].Bone3 )
												append w.weights ( w3 )
											)
											if ( W1_array[b].Weight4 != 0 ) then
											(
												w4 = W1_array[b].Weight4 as float
												append w.boneids ( ActualB1_array[b].Bone4 )
												append w.weights ( w4 )
											)
										)
										append Weight_array w
									)
								)
								for y = PolyStruct_array[i].PolygonStart to ( PolyStruct_array[i].PolygonCount + PolyStruct_array[i].PolygonStart ) do
								( append Face_array2 Face_array[y] )
								VertexMin = PolyStruct_array[i].VertexMin
								VertexMax = PolyStruct_array[i].VertexMax
								for x = VertexMin to VertexMax do
								(
									append Vert_array2 Vert_array[x]
									if Normal_array.count > 0 do
									( append Normal_array2 Normal_array[x] )
									append UV_array2 UV_array[x]
									append Weight_array2 Weight_array[x]
								)
								for x = 1 to PolyStruct_array[i].PolygonCount do
								(
									Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
									append Face_array3 Faces3
								)
								local PolyMat = standardMaterial()
								PolyMat.name = PolyStruct_array[i].MatName
								PolyMat.showinviewport = true
								PolyMat.twosided = false
								if TexFormat == 1 then
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + PolyStruct_array[i].MatName + ".dds" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + PolyStruct_array[i].MatName + ".dds" ) )
								)
								else
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + PolyStruct_array[i].MatName + ".png" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + PolyStruct_array[i].MatName + ".png" ) )
								)
								tm.alphasource = 0
								PolyMat.diffuseMap = tm
								PolyMat.opacityMap = tm
								PolyMat.opacityMap.monoOutput = 1
								msh = mesh vertices: Vert_array2 faces: Face_array3
								msh.numTVerts = Vert_array2.count
								defaultVCFaces msh
								buildTVFaces msh
								msh.name = ( h as string )
								msh.material = PolyMat
								for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
								for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
								max modify mode
								select msh
								for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
								if Normal_array2.count > 0 do
								(
									addmodifier msh ( Edit_Normals() ) ui: off
									msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
									EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
									EN_setNormal = msh.Edit_Normals.SetNormal
									normID = #{}
									for v = 1 to Normal_array2.count do
									(
										free normID
										EN_convertVS #{v} &normID
										for id in normID do EN_setNormal id Normal_array2[v]
									)
								)
								if BoneCount != 0 and BoneIDSets > 0 do
								(
									skinMod = skin()
									boneIDMap = #()
									addModifier msh skinMod
									for i = 1 to BoneCount do
									(
										maxbone = getnodebyname BoneSetup[i].name
										if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
									)
									local numSkinBones = skinOps.GetNumberBones skinMod
									for i = 1 to numSkinBones do
									(
										local boneName = skinOps.GetBoneName skinMod i 0
										for j = 1 to BoneCount do
										(
											if boneName == BoneSetup[j].Name then
											(
												boneIDMap[j] = i
												j = BoneCount + 1
											)
										)
									)
									modPanel.setCurrentObject skinMod
									for i = 1 to Vert_array2.count do
									(
										skinOps.SetVertexWeights skinMod i 1 1
										skinOps.unnormalizeVertex skinMod i true
										skinOps.SetVertexWeights skinMod i 1 0
									)
									skinOps.RemoveZeroWeights skinMod
									for i = 1 to Vert_array2.count do
									( skinOps.unnormalizeVertex skinMod i false )
									for i = 1 to Weight_array2.count do
									(
										w = Weight_array2[i]
										bi = #()
										wv = #()
										for j = 1 to w.boneids.count do
										(
											boneid = w.boneids[j]
											weight = w.weights[j]
											append bi boneIDMap[boneid]
											append wv weight
										)
										skinOps.ReplaceVertexWeights skinMod i bi wv
									)
								)
							)
							fclose f
						)
						( VerNum == 0 and SamFix == 3 ):(
							Face_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							B1_array = #()
							W1_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							TexName_array = #()
							MatPlus = 0
							FooterPlus = 0
							struct Polygon_Info_Struct
							(
								VertexMin,
								VertexMax,
								PolygonStart,
								PolygonCount,
								FacePointCount,
								MatName,
								BoneSetNum,
								SingleBindNode
							)
							fseek f -0x01 #seek_cur
							headercheck1 = readshort f #unsigned
							if headercheck1 != 0x3131 and headercheck1 != 0x3031 and headercheck1 != 0x3130 do
							( fseek f -0x01 #seek_cur )
							boundingminx = readfloat f
							boundingminy = readfloat f
							boundingminz = readfloat f
							boundingmaxx = readfloat f
							boundingmaxy = readfloat f
							boundingmaxz = readfloat f
							head3asubsize = readlong f #unsigned
							polytotal = readlong f #unsigned
							if polytotal > 1000 do
							(
								fseek f -0x21 #seek_cur
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								head3asubsize = readlong f #unsigned
								polytotal = readlong f #unsigned
							)
							if polytotal > 1000 do
							( throw ( "Something went wrong! Contact RTB!" ) )
							for x = 1 to polytotal do
							(
								nameheaderlength = readlong f #unsigned - 8
								if nameheaderlength > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								namelength = ( readlong f #unsigned ) - 4
								fseek f nameheaderlength #seek_cur
								nameheaderlength2 = readlong f #unsigned - 8
								if nameheaderlength2 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								namelength2 = ( readlong f #unsigned ) - 4
								fseek f nameheaderlength2 #seek_cur
								BoneSetNum = ( readlong f #unsigned ) + 1
								SingleBindNode = readlong f #unsigned
								VertexMin = readlong f #unsigned + 1
								VertexMax = readlong f #unsigned + 1
								FacepointStart = readlong f #unsigned
								PolygonStart = ( FacepointStart / 3 ) + 1
								PolygonCount = readlong f #unsigned
								FacepointCount = PolygonCount * 3
								nameheaderlength3 = readlong f #unsigned
								namelength3 = readlong f #unsigned
								fseek f namelength3 #seek_cur
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								materialheaderlength = readlong f #unsigned
								if materialheaderlength > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength = readlong f #unsigned - 6
								if materialnamelength > 0 do
								(
									MaterialName = ReadFixedString f ( materialnamelength )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength2 = readlong f #unsigned
								if materialheaderlength2 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength2 = readlong f #unsigned - 6
								if materialnamelength2 > 0 do
								(
									MaterialName2 = ReadFixedString f ( materialnamelength2 )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength3 = readlong f #unsigned
								if materialheaderlength3 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength3 = readlong f #unsigned - 6
								if materialnamelength3 > 0 do
								(
									MaterialName3 = ReadFixedString f ( materialnamelength3 )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength4 = readlong f #unsigned
								if materialheaderlength4 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength4 = readlong f #unsigned - 6
								if materialnamelength4 > 0 do
								(
									MaterialName4 = ReadFixedString f ( materialnamelength4 )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength5 = readlong f #unsigned
								if materialheaderlength5 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength5 = readlong f #unsigned - 6
								if materialnamelength5 > 0 do
								(
									MaterialName5 = ReadFixedString f ( materialnamelength5 )
									fseek f 0x06 #seek_cur
								)
								fseek f 0x01 #seek_cur
								materialheaderlength6 = readlong f #unsigned
								if materialheaderlength6 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength6 = readlong f #unsigned - 6
								if materialnamelength6 > 0 do
								(
									MaterialName6 = ReadFixedString f ( materialnamelength6 )
									fseek f 0x06 #seek_cur
								)
								unknownenvvalue = readlong f #unsigned
								fseek f 0x02 #seek_cur
								float2 = readfloat f
								materialheaderlength7 = readlong f #unsigned
								if materialheaderlength7 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength7 = readlong f #unsigned - 6
								if materialnamelength7 > 0 do
								(
									MaterialName7 = ReadFixedString f ( materialnamelength7 )
									fseek f 0x06 #seek_cur
								)
								floatx3 = readfloat f
								floaty3 = readfloat f
								floatz3 = readfloat f
								floatx4 = readfloat f
								floaty4 = readfloat f
								floatz4 = readfloat f
								floatx5 = readfloat f
								floaty5 = readfloat f
								floatz5 = readfloat f
								fseek f 0x01 #seek_cur
								floatx6 = readfloat f
								floaty6 = readfloat f
								floatz6 = readfloat f
								floatx7 = readfloat f
								floaty7 = readfloat f
								floatz7 = readfloat f
								floatx8 = readfloat f
								floaty8 = readfloat f
								floatz8 = readfloat f
								float10 = readfloat f
								float11 = readfloat f
								fseek f 0x05 #seek_cur
								unknown1 = readlong f #unsigned
								float12 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								fseek f 0x01 #seek_cur
								namelength = readlong f #unsigned
								if namelength > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								fseek f namelength #seek_cur
								namelength2 = readlong f #unsigned
								if namelength2 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								fseek f namelength2 #seek_cur
								append PolyStruct_array ( Polygon_Info_Struct VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatName: MaterialName BoneSetNum: BoneSetNum SingleBindNode: SingleBindNode )
							)
							IDHeaderLength = ( readlong f #unsigned - 4 )
							BoneIDSets = readlong f #unsigned
							for x = 1 to BoneIDSets do
							(
								append BoneIDOffset_Array ( ftell f )
								boneidtotal = readlong f #unsigned
								for y = 1 to boneidtotal do
								(
									boneidheaderlength = readlong f #unsigned
									boneidnamelength = readlong f #unsigned
									bonename = ReadFixedString f boneidnamelength
									ffffffff = readlong f #unsigned
								)
							)
							footercheck = 0x30
							do ( footercheck = readbyte f #unsigned )
							while footercheck != 0x65
							fseek f 0x03 #seek_cur
							facecount = readlong f #unsigned
							facelength = readlong f #unsigned
							for x = 1 to facecount / 3 do
							(
								fa = readshort f #unsigned + 1
								fb = readshort f #unsigned + 1
								fc = readshort f #unsigned + 1
								append Face_array [fa, fb, fc]
							)
							fseek f 0x02 #seek_cur
							fseek f 0x08 #seek_cur
							BufferType = readlong f #unsigned
							fseek f -0x0C #seek_cur
							FileEnd = 0
							case of
							(
								default:( throw ( "Something went wrong! Contact RTB!" ) )
								( BufferType == 0 ):(
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									for x = 1 to sectioncount do
									(
										vx = readfloat f * ModelScale
										vy = readfloat f * ModelScale
										vz = readfloat f * ModelScale
										append Vert_array [vx, vy, vz]
									)
									fseek f 0x02 #seek_cur
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									for x = 1 to sectioncount do
									(
										nx = readfloat f
										ny = readfloat f
										nz = readfloat f
										append Normal_array [nx, ny, nz]
									)
									fseek f 0x02 #seek_cur
									if BoneIDSets > 0 do
									(
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x01 #seek_cur
										for x = 1 to sectioncount do
										(
											Weight1 = readfloat f
											Weight2 = readfloat f
											Weight3 = readfloat f
											Weight4 = 0
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										fseek f 0x02 #seek_cur
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x01 #seek_cur
										for x = 1 to sectioncount do
										(
											Bone1 = ( readbyte f #unsigned ) / 4
											Bone2 = ( readbyte f #unsigned ) / 4
											Bone3 = ( readbyte f #unsigned ) / 4
											Bone4 = ( readbyte f #unsigned ) / 4
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
										fseek f 0x02 #seek_cur
									)
									if BoneIDSets == 0 do
									( fseek f 0x02 #seek_cur )
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									for x = 1 to sectioncount do
									(
										tu = readfloat f
										tv = ( readfloat f * -1 ) + 1
										append UV_array [tu, tv, 0]
									)
									fseek f 0x02 #seek_cur
								)
								( BufferType == 1 ):(
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									for x = 1 to sectioncount do
									(
										vx = readfloat f * ModelScale
										vy = readfloat f * ModelScale
										vz = readfloat f * ModelScale
										append Vert_array [vx, vy, vz]
									)
									fseek f 0x02 #seek_cur
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									for x = 1 to sectioncount do
									( NormVal = readshort f #unsigned )
									fseek f 0x02 #seek_cur
									if BoneIDSets > 0 do
									(
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x01 #seek_cur
										for x = 1 to sectioncount do
										(
											Weight1 = readfloat f
											Weight2 = readfloat f
											Weight3 = readfloat f
											Weight4 = 0
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										fseek f 0x02 #seek_cur
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x01 #seek_cur
										for x = 1 to sectioncount do
										(
											Bone1 = ( readbyte f #unsigned ) / 4
											Bone2 = ( readbyte f #unsigned ) / 4
											Bone3 = ( readbyte f #unsigned ) / 4
											Bone4 = ( readbyte f #unsigned ) / 4
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
										fseek f 0x02 #seek_cur
									)
									if BoneIDSets == 0 do
									( fseek f 0x02 #seek_cur )
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x01 #seek_cur
									for x = 1 to sectioncount do
									(
										tu = readfloat f
										tv = ( readfloat f * -1 ) + 1
										append UV_array [tu, tv, 0]
									)
									fseek f 0x02 #seek_cur
								)
							)
							
							
							for i = 1 to PolyStruct_array.count do
							(
								ProperBoneID_array = #()
								FixedBoneID_array = #()
								ActualB1_array = #()
								Weight_array = #()
								Weight_array2 = #()
								Face_array2 = #()
								Face_array3 = #()
								Vert_array2 = #()
								Normal_array2 = #()
								UV_array2 = #()
								if BoneCount != 0 and BoneIDSets > 0 do
								(
									fseek f BoneIDOffset_array[1 * PolyStruct_array[i].BoneSetNum] #seek_set
									boneidtotal = readlong f #unsigned
									ProperBoneID_array = #()
									for y = 1 to boneidtotal do
									(
										boneidheaderlength = readlong f #unsigned
										boneidnamelength = readlong f #unsigned
										bonename = ReadFixedString f boneidnamelength
										append ProperBoneID_array bonename
										ffffffff = readlong f #unsigned
									)
									for a = 1 to boneidtotal do
									(
										for b = 1 to BoneCount do
										(
											if ProperBoneID_array[a] == BoneName_array[b] do
											( append FixedBoneID_array b )
										)
									)
									for x = 1 to B1_array.count do
									(
										ImproperBone1 = B1_array[x].Bone1
										ImproperBone2 = B1_array[x].Bone2
										ImproperBone3 = B1_array[x].Bone3
										ImproperBone4 = B1_array[x].Bone4
										ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
										ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
										ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
										ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
										if ProperBone1 == undefined do
										( ProperBone1 = 1 )
										if ProperBone2 == undefined do
										( ProperBone2 = 1 )
										if ProperBone3 == undefined do
										( ProperBone3 = 1 )
										if ProperBone4 == undefined do
										( ProperBone4 = 1 )
										append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
									)
									for b = 1 to W1_array.count Do
									(
										w = ( weight_data boneids: #() weights: #() )
										maxweight = 0
										if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
										if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
										if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
										if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
										if ( maxweight != 0 ) then
										(
											if ( W1_array[b].Weight1 != 0 ) then
											(
												w1 = W1_array[b].Weight1 as float
												append w.boneids ( ActualB1_array[b].Bone1 )
												append w.weights ( w1 )
											)
											if ( W1_array[b].Weight2 != 0 ) then
											(
												w2 = W1_array[b].Weight2 as float
												append w.boneids ( ActualB1_array[b].Bone2 )
												append w.weights ( w2 )
											)
											if ( W1_array[b].Weight3 != 0 ) then
											(
												w3 = W1_array[b].Weight3 as float
												append w.boneids ( ActualB1_array[b].Bone3 )
												append w.weights ( w3 )
											)
											if ( W1_array[b].Weight4 != 0 ) then
											(
												w4 = W1_array[b].Weight4 as float
												append w.boneids ( ActualB1_array[b].Bone4 )
												append w.weights ( w4 )
											)
										)
										append Weight_array w
									)
								)
								for y = PolyStruct_array[i].PolygonStart to ( PolyStruct_array[i].PolygonCount + PolyStruct_array[i].PolygonStart ) do
								( append Face_array2 Face_array[y] )
								VertexMin = PolyStruct_array[i].VertexMin
								VertexMax = PolyStruct_array[i].VertexMax
								for x = VertexMin to VertexMax do
								(
									append Vert_array2 Vert_array[x]
									if Normal_array.count > 0 do
									( append Normal_array2 Normal_array[x] )
									append UV_array2 UV_array[x]
									append Weight_array2 Weight_array[x]
								)
								for x = 1 to PolyStruct_array[i].PolygonCount do
								(
									Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
									append Face_array3 Faces3
								)
								local PolyMat = standardMaterial()
								PolyMat.name = PolyStruct_array[i].MatName
								PolyMat.showinviewport = true
								PolyMat.twosided = false
								if TexFormat == 1 then
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + PolyStruct_array[i].MatName + ".dds" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + PolyStruct_array[i].MatName + ".dds" ) )
								)
								else
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + PolyStruct_array[i].MatName + ".png" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + PolyStruct_array[i].MatName + ".png" ) )
								)
								tm.alphasource = 0
								PolyMat.diffuseMap = tm
								PolyMat.opacityMap = tm
								PolyMat.opacityMap.monoOutput = 1
								msh = mesh vertices: Vert_array2 faces: Face_array3
								msh.numTVerts = Vert_array2.count
								defaultVCFaces msh
								buildTVFaces msh
								msh.name = ( h as string )
								msh.material = PolyMat
								for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
								for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
								max modify mode
								select msh
								for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
								if Normal_array2.count > 0 do
								(
									addmodifier msh ( Edit_Normals() ) ui: off
									msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
									EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
									EN_setNormal = msh.Edit_Normals.SetNormal
									normID = #{}
									for v = 1 to Normal_array2.count do
									(
										free normID
										EN_convertVS #{v} &normID
										for id in normID do EN_setNormal id Normal_array2[v]
									)
								)
								if BoneCount != 0 and BoneIDSets > 0 do
								(
									skinMod = skin()
									boneIDMap = #()
									addModifier msh skinMod
									for i = 1 to BoneCount do
									(
										maxbone = getnodebyname BoneSetup[i].name
										if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
									)
									local numSkinBones = skinOps.GetNumberBones skinMod
									for i = 1 to numSkinBones do
									(
										local boneName = skinOps.GetBoneName skinMod i 0
										for j = 1 to BoneCount do
										(
											if boneName == BoneSetup[j].Name then
											(
												boneIDMap[j] = i
												j = BoneCount + 1
											)
										)
									)
									modPanel.setCurrentObject skinMod
									for i = 1 to Vert_array2.count do
									(
										skinOps.SetVertexWeights skinMod i 1 1
										skinOps.unnormalizeVertex skinMod i true
										skinOps.SetVertexWeights skinMod i 1 0
									)
									skinOps.RemoveZeroWeights skinMod
									for i = 1 to Vert_array2.count do
									( skinOps.unnormalizeVertex skinMod i false )
									for i = 1 to Weight_array2.count do
									(
										w = Weight_array2[i]
										bi = #()
										wv = #()
										for j = 1 to w.boneids.count do
										(
											boneid = w.boneids[j]
											weight = w.weights[j]
											append bi boneIDMap[boneid]
											append wv weight
										)
										skinOps.ReplaceVertexWeights skinMod i bi wv
									)
								)
							)
							fclose f
						)
						( VerNum == 0 and SamFix == 4 ):(
							Face_array = #()
							FacePoint_array = #()
							TriStrip_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							B1_array = #()
							W1_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							TexName_array = #()
							struct Polygon_Info_Struct
							(
								VertexMin,
								VertexMax,
								FacepointStart,
								PolygonCount,
								FacePointCount,
								MatName,
								BoneSetNum,
								SingleBindNode
							)
							struct TriStrip_Info_Struct
							(
								TriStripStart,
								TriStripEnd
							)
							boundingminx = readfloat f
							boundingminy = readfloat f
							boundingminz = readfloat f
							boundingmaxx = readfloat f
							boundingmaxy = readfloat f
							boundingmaxz = readfloat f
							head3asubsize = readlong f #unsigned
							polytotal = readlong f #unsigned
							if polytotal > 1000 do
							(
								fseek f -0x21 #seek_cur
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								head3asubsize = readlong f #unsigned
								polytotal = readlong f #unsigned
							)
							if polytotal > 1000 do
							( throw ( "Something went wrong! Contact RTB!" ) )
							for x = 1 to polytotal do
							(
								nameheaderlength = readlong f #unsigned - 8
								if nameheaderlength > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								namelength = ( readlong f #unsigned ) - 4
								fseek f nameheaderlength #seek_cur
								nameheaderlength2 = readlong f #unsigned - 8
								if nameheaderlength2 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								namelength2 = ( readlong f #unsigned ) - 4
								fseek f nameheaderlength2 #seek_cur
								BoneSetNum = ( readlong f #unsigned ) + 1
								SingleBindNode = readlong f #unsigned
								VertexMin = readlong f #unsigned + 1
								VertexMax = readlong f #unsigned + 1
								FacepointStart = readlong f #unsigned + 1
								PolygonStart = ( FacepointStart / 3 ) + 1
								PolygonCount = readlong f #unsigned
								FacepointCount = ( PolygonCount * 3 )
								nameheaderlength3 = readlong f #unsigned
								namelength3 = readlong f #unsigned
								fseek f namelength3 #seek_cur
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								materialheaderlength = readlong f #unsigned
								if materialheaderlength > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength = readlong f #unsigned - 6
								if materialnamelength > 0 do
								(
									MaterialName = ReadFixedString f ( materialnamelength )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength2 = readlong f #unsigned
								if materialheaderlength2 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength2 = readlong f #unsigned - 6
								if materialnamelength2 > 0 do
								(
									MaterialName2 = ReadFixedString f ( materialnamelength2 )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength3 = readlong f #unsigned
								if materialheaderlength3 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength3 = readlong f #unsigned - 6
								if materialnamelength3 > 0 do
								(
									MaterialName3 = ReadFixedString f ( materialnamelength3 )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength4 = readlong f #unsigned
								if materialheaderlength4 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength4 = readlong f #unsigned - 6
								if materialnamelength4 > 0 do
								(
									MaterialName4 = ReadFixedString f ( materialnamelength4 )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength5 = readlong f #unsigned
								if materialheaderlength5 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength5 = readlong f #unsigned - 6
								if materialnamelength5 > 0 do
								(
									MaterialName5 = ReadFixedString f ( materialnamelength5 )
									fseek f 0x06 #seek_cur
								)
								fseek f 0x01 #seek_cur
								TriStripHeader = readlong f #unsigned
								TriStripGroups = readlong f #unsigned
								if TriStripGroups == 2 then
								(
									TriStripStart = readshort f #unsigned + 1
									TriStripEnd = readshort f #unsigned + 1
									append TriStrip_array ( TriStrip_Info_Struct TriStripStart: TriStripStart TriStripEnd: TriStripEnd )
								)
								else
								( append TriStrip_array ( TriStrip_Info_Struct TriStripStart: 0 TriStripEnd: 0 ) )
								if TriStripGroups > 2 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								FacePointEnd = readlong f #unsigned
								fseek f 0x02 #seek_cur
								float2 = readfloat f
								materialheaderlength6 = readlong f #unsigned
								if materialheaderlength6 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								materialnamelength6 = readlong f #unsigned - 6
								if materialnamelength6 > 0 do
								(
									MaterialName6 = ReadFixedString f ( materialnamelength6 )
									fseek f 0x06 #seek_cur
								)
								floatx3 = readfloat f
								floaty3 = readfloat f
								floatz3 = readfloat f
								floatx4 = readfloat f
								floaty4 = readfloat f
								floatz4 = readfloat f
								floatx5 = readfloat f
								floaty5 = readfloat f
								floatz5 = readfloat f
								fseek f 0x01 #seek_cur
								floatx6 = readfloat f
								floaty6 = readfloat f
								floatz6 = readfloat f
								floatx7 = readfloat f
								floaty7 = readfloat f
								floatz7 = readfloat f
								floatx8 = readfloat f
								floaty8 = readfloat f
								floatz8 = readfloat f
								float10 = readfloat f
								float11 = readfloat f
								fseek f 0x05 #seek_cur
								float12 = readfloat f
								float13 = readfloat f
								float14 = readfloat f
								float15 = readfloat f
								unknown4 = readlong f #unsigned
								fseek f 0x01 #seek_cur
								namelength = readlong f #unsigned
								if namelength > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								fseek f namelength #seek_cur
								namelength2 = readlong f #unsigned
								if namelength2 > 1000 do
								( throw ( "Something went wrong! Contact RTB!" ) )
								fseek f namelength2 #seek_cur
								append PolyStruct_array ( Polygon_Info_Struct VertexMin: VertexMin VertexMax: VertexMax FacepointStart: FacepointStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatName: MaterialName BoneSetNum: BoneSetNum SingleBindNode: SingleBindNode )
							)
							IDHeaderLength = ( readlong f #unsigned - 4 )
							BoneIDSets = readlong f #unsigned
							for x = 1 to BoneIDSets do
							(
								append BoneIDOffset_Array ( ftell f )
								boneidtotal = readlong f #unsigned
								for y = 1 to boneidtotal do
								(
									boneidheaderlength = readlong f #unsigned
									boneidnamelength = readlong f #unsigned
									bonename = ReadFixedString f boneidnamelength
									ffffffff = readlong f #unsigned
								)
							)
							footercheck = 0x30
							do ( footercheck = readbyte f #unsigned )
							while footercheck != 0x65
							fseek f 0x03 #seek_cur
							facecount = readlong f #unsigned
							facelength = readlong f #unsigned
							realignment = ( facecount * facelength ) + ( ftell f )
							for x = 1 to facecount do
							(
								face = readshort f #unsigned + 1
								append FacePoint_array face
							)
							fseek f realignment #seek_set
							fseek f 0x02 #seek_cur
							fseek f 0x08 #seek_cur
							BufferType = readlong f #unsigned
							fseek f -0x0C #seek_cur
							FileEnd = 0
							case of
							(
								default:( throw ( "Something went wrong! Contact RTB!" ) )
								( BufferType == 0 ):(
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									compressioncheck = readshort f #unsigned
									if compressioncheck == 12337 do
									(
										print ( "Can't parse " + ( h as string ) + ", as it's compressed!" )
										continue
									)
									if sectioncount > 100000 do
									( throw ( "Something went wrong! Contact RTB!" ) )
									for x = 1 to sectioncount do
									(
										vx = readfloat f * ModelScale
										vy = readfloat f * ModelScale
										vz = readfloat f * ModelScale
										append Vert_array [vx, vy, vz]
									)
									fseek f 0x02 #seek_cur
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x02 #seek_cur
									if sectioncount > 100000 do
									( throw ( "Something went wrong! Contact RTB!" ) )
									for x = 1 to sectioncount do
									(
										nx = readfloat f
										ny = readfloat f
										nz = readfloat f
										append Normal_array [nx, ny, nz]
									)
									fseek f 0x02 #seek_cur
									if BoneIDSets > 0 do
									(
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x02 #seek_cur
										if sectioncount > 100000 do
										( throw ( "Something went wrong! Contact RTB!" ) )
										for x = 1 to sectioncount do
										(
											Weight1 = readfloat f
											Weight2 = readfloat f
											Weight3 = readfloat f
											Weight4 = 0
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										fseek f 0x02 #seek_cur
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x02 #seek_cur
										if sectioncount > 100000 do
										( throw ( "Something went wrong! Contact RTB!" ) )
										for x = 1 to sectioncount do
										(
											Bone1 = ( readbyte f #unsigned ) / 4
											Bone2 = ( readbyte f #unsigned ) / 4
											Bone3 = ( readbyte f #unsigned ) / 4
											Bone4 = ( readbyte f #unsigned ) / 4
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
										fseek f 0x02 #seek_cur
									)
									if BoneIDSets == 0 do
									( fseek f 0x02 #seek_cur )
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x02 #seek_cur
									if sectioncount > 100000 do
									( throw ( "Something went wrong! Contact RTB!" ) )
									for x = 1 to sectioncount do
									(
										tu = readfloat f
										tv = ( readfloat f * -1 ) + 1
										append UV_array [tu, tv, 0]
									)
									fseek f 0x02 #seek_cur
								)
								( BufferType == 1 ):(
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									compressioncheck = readshort f #unsigned
									if compressioncheck == 12337 do
									(
										print ( "Can't parse " + ( h as string ) + ", as it's compressed!" )
										continue
									)
									if sectioncount > 100000 do
									( throw ( "Something went wrong! Contact RTB!" ) )
									for x = 1 to sectioncount do
									(
										vx = readfloat f * ModelScale
										vy = readfloat f * ModelScale
										vz = readfloat f * ModelScale
										append Vert_array [vx, vy, vz]
									)
									fseek f 0x02 #seek_cur
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x02 #seek_cur
									if sectioncount > 100000 do
									( throw ( "Something went wrong! Contact RTB!" ) )
									for x = 1 to sectioncount do
									( NormVal = readshort f #unsigned )
									fseek f 0x02 #seek_cur
									if BoneIDSets > 0 do
									(
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x02 #seek_cur
										if sectioncount > 100000 do
										( throw ( "Something went wrong! Contact RTB!" ) )
										for x = 1 to sectioncount do
										(
											Weight1 = readfloat f
											Weight2 = readfloat f
											Weight3 = readfloat f
											Weight4 = 0
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										fseek f 0x02 #seek_cur
										sectioncount = readlong f #unsigned
										sectionlength = readlong f #unsigned
										sectiontype = readlong f #unsigned
										fseek f 0x02 #seek_cur
										if sectioncount > 100000 do
										( throw ( "Something went wrong! Contact RTB!" ) )
										for x = 1 to sectioncount do
										(
											Bone1 = ( readbyte f #unsigned ) / 4
											Bone2 = ( readbyte f #unsigned ) / 4
											Bone3 = ( readbyte f #unsigned ) / 4
											Bone4 = ( readbyte f #unsigned ) / 4
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
										fseek f 0x02 #seek_cur
									)
									if BoneIDSets == 0 do
									( fseek f 0x02 #seek_cur )
									sectioncount = readlong f #unsigned
									sectionlength = readlong f #unsigned
									sectiontype = readlong f #unsigned
									fseek f 0x02 #seek_cur
									if sectioncount > 100000 do
									( throw ( "Something went wrong! Contact RTB!" ) )
									for x = 1 to sectioncount do
									(
										tu = readfloat f
										tv = ( readfloat f * -1 ) + 1
										append UV_array [tu, tv, 0]
									)
									fseek f 0x02 #seek_cur
								)
							)
							
							
							for i = 1 to PolyStruct_array.count do
							(
								ProperBoneID_array = #()
								FixedBoneID_array = #()
								ActualB1_array = #()
								Weight_array = #()
								Weight_array2 = #()
								Face_array2 = #()
								Face_array3 = #()
								Vert_array2 = #()
								Normal_array2 = #()
								UV_array2 = #()
								if BoneCount != 0 and BoneIDSets > 0 do
								(
									fseek f BoneIDOffset_array[1 * PolyStruct_array[i].BoneSetNum] #seek_set
									boneidtotal = readlong f #unsigned
									ProperBoneID_array = #()
									for y = 1 to boneidtotal do
									(
										boneidheaderlength = readlong f #unsigned
										boneidnamelength = readlong f #unsigned
										bonename = ReadFixedString f boneidnamelength
										append ProperBoneID_array bonename
										ffffffff = readlong f #unsigned
									)
									for a = 1 to boneidtotal do
									(
										for b = 1 to BoneCount do
										(
											if ProperBoneID_array[a] == BoneName_array[b] do
											( append FixedBoneID_array b )
										)
									)
									for x = 1 to B1_array.count do
									(
										ImproperBone1 = B1_array[x].Bone1
										ImproperBone2 = B1_array[x].Bone2
										ImproperBone3 = B1_array[x].Bone3
										ImproperBone4 = B1_array[x].Bone4
										ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
										ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
										ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
										ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
										if ProperBone1 == undefined do
										( ProperBone1 = 1 )
										if ProperBone2 == undefined do
										( ProperBone2 = 1 )
										if ProperBone3 == undefined do
										( ProperBone3 = 1 )
										if ProperBone4 == undefined do
										( ProperBone4 = 1 )
										append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
									)
									for b = 1 to W1_array.count Do
									(
										w = ( weight_data boneids: #() weights: #() )
										maxweight = 0
										if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
										if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
										if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
										if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
										if ( maxweight != 0 ) then
										(
											if ( W1_array[b].Weight1 != 0 ) then
											(
												w1 = W1_array[b].Weight1 as float
												append w.boneids ( ActualB1_array[b].Bone1 )
												append w.weights ( w1 )
											)
											if ( W1_array[b].Weight2 != 0 ) then
											(
												w2 = W1_array[b].Weight2 as float
												append w.boneids ( ActualB1_array[b].Bone2 )
												append w.weights ( w2 )
											)
											if ( W1_array[b].Weight3 != 0 ) then
											(
												w3 = W1_array[b].Weight3 as float
												append w.boneids ( ActualB1_array[b].Bone3 )
												append w.weights ( w3 )
											)
											if ( W1_array[b].Weight4 != 0 ) then
											(
												w4 = W1_array[b].Weight4 as float
												append w.boneids ( ActualB1_array[b].Bone4 )
												append w.weights ( w4 )
											)
										)
										append Weight_array w
									)
								)
								fa = undefined
								fb = undefined
								fc = undefined
								facenum = 1
								PolygonCount = PolyStruct_array[i].PolygonCount
								TriStripStart = ( PolyStruct_array[i].FacepointCount + ( PolyStruct_array[i].FacepointStart - 1 ) )
								for y = PolyStruct_array[i].FacepointStart to ( PolyStruct_array[i].FacepointCount + ( PolyStruct_array[i].FacepointStart - 1 ) ) do
								(
									if facenum == 1 do
									( fa = FacePoint_array[y] )
									if facenum == 2 do
									( fb = FacePoint_array[y] )
									if facenum == 3 do
									(
										fc = FacePoint_array[y]
										append Face_array2 [fa, fb, fc]
										fa = undefined
										fb = undefined
										fc = undefined
										facenum = 0
									)
									facenum = facenum + 1
								)
								if TriStrip_array[i].TriStripStart != 0 do
								(
									StartDirection = 1
									FaceDirection = StartDirection
									index = TriStrip_array[i].TriStripStart + 2
									f1 = FacePoint_array[index - 2]
									f2 = FacePoint_array[index - 1]
									do
									(
										f3 = FacePoint_array[index]
										FaceDirection *= -1
										if ( f1 != f2 ) and ( f2 != f3 ) and ( f3 != f1 ) then
										(
											if FaceDirection > 0 then
											(
												append Face_array2 [f3, f2, f1]
												PolygonCount = PolygonCount + 1
											)
											else
											(
												append Face_array2 [f2, f3, f1]
												PolygonCount = PolygonCount + 1
											)
										)
										f1 = f2
										f2 = f3
										index = index + 1
									)
									while index != TriStrip_array[i].TriStripEnd
								)
								VertexMin = PolyStruct_array[i].VertexMin
								VertexMax = PolyStruct_array[i].VertexMax
								for x = VertexMin to VertexMax do
								(
									append Vert_array2 Vert_array[x]
									if Normal_array.count > 0 do
									( append Normal_array2 Normal_array[x] )
									append UV_array2 UV_array[x]
									append Weight_array2 Weight_array[x]
								)
								for x = 1 to PolygonCount do
								(
									Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
									append Face_array3 Faces3
								)
								local PolyMat = standardMaterial()
								PolyMat.name = PolyStruct_array[i].MatName
								PolyMat.showinviewport = true
								PolyMat.twosided = false
								if TexFormat == 1 then
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + PolyStruct_array[i].MatName + ".dds" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + PolyStruct_array[i].MatName + ".dds" ) )
								)
								else
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + PolyStruct_array[i].MatName + ".png" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + PolyStruct_array[i].MatName + ".png" ) )
								)
								tm.alphasource = 0
								PolyMat.diffuseMap = tm
								PolyMat.opacityMap = tm
								PolyMat.opacityMap.monoOutput = 1
								msh = mesh vertices: Vert_array2 faces: Face_array3
								msh.numTVerts = Vert_array2.count
								defaultVCFaces msh
								buildTVFaces msh
								msh.name = ( h as string )
								msh.material = PolyMat
								for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
								for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
								max modify mode
								select msh
								for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
								if Normal_array2.count > 0 do
								(
									addmodifier msh ( Edit_Normals() ) ui: off
									msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
									EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
									EN_setNormal = msh.Edit_Normals.SetNormal
									normID = #{}
									for v = 1 to Normal_array2.count do
									(
										free normID
										EN_convertVS #{v} &normID
										for id in normID do EN_setNormal id Normal_array2[v]
									)
								)
								if BoneCount != 0 and BoneIDSets > 0 do
								(
									skinMod = skin()
									boneIDMap = #()
									addModifier msh skinMod
									for i = 1 to BoneCount do
									(
										maxbone = getnodebyname BoneSetup[i].name
										if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
									)
									local numSkinBones = skinOps.GetNumberBones skinMod
									for i = 1 to numSkinBones do
									(
										local boneName = skinOps.GetBoneName skinMod i 0
										for j = 1 to BoneCount do
										(
											if boneName == BoneSetup[j].Name then
											(
												boneIDMap[j] = i
												j = BoneCount + 1
											)
										)
									)
									modPanel.setCurrentObject skinMod
									for i = 1 to Vert_array2.count do
									(
										skinOps.SetVertexWeights skinMod i 1 1
										skinOps.unnormalizeVertex skinMod i true
										skinOps.SetVertexWeights skinMod i 1 0
									)
									skinOps.RemoveZeroWeights skinMod
									for i = 1 to Vert_array2.count do
									( skinOps.unnormalizeVertex skinMod i false )
									for i = 1 to Weight_array2.count do
									(
										w = Weight_array2[i]
										bi = #()
										wv = #()
										for j = 1 to w.boneids.count do
										(
											boneid = w.boneids[j]
											weight = w.weights[j]
											append bi boneIDMap[boneid]
											append wv weight
										)
										skinOps.ReplaceVertexWeights skinMod i bi wv
									)
								)
							)
							fclose f
						)
						( VerNum == 1 ):( print "Version 1's unsupported for now. Sorry." )
						( VerNum == 2 ):(
							Face_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							UV2_array = #()
							UV3_array = #()
							UV4_array = #()
							B1_array = #()
							W1_array = #()
							Color_array = #()
							MatColor_array = #()
							Alpha_array = #()
							MatAlpha_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							TexName_array = #()
							struct Polygon_Info_Struct
							(
								VertexMin,
								VertexMax,
								PolygonStart,
								PolygonCount,
								FacePointCount,
								MatNum,
								BoneSetNum
							)
							fseek f 0x05 #seek_cur
							printDebug ( "Model start = " + ( ftell f as string ) )
							boundingminx = readfloat f
							boundingminy = readfloat f
							boundingminz = readfloat f
							boundingmaxx = readfloat f
							boundingmaxy = readfloat f
							boundingmaxz = readfloat f
							headerlength = readlong f #unsigned - 4
							fseek f headerlength #seek_cur
							head3asubsize = readlong f #unsigned
							polytotal = readlong f #unsigned
							printDebug ( "Count = " + polytotal as string )
							for x = 1 to polytotal do
							(
								printDebug ( "Model info start = " + ( ftell f as string ) )
								fseek f 0x18 #seek_cur
								BoneSetNum = ( readlong f #unsigned ) + 1
								fseek f 0x08 #seek_cur
								VertexMin = readlong f #unsigned + 1
								VertexMax = readlong f #unsigned + 1
								FacepointStart = readlong f #unsigned
								PolygonStart = ( FacepointStart / 3 ) + 1
								PolygonCount = readlong f #unsigned
								FacepointCount = PolygonCount * 3
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								floatx2 = readfloat f
								floaty2 = readfloat f
								floatz2 = readfloat f
								headerlength = readlong f #unsigned
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readfloat f
								MatNum = readlong f #unsigned + 1
								fseek f 0x1C #seek_cur
								materialheaderlength = readlong f #unsigned
								materialnamelength = readlong f #unsigned - 6
								if materialnamelength > 0 do
								(
									MaterialName = ReadFixedString f ( materialnamelength )
									printDebug ( "Tex1 = " + MaterialName as string )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength2 = readlong f #unsigned
								materialnamelength2 = readlong f #unsigned - 6
								if materialnamelength2 > 0 do
								(
									MaterialName2 = ReadFixedString f ( materialnamelength2 )
									printDebug ( "Tex2 = " + MaterialName2 as string )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength3 = readlong f #unsigned
								materialnamelength3 = readlong f #unsigned - 6
								if materialnamelength3 > 0 do
								(
									MaterialName3 = ReadFixedString f ( materialnamelength3 )
									printDebug ( "Tex3 = " + MaterialName3 as string )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength4 = readlong f #unsigned
								materialnamelength4 = readlong f #unsigned - 6
								if materialnamelength4 > 0 do
								(
									MaterialName4 = ReadFixedString f ( materialnamelength4 )
									printDebug ( "Tex4 = " + MaterialName4 as string )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength5 = readlong f #unsigned
								materialnamelength5 = readlong f #unsigned - 6
								if materialnamelength5 > 0 do
								(
									MaterialName5 = ReadFixedString f ( materialnamelength5 )
									printDebug ( "Tex5 = " + MaterialName5 as string )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength6 = readlong f #unsigned
								materialnamelength6 = readlong f #unsigned - 6
								if materialnamelength6 > 0 do
								(
									MaterialName6 = ReadFixedString f ( materialnamelength6 )
									printDebug ( "Tex6 = " + MaterialName6 as string )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength7 = readlong f #unsigned
								materialnamelength7 = readlong f #unsigned - 6
								if materialnamelength7 > 0 do
								(
									MaterialName7 = ReadFixedString f ( materialnamelength7 )
									printDebug ( "Tex7 = " + MaterialName7 as string )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength8 = readlong f #unsigned
								materialnamelength8 = readlong f #unsigned - 6
								if materialnamelength8 > 0 do
								(
									MaterialName8 = ReadFixedString f ( materialnamelength8 )
									printDebug ( "Tex8 = " + MaterialName8 as string )
									fseek f 0x06 #seek_cur
								)
								materialheaderlength9 = readlong f #unsigned
								materialnamelength9 = readlong f #unsigned - 6
								if materialnamelength9 > 0 do
								(
									MaterialName9 = ReadFixedString f ( materialnamelength9 )
									printDebug ( "Tex9 = " + MaterialName9 as string )
									fseek f 0x06 #seek_cur
								)
								fseek f 0x19 #seek_cur
								materialheaderlength10 = readlong f #unsigned
								materialnamelength10 = readlong f #unsigned - 6
								if materialnamelength10 > 0 do
								(
									MaterialName10 = ReadFixedString f ( materialnamelength10 )
									printDebug ( "Tex10 = " + MaterialName10 as string )
									fseek f 0x06 #seek_cur
								)
								fseek f 0xB8 #seek_cur
								materialheaderlength11 = readlong f #unsigned
								materialnamelength11 = readlong f #unsigned - 6
								if materialnamelength11 > 0 do
								(
									MaterialName11 = ReadFixedString f ( materialnamelength11 )
									printDebug ( "Tex11 = " + MaterialName11 as string )
									fseek f 0x06 #seek_cur
								)
								bytepad = readbyte f #unsigned
								colorr = ( readfloat f ) * 255
								colorg = ( readfloat f ) * 255
								colorb = ( readfloat f ) * 255
								colora = ( readfloat f ) * 255
								fseek f 0x08 #seek_cur
								append MatColor_array [colorr, colorg, colorb]
								append MatAlpha_array colora
								append PolyStruct_array ( Polygon_Info_Struct VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum BoneSetNum: BoneSetNum )
							)
							printDebug ( "Header B start = " + ( ftell f as string ) )
							headerBsize = ( readlong f #unsigned ) - 4
							fseek f headerBsize #seek_cur
							printDebug ( "Header C (Bone IDs) start = " + ( ftell f as string ) )
							IDHeaderLength = ( readlong f #unsigned - 4 )
							BoneIDSets = readlong f #unsigned
							printDebug ( "Count = " + BoneIDSets as string )
							for x = 1 to BoneIDSets do
							(
								append BoneIDOffset_Array ( ftell f )
								boneidtotal = readlong f #unsigned
								ProperBoneID_array = #()
								for y = 1 to boneidtotal do
								(
									properid1 = readlong f #unsigned
									properid2 = readlong f #unsigned
									nothing = readlong f #unsigned
								)
							)
							printDebug ( "Header D start = " + ( ftell f as string ) )
							headerDsize = ( readlong f #unsigned - 4 )
							fseek f headerDsize #seek_cur
							printDebug ( "Header E start = " + ( ftell f as string ) )
							headerEsize = ( readlong f #unsigned - 4 )
							fseek f headerEsize #seek_cur
							printDebug ( "Header F start = " + ( ftell f as string ) )
							fseek f 0x11 #seek_cur
							printDebug ( "Header G start = " + ( ftell f as string ) )
							MatGroupSize = ( readlong f #unsigned ) - 4 + ( ftell f )
							MatGroupCount = readlong f #unsigned
							for n = 1 to MatGroupCount do
							(
								materialsectionlength = readlong f #unsigned
								materialnamelength = ( readlong f #unsigned ) - 6
								materialname = ReadFixedString f materialnamelength
								append TexName_array materialname
								fseek f 0x06 #seek_cur
								floatx1 = readfloat f
								floaty1 = readfloat f
								floatz1 = readfloat f
								floatx2 = readfloat f
								floaty2 = readfloat f
								floatz2 = readfloat f
								headerlength = ( readlong f #unsigned - 4 )
								fseek f headerlength #seek_cur
								fseek f 0x06 #seek_cur
							)
							printDebug ( "Header H start = " + ( ftell f as string ) )
							headerHsize = ( readlong f #unsigned - 4 )
							fseek f headerHsize #seek_cur
							printDebug ( "Header I start = " + ( ftell f as string ) )
							headerIsize = ( readlong f #unsigned - 4 )
							fseek f headerIsize #seek_cur
							printDebug ( "Header J start = " + ( ftell f as string ) )
							headerJsize = ( readlong f #unsigned - 4 )
							fseek f headerJsize #seek_cur
							printDebug ( "Header K start = " + ( ftell f as string ) )
							headerKsize = ( readlong f #unsigned - 4 )
							fseek f headerKsize #seek_cur
							printDebug ( "Header L start = " + ( ftell f as string ) )
							headerLsize = ( readlong f #unsigned - 4 )
							fseek f headerLsize #seek_cur
							printDebug ( "Header M start = " + ( ftell f as string ) )
							headerMsize = ( readlong f #unsigned - 4 )
							fseek f headerMsize #seek_cur
							printDebug ( "Header N start = " + ( ftell f as string ) )
							headerNsize = ( readlong f #unsigned - 4 )
							fseek f headerNsize #seek_cur
							bytepad = readbyte f #unsigned
							bytepad2 = readbyte f #unsigned
							fseek f 0x0C #seek_cur
							UV1XMult = readfloat f
							UV1YMult = readfloat f
							UV3XMult = readfloat f
							UV3YMult = readfloat f
							UV2XMult = readfloat f
							UV2YMult = readfloat f
							printDebug ( "Header O start = " + ( ftell f as string ) )
							headerOsize = ( readlong f #unsigned - 4 )
							fseek f headerOsize #seek_cur
							printDebug ( "Header P start = " + ( ftell f as string ) )
							headerPsize = ( readlong f #unsigned - 4 )
							fseek f headerPsize #seek_cur
							bytepad = readbyte f #unsigned
							bytepad2 = readbyte f #unsigned
							unknown = readlong f #unsigned
							printDebug ( "Face info start = " + ( ftell f as string ) )
							facecount = readlong f #unsigned
							fseek f 0x08 #seek_cur
							for x = 1 to facecount / 3 do
							(
								fa = readshort f #unsigned + 1
								fb = readshort f #unsigned + 1
								fc = readshort f #unsigned + 1
								append Face_array [fa, fb, fc]
							)
							printDebug ( "Vertex Buffer start = " + ( ftell f as string ) )
							vertcount = readlong f #unsigned
							vertlength = readlong f #unsigned
							fseek f 0x0C #seek_cur
							vertheaderlength = readlong f #unsigned
							VertexOffset = readlong f #unsigned
							VertexAmt = readlong f #unsigned
							VertexFmt = readlong f #unsigned
							if VertexFmt > 0 do
							( printDebug ( "Vertex Offset = " + VertexOffset as string + ", Count = " + VertexAmt as string + ", Format = " + VertexFmt as string ) )
							UVOffset = readlong f #unsigned
							UVAmt = readlong f #unsigned
							UVFmt = readlong f #unsigned
							if UVFmt > 0 do
							( printDebug ( "UV Offset = " + UVOffset as string + ", Count = " + UVAmt as string + ", Format = " + UVFmt as string ) )
							NormalsOffset = readlong f #unsigned
							NormalsAmt = readlong f #unsigned
							NormalsFmt = readlong f #unsigned
							if NormalsFmt > 0 do
							( printDebug ( "Normals Offset = " + NormalsOffset as string + ", Count = " + NormalsAmt as string + ", Format = " + NormalsFmt as string ) )
							WeightsOffset = readlong f #unsigned
							WeightsAmt = readlong f #unsigned
							WeightsFmt = readlong f #unsigned
							if WeightsFmt > 0 do
							( printDebug ( "Weights Offset = " + WeightsOffset as string + ", Count = " + WeightsAmt as string + ", Format = " + WeightsFmt as string ) )
							BonesOffset = readlong f #unsigned
							BonesAmt = readlong f #unsigned
							BonesFmt = readlong f #unsigned
							if BonesFmt > 0 do
							( printDebug ( "Bones Offset = " + BonesOffset as string + ", Count = " + BonesAmt as string + ", Format = " + BonesFmt as string ) )
							Unknown1Offset = readlong f #unsigned
							Unknown1Amt = readlong f #unsigned
							Unknown1Fmt = readlong f #unsigned
							if Unknown1Fmt > 0 do
							( printDebug ( "Unknown1 Offset = " + Unknown1Offset as string + ", Count = " + Unknown1Amt as string + ", Format = " + Unknown1Fmt as string ) )
							ColorsOffset = readlong f #unsigned
							ColorsAmt = readlong f #unsigned
							ColorsFmt = readlong f #unsigned
							if ColorsFmt > 0 do
							( printDebug ( "Colors Offset = " + ColorsOffset as string + ", Count = " + ColorsAmt as string + ", Format = " + ColorsFmt as string ) )
							BinormalsOffset = readlong f #unsigned
							BinormalsAmt = readlong f #unsigned
							BinormalsFmt = readlong f #unsigned
							if BinormalsFmt > 0 do
							( printDebug ( "Binormals? Offset = " + BinormalsOffset as string + ", Count = " + BinormalsAmt as string + ", Format = " + BinormalsFmt as string ) )
							TangentsOffset = readlong f #unsigned
							TangentsAmt = readlong f #unsigned
							TangentsFmt = readlong f #unsigned
							if TangentsFmt > 0 do
							( printDebug ( "Tangents? Offset = " + TangentsOffset as string + ", Count = " + TangentsAmt as string + ", Format = " + TangentsFmt as string ) )
							UV2Offset = readlong f #unsigned
							UV2Amt = readlong f #unsigned
							UV2Fmt = readlong f #unsigned
							if UV2Fmt > 0 do
							( printDebug ( "UV2 Offset = " + UV2Offset as string + ", Count = " + UV2Amt as string + ", Format = " + UV2Fmt as string ) )
							UV3Offset = readlong f #unsigned
							UV3Amt = readlong f #unsigned
							UV3Fmt = readlong f #unsigned
							if UV3Fmt > 0 do
							( printDebug ( "UV3 Offset = " + UV3Offset as string + ", Count = " + UV3Amt as string + ", Format = " + UV3Fmt as string ) )
							UV4Offset = readlong f #unsigned
							UV4Amt = readlong f #unsigned
							UV4Fmt = readlong f #unsigned
							if UV4Fmt > 0 do
							(
								printDebug ( "UV4(?) Offset = " + UV4Offset as string + ", Count = " + UV4Amt as string + ", Format = " + UV4Fmt as string )
								break()
							)
							Unknown2Offset = readlong f #unsigned
							Unknown2Amt = readlong f #unsigned
							Unknown2Fmt = readlong f #unsigned
							if Unknown2Fmt > 0 do
							(
								printDebug ( "Unknown2 Offset = " + Unknown2Offset as string + ", Count = " + Unknown2Amt as string + ", Format = " + Unknown2Fmt as string )
								break()
							)
							printDebug ( "Vertex start = " + ( ftell f as string ) )
							for x = 1 to vertcount do
							(
								if VertexFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown positions format!" ) )
										( VertexFmt == 1 ):(
											vx = readfloat f * ModelScale
											vy = readfloat f * ModelScale
											vz = readfloat f * ModelScale
											append Vert_array [vx, vy, vz]
										)
									)
									
									
								)
								if UVFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV1 format!" ) )
										( UVFmt == 1 ):(
											tu = readfloat f
											tv = ( ( readfloat f ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
										( UVFmt == 4 ):(
											tu = ( ( readshort f as float / 32767 ) * UV1XMult )
											tv = ( ( ( readshort f as float / 32767 ) * UV1YMult ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
										( UVFmt == 5 ):(
											tu = ( ( readshort f as float / 65535 ) * UV1XMult )
											tv = ( ( ( readshort f as float / 65535 ) * UV1YMult ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
										( UVFmt == 11 ):(
											tu = ( readhalffloat f as float ) * 2
											tv = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
									)
									
									
								)
								if UV2Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV2 format!" ) )
										( UV2Fmt == 1 ):(
											tu2 = readfloat f
											tv2 = ( ( readfloat f ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
										( UV2Fmt == 4 ):(
											tu2 = ( ( readshort f as float / 32767 ) * UV2XMult )
											tv2 = ( ( ( readshort f as float / 32767 ) * UV2YMult ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
										( UV2Fmt == 5 ):(
											tu2 = ( ( readshort f as float / 65535 ) * UV2XMult )
											tv2 = ( ( ( readshort f as float / 65535 ) * UV2YMult ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
										( UV2Fmt == 11 ):(
											tu2 = ( readhalffloat f as float ) * 2
											tv2 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
									)
									
									
								)
								if UV3Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV3 format!" ) )
										( UV3Fmt == 1 ):(
											tu3 = readfloat f
											tv3 = ( ( readfloat f ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
										( UV3Fmt == 4 ):(
											tu3 = ( ( readshort f as float / 32767 ) * UV3XMult )
											tv3 = ( ( ( readshort f as float / 32767 ) * UV3YMult ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
										( UV3Fmt == 5 ):(
											tu3 = ( ( readshort f as float / 65535 ) * UV3XMult )
											tv3 = ( ( ( readshort f as float / 65535 ) * UV3YMult ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
										( UV3Fmt == 11 ):(
											tu3 = ( readhalffloat f as float ) * 2
											tv3 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
									)
									
									
								)
								if UV4Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV4 format!" ) )
										( UV4Fmt == 1 ):(
											tu4 = readfloat f
											tv4 = ( ( readfloat f ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
										( UV4Fmt == 4 ):(
											tu4 = ( ( readshort f as float / 32767 ) * UV4XMult )
											tv4 = ( ( ( readshort f as float / 32767 ) * UV4YMult ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
										( UV4Fmt == 5 ):(
											tu4 = ( ( readshort f as float / 65535 ) * UV4XMult )
											tv4 = ( ( ( readshort f as float / 65535 ) * UV4YMult ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
										( UV4Fmt == 11 ):(
											tu4 = ( readhalffloat f as float ) * 2
											tv4 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
									)
									
									
								)
								if BonesFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown bones format!" ) )
										( BonesFmt == 3 ):(
											Bone1 = readbyte f #unsigned / 4
											Bone2 = readbyte f #unsigned / 4
											Bone3 = readbyte f #unsigned / 4
											Bone4 = readbyte f #unsigned / 4
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
										( BonesFmt == 8 ):(
											Bone1 = readbyte f #unsigned / 3
											Bone2 = readbyte f #unsigned / 3
											Bone3 = readbyte f #unsigned / 3
											Bone4 = readbyte f #unsigned / 3
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
									)
									
									
								)
								if WeightsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown weights format!" ) )
										( WeightsFmt == 1 ):(
											Weight1 = readfloat f
											Weight2 = readfloat f
											Weight3 = readfloat f
											Weight4 = 0
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										( WeightsFmt == 4 ):(
											Weight1 = ( readshort f as float / 32767 )
											Weight2 = ( readshort f as float / 32767 )
											Weight3 = ( readshort f as float / 32767 )
											Weight4 = ( readshort f as float / 32767 )
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										( WeightsFmt == 5 ):(
											Weight1 = ( readshort f #unsigned as float / 65535 )
											Weight2 = ( readshort f #unsigned as float / 65535 )
											Weight3 = ( readshort f #unsigned as float / 65535 )
											Weight4 = ( readshort f #unsigned as float / 65535 )
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
									)
									
									
								)
								if ColorsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown colors format!" ) )
										( ColorsFmt == 1 ):(
											colorr = readfloat f * 255
											colorg = readfloat f * 255
											colorb = readfloat f * 255
											colora = readfloat f
											append Color_array [colorr, colorg, colorb]
											append Alpha_array colora
										)
										( ColorsFmt == 3 ):(
											colorr = readbyte f #unsigned
											colorg = readbyte f #unsigned
											colorb = readbyte f #unsigned
											colora = ( readbyte f #unsigned as float ) / 255
											append Color_array [colorr, colorg, colorb]
											append Alpha_array colora
										)
									)
									
									
								)
								if Unknown1Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown unknown format!" ) )
										( Unknown1Fmt == 1 ):( unknown1 = readfloat f )
									)
									
									
								)
								if NormalsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown normals format!" ) )
										( NormalsFmt == 2 ):(
											nx = readbyte f as float / 127
											ny = readbyte f as float / 127
											nz = readbyte f as float / 127
											nq = readbyte f as float / 127
											append Normal_array [nx, ny, nz]
										)
										( NormalsFmt == 4 ):(
											nx = readshort f as float / 32767
											ny = readshort f as float / 32767
											nz = readshort f as float / 32767
											nq = readshort f as float / 32767
											append Normal_array [nx, ny, nz]
										)
									)
									
									
								)
								if BinormalsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown binormals format!" ) )
										( BinormalsFmt == 2 ):(
											nx2 = readbyte f as float / 127
											ny2 = readbyte f as float / 127
											nz2 = readbyte f as float / 127
											nq2 = readbyte f as float / 127
										)
										( BinormalsFmt == 4 ):(
											nx2 = readshort f as float / 32767
											ny2 = readshort f as float / 32767
											nz2 = readshort f as float / 32767
											nq2 = readshort f as float / 32767
										)
									)
									
									
								)
								if TangentsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown tangents format!" ) )
										( TangentsFmt == 2 ):(
											nx3 = readbyte f as float / 127
											ny3 = readbyte f as float / 127
											nz3 = readbyte f as float / 127
											nq3 = readbyte f as float / 127
										)
										( TangentsFmt == 4 ):(
											nx3 = readshort f as float / 32767
											ny3 = readshort f as float / 32767
											nz3 = readshort f as float / 32767
											nq3 = readshort f as float / 32767
										)
									)
									
									
								)
							)
							printDebug ( "End of file = " + ( ftell f as string ) )
							printDebug ( PolyStruct_array )
							if B1_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append B1_array ( Bone_Info_Struct Bone1: 0 Bone2: 0 Bone3: 0 Bone4: 0 ) )
							)
							if W1_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append W1_array ( Weight_Info_Struct Weight1: 1 Weight2: 0 Weight3: 0 Weight4: 0 ) )
							)
							if Color_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								(
									append Color_array [255, 255, 255]
									append Alpha_array 1
								)
							)
							if UV_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append UV_array [0, 0, 0] )
							)
							for i = 1 to PolyStruct_array.count do
							(
								ProperBoneID_array = #()
								FixedBoneID_array = #()
								ActualB1_array = #()
								Weight_array = #()
								Weight_array2 = #()
								Face_array2 = #()
								Face_array3 = #()
								Vert_array2 = #()
								Normal_array2 = #()
								Color_array2 = #()
								Alpha_array2 = #()
								UV_array2 = #()
								UV2_array2 = #()
								UV3_array2 = #()
								UV4_array2 = #()
								if BoneCount != 0 and B1_array.count > 0 do
								(
									fseek f BoneIDOffset_array[1 * PolyStruct_array[i].BoneSetNum] #seek_set
									boneidtotal = readlong f #unsigned
									ProperBoneID_array = #()
									for y = 1 to boneidtotal do
									(
										BoneHash2 = readlong f #unsigned
										BoneHash1 = readlong f #unsigned
										nothing = readlong f #unsigned
										BoneName = ( "0x" + bit.intAsHex ( BoneHash1 ) as string )
										for z = 1 to BoneHash_array.count do
										(
											if BoneHash1 == BoneHash_array[z].BoneHash1 and BoneHash2 == BoneHash_array[z].BoneHash2 do
											( BoneName = BoneHash_array[z].BoneString )
										)
										append ProperBoneID_array BoneName
									)
									for a = 1 to boneidtotal do
									(
										for b = 1 to BoneCount do
										(
											if ProperBoneID_array[a] == BoneName_array[b] do
											( append FixedBoneID_array b )
										)
									)
									for x = 1 to B1_array.count do
									(
										ImproperBone1 = B1_array[x].Bone1
										ImproperBone2 = B1_array[x].Bone2
										ImproperBone3 = B1_array[x].Bone3
										ImproperBone4 = B1_array[x].Bone4
										ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
										ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
										ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
										ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
										if ProperBone1 == undefined do
										( ProperBone1 = 1 )
										if ProperBone2 == undefined do
										( ProperBone2 = 1 )
										if ProperBone3 == undefined do
										( ProperBone3 = 1 )
										if ProperBone4 == undefined do
										( ProperBone4 = 1 )
										append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
									)
									for b = 1 to W1_array.count Do
									(
										w = ( weight_data boneids: #() weights: #() )
										maxweight = 0
										if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
										if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
										if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
										if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
										if ( maxweight != 0 ) then
										(
											if ( W1_array[b].Weight1 != 0 ) then
											(
												w1 = W1_array[b].Weight1 as float
												append w.boneids ( ActualB1_array[b].Bone1 )
												append w.weights ( w1 )
											)
											if ( W1_array[b].Weight2 != 0 ) then
											(
												w2 = W1_array[b].Weight2 as float
												append w.boneids ( ActualB1_array[b].Bone2 )
												append w.weights ( w2 )
											)
											if ( W1_array[b].Weight3 != 0 ) then
											(
												w3 = W1_array[b].Weight3 as float
												append w.boneids ( ActualB1_array[b].Bone3 )
												append w.weights ( w3 )
											)
											if ( W1_array[b].Weight4 != 0 ) then
											(
												w4 = W1_array[b].Weight4 as float
												append w.boneids ( ActualB1_array[b].Bone4 )
												append w.weights ( w4 )
											)
										)
										append Weight_array w
									)
								)
								for y = PolyStruct_array[i].PolygonStart to ( PolyStruct_array[i].PolygonCount + PolyStruct_array[i].PolygonStart ) do
								( append Face_array2 Face_array[y] )
								VertexMin = PolyStruct_array[i].VertexMin
								VertexMax = PolyStruct_array[i].VertexMax
								for x = VertexMin to VertexMax do
								(
									append Vert_array2 Vert_array[x]
									append Normal_array2 Normal_array[x]
									append Color_array2 Color_array[x]
									append Alpha_array2 Alpha_array[x]
									append UV_array2 UV_array[x]
									if UV2_array.count > 0 do
									( append UV2_array2 UV2_array[x] )
									if UV3_array.count > 0 do
									( append UV3_array2 UV3_array[x] )
									if UV4_array.count > 0 do
									( append UV4_array2 UV4_array[x] )
									append Weight_array2 Weight_array[x]
								)
								for x = 1 to PolyStruct_array[i].PolygonCount do
								(
									Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
									append Face_array3 Faces3
								)
								local PolyMat = standardMaterial()
								PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
								PolyMat.showinviewport = true
								PolyMat.twosided = false
								if TexFormat == 1 then
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
								)
								else
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
								)
								tm.alphasource = 0
								PolyMat.diffuseMap = tm
								PolyMat.opacityMap = tm
								PolyMat.opacityMap.monoOutput = 1
								msh = mesh vertices: Vert_array2 faces: Face_array3
								msh.numTVerts = Vert_array2.count
								if VertColors == true then
								(
									setNumCPVVerts msh msh.numTVerts
									setCVertMode msh true
									setShadeCVerts msh true
								)
								defaultVCFaces msh
								buildTVFaces msh
								msh.name = ( h as string )
								msh.material = PolyMat
								if VertColors == true then
								(
									for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
									for j = 1 to Alpha_array2.count do
									( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
								)
								for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
								for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
								max modify mode
								select msh
								for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
								addmodifier msh ( Edit_Normals() ) ui: off
								msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
								EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
								EN_setNormal = msh.Edit_Normals.SetNormal
								normID = #{}
								for v = 1 to Normal_array2.count do
								(
									free normID
									EN_convertVS #{v} &normID
									for id in normID do EN_setNormal id Normal_array2[v]
								)
								if BoneCount != 0 and B1_array.count > 0 do
								(
									skinMod = skin()
									boneIDMap = #()
									addModifier msh skinMod
									for i = 1 to BoneCount do
									(
										maxbone = getnodebyname BoneSetup[i].name
										if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
									)
									local numSkinBones = skinOps.GetNumberBones skinMod
									for i = 1 to numSkinBones do
									(
										local boneName = skinOps.GetBoneName skinMod i 0
										for j = 1 to BoneCount do
										(
											if boneName == BoneSetup[j].Name then
											(
												boneIDMap[j] = i
												j = BoneCount + 1
											)
										)
									)
									modPanel.setCurrentObject skinMod
									for i = 1 to Vert_array2.count do
									(
										skinOps.SetVertexWeights skinMod i 1 1
										skinOps.unnormalizeVertex skinMod i true
										skinOps.SetVertexWeights skinMod i 1 0
									)
									skinOps.RemoveZeroWeights skinMod
									for i = 1 to Vert_array2.count do
									( skinOps.unnormalizeVertex skinMod i false )
									for i = 1 to Weight_array2.count do
									(
										w = Weight_array2[i]
										bi = #()
										wv = #()
										for j = 1 to w.boneids.count do
										(
											boneid = w.boneids[j]
											weight = w.weights[j]
											append bi boneIDMap[boneid]
											append wv weight
										)
										skinOps.ReplaceVertexWeights skinMod i bi wv
									)
								)
								if UVLayers == 1 do
								(
									if UV2_array2.count > 0 do
									(
										meshop.setNumMaps msh 3 keep: true
										for i = 1 to UV2_array2.count do
										( meshop.setMapVert msh 2 i UV2_array2[i] )
									)
									if UV3_array2.count > 0 do
									(
										meshop.setNumMaps msh 4 keep: true
										for i = 1 to UV3_array2.count do
										( meshop.setMapVert msh 3 i UV3_array2[i] )
									)
									if UV4_array2.count > 0 do
									(
										meshop.setNumMaps msh 5 keep: true
										for i = 1 to UV4_array2.count do
										( meshop.setMapVert msh 4 i UV4_array2[i] )
									)
								)
								if UVLayers == 2 do
								(
									if UV2_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 2" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV2_array2.count do setTVert msh j UV2_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
									if UV3_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 3" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV3_array2.count do setTVert msh j UV3_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
									if UV4_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 4" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV4_array2.count do setTVert msh j UV4_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
								)
							)
							fclose f
						)
						( VerNum == 5 ):(
							Face_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							UV2_array = #()
							UV3_array = #()
							UV4_array = #()
							B1_array = #()
							W1_array = #()
							Color_array = #()
							MatColor_array = #()
							Alpha_array = #()
							MatAlpha_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							TexName_array = #()
							NoRig = #()
							struct Polygon_Info_Struct
							(
								VertexMin,
								VertexMax,
								PolygonStart,
								PolygonCount,
								FacePointCount,
								MatNum,
								BoneSetNum,
								SingleBindNode
							)
							fseek f 0x07 #seek_cur
							printDebug ( "Model start = " + ( ftell f as string ) )
							boundingminx = readfloat f
							boundingminy = readfloat f
							boundingminz = readfloat f
							boundingmaxx = readfloat f
							boundingmaxy = readfloat f
							boundingmaxz = readfloat f
							headerlength = readlong f #unsigned - 4
							fseek f headerlength #seek_cur
							head3asubsize = readlong f #unsigned
							polytotal = readlong f #unsigned
							printDebug ( "Count = " + polytotal as string )
							for x = 1 to polytotal do
							(
								printDebug ( "Model info start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								BoneSetNum = ( readlong f #unsigned ) + 1
								SingleBindNode = readlong f #unsigned
								VertexMin = readlong f #unsigned + 1
								VertexMax = readlong f #unsigned + 1
								FacepointStart = readlong f #unsigned
								PolygonStart = ( FacepointStart / 3 ) + 1
								PolygonCount = readlong f #unsigned
								FacepointCount = PolygonCount * 3
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								headerlength = readlong f #unsigned
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readlong f #unsigned
								headerlength2 = readlong f #unsigned
								MatNum = readlong f #unsigned + 1
								fseek f ( headerlength2 - 0x08 ) #seek_cur
								fseek f 0xA8 #seek_cur
								colorr = ( readfloat f ) * 255
								colorg = ( readfloat f ) * 255
								colorb = ( readfloat f ) * 255
								colora = ( readfloat f ) * 255
								append MatColor_array [colorr, colorg, colorb]
								append MatAlpha_array colora
								append PolyStruct_array ( Polygon_Info_Struct VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum BoneSetNum: BoneSetNum SingleBindNode: SingleBindNode )
							)
							printDebug ( "Header B start = " + ( ftell f as string ) )
							headerBsize = ( readlong f #unsigned ) - 4
							fseek f headerBsize #seek_cur
							printDebug ( "Header C (Bone IDs) start = " + ( ftell f as string ) )
							IDHeaderLength = ( readlong f #unsigned - 4 )
							BoneIDSets = readlong f #unsigned
							printDebug ( "Count = " + BoneIDSets as string )
							for x = 1 to BoneIDSets do
							(
								append BoneIDOffset_Array ( ftell f )
								boneidtotal = readlong f #unsigned
								ProperBoneID_array = #()
								for y = 1 to boneidtotal do
								(
									properid1 = readlong f #unsigned
									properid2 = readlong f #unsigned
									nothing = readlong f #unsigned
								)
							)
							printDebug ( "Header D start = " + ( ftell f as string ) )
							headerDsize = ( readlong f #unsigned - 4 )
							fseek f headerDsize #seek_cur
							printDebug ( "Header E start = " + ( ftell f as string ) )
							headerEsize = ( readlong f #unsigned - 4 )
							fseek f headerEsize #seek_cur
							printDebug ( "Header F start = " + ( ftell f as string ) )
							fseek f 0x08 #seek_cur
							printDebug ( "Header G (Material Info) start = " + ( ftell f as string ) )
							MatGroupSize = ( readlong f #unsigned ) - 4 + ( ftell f )
							MatGroupCount = readlong f #unsigned
							for n = 1 to MatGroupCount do
							(
								materialsectionlength = readlong f #unsigned
								materialnamelength = ( readlong f #unsigned ) - 6
								materialname = ReadFixedString f materialnamelength
								append TexName_array materialname
								fseek f 0x06 #seek_cur
								somekindamaterialthing = readlong f #unsigned
								fseek f 0x18 #seek_cur
								somekindamaterialthing2 = readlong f #unsigned
								fseek f somekindamaterialthing2 #seek_cur
							)
							fseek f MatGroupSize #seek_set
							printDebug ( "Header H start = " + ( ftell f as string ) )
							fseek f 0x0C #seek_cur
							printDebug ( "Header I start = " + ( ftell f as string ) )
							UV1XMult = readfloat f
							UV1YMult = readfloat f
							UV4XMult = readfloat f
							UV4YMult = readfloat f
							UV2XMult = readfloat f
							UV2YMult = readfloat f
							UV3XMult = readfloat f
							UV3YMult = readfloat f
							printDebug ( "UV Multipliers = 1 (" + UV1XMult as string + ", " + UV1YMult as string + "), 2 (" + UV2XMult as string + ", " + UV2YMult as string + "), 3 (" + UV3XMult as string + ", " + UV3YMult as string + "), 4 (" + UV4XMult as string + ", " + UV4YMult as string + ")" )
							printDebug ( "Header J start = " + ( ftell f as string ) )
							headerJsize = ( readlong f #unsigned ) - 4
							fseek f headerJsize #seek_cur
							printDebug ( "Header K start = " + ( ftell f as string ) )
							headerKsize = ( readlong f #unsigned ) - 4
							fseek f headerKsize #seek_cur
							bytepad = readbyte f #unsigned
							bytepad2 = readbyte f #unsigned
							unknown = readlong f #unsigned
							printDebug ( "Face info start = " + ( ftell f as string ) )
							facecount = readlong f #unsigned
							fseek f 0x08 #seek_cur
							for x = 1 to facecount / 3 do
							(
								fa = readshort f #unsigned + 1
								fb = readshort f #unsigned + 1
								fc = readshort f #unsigned + 1
								append Face_array [fa, fb, fc]
							)
							printDebug ( "Vertex Buffer start = " + ( ftell f as string ) )
							vertcount = readlong f #unsigned
							vertlength = readlong f #unsigned
							fseek f 0x0C #seek_cur
							vertheaderlength = readlong f #unsigned
							VertexOffset = readlong f #unsigned
							VertexAmt = readlong f #unsigned
							VertexFmt = readlong f #unsigned
							if VertexFmt > 0 do
							( printDebug ( "Vertex Offset = " + VertexOffset as string + ", Count = " + VertexAmt as string + ", Format = " + VertexFmt as string ) )
							UVOffset = readlong f #unsigned
							UVAmt = readlong f #unsigned
							UVFmt = readlong f #unsigned
							if UVFmt > 0 do
							( printDebug ( "UV Offset = " + UVOffset as string + ", Count = " + UVAmt as string + ", Format = " + UVFmt as string ) )
							NormalsOffset = readlong f #unsigned
							NormalsAmt = readlong f #unsigned
							NormalsFmt = readlong f #unsigned
							if NormalsFmt > 0 do
							( printDebug ( "Normals Offset = " + NormalsOffset as string + ", Count = " + NormalsAmt as string + ", Format = " + NormalsFmt as string ) )
							WeightsOffset = readlong f #unsigned
							WeightsAmt = readlong f #unsigned
							WeightsFmt = readlong f #unsigned
							if WeightsFmt > 0 do
							( printDebug ( "Weights Offset = " + WeightsOffset as string + ", Count = " + WeightsAmt as string + ", Format = " + WeightsFmt as string ) )
							BonesOffset = readlong f #unsigned
							BonesAmt = readlong f #unsigned
							BonesFmt = readlong f #unsigned
							if BonesFmt > 0 do
							( printDebug ( "Bones Offset = " + BonesOffset as string + ", Count = " + BonesAmt as string + ", Format = " + BonesFmt as string ) )
							ColorsOffset = readlong f #unsigned
							ColorsAmt = readlong f #unsigned
							ColorsFmt = readlong f #unsigned
							if ColorsFmt > 0 do
							( printDebug ( "Colors Offset = " + ColorsOffset as string + ", Count = " + ColorsAmt as string + ", Format = " + ColorsFmt as string ) )
							Unknown1Offset = readlong f #unsigned
							Unknown1Amt = readlong f #unsigned
							Unknown1Fmt = readlong f #unsigned
							if Unknown1Fmt > 0 do
							(
								printDebug ( "Unknown1 Offset = " + Unknown1Offset as string + ", Count = " + Unknown1Amt as string + ", Format = " + Unknown1Fmt as string )
								break()
							)
							BinormalsOffset = readlong f #unsigned
							BinormalsAmt = readlong f #unsigned
							BinormalsFmt = readlong f #unsigned
							if BinormalsFmt > 0 do
							( printDebug ( "Binormals? Offset = " + BinormalsOffset as string + ", Count = " + BinormalsAmt as string + ", Format = " + BinormalsFmt as string ) )
							TangentsOffset = readlong f #unsigned
							TangentsAmt = readlong f #unsigned
							TangentsFmt = readlong f #unsigned
							if TangentsFmt > 0 do
							(
								printDebug ( "Tangents? Offset = " + TangentsOffset as string + ", Count = " + TangentsAmt as string + ", Format = " + TangentsFmt as string )
								break()
							)
							UV2Offset = readlong f #unsigned
							UV2Amt = readlong f #unsigned
							UV2Fmt = readlong f #unsigned
							if UV2Fmt > 0 do
							( printDebug ( "UV2 Offset = " + UV2Offset as string + ", Count = " + UV2Amt as string + ", Format = " + UV2Fmt as string ) )
							UV3Offset = readlong f #unsigned
							UV3Amt = readlong f #unsigned
							UV3Fmt = readlong f #unsigned
							if UV3Fmt > 0 do
							( printDebug ( "UV3 Offset = " + UV3Offset as string + ", Count = " + UV3Amt as string + ", Format = " + UV3Fmt as string ) )
							UV4Offset = readlong f #unsigned
							UV4Amt = readlong f #unsigned
							UV4Fmt = readlong f #unsigned
							if UV4Fmt > 0 do
							( printDebug ( "UV4(?) Offset = " + UV4Offset as string + ", Count = " + UV4Amt as string + ", Format = " + UV4Fmt as string ) )
							Unknown2Offset = readlong f #unsigned
							Unknown2Amt = readlong f #unsigned
							Unknown2Fmt = readlong f #unsigned
							if Unknown2Fmt > 0 do
							( throw ( "Something went wrong! Contact RTB!" ) )
							Unknown3Offset = readlong f #unsigned
							Unknown3Amt = readlong f #unsigned
							Unknown3Fmt = readlong f #unsigned
							if Unknown3Fmt > 0 do
							( throw ( "Something went wrong! Contact RTB!" ) )
							printDebug ( "Vertex start = " + ( ftell f as string ) )
							for x = 1 to vertcount do
							(
								if VertexFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown positions format!" ) )
										( VertexFmt == 1 ):(
											vx = readfloat f * ModelScale
											vy = readfloat f * ModelScale
											vz = readfloat f * ModelScale
											append Vert_array [vx, vy, vz]
										)
									)
									
									
								)
								if UVFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV1 format!" ) )
										( UVFmt == 1 ):(
											tu = readfloat f
											tv = ( ( readfloat f ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
										( UVFmt == 4 ):(
											tu = ( ( readshort f as float / 32767 ) * UV1XMult )
											tv = ( ( ( readshort f as float / 32767 ) * UV1YMult ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
										( UVFmt == 5 ):(
											tu = ( ( readshort f as float / 65535 ) * UV1XMult )
											tv = ( ( ( readshort f as float / 65535 ) * UV1YMult ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
										( UVFmt == 11 ):(
											tu = ( readhalffloat f as float ) * 2
											tv = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
									)
									
									
								)
								if UV2Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV2 format!" ) )
										( UV2Fmt == 1 ):(
											tu2 = readfloat f
											tv2 = ( ( readfloat f ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
										( UV2Fmt == 4 ):(
											tu2 = ( ( readshort f as float / 32767 ) * UV2XMult )
											tv2 = ( ( ( readshort f as float / 32767 ) * UV2YMult ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
										( UV2Fmt == 5 ):(
											tu2 = ( ( readshort f as float / 65535 ) * UV2XMult )
											tv2 = ( ( ( readshort f as float / 65535 ) * UV2YMult ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
										( UV2Fmt == 11 ):(
											tu2 = ( readhalffloat f as float ) * 2
											tv2 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
									)
									
									
								)
								if UV3Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV3 format!" ) )
										( UV3Fmt == 1 ):(
											tu3 = readfloat f
											tv3 = ( ( readfloat f ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
										( UV3Fmt == 4 ):(
											tu3 = ( ( readshort f as float / 32767 ) * UV3XMult )
											tv3 = ( ( ( readshort f as float / 32767 ) * UV3YMult ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
										( UV3Fmt == 5 ):(
											tu3 = ( ( readshort f as float / 65535 ) * UV3XMult )
											tv3 = ( ( ( readshort f as float / 65535 ) * UV3YMult ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
										( UV3Fmt == 11 ):(
											tu3 = ( readhalffloat f as float ) * 2
											tv3 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
									)
									
									
								)
								if UV4Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV4 format!" ) )
										( UV4Fmt == 1 ):(
											tu4 = readfloat f
											tv4 = ( ( readfloat f ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
										( UV4Fmt == 4 ):(
											tu4 = ( ( readshort f as float / 32767 ) * UV4XMult )
											tv4 = ( ( ( readshort f as float / 32767 ) * UV4YMult ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
										( UV4Fmt == 5 ):(
											tu4 = ( ( readshort f as float / 65535 ) * UV4XMult )
											tv4 = ( ( ( readshort f as float / 65535 ) * UV4YMult ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
										( UV4Fmt == 11 ):(
											tu4 = ( readhalffloat f as float ) * 2
											tv4 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
									)
									
									
								)
								if BonesFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown bones format!" ) )
										( BonesFmt == 3 ):(
											Bone1 = readbyte f #unsigned / 4
											Bone2 = readbyte f #unsigned / 4
											Bone3 = readbyte f #unsigned / 4
											Bone4 = readbyte f #unsigned / 4
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
										( BonesFmt == 8 ):(
											Bone1 = readbyte f #unsigned / 3
											Bone2 = readbyte f #unsigned / 3
											Bone3 = readbyte f #unsigned / 3
											Bone4 = readbyte f #unsigned / 3
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
									)
									
									
								)
								if WeightsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown weights format!" ) )
										( WeightsFmt == 1 ):(
											Weight1 = readfloat f
											Weight2 = readfloat f
											Weight3 = readfloat f
											Weight4 = 0
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										( WeightsFmt == 4 ):(
											Weight1 = ( readshort f as float / 32767 )
											Weight2 = ( readshort f as float / 32767 )
											Weight3 = ( readshort f as float / 32767 )
											Weight4 = ( readshort f as float / 32767 )
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										( WeightsFmt == 5 ):(
											Weight1 = ( readshort f #unsigned as float / 65535 )
											Weight2 = ( readshort f #unsigned as float / 65535 )
											Weight3 = ( readshort f #unsigned as float / 65535 )
											Weight4 = ( readshort f #unsigned as float / 65535 )
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
									)
									
									
								)
								if ColorsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown colors format!" ) )
										( ColorsFmt == 1 ):(
											colorr = readfloat f * 255
											colorg = readfloat f * 255
											colorb = readfloat f * 255
											colora = readfloat f
											append Color_array [colorr, colorg, colorb]
											append Alpha_array colora
										)
										( ColorsFmt == 3 ):(
											colorr = readbyte f #unsigned
											colorg = readbyte f #unsigned
											colorb = readbyte f #unsigned
											colora = ( readbyte f #unsigned as float ) / 255
											append Color_array [colorr, colorg, colorb]
											append Alpha_array colora
										)
									)
									
									
								)
								if Unknown1Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown unknown format!" ) )
										( Unknown1Fmt == 1 ):( unknown1 = readfloat f )
									)
									
									
								)
								if NormalsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown normals format!" ) )
										( NormalsFmt == 2 ):(
											nx = readbyte f as float / 127
											ny = readbyte f as float / 127
											nz = readbyte f as float / 127
											nq = readbyte f as float / 127
											append Normal_array [nx, ny, nz]
										)
										( NormalsFmt == 4 ):(
											nx = readshort f as float / 32767
											ny = readshort f as float / 32767
											nz = readshort f as float / 32767
											nq = readshort f as float / 32767
											append Normal_array [nx, ny, nz]
										)
									)
									
									
								)
								if BinormalsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown binormals format!" ) )
										( BinormalsFmt == 2 ):(
											nx2 = readbyte f as float / 127
											ny2 = readbyte f as float / 127
											nz2 = readbyte f as float / 127
											nq2 = readbyte f as float / 127
										)
										( BinormalsFmt == 4 ):(
											nx2 = readshort f as float / 32767
											ny2 = readshort f as float / 32767
											nz2 = readshort f as float / 32767
											nq2 = readshort f as float / 32767
										)
									)
									
									
								)
								if TangentsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown tangents format!" ) )
										( TangentsFmt == 2 ):(
											nx3 = readbyte f as float / 127
											ny3 = readbyte f as float / 127
											nz3 = readbyte f as float / 127
											nq3 = readbyte f as float / 127
										)
										( TangentsFmt == 4 ):(
											nx3 = readshort f as float / 32767
											ny3 = readshort f as float / 32767
											nz3 = readshort f as float / 32767
											nq3 = readshort f as float / 32767
										)
									)
									
									
								)
							)
							printDebug ( "End of file = " + ( ftell f as string ) )
							printDebug ( PolyStruct_array )
							if B1_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								(
									append B1_array ( Bone_Info_Struct Bone1: 0 Bone2: 0 Bone3: 0 Bone4: 0 )
									NoRig = 1
								)
							)
							if W1_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append W1_array ( Weight_Info_Struct Weight1: 1 Weight2: 0 Weight3: 0 Weight4: 0 ) )
							)
							if Color_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								(
									append Color_array [255, 255, 255]
									append Alpha_array 1
								)
							)
							if UV_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append UV_array [0, 0, 0] )
							)
							for i = 1 to PolyStruct_array.count do
							(
								ProperBoneID_array = #()
								FixedBoneID_array = #()
								ActualB1_array = #()
								Weight_array = #()
								Weight_array2 = #()
								Face_array2 = #()
								Face_array3 = #()
								Vert_array2 = #()
								Normal_array2 = #()
								Color_array2 = #()
								Alpha_array2 = #()
								UV_array2 = #()
								UV2_array2 = #()
								UV3_array2 = #()
								UV4_array2 = #()
								if BoneCount != 0 and B1_array.count > 0 do
								(
									fseek f BoneIDOffset_array[1 * PolyStruct_array[i].BoneSetNum] #seek_set
									boneidtotal = readlong f #unsigned
									ProperBoneID_array = #()
									for y = 1 to boneidtotal do
									(
										BoneHash2 = readlong f #unsigned
										BoneHash1 = readlong f #unsigned
										nothing = readlong f #unsigned
										BoneName = ( "0x" + bit.intAsHex ( BoneHash1 ) as string )
										for z = 1 to BoneHash_array.count do
										(
											if BoneHash1 == BoneHash_array[z].BoneHash1 and BoneHash2 == BoneHash_array[z].BoneHash2 do
											( BoneName = BoneHash_array[z].BoneString )
										)
										append ProperBoneID_array BoneName
									)
									for a = 1 to boneidtotal do
									(
										for b = 1 to BoneCount do
										(
											if ProperBoneID_array[a] == BoneName_array[b] do
											( append FixedBoneID_array b )
										)
									)
									for x = 1 to B1_array.count do
									(
										ImproperBone1 = B1_array[x].Bone1
										ImproperBone2 = B1_array[x].Bone2
										ImproperBone3 = B1_array[x].Bone3
										ImproperBone4 = B1_array[x].Bone4
										ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
										ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
										ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
										ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
										if ProperBone1 == undefined do
										( ProperBone1 = 1 )
										if ProperBone2 == undefined do
										( ProperBone2 = 1 )
										if ProperBone3 == undefined do
										( ProperBone3 = 1 )
										if ProperBone4 == undefined do
										( ProperBone4 = 1 )
										append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
									)
									for b = 1 to W1_array.count Do
									(
										w = ( weight_data boneids: #() weights: #() )
										maxweight = 0
										if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
										if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
										if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
										if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
										if ( maxweight != 0 ) then
										(
											if ( W1_array[b].Weight1 != 0 ) then
											(
												w1 = W1_array[b].Weight1 as float
												append w.boneids ( ActualB1_array[b].Bone1 )
												append w.weights ( w1 )
											)
											if ( W1_array[b].Weight2 != 0 ) then
											(
												w2 = W1_array[b].Weight2 as float
												append w.boneids ( ActualB1_array[b].Bone2 )
												append w.weights ( w2 )
											)
											if ( W1_array[b].Weight3 != 0 ) then
											(
												w3 = W1_array[b].Weight3 as float
												append w.boneids ( ActualB1_array[b].Bone3 )
												append w.weights ( w3 )
											)
											if ( W1_array[b].Weight4 != 0 ) then
											(
												w4 = W1_array[b].Weight4 as float
												append w.boneids ( ActualB1_array[b].Bone4 )
												append w.weights ( w4 )
											)
										)
										append Weight_array w
									)
								)
								for y = PolyStruct_array[i].PolygonStart to ( PolyStruct_array[i].PolygonCount + PolyStruct_array[i].PolygonStart ) do
								( append Face_array2 Face_array[y] )
								VertexMin = PolyStruct_array[i].VertexMin
								VertexMax = PolyStruct_array[i].VertexMax
								for x = VertexMin to VertexMax do
								(
									append Vert_array2 Vert_array[x]
									append Normal_array2 Normal_array[x]
									append Color_array2 Color_array[x]
									append Alpha_array2 Alpha_array[x]
									append UV_array2 UV_array[x]
									if UV2_array.count > 0 do
									( append UV2_array2 UV2_array[x] )
									if UV3_array.count > 0 do
									( append UV3_array2 UV3_array[x] )
									if UV4_array.count > 0 do
									( append UV4_array2 UV4_array[x] )
									append Weight_array2 Weight_array[x]
								)
								for x = 1 to PolyStruct_array[i].PolygonCount do
								(
									Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
									append Face_array3 Faces3
								)
								local PolyMat = standardMaterial()
								PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
								PolyMat.showinviewport = true
								PolyMat.twosided = false
								if TexFormat == 1 then
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
								)
								else
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
								)
								tm.alphasource = 0
								PolyMat.diffuseMap = tm
								PolyMat.opacityMap = tm
								PolyMat.opacityMap.monoOutput = 1
								msh = mesh vertices: Vert_array2 faces: Face_array3
								msh.numTVerts = Vert_array2.count
								if VertColors == true then
								(
									setNumCPVVerts msh msh.numTVerts
									setCVertMode msh true
									setShadeCVerts msh true
								)
								defaultVCFaces msh
								buildTVFaces msh
								msh.name = ( h as string )
								msh.material = PolyMat
								if VertColors == true then
								(
									for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
									for j = 1 to Alpha_array2.count do
									( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
								)
								for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
								for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
								max modify mode
								select msh
								for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
								addmodifier msh ( Edit_Normals() ) ui: off
								msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
								EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
								EN_setNormal = msh.Edit_Normals.SetNormal
								normID = #{}
								for v = 1 to Normal_array2.count do
								(
									free normID
									EN_convertVS #{v} &normID
									for id in normID do EN_setNormal id Normal_array2[v]
								)
								if BoneCount != 0 and B1_array.count > 0 do
								(
									skinMod = skin()
									boneIDMap = #()
									addModifier msh skinMod
									for i = 1 to BoneCount do
									(
										maxbone = getnodebyname BoneSetup[i].name
										if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
									)
									local numSkinBones = skinOps.GetNumberBones skinMod
									for i = 1 to numSkinBones do
									(
										local boneName = skinOps.GetBoneName skinMod i 0
										for j = 1 to BoneCount do
										(
											if boneName == BoneSetup[j].Name then
											(
												boneIDMap[j] = i
												j = BoneCount + 1
											)
										)
									)
									modPanel.setCurrentObject skinMod
									for i = 1 to Vert_array2.count do
									(
										skinOps.SetVertexWeights skinMod i 1 1
										skinOps.unnormalizeVertex skinMod i true
										skinOps.SetVertexWeights skinMod i 1 0
									)
									skinOps.RemoveZeroWeights skinMod
									for i = 1 to Vert_array2.count do
									( skinOps.unnormalizeVertex skinMod i false )
									for i = 1 to Weight_array2.count do
									(
										w = Weight_array2[i]
										bi = #()
										wv = #()
										for j = 1 to w.boneids.count do
										(
											boneid = w.boneids[j]
											weight = w.weights[j]
											append bi boneIDMap[boneid]
											append wv weight
										)
										skinOps.ReplaceVertexWeights skinMod i bi wv
									)
								)
								if UVLayers == 1 do
								(
									if UV2_array2.count > 0 do
									(
										meshop.setNumMaps msh 3 keep: true
										for i = 1 to UV2_array2.count do
										( meshop.setMapVert msh 2 i UV2_array2[i] )
									)
									if UV3_array2.count > 0 do
									(
										meshop.setNumMaps msh 4 keep: true
										for i = 1 to UV3_array2.count do
										( meshop.setMapVert msh 3 i UV3_array2[i] )
									)
									if UV4_array2.count > 0 do
									(
										meshop.setNumMaps msh 5 keep: true
										for i = 1 to UV4_array2.count do
										( meshop.setMapVert msh 4 i UV4_array2[i] )
									)
								)
								if UVLayers == 2 do
								(
									if UV2_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 2" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV2_array2.count do setTVert msh j UV2_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
									if UV3_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 3" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV3_array2.count do setTVert msh j UV3_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
									if UV4_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 4" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV4_array2.count do setTVert msh j UV4_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
								)
							)
							fclose f
						)
						( VerNum == 12 ):(
							Face_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							UV2_array = #()
							UV3_array = #()
							UV4_array = #()
							B1_array = #()
							W1_array = #()
							Color_array = #()
							MatColor_array = #()
							Alpha_array = #()
							MatAlpha_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							TexName_array = #()
							struct Polygon_Info_Struct
							(
								VertexMin,
								VertexMax,
								PolygonStart,
								PolygonCount,
								FacePointCount,
								MatNum,
								BoneSetNum
							)
							fseek f 0x07 #seek_cur
							printDebug ( "Model start = " + ( ftell f as string ) )
							boundingminx = readfloat f
							boundingminy = readfloat f
							boundingminz = readfloat f
							boundingmaxx = readfloat f
							boundingmaxy = readfloat f
							boundingmaxz = readfloat f
							headerlength = readlong f #unsigned - 4
							fseek f headerlength #seek_cur
							head3asubsize = readlong f #unsigned
							polytotal = readlong f #unsigned
							printDebug ( "Count = " + polytotal as string )
							for x = 1 to polytotal do
							(
								printDebug ( "Model info start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								BoneSetNum = ( readlong f #unsigned ) + 1
								unknown2 = readlong f #unsigned
								unknown3 = readlong f #unsigned
								VertexMin = readlong f #unsigned + 1
								VertexMax = readlong f #unsigned + 1
								FacepointStart = readlong f #unsigned
								PolygonStart = ( FacepointStart / 3 ) + 1
								PolygonCount = readlong f #unsigned
								FacepointCount = PolygonCount * 3
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								headerlength = readlong f #unsigned
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readlong f #unsigned
								headerlength2 = readlong f #unsigned
								MatNum = readlong f #unsigned + 1
								fseek f ( headerlength2 - 0x08 ) #seek_cur
								fseek f 0x94 #seek_cur
								colorr = ( readfloat f ) * 255
								colorg = ( readfloat f ) * 255
								colorb = ( readfloat f ) * 255
								colora = readfloat f
								append MatColor_array [colorr, colorg, colorb]
								append MatAlpha_array colora
								append PolyStruct_array ( Polygon_Info_Struct VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum BoneSetNum: BoneSetNum )
							)
							printDebug ( "Header B start = " + ( ftell f as string ) )
							headerBsize = ( readlong f #unsigned ) - 4
							fseek f headerBsize #seek_cur
							printDebug ( "Header C (Bone IDs) start = " + ( ftell f as string ) )
							IDHeaderLength = ( readlong f #unsigned - 4 )
							BoneIDSets = readlong f #unsigned
							printDebug ( "Count = " + BoneIDSets as string )
							for b = 1 to BoneIDSets do
							(
								append BoneIDOffset_Array ( ftell f )
								boneidtotal = readlong f #unsigned
								ProperBoneID_array = #()
								for y = 1 to boneidtotal do
								(
									properid1 = readlong f #unsigned
									properid2 = readlong f #unsigned
									unknown = readlong f #unsigned
									float = readfloat f
									float = readfloat f
									float = readfloat f
									float = readfloat f
									float = readfloat f
									float = readfloat f
									length = readlong f #unsigned
									float = readfloat f
									float = readfloat f
									float = readfloat f
									float = readfloat f
									boneid1 = readbyte f #unsigned
									boneid2 = readbyte f #unsigned
									boneid3 = readbyte f #unsigned
									boneid4 = readbyte f #unsigned
								)
							)
							printDebug ( "Header D start = " + ( ftell f as string ) )
							headerDsize = ( readlong f #unsigned - 4 )
							fseek f headerDsize #seek_cur
							printDebug ( "Header E start = " + ( ftell f as string ) )
							headerEsize = ( readlong f #unsigned - 4 )
							fseek f headerEsize #seek_cur
							printDebug ( "Header F start = " + ( ftell f as string ) )
							headerFsize = ( readlong f #unsigned ) - 4
							fseek f headerFsize #seek_cur
							printDebug ( "Header G start = " + ( ftell f as string ) )
							fseek f 0x08 #seek_cur
							printDebug ( "Header H (Material Info) start = " + ( ftell f as string ) )
							MatGroupSize = ( readlong f #unsigned ) - 4 + ( ftell f )
							MatGroupCount = readlong f #unsigned
							for x = 1 to MatGroupCount do
							(
								materialsectionlength = readlong f #unsigned
								materialnamelength = ( readlong f #unsigned ) - 6
								materialname = ReadFixedString f materialnamelength
								append TexName_array materialname
								fseek f 0x06 #seek_cur
								somekindamaterialthing = readlong f #unsigned
								fseek f 0x18 #seek_cur
								somekindamaterialthing2 = readlong f #unsigned
								fseek f somekindamaterialthing2 #seek_cur
							)
							fseek f MatGroupSize #seek_set
							printDebug ( "Header I start = " + ( ftell f as string ) )
							UV1XMult = readfloat f
							UV1YMult = readfloat f
							UV4XMult = readfloat f
							UV4YMult = readfloat f
							UV2XMult = readfloat f
							UV2YMult = readfloat f
							UV3XMult = readfloat f
							UV3YMult = readfloat f
							printDebug ( "UV Multipliers = 1 (" + UV1XMult as string + ", " + UV1YMult as string + "), 2 (" + UV2XMult as string + ", " + UV2YMult as string + "), 3 (" + UV3XMult as string + ", " + UV3YMult as string + "), 4 (" + UV4XMult as string + ", " + UV4YMult as string + ")" )
							printDebug ( "Header J start = " + ( ftell f as string ) )
							headerJsize = ( readlong f #unsigned ) - 4
							fseek f headerJsize #seek_cur
							printDebug ( "Header K start = " + ( ftell f as string ) )
							headerKsize = ( readlong f #unsigned ) - 4
							fseek f headerKsize #seek_cur
							bytepad = readbyte f #unsigned
							unknown = readlong f #unsigned
							printDebug ( "Face info start = " + ( ftell f as string ) )
							facecount = readlong f #unsigned
							fseek f 0x08 #seek_cur
							for x = 1 to facecount / 3 do
							(
								fa = readshort f #unsigned + 1
								fb = readshort f #unsigned + 1
								fc = readshort f #unsigned + 1
								append Face_array [fa, fb, fc]
							)
							printDebug ( "Vertex Buffer start = " + ( ftell f as string ) )
							vertcount = readlong f #unsigned
							vertlength = readlong f #unsigned
							fseek f 0x0C #seek_cur
							vertheaderlength = readlong f #unsigned
							VertexOffset = readlong f #unsigned
							VertexAmt = readlong f #unsigned
							VertexFmt = readlong f #unsigned
							if VertexFmt > 0 do
							( printDebug ( "Vertex Offset = " + VertexOffset as string + ", Count = " + VertexAmt as string + ", Format = " + VertexFmt as string ) )
							UVOffset = readlong f #unsigned
							UVAmt = readlong f #unsigned
							UVFmt = readlong f #unsigned
							if UVFmt > 0 do
							( printDebug ( "UV Offset = " + UVOffset as string + ", Count = " + UVAmt as string + ", Format = " + UVFmt as string ) )
							NormalsOffset = readlong f #unsigned
							NormalsAmt = readlong f #unsigned
							NormalsFmt = readlong f #unsigned
							if NormalsFmt > 0 do
							( printDebug ( "Normals Offset = " + NormalsOffset as string + ", Count = " + NormalsAmt as string + ", Format = " + NormalsFmt as string ) )
							WeightsOffset = readlong f #unsigned
							WeightsAmt = readlong f #unsigned
							WeightsFmt = readlong f #unsigned
							if WeightsFmt > 0 do
							( printDebug ( "Weights Offset = " + WeightsOffset as string + ", Count = " + WeightsAmt as string + ", Format = " + WeightsFmt as string ) )
							BonesOffset = readlong f #unsigned
							BonesAmt = readlong f #unsigned
							BonesFmt = readlong f #unsigned
							if BonesFmt > 0 do
							( printDebug ( "Bones Offset = " + BonesOffset as string + ", Count = " + BonesAmt as string + ", Format = " + BonesFmt as string ) )
							ColorsOffset = readlong f #unsigned
							ColorsAmt = readlong f #unsigned
							ColorsFmt = readlong f #unsigned
							if ColorsFmt > 0 do
							( printDebug ( "Colors Offset = " + ColorsOffset as string + ", Count = " + ColorsAmt as string + ", Format = " + ColorsFmt as string ) )
							Unknown1Offset = readlong f #unsigned
							Unknown1Amt = readlong f #unsigned
							Unknown1Fmt = readlong f #unsigned
							if Unknown1Fmt > 0 do
							( printDebug ( "Unknown1 Offset = " + Unknown1Offset as string + ", Count = " + Unknown1Amt as string + ", Format = " + Unknown1Fmt as string ) )
							BinormalsOffset = readlong f #unsigned
							BinormalsAmt = readlong f #unsigned
							BinormalsFmt = readlong f #unsigned
							if BinormalsFmt > 0 do
							( printDebug ( "Binormals? Offset = " + BinormalsOffset as string + ", Count = " + BinormalsAmt as string + ", Format = " + BinormalsFmt as string ) )
							TangentsOffset = readlong f #unsigned
							TangentsAmt = readlong f #unsigned
							TangentsFmt = readlong f #unsigned
							if TangentsFmt > 0 do
							( printDebug ( "Tangents? Offset = " + TangentsOffset as string + ", Count = " + TangentsAmt as string + ", Format = " + TangentsFmt as string ) )
							UV2Offset = readlong f #unsigned
							UV2Amt = readlong f #unsigned
							UV2Fmt = readlong f #unsigned
							if UV2Fmt > 0 do
							( printDebug ( "UV2 Offset = " + UV2Offset as string + ", Count = " + UV2Amt as string + ", Format = " + UV2Fmt as string ) )
							UV3Offset = readlong f #unsigned
							UV3Amt = readlong f #unsigned
							UV3Fmt = readlong f #unsigned
							if UV3Fmt > 0 do
							( printDebug ( "UV3 Offset = " + UV3Offset as string + ", Count = " + UV3Amt as string + ", Format = " + UV3Fmt as string ) )
							UV4Offset = readlong f #unsigned
							UV4Amt = readlong f #unsigned
							UV4Fmt = readlong f #unsigned
							if UV4Fmt > 0 do
							( printDebug ( "UV4(?) Offset = " + UV4Offset as string + ", Count = " + UV4Amt as string + ", Format = " + UV4Fmt as string ) )
							printDebug ( "Vertex start = " + ( ftell f as string ) )
							for x = 1 to vertcount do
							(
								if VertexFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown positions format!" ) )
										( VertexFmt == 1 ):(
											vx = readfloat f * ModelScale
											vy = readfloat f * ModelScale
											vz = readfloat f * ModelScale
											append Vert_array [vx, vy, vz]
										)
									)
									
									
								)
								if UVFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV1 format!" ) )
										( UVFmt == 1 ):(
											tu = readfloat f
											tv = ( ( readfloat f ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
										( UVFmt == 4 ):(
											tu = ( ( readshort f as float / 32767 ) * UV1XMult )
											tv = ( ( ( readshort f as float / 32767 ) * UV1YMult ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
										( UVFmt == 5 ):(
											tu = ( ( readshort f as float / 65535 ) * UV1XMult )
											tv = ( ( ( readshort f as float / 65535 ) * UV1YMult ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
										( UVFmt == 11 ):(
											tu = ( readhalffloat f as float ) * 2
											tv = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
									)
									
									
								)
								if UV2Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV2 format!" ) )
										( UV2Fmt == 1 ):(
											tu2 = readfloat f
											tv2 = ( ( readfloat f ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
										( UV2Fmt == 4 ):(
											tu2 = ( ( readshort f as float / 32767 ) * UV2XMult )
											tv2 = ( ( ( readshort f as float / 32767 ) * UV2YMult ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
										( UV2Fmt == 5 ):(
											tu2 = ( ( readshort f as float / 65535 ) * UV2XMult )
											tv2 = ( ( ( readshort f as float / 65535 ) * UV2YMult ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
										( UV2Fmt == 11 ):(
											tu2 = ( readhalffloat f as float ) * 2
											tv2 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
									)
									
									
								)
								if UV3Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV3 format!" ) )
										( UV3Fmt == 1 ):(
											tu3 = readfloat f
											tv3 = ( ( readfloat f ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
										( UV3Fmt == 4 ):(
											tu3 = ( ( readshort f as float / 32767 ) * UV3XMult )
											tv3 = ( ( ( readshort f as float / 32767 ) * UV3YMult ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
										( UV3Fmt == 5 ):(
											tu3 = ( ( readshort f as float / 65535 ) * UV3XMult )
											tv3 = ( ( ( readshort f as float / 65535 ) * UV3YMult ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
										( UV3Fmt == 11 ):(
											tu3 = ( readhalffloat f as float ) * 2
											tv3 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
									)
									
									
								)
								if UV4Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV4 format!" ) )
										( UV4Fmt == 1 ):(
											tu4 = readfloat f
											tv4 = ( ( readfloat f ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
										( UV4Fmt == 4 ):(
											tu4 = ( ( readshort f as float / 32767 ) * UV4XMult )
											tv4 = ( ( ( readshort f as float / 32767 ) * UV4YMult ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
										( UV4Fmt == 5 ):(
											tu4 = ( ( readshort f as float / 65535 ) * UV4XMult )
											tv4 = ( ( ( readshort f as float / 65535 ) * UV4YMult ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
										( UV4Fmt == 11 ):(
											tu4 = ( readhalffloat f as float ) * 2
											tv4 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
									)
									
									
								)
								if BonesFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown bones format!" ) )
										( BonesFmt == 3 ):(
											Bone1 = readbyte f #unsigned / 4
											Bone2 = readbyte f #unsigned / 4
											Bone3 = readbyte f #unsigned / 4
											Bone4 = readbyte f #unsigned / 4
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
										( BonesFmt == 8 ):(
											Bone1 = readbyte f #unsigned / 3
											Bone2 = readbyte f #unsigned / 3
											Bone3 = readbyte f #unsigned / 3
											Bone4 = readbyte f #unsigned / 3
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
									)
									
									
								)
								if WeightsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown weights format!" ) )
										( WeightsFmt == 1 ):(
											Weight1 = readfloat f
											Weight2 = readfloat f
											Weight3 = readfloat f
											Weight4 = 0
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										( WeightsFmt == 4 ):(
											Weight1 = ( readshort f as float / 32767 )
											Weight2 = ( readshort f as float / 32767 )
											Weight3 = ( readshort f as float / 32767 )
											Weight4 = ( readshort f as float / 32767 )
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										( WeightsFmt == 5 ):(
											Weight1 = ( readshort f #unsigned as float / 65535 )
											Weight2 = ( readshort f #unsigned as float / 65535 )
											Weight3 = ( readshort f #unsigned as float / 65535 )
											Weight4 = ( readshort f #unsigned as float / 65535 )
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
									)
									
									
								)
								if ColorsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown colors format!" ) )
										( ColorsFmt == 1 ):(
											colorr = readfloat f * 255
											colorg = readfloat f * 255
											colorb = readfloat f * 255
											colora = readfloat f
											append Color_array [colorr, colorg, colorb]
											append Alpha_array colora
										)
										( ColorsFmt == 3 ):(
											colorr = readbyte f #unsigned
											colorg = readbyte f #unsigned
											colorb = readbyte f #unsigned
											colora = ( readbyte f #unsigned as float ) / 255
											append Color_array [colorr, colorg, colorb]
											append Alpha_array colora
										)
									)
									
									
								)
								if Unknown1Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown unknown format!" ) )
										( Unknown1Fmt == 1 ):( unknown1 = readfloat f )
									)
									
									
								)
								if NormalsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown normals format!" ) )
										( NormalsFmt == 2 ):(
											nx = readbyte f as float / 127
											ny = readbyte f as float / 127
											nz = readbyte f as float / 127
											nq = readbyte f as float / 127
											append Normal_array [nx, ny, nz]
										)
										( NormalsFmt == 4 ):(
											nx = readshort f as float / 32767
											ny = readshort f as float / 32767
											nz = readshort f as float / 32767
											nq = readshort f as float / 32767
											append Normal_array [nx, ny, nz]
										)
									)
									
									
								)
								if BinormalsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown binormals format!" ) )
										( BinormalsFmt == 2 ):(
											nx2 = readbyte f as float / 127
											ny2 = readbyte f as float / 127
											nz2 = readbyte f as float / 127
											nq2 = readbyte f as float / 127
										)
										( BinormalsFmt == 4 ):(
											nx2 = readshort f as float / 32767
											ny2 = readshort f as float / 32767
											nz2 = readshort f as float / 32767
											nq2 = readshort f as float / 32767
										)
									)
									
									
								)
								if TangentsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown tangents format!" ) )
										( TangentsFmt == 2 ):(
											nx3 = readbyte f as float / 127
											ny3 = readbyte f as float / 127
											nz3 = readbyte f as float / 127
											nq3 = readbyte f as float / 127
										)
										( TangentsFmt == 4 ):(
											nx3 = readshort f as float / 32767
											ny3 = readshort f as float / 32767
											nz3 = readshort f as float / 32767
											nq3 = readshort f as float / 32767
										)
									)
									
									
								)
							)
							printDebug ( "End of file = " + ( ftell f as string ) )
							printDebug ( PolyStruct_array )
							if B1_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append B1_array ( Bone_Info_Struct Bone1: 0 Bone2: 0 Bone3: 0 Bone4: 0 ) )
							)
							if W1_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append W1_array ( Weight_Info_Struct Weight1: 1 Weight2: 0 Weight3: 0 Weight4: 0 ) )
							)
							if Color_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								(
									append Color_array [255, 255, 255]
									append Alpha_array 1
								)
							)
							if UV_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append UV_array [0, 0, 0] )
							)
							for i = 1 to PolyStruct_array.count do
							(
								ProperBoneID_array = #()
								FixedBoneID_array = #()
								ActualB1_array = #()
								Weight_array = #()
								Weight_array2 = #()
								Face_array2 = #()
								Face_array3 = #()
								Vert_array2 = #()
								Normal_array2 = #()
								Color_array2 = #()
								Alpha_array2 = #()
								UV_array2 = #()
								UV2_array2 = #()
								UV3_array2 = #()
								UV4_array2 = #()
								if BoneCount != 0 and B1_array.count > 0 do
								(
									fseek f BoneIDOffset_array[1 * PolyStruct_array[i].BoneSetNum] #seek_set
									boneidtotal = readlong f #unsigned
									ProperBoneID_array = #()
									for y = 1 to boneidtotal do
									(
										BoneHash2 = readlong f #unsigned
										BoneHash1 = readlong f #unsigned
										nothing = readlong f #unsigned
										unkfloat1 = readfloat f
										unkfloat2 = readfloat f
										unkfloat3 = readfloat f
										unkfloat4 = readfloat f
										unkfloat5 = readfloat f
										unkfloat6 = readfloat f
										headerlength = readlong f #unsigned
										unkfloat7 = readfloat f
										unkfloat8 = readfloat f
										unkfloat9 = readfloat f
										unkfloat10 = readfloat f
										unknown = readlong f #unsigned
										BoneName = ( "0x" + bit.intAsHex ( BoneHash1 ) as string )
										for z = 1 to BoneHash_array.count do
										(
											if BoneHash1 == BoneHash_array[z].BoneHash1 and BoneHash2 == BoneHash_array[z].BoneHash2 do
											( BoneName = BoneHash_array[z].BoneString )
										)
										append ProperBoneID_array BoneName
									)
									for a = 1 to boneidtotal do
									(
										for b = 1 to BoneCount do
										(
											if ProperBoneID_array[a] == BoneName_array[b] do
											( append FixedBoneID_array b )
										)
									)
									for x = 1 to B1_array.count do
									(
										ImproperBone1 = B1_array[x].Bone1
										ImproperBone2 = B1_array[x].Bone2
										ImproperBone3 = B1_array[x].Bone3
										ImproperBone4 = B1_array[x].Bone4
										ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
										ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
										ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
										ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
										if ProperBone1 == undefined do
										( ProperBone1 = 1 )
										if ProperBone2 == undefined do
										( ProperBone2 = 1 )
										if ProperBone3 == undefined do
										( ProperBone3 = 1 )
										if ProperBone4 == undefined do
										( ProperBone4 = 1 )
										append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
									)
									for b = 1 to W1_array.count Do
									(
										w = ( weight_data boneids: #() weights: #() )
										maxweight = 0
										if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
										if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
										if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
										if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
										if ( maxweight != 0 ) then
										(
											if ( W1_array[b].Weight1 != 0 ) then
											(
												w1 = W1_array[b].Weight1 as float
												append w.boneids ( ActualB1_array[b].Bone1 )
												append w.weights ( w1 )
											)
											if ( W1_array[b].Weight2 != 0 ) then
											(
												w2 = W1_array[b].Weight2 as float
												append w.boneids ( ActualB1_array[b].Bone2 )
												append w.weights ( w2 )
											)
											if ( W1_array[b].Weight3 != 0 ) then
											(
												w3 = W1_array[b].Weight3 as float
												append w.boneids ( ActualB1_array[b].Bone3 )
												append w.weights ( w3 )
											)
											if ( W1_array[b].Weight4 != 0 ) then
											(
												w4 = W1_array[b].Weight4 as float
												append w.boneids ( ActualB1_array[b].Bone4 )
												append w.weights ( w4 )
											)
										)
										append Weight_array w
									)
								)
								for y = PolyStruct_array[i].PolygonStart to ( PolyStruct_array[i].PolygonCount + PolyStruct_array[i].PolygonStart ) do
								( append Face_array2 Face_array[y] )
								VertexMin = PolyStruct_array[i].VertexMin
								VertexMax = PolyStruct_array[i].VertexMax
								for x = VertexMin to VertexMax do
								(
									append Vert_array2 Vert_array[x]
									append Normal_array2 Normal_array[x]
									append Color_array2 Color_array[x]
									append Alpha_array2 Alpha_array[x]
									append UV_array2 UV_array[x]
									if UV2_array.count > 0 do
									( append UV2_array2 UV2_array[x] )
									if UV3_array.count > 0 do
									( append UV3_array2 UV3_array[x] )
									if UV4_array.count > 0 do
									( append UV4_array2 UV4_array[x] )
									append Weight_array2 Weight_array[x]
								)
								for x = 1 to PolyStruct_array[i].PolygonCount do
								(
									Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
									append Face_array3 Faces3
								)
								local PolyMat = standardMaterial()
								PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
								PolyMat.showinviewport = true
								PolyMat.twosided = false
								if TexFormat == 1 then
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
								)
								else
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
								)
								tm.alphasource = 0
								PolyMat.diffuseMap = tm
								PolyMat.opacityMap = tm
								PolyMat.opacityMap.monoOutput = 1
								msh = mesh vertices: Vert_array2 faces: Face_array3
								msh.numTVerts = Vert_array2.count
								if VertColors == true then
								(
									setNumCPVVerts msh msh.numTVerts
									setCVertMode msh true
									setShadeCVerts msh true
								)
								defaultVCFaces msh
								buildTVFaces msh
								msh.name = ( h as string )
								msh.material = PolyMat
								if VertColors == true then
								(
									for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
									for j = 1 to Alpha_array2.count do
									( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
								)
								for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
								for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
								max modify mode
								select msh
								for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
								addmodifier msh ( Edit_Normals() ) ui: off
								msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
								EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
								EN_setNormal = msh.Edit_Normals.SetNormal
								normID = #{}
								for v = 1 to Normal_array2.count do
								(
									free normID
									EN_convertVS #{v} &normID
									for id in normID do EN_setNormal id Normal_array2[v]
								)
								if BoneCount != 0 and B1_array.count > 0 do
								(
									skinMod = skin()
									boneIDMap = #()
									addModifier msh skinMod
									for i = 1 to BoneCount do
									(
										maxbone = getnodebyname BoneSetup[i].name
										if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
									)
									local numSkinBones = skinOps.GetNumberBones skinMod
									for i = 1 to numSkinBones do
									(
										local boneName = skinOps.GetBoneName skinMod i 0
										for j = 1 to BoneCount do
										(
											if boneName == BoneSetup[j].Name then
											(
												boneIDMap[j] = i
												j = BoneCount + 1
											)
										)
									)
									modPanel.setCurrentObject skinMod
									for i = 1 to Vert_array2.count do
									(
										skinOps.SetVertexWeights skinMod i 1 1
										skinOps.unnormalizeVertex skinMod i true
										skinOps.SetVertexWeights skinMod i 1 0
									)
									skinOps.RemoveZeroWeights skinMod
									for i = 1 to Vert_array2.count do
									( skinOps.unnormalizeVertex skinMod i false )
									for i = 1 to Weight_array2.count do
									(
										w = Weight_array2[i]
										bi = #()
										wv = #()
										for j = 1 to w.boneids.count do
										(
											boneid = w.boneids[j]
											weight = w.weights[j]
											append bi boneIDMap[boneid]
											append wv weight
										)
										skinOps.ReplaceVertexWeights skinMod i bi wv
									)
								)
								if UVLayers == 1 do
								(
									if UV2_array2.count > 0 do
									(
										meshop.setNumMaps msh 3 keep: true
										for i = 1 to UV2_array2.count do
										( meshop.setMapVert msh 2 i UV2_array2[i] )
									)
									if UV3_array2.count > 0 do
									(
										meshop.setNumMaps msh 4 keep: true
										for i = 1 to UV3_array2.count do
										( meshop.setMapVert msh 3 i UV3_array2[i] )
									)
									if UV4_array2.count > 0 do
									(
										meshop.setNumMaps msh 5 keep: true
										for i = 1 to UV4_array2.count do
										( meshop.setMapVert msh 4 i UV4_array2[i] )
									)
								)
								if UVLayers == 2 do
								(
									if UV2_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 2" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV2_array2.count do setTVert msh j UV2_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
									if UV3_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 3" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV3_array2.count do setTVert msh j UV3_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
									if UV4_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 4" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV4_array2.count do setTVert msh j UV4_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
								)
							)
							fclose f
						)
						( VerNum == 13 or VerNum == 14 ):(
							Face_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							UV2_array = #()
							UV3_array = #()
							UV4_array = #()
							UV5_array = #()
							B1_array = #()
							W1_array = #()
							Color_array = #()
							MatColor_array = #()
							Alpha_array = #()
							MatAlpha_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							TexName_array = #()
							struct Polygon_Info_Struct
							(
								VertexMin,
								VertexMax,
								PolygonStart,
								PolygonCount,
								FacePointCount,
								MatNum,
								BoneSetNum
							)
							fseek f 0x07 #seek_cur
							printDebug ( "Model start = " + ( ftell f as string ) )
							boundingminx = readfloat f
							boundingminy = readfloat f
							boundingminz = readfloat f
							boundingmaxx = readfloat f
							boundingmaxy = readfloat f
							boundingmaxz = readfloat f
							headerlength = readlong f #unsigned - 4
							fseek f headerlength #seek_cur
							head3asubsize = readlong f #unsigned
							polytotal = readlong f #unsigned
							printDebug ( "Count = " + polytotal as string )
							for x = 1 to polytotal do
							(
								printDebug ( "Model info start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								BoneSetNum = ( readlong f #unsigned ) + 1
								unknown2 = readlong f #unsigned
								unknown3 = readlong f #unsigned
								VertexMin = readlong f #unsigned + 1
								VertexMax = readlong f #unsigned + 1
								FacepointStart = readlong f #unsigned
								PolygonStart = ( FacepointStart / 3 ) + 1
								PolygonCount = readlong f #unsigned
								FacepointCount = PolygonCount * 3
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								headerlength = readlong f #unsigned
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readlong f #unsigned
								headerlength2 = readlong f #unsigned
								MatNum = readlong f #unsigned + 1
								fseek f ( headerlength2 - 0x08 ) #seek_cur
								fseek f 0x88 #seek_cur
								colorr = ( readfloat f ) * 255
								colorg = ( readfloat f ) * 255
								colorb = ( readfloat f ) * 255
								colora = readfloat f
								append MatColor_array [colorr, colorg, colorb]
								append MatAlpha_array colora
								append PolyStruct_array ( Polygon_Info_Struct VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum BoneSetNum: BoneSetNum )
							)
							printDebug ( "Header B start = " + ( ftell f as string ) )
							headerBsize = ( readlong f #unsigned ) - 4
							fseek f headerBsize #seek_cur
							printDebug ( "Header C (Bone IDs) start = " + ( ftell f as string ) )
							IDHeaderLength = ( readlong f #unsigned - 4 )
							BoneIDSets = readlong f #unsigned
							printDebug ( "Count = " + BoneIDSets as string )
							for b = 1 to BoneIDSets do
							(
								append BoneIDOffset_Array ( ftell f )
								boneidtotal = readlong f #unsigned
								ProperBoneID_array = #()
								for y = 1 to boneidtotal do
								(
									properid1 = readlong f #unsigned
									properid2 = readlong f #unsigned
									float = readfloat f
									float = readfloat f
									float = readfloat f
									float = readfloat f
									float = readfloat f
									float = readfloat f
									length = readlong f #unsigned
									float = readfloat f
									float = readfloat f
									float = readfloat f
									float = readfloat f
									boneid1 = readbyte f #unsigned
									boneid2 = readbyte f #unsigned
									boneid3 = readbyte f #unsigned
									boneid4 = readbyte f #unsigned
								)
							)
							printDebug ( "Header D start = " + ( ftell f as string ) )
							headerDsize = ( readlong f #unsigned - 4 )
							fseek f headerDsize #seek_cur
							printDebug ( "Header E start = " + ( ftell f as string ) )
							headerEsize = ( readlong f #unsigned - 4 )
							fseek f headerEsize #seek_cur
							printDebug ( "Header F start = " + ( ftell f as string ) )
							headerFsize = ( readlong f #unsigned ) - 4
							fseek f headerFsize #seek_cur
							printDebug ( "Header G start = " + ( ftell f as string ) )
							fseek f 0x08 #seek_cur
							printDebug ( "Header H (Material Info) start = " + ( ftell f as string ) )
							TexGroupSize = readlong f #unsigned
							for v = 1 to 11 do
							(
								TexGroupCount = readlong f #unsigned
								for x = 1 to TexGroupCount do
								(
									TexSectLength = readlong f #unsigned
									TexHash2 = readlong f #unsigned
									TexHash1 = readlong f #unsigned
									TexName = bit.intAsHex ( TexHash1 ) as string
									for y = 1 to TexHash_array.count do
									(
										if TexHash1 == TexHash_array[y].TexHash1 and TexHash2 == TexHash_array[y].TexHash2 do
										( TexName = TexHash_array[y].TexString )
									)
									TexUnk = readlong f #unsigned
									TexUnkA = readlong f #unsigned
									TexUnkB = readlong f #unsigned
									TexFloatA = readfloat f
									TexFloatB = readfloat f
									TexFloatC = readfloat f
									TexFloatD = readfloat f
									TexFloatE = readfloat f
									TexFloatF = readfloat f
									TexSubHeaderLen = readlong f #unsigned
									TexSubFloatA = readfloat f
									TexSubFloatB = readfloat f
									TexSubFloatC = readfloat f
									TexSubFloatD = readfloat f
									TexSubFloatE = readfloat f
									if v == 1 do
									( append TexName_array TexName )
								)
							)
							printDebug ( "Header I start = " + ( ftell f as string ) )
							UV1XMult = readfloat f
							UV1YMult = readfloat f
							UV4XMult = readfloat f
							UV4YMult = readfloat f
							UV2XMult = readfloat f
							UV2YMult = readfloat f
							UV3XMult = readfloat f
							UV3YMult = readfloat f
							printDebug ( "UV Multipliers = 1 (" + UV1XMult as string + ", " + UV1YMult as string + "), 2 (" + UV2XMult as string + ", " + UV2YMult as string + "), 3 (" + UV3XMult as string + ", " + UV3YMult as string + "), 4 (" + UV4XMult as string + ", " + UV4YMult as string + ")" )
							printDebug ( "Header J start = " + ( ftell f as string ) )
							headerJsize = ( readlong f #unsigned ) - 4
							fseek f headerJsize #seek_cur
							printDebug ( "Header K start = " + ( ftell f as string ) )
							headerKsize = ( readlong f #unsigned ) - 4
							fseek f headerKsize #seek_cur
							bytepad = readbyte f #unsigned
							unknown = readlong f #unsigned
							printDebug ( "Face info start = " + ( ftell f as string ) )
							facecount = readlong f #unsigned
							fseek f 0x08 #seek_cur
							for x = 1 to facecount / 3 do
							(
								fa = readshort f #unsigned + 1
								fb = readshort f #unsigned + 1
								fc = readshort f #unsigned + 1
								append Face_array [fa, fb, fc]
							)
							printDebug ( "Vertex Buffer start = " + ( ftell f as string ) )
							vertcount = readlong f #unsigned
							vertlength = readlong f #unsigned
							fseek f 0x0C #seek_cur
							vertheaderlength = readlong f #unsigned
							VertexOffset = readlong f #unsigned
							VertexAmt = readlong f #unsigned
							VertexFmt = readlong f #unsigned
							if VertexFmt > 0 do
							( printDebug ( "Vertex Offset = " + VertexOffset as string + ", Count = " + VertexAmt as string + ", Format = " + VertexFmt as string ) )
							UVOffset = readlong f #unsigned
							UVAmt = readlong f #unsigned
							UVFmt = readlong f #unsigned
							if UVFmt > 0 do
							( printDebug ( "UV Offset = " + UVOffset as string + ", Count = " + UVAmt as string + ", Format = " + UVFmt as string ) )
							NormalsOffset = readlong f #unsigned
							NormalsAmt = readlong f #unsigned
							NormalsFmt = readlong f #unsigned
							if NormalsFmt > 0 do
							( printDebug ( "Normals Offset = " + NormalsOffset as string + ", Count = " + NormalsAmt as string + ", Format = " + NormalsFmt as string ) )
							WeightsOffset = readlong f #unsigned
							WeightsAmt = readlong f #unsigned
							WeightsFmt = readlong f #unsigned
							if WeightsFmt > 0 do
							( printDebug ( "Weights Offset = " + WeightsOffset as string + ", Count = " + WeightsAmt as string + ", Format = " + WeightsFmt as string ) )
							BonesOffset = readlong f #unsigned
							BonesAmt = readlong f #unsigned
							BonesFmt = readlong f #unsigned
							if BonesFmt > 0 do
							( printDebug ( "Bones Offset = " + BonesOffset as string + ", Count = " + BonesAmt as string + ", Format = " + BonesFmt as string ) )
							ColorsOffset = readlong f #unsigned
							ColorsAmt = readlong f #unsigned
							ColorsFmt = readlong f #unsigned
							if ColorsFmt > 0 do
							( printDebug ( "Colors Offset = " + ColorsOffset as string + ", Count = " + ColorsAmt as string + ", Format = " + ColorsFmt as string ) )
							Unknown1Offset = readlong f #unsigned
							Unknown1Amt = readlong f #unsigned
							Unknown1Fmt = readlong f #unsigned
							if Unknown1Fmt > 0 do
							( printDebug ( "Unknown1 Offset = " + Unknown1Offset as string + ", Count = " + Unknown1Amt as string + ", Format = " + Unknown1Fmt as string ) )
							BinormalsOffset = readlong f #unsigned
							BinormalsAmt = readlong f #unsigned
							BinormalsFmt = readlong f #unsigned
							if BinormalsFmt > 0 do
							( printDebug ( "Binormals? Offset = " + BinormalsOffset as string + ", Count = " + BinormalsAmt as string + ", Format = " + BinormalsFmt as string ) )
							TangentsOffset = readlong f #unsigned
							TangentsAmt = readlong f #unsigned
							TangentsFmt = readlong f #unsigned
							if TangentsFmt > 0 do
							( printDebug ( "Tangents? Offset = " + TangentsOffset as string + ", Count = " + TangentsAmt as string + ", Format = " + TangentsFmt as string ) )
							UV2Offset = readlong f #unsigned
							UV2Amt = readlong f #unsigned
							UV2Fmt = readlong f #unsigned
							if UV2Fmt > 0 do
							( printDebug ( "UV2 Offset = " + UV2Offset as string + ", Count = " + UV2Amt as string + ", Format = " + UV2Fmt as string ) )
							UV3Offset = readlong f #unsigned
							UV3Amt = readlong f #unsigned
							UV3Fmt = readlong f #unsigned
							if UV3Fmt > 0 do
							( printDebug ( "UV3 Offset = " + UV3Offset as string + ", Count = " + UV3Amt as string + ", Format = " + UV3Fmt as string ) )
							UV4Offset = readlong f #unsigned
							UV4Amt = readlong f #unsigned
							UV4Fmt = readlong f #unsigned
							if UV4Fmt > 0 do
							( printDebug ( "UV4(?) Offset = " + UV4Offset as string + ", Count = " + UV4Amt as string + ", Format = " + UV4Fmt as string ) )
							printDebug ( "Vertex start = " + ( ftell f as string ) )
							for x = 1 to vertcount do
							(
								if VertexFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown positions format!" ) )
										( VertexFmt == 1 ):(
											vx = readfloat f * ModelScale
											vy = readfloat f * ModelScale
											vz = readfloat f * ModelScale
											append Vert_array [vx, vy, vz]
										)
									)
									
									
								)
								if UVFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV1 format!" ) )
										( UVFmt == 1 ):(
											tu = readfloat f
											tv = ( ( readfloat f ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
										( UVFmt == 4 ):(
											tu = ( ( readshort f as float / 32767 ) * UV1XMult )
											tv = ( ( ( readshort f as float / 32767 ) * UV1YMult ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
										( UVFmt == 5 ):(
											tu = ( ( readshort f as float / 65535 ) * UV1XMult )
											tv = ( ( ( readshort f as float / 65535 ) * UV1YMult ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
										( UVFmt == 11 ):(
											tu = ( readhalffloat f as float ) * 2
											tv = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV_array [tu, tv, 0]
										)
									)
									
									
								)
								if UV2Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV2 format!" ) )
										( UV2Fmt == 1 ):(
											tu2 = readfloat f
											tv2 = ( ( readfloat f ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
										( UV2Fmt == 4 ):(
											tu2 = ( ( readshort f as float / 32767 ) * UV2XMult )
											tv2 = ( ( ( readshort f as float / 32767 ) * UV2YMult ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
										( UV2Fmt == 5 ):(
											tu2 = ( ( readshort f as float / 65535 ) * UV2XMult )
											tv2 = ( ( ( readshort f as float / 65535 ) * UV2YMult ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
										( UV2Fmt == 11 ):(
											tu2 = ( readhalffloat f as float ) * 2
											tv2 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV2_array [tu2, tv2, 0]
										)
									)
									
									
								)
								if UV3Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV3 format!" ) )
										( UV3Fmt == 1 ):(
											tu3 = readfloat f
											tv3 = ( ( readfloat f ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
										( UV3Fmt == 4 ):(
											tu3 = ( ( readshort f as float / 32767 ) * UV3XMult )
											tv3 = ( ( ( readshort f as float / 32767 ) * UV3YMult ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
										( UV3Fmt == 5 ):(
											tu3 = ( ( readshort f as float / 65535 ) * UV3XMult )
											tv3 = ( ( ( readshort f as float / 65535 ) * UV3YMult ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
										( UV3Fmt == 11 ):(
											tu3 = ( readhalffloat f as float ) * 2
											tv3 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV3_array [tu3, tv3, 0]
										)
									)
									
									
								)
								if UV4Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown UV4 format!" ) )
										( UV4Fmt == 1 ):(
											tu4 = readfloat f
											tv4 = ( ( readfloat f ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
										( UV4Fmt == 4 ):(
											tu4 = ( ( readshort f as float / 32767 ) * UV4XMult )
											tv4 = ( ( ( readshort f as float / 32767 ) * UV4YMult ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
										( UV4Fmt == 5 ):(
											tu4 = ( ( readshort f as float / 65535 ) * UV4XMult )
											tv4 = ( ( ( readshort f as float / 65535 ) * UV4YMult ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
										( UV4Fmt == 11 ):(
											tu4 = ( readhalffloat f as float ) * 2
											tv4 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
											append UV4_array [tu4, tv4, 0]
										)
									)
									
									
								)
								if BonesFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown bones format!" ) )
										( BonesFmt == 3 ):(
											Bone1 = readbyte f #unsigned / 4
											Bone2 = readbyte f #unsigned / 4
											Bone3 = readbyte f #unsigned / 4
											Bone4 = readbyte f #unsigned / 4
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
										( BonesFmt == 8 ):(
											Bone1 = readbyte f #unsigned / 3
											Bone2 = readbyte f #unsigned / 3
											Bone3 = readbyte f #unsigned / 3
											Bone4 = readbyte f #unsigned / 3
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
										)
									)
									
									
								)
								if WeightsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown weights format!" ) )
										( WeightsFmt == 1 ):(
											Weight1 = readfloat f
											Weight2 = readfloat f
											Weight3 = readfloat f
											Weight4 = 0
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										( WeightsFmt == 4 ):(
											Weight1 = ( readshort f as float / 32767 )
											Weight2 = ( readshort f as float / 32767 )
											Weight3 = ( readshort f as float / 32767 )
											Weight4 = ( readshort f as float / 32767 )
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
										( WeightsFmt == 5 ):(
											Weight1 = ( readshort f #unsigned as float / 65535 )
											Weight2 = ( readshort f #unsigned as float / 65535 )
											Weight3 = ( readshort f #unsigned as float / 65535 )
											Weight4 = ( readshort f #unsigned as float / 65535 )
											append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
										)
									)
									
									
								)
								if ColorsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown colors format!" ) )
										( ColorsFmt == 1 ):(
											colorr = readfloat f * 255
											colorg = readfloat f * 255
											colorb = readfloat f * 255
											colora = readfloat f
											append Color_array [colorr, colorg, colorb]
											append Alpha_array colora
										)
										( ColorsFmt == 3 ):(
											colorr = readbyte f #unsigned
											colorg = readbyte f #unsigned
											colorb = readbyte f #unsigned
											colora = ( readbyte f #unsigned as float ) / 255
											append Color_array [colorr, colorg, colorb]
											append Alpha_array colora
										)
									)
									
									
								)
								if Unknown1Fmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown unknown format!" ) )
										( Unknown1Fmt == 1 ):( unknown1 = readfloat f )
									)
									
									
								)
								if NormalsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown normals format!" ) )
										( NormalsFmt == 2 ):(
											nx = readbyte f as float / 127
											ny = readbyte f as float / 127
											nz = readbyte f as float / 127
											nq = readbyte f as float / 127
											append Normal_array [nx, ny, nz]
										)
										( NormalsFmt == 4 ):(
											nx = readshort f as float / 32767
											ny = readshort f as float / 32767
											nz = readshort f as float / 32767
											nq = readshort f as float / 32767
											append Normal_array [nx, ny, nz]
										)
									)
									
									
								)
								if BinormalsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown binormals format!" ) )
										( BinormalsFmt == 2 ):(
											nx2 = readbyte f as float / 127
											ny2 = readbyte f as float / 127
											nz2 = readbyte f as float / 127
											nq2 = readbyte f as float / 127
										)
										( BinormalsFmt == 4 ):(
											nx2 = readshort f as float / 32767
											ny2 = readshort f as float / 32767
											nz2 = readshort f as float / 32767
											nq2 = readshort f as float / 32767
										)
									)
									
									
								)
								if TangentsFmt > 0 do
								(
									case of
									(
										default:( throw ( "Unknown tangents format!" ) )
										( TangentsFmt == 2 ):(
											nx3 = readbyte f as float / 127
											ny3 = readbyte f as float / 127
											nz3 = readbyte f as float / 127
											nq3 = readbyte f as float / 127
										)
										( TangentsFmt == 4 ):(
											nx3 = readshort f as float / 32767
											ny3 = readshort f as float / 32767
											nz3 = readshort f as float / 32767
											nq3 = readshort f as float / 32767
										)
									)
									
									
								)
							)
							printDebug ( "End of file = " + ( ftell f as string ) )
							printDebug ( PolyStruct_array )
							if B1_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append B1_array ( Bone_Info_Struct Bone1: 0 Bone2: 0 Bone3: 0 Bone4: 0 ) )
							)
							if W1_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append W1_array ( Weight_Info_Struct Weight1: 1 Weight2: 0 Weight3: 0 Weight4: 0 ) )
							)
							if Color_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								(
									append Color_array [255, 255, 255]
									append Alpha_array 1
								)
							)
							if UV_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append UV_array [0, 0, 0] )
							)
							for i = 1 to PolyStruct_array.count do
							(
								ProperBoneID_array = #()
								FixedBoneID_array = #()
								ActualB1_array = #()
								Weight_array = #()
								Weight_array2 = #()
								Face_array2 = #()
								Face_array3 = #()
								Vert_array2 = #()
								Normal_array2 = #()
								Color_array2 = #()
								Alpha_array2 = #()
								UV_array2 = #()
								UV2_array2 = #()
								UV3_array2 = #()
								UV4_array2 = #()
								UV5_array2 = #()
								if BoneCount != 0 and B1_array.count > 0 do
								(
									fseek f BoneIDOffset_array[1 * PolyStruct_array[i].BoneSetNum] #seek_set
									boneidtotal = readlong f #unsigned
									ProperBoneID_array = #()
									for y = 1 to boneidtotal do
									(
										BoneHash2 = readlong f #unsigned
										BoneHash1 = readlong f #unsigned
										unkfloat1 = readfloat f
										unkfloat2 = readfloat f
										unkfloat3 = readfloat f
										unkfloat4 = readfloat f
										unkfloat5 = readfloat f
										unkfloat6 = readfloat f
										headerlength = readlong f #unsigned
										unkfloat7 = readfloat f
										unkfloat8 = readfloat f
										unkfloat9 = readfloat f
										unkfloat10 = readfloat f
										unknown = readlong f #unsigned
										BoneName = ( "0x" + bit.intAsHex ( BoneHash1 ) as string )
										for z = 1 to BoneHash_array.count do
										(
											if BoneHash1 == BoneHash_array[z].BoneHash1 and BoneHash2 == BoneHash_array[z].BoneHash2 do
											( BoneName = BoneHash_array[z].BoneString )
										)
										append ProperBoneID_array BoneName
									)
									for a = 1 to boneidtotal do
									(
										for b = 1 to BoneCount do
										(
											if ProperBoneID_array[a] == BoneName_array[b] do
											( append FixedBoneID_array b )
										)
									)
									for x = 1 to B1_array.count do
									(
										ImproperBone1 = B1_array[x].Bone1
										ImproperBone2 = B1_array[x].Bone2
										ImproperBone3 = B1_array[x].Bone3
										ImproperBone4 = B1_array[x].Bone4
										ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
										ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
										ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
										ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
										if ProperBone1 == undefined do
										( ProperBone1 = 1 )
										if ProperBone2 == undefined do
										( ProperBone2 = 1 )
										if ProperBone3 == undefined do
										( ProperBone3 = 1 )
										if ProperBone4 == undefined do
										( ProperBone4 = 1 )
										append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
									)
									for b = 1 to W1_array.count Do
									(
										w = ( weight_data boneids: #() weights: #() )
										maxweight = 0
										if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
										if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
										if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
										if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
										if ( maxweight != 0 ) then
										(
											if ( W1_array[b].Weight1 != 0 ) then
											(
												w1 = W1_array[b].Weight1 as float
												append w.boneids ( ActualB1_array[b].Bone1 )
												append w.weights ( w1 )
											)
											if ( W1_array[b].Weight2 != 0 ) then
											(
												w2 = W1_array[b].Weight2 as float
												append w.boneids ( ActualB1_array[b].Bone2 )
												append w.weights ( w2 )
											)
											if ( W1_array[b].Weight3 != 0 ) then
											(
												w3 = W1_array[b].Weight3 as float
												append w.boneids ( ActualB1_array[b].Bone3 )
												append w.weights ( w3 )
											)
											if ( W1_array[b].Weight4 != 0 ) then
											(
												w4 = W1_array[b].Weight4 as float
												append w.boneids ( ActualB1_array[b].Bone4 )
												append w.weights ( w4 )
											)
										)
										append Weight_array w
									)
								)
								for y = PolyStruct_array[i].PolygonStart to ( PolyStruct_array[i].PolygonCount + PolyStruct_array[i].PolygonStart ) do
								( append Face_array2 Face_array[y] )
								VertexMin = PolyStruct_array[i].VertexMin
								VertexMax = PolyStruct_array[i].VertexMax
								for x = VertexMin to VertexMax do
								(
									append Vert_array2 Vert_array[x]
									append Normal_array2 Normal_array[x]
									append Color_array2 Color_array[x]
									append Alpha_array2 Alpha_array[x]
									append UV_array2 UV_array[x]
									if UV2_array.count > 0 do
									( append UV2_array2 UV2_array[x] )
									if UV3_array.count > 0 do
									( append UV3_array2 UV3_array[x] )
									if UV4_array.count > 0 do
									( append UV4_array2 UV4_array[x] )
									if UV5_array.count > 0 do
									( append UV5_array2 UV5_array[x] )
									append Weight_array2 Weight_array[x]
								)
								for x = 1 to PolyStruct_array[i].PolygonCount do
								(
									Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
									append Face_array3 Faces3
								)
								local PolyMat = standardMaterial()
								PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
								PolyMat.showinviewport = true
								PolyMat.twosided = false
								if TexFormat == 1 then
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
								)
								else
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
								)
								tm.alphasource = 0
								PolyMat.diffuseMap = tm
								PolyMat.opacityMap = tm
								PolyMat.opacityMap.monoOutput = 1
								msh = mesh vertices: Vert_array2 faces: Face_array3
								msh.numTVerts = Vert_array2.count
								if VertColors == true then
								(
									setNumCPVVerts msh msh.numTVerts
									setCVertMode msh true
									setShadeCVerts msh true
								)
								defaultVCFaces msh
								buildTVFaces msh
								msh.name = ( h as string )
								msh.material = PolyMat
								if VertColors == true then
								(
									for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
									for j = 1 to Alpha_array2.count do
									( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
								)
								for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
								for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
								max modify mode
								select msh
								for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
								addmodifier msh ( Edit_Normals() ) ui: off
								msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
								EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
								EN_setNormal = msh.Edit_Normals.SetNormal
								normID = #{}
								for v = 1 to Normal_array2.count do
								(
									free normID
									EN_convertVS #{v} &normID
									for id in normID do EN_setNormal id Normal_array2[v]
								)
								if BoneCount != 0 and B1_array.count > 0 do
								(
									skinMod = skin()
									boneIDMap = #()
									addModifier msh skinMod
									for i = 1 to BoneCount do
									(
										maxbone = getnodebyname BoneSetup[i].name
										if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
									)
									local numSkinBones = skinOps.GetNumberBones skinMod
									for i = 1 to numSkinBones do
									(
										local boneName = skinOps.GetBoneName skinMod i 0
										for j = 1 to BoneCount do
										(
											if boneName == BoneSetup[j].Name then
											(
												boneIDMap[j] = i
												j = BoneCount + 1
											)
										)
									)
									modPanel.setCurrentObject skinMod
									for i = 1 to Vert_array2.count do
									(
										skinOps.SetVertexWeights skinMod i 1 1
										skinOps.unnormalizeVertex skinMod i true
										skinOps.SetVertexWeights skinMod i 1 0
									)
									skinOps.RemoveZeroWeights skinMod
									for i = 1 to Vert_array2.count do
									( skinOps.unnormalizeVertex skinMod i false )
									for i = 1 to Weight_array2.count do
									(
										w = Weight_array2[i]
										bi = #()
										wv = #()
										for j = 1 to w.boneids.count do
										(
											boneid = w.boneids[j]
											weight = w.weights[j]
											append bi boneIDMap[boneid]
											append wv weight
										)
										skinOps.ReplaceVertexWeights skinMod i bi wv
									)
								)
								if UVLayers == 1 do
								(
									if UV2_array2.count > 0 do
									(
										meshop.setNumMaps msh 3 keep: true
										for i = 1 to UV2_array2.count do
										( meshop.setMapVert msh 2 i UV2_array2[i] )
									)
									if UV3_array2.count > 0 do
									(
										meshop.setNumMaps msh 4 keep: true
										for i = 1 to UV3_array2.count do
										( meshop.setMapVert msh 3 i UV3_array2[i] )
									)
									if UV4_array2.count > 0 do
									(
										meshop.setNumMaps msh 5 keep: true
										for i = 1 to UV4_array2.count do
										( meshop.setMapVert msh 4 i UV4_array2[i] )
									)
									if UV5_array2.count > 0 do
									(
										meshop.setNumMaps msh 6 keep: true
										for i = 1 to UV5_array2.count do
										( meshop.setMapVert msh 5 i UV5_array2[i] )
									)
								)
								if UVLayers == 2 do
								(
									if UV2_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 2" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV2_array2.count do setTVert msh j UV2_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
									if UV3_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 3" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV3_array2.count do setTVert msh j UV3_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
									if UV4_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 4" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV4_array2.count do setTVert msh j UV4_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
									if UV5_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 5" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV5_array2.count do setTVert msh j UV5_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
								)
							)
							fclose f
						)
						( VerNum == 17 or VerNum == 18 ):(
							Face_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							UV2_array = #()
							UV3_array = #()
							UV4_array = #()
							UV5_array = #()
							B1_array = #()
							W1_array = #()
							Color_array = #()
							MatColor_array = #()
							Alpha_array = #()
							MatAlpha_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							TexName_array = #()
							struct Polygon_Info_Struct
							(
								VertexMin,
								VertexMax,
								PolygonStart,
								PolygonCount,
								FacePointCount,
								MatNum,
								BoneSetNum
							)
							fseek f 0x07 #seek_cur
							printDebug ( "Model start = " + ( ftell f as string ) )
							boundingminx = readfloat f
							boundingminy = readfloat f
							boundingminz = readfloat f
							boundingmaxx = readfloat f
							boundingmaxy = readfloat f
							boundingmaxz = readfloat f
							headerlength = readlong f #unsigned - 4
							fseek f headerlength #seek_cur
							head3asubsize = readlong f #unsigned
							polytotal = readlong f #unsigned
							printDebug ( "Count = " + polytotal as string )
							for x = 1 to polytotal do
							(
								printDebug ( "Model info start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								BoneSetNum = ( readlong f #unsigned ) + 1
								unknown2 = readlong f #unsigned
								unknown3 = readlong f #unsigned
								VertexMin = readlong f #unsigned + 1
								VertexMax = readlong f #unsigned + 1
								FacepointStart = readlong f #unsigned
								PolygonStart = ( FacepointStart / 3 ) + 1
								PolygonCount = readlong f #unsigned
								FacepointCount = PolygonCount * 3
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								headerlength = readlong f #unsigned
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readlong f #unsigned
								headerlength2 = readlong f #unsigned
								MatNum = readlong f #unsigned + 1
								fseek f ( headerlength2 - 0x08 ) #seek_cur
								fseek f 0x88 #seek_cur
								colorr = ( readfloat f ) * 255
								colorg = ( readfloat f ) * 255
								colorb = ( readfloat f ) * 255
								colora = readfloat f
								append MatColor_array [colorr, colorg, colorb]
								append MatAlpha_array colora
								append PolyStruct_array ( Polygon_Info_Struct VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum BoneSetNum: BoneSetNum )
							)
							printDebug ( "Header B start = " + ( ftell f as string ) )
							headerBsize = ( readlong f #unsigned ) - 4
							fseek f headerBsize #seek_cur
							printDebug ( "Header C (Bone IDs) start = " + ( ftell f as string ) )
							IDHeaderLength = ( readlong f #unsigned - 4 )
							BoneIDSets = readlong f #unsigned
							printDebug ( "Count = " + BoneIDSets as string )
							for b = 1 to BoneIDSets do
							(
								append BoneIDOffset_Array ( ftell f )
								boneidtotal = readlong f #unsigned
								ProperBoneID_array = #()
								for y = 1 to boneidtotal do
								(
									properid1 = readlong f #unsigned
									properid2 = readlong f #unsigned
									float = readfloat f
									float = readfloat f
									float = readfloat f
									float = readfloat f
									float = readfloat f
									float = readfloat f
									length = readlong f #unsigned
									float = readfloat f
									float = readfloat f
									float = readfloat f
									float = readfloat f
									boneid1 = readbyte f #unsigned
									boneid2 = readbyte f #unsigned
									boneid3 = readbyte f #unsigned
									boneid4 = readbyte f #unsigned
								)
							)
							printDebug ( "Header D start = " + ( ftell f as string ) )
							headerDsize = ( readlong f #unsigned - 4 )
							fseek f headerDsize #seek_cur
							printDebug ( "Header E start = " + ( ftell f as string ) )
							headerEsize = ( readlong f #unsigned - 4 )
							fseek f headerEsize #seek_cur
							printDebug ( "Header F start = " + ( ftell f as string ) )
							headerFsize = ( readlong f #unsigned ) - 4
							fseek f headerFsize #seek_cur
							printDebug ( "Header G start = " + ( ftell f as string ) )
							fseek f 0x08 #seek_cur
							printDebug ( "Header H (Material Info) start = " + ( ftell f as string ) )
							TexGroupSize = readlong f #unsigned
							for v = 1 to 14 do
							(
								print ( "SET " + v as string )
								TexGroupCount = readlong f #unsigned
								for x = 1 to TexGroupCount do
								(
									TexSectLength = readlong f #unsigned
									TexHash2 = readlong f #unsigned
									TexHash1 = readlong f #unsigned
									TexName = bit.intAsHex ( TexHash1 ) as string
									for y = 1 to TexHash_array.count do
									(
										if TexHash1 == TexHash_array[y].TexHash1 and TexHash2 == TexHash_array[y].TexHash2 do
										( TexName = TexHash_array[y].TexString )
									)
									TexUnk = readlong f #unsigned
									TexUnkA = readlong f #unsigned
									TexUnkB = readlong f #unsigned
									TexFloatA = readfloat f
									TexFloatB = readfloat f
									TexFloatC = readfloat f
									TexFloatD = readfloat f
									TexFloatE = readfloat f
									TexFloatF = readfloat f
									TexSubHeaderLen = readlong f #unsigned
									TexSubFloatA = readfloat f
									TexSubFloatB = readfloat f
									TexSubFloatC = readfloat f
									TexSubFloatD = readfloat f
									TexSubFloatE = readfloat f
									TexSubFloatF = readfloat f
									if v == 1 do
									( append TexName_array TexName )
								)
							)
							printDebug ( "Header I start = " + ( ftell f as string ) )
							UV1XMult = readfloat f
							UV1YMult = readfloat f
							UV5XMult = readfloat f
							UV5YMult = readfloat f
							UV2XMult = readfloat f
							UV2YMult = readfloat f
							UV3XMult = readfloat f
							UV3YMult = readfloat f
							UV4XMult = readfloat f
							UV4YMult = readfloat f
							printDebug ( "UV Multipliers = 1 (" + UV1XMult as string + ", " + UV1YMult as string + "), 2 (" + UV2XMult as string + ", " + UV2YMult as string + "), 3 (" + UV3XMult as string + ", " + UV3YMult as string + "), 4 (" + UV4XMult as string + ", " + UV4YMult as string + "), ? (" + UV5XMult as string + ", " + UV5YMult as string + ")" )
							printDebug ( "Header J start = " + ( ftell f as string ) )
							headerJsize = ( readlong f #unsigned ) - 4
							fseek f headerJsize #seek_cur
							printDebug ( "Header K start = " + ( ftell f as string ) )
							headerKsize = ( readlong f #unsigned ) - 4
							fseek f headerKsize #seek_cur
							bytepad = readbyte f #unsigned
							unknown = readlong f #unsigned
							printDebug ( "Face info start = " + ( ftell f as string ) )
							facecount = readlong f #unsigned
							facetype = readlong f #unsigned
							fseek f 0x04 #seek_cur
							case facetype of
							(
								default:( throw ( "Unknown faces format!" ) )
								0 :(
									for x = 1 to facecount / 3 do
									(
										fa = readshort f #unsigned + 1
										fb = readshort f #unsigned + 1
										fc = readshort f #unsigned + 1
										append Face_array [fa, fb, fc]
									)
								)
								2 :(
									for x = 1 to facecount / 3 do
									(
										fa = readBEshort f + 1
										fb = readBEshort f + 1
										fc = readBEshort f + 1
										append Face_array [fa, fb, fc]
									)
								)
							)
							
							
							for z = 1 to 2 do
							(
								printDebug ( "Vertex Buffer " + z as string + " start = " + ( ftell f as string ) )
								vertcount = readlong f #unsigned
								vertlength = readlong f #unsigned
								fseek f 0x08 #seek_cur
								vertheaderlength = readlong f #unsigned
								VertexOffset = readlong f #unsigned
								VertexAmt = readlong f #unsigned
								VertexFmt = readlong f #unsigned
								if VertexFmt > 0 do
								( printDebug ( "Vertex Offset = " + VertexOffset as string + ", Count = " + VertexAmt as string + ", Format = " + VertexFmt as string ) )
								UVOffset = readlong f #unsigned
								UVAmt = readlong f #unsigned
								UVFmt = readlong f #unsigned
								if UVFmt > 0 do
								( printDebug ( "UV Offset = " + UVOffset as string + ", Count = " + UVAmt as string + ", Format = " + UVFmt as string ) )
								NormalsOffset = readlong f #unsigned
								NormalsAmt = readlong f #unsigned
								NormalsFmt = readlong f #unsigned
								if NormalsFmt > 0 do
								( printDebug ( "Normals Offset = " + NormalsOffset as string + ", Count = " + NormalsAmt as string + ", Format = " + NormalsFmt as string ) )
								WeightsOffset = readlong f #unsigned
								WeightsAmt = readlong f #unsigned
								WeightsFmt = readlong f #unsigned
								if WeightsFmt > 0 do
								( printDebug ( "Weights Offset = " + WeightsOffset as string + ", Count = " + WeightsAmt as string + ", Format = " + WeightsFmt as string ) )
								BonesOffset = readlong f #unsigned
								BonesAmt = readlong f #unsigned
								BonesFmt = readlong f #unsigned
								if BonesFmt > 0 do
								( printDebug ( "Bones Offset = " + BonesOffset as string + ", Count = " + BonesAmt as string + ", Format = " + BonesFmt as string ) )
								ColorsOffset = readlong f #unsigned
								ColorsAmt = readlong f #unsigned
								ColorsFmt = readlong f #unsigned
								if ColorsFmt > 0 do
								( printDebug ( "Colors Offset = " + ColorsOffset as string + ", Count = " + ColorsAmt as string + ", Format = " + ColorsFmt as string ) )
								Unknown1Offset = readlong f #unsigned
								Unknown1Amt = readlong f #unsigned
								Unknown1Fmt = readlong f #unsigned
								if Unknown1Fmt > 0 do
								( printDebug ( "Unknown1 Offset = " + Unknown1Offset as string + ", Count = " + Unknown1Amt as string + ", Format = " + Unknown1Fmt as string ) )
								BinormalsOffset = readlong f #unsigned
								BinormalsAmt = readlong f #unsigned
								BinormalsFmt = readlong f #unsigned
								if BinormalsFmt > 0 do
								( printDebug ( "Binormals? Offset = " + BinormalsOffset as string + ", Count = " + BinormalsAmt as string + ", Format = " + BinormalsFmt as string ) )
								TangentsOffset = readlong f #unsigned
								TangentsAmt = readlong f #unsigned
								TangentsFmt = readlong f #unsigned
								if TangentsFmt > 0 do
								( printDebug ( "Tangents? Offset = " + TangentsOffset as string + ", Count = " + TangentsAmt as string + ", Format = " + TangentsFmt as string ) )
								UV2Offset = readlong f #unsigned
								UV2Amt = readlong f #unsigned
								UV2Fmt = readlong f #unsigned
								if UV2Fmt > 0 do
								( printDebug ( "UV2 Offset = " + UV2Offset as string + ", Count = " + UV2Amt as string + ", Format = " + UV2Fmt as string ) )
								UV3Offset = readlong f #unsigned
								UV3Amt = readlong f #unsigned
								UV3Fmt = readlong f #unsigned
								if UV3Fmt > 0 do
								( printDebug ( "UV3 Offset = " + UV3Offset as string + ", Count = " + UV3Amt as string + ", Format = " + UV3Fmt as string ) )
								UV4Offset = readlong f #unsigned
								UV4Amt = readlong f #unsigned
								UV4Fmt = readlong f #unsigned
								if UV4Fmt > 0 do
								( printDebug ( "UV4 Offset = " + UV4Offset as string + ", Count = " + UV4Amt as string + ", Format = " + UV4Fmt as string ) )
								UV5Offset = readlong f #unsigned
								UV5Amt = readlong f #unsigned
								UV5Fmt = readlong f #unsigned
								if UV5Fmt > 0 do
								( printDebug ( "UV5? Offset = " + UV5Offset as string + ", Count = " + UV5Amt as string + ", Format = " + UV5Fmt as string ) )
								printDebug ( "Vertex start = " + ( ftell f as string ) )
								for x = 1 to vertcount do
								(
									if VertexFmt > 0 do
									(
										case of
										(
											default:( throw ( "Unknown positions format!" ) )
											( VertexFmt == 1 ):(
												vx = readfloat f * ModelScale
												vy = readfloat f * ModelScale
												vz = readfloat f * ModelScale
												append Vert_array [vx, vy, vz]
											)
											( VertexFmt == 11 ):(
												vx = ( ReadBEHalfFloat f * 2 ) * ModelScale
												vy = ( ReadBEHalfFloat f * 2 ) * ModelScale
												vz = ( ReadBEHalfFloat f * 2 ) * ModelScale
												vq = ( ReadBEHalfFloat f * 2 ) * ModelScale
												append Vert_array [vx, vy, vz]
											)
										)
										
										
									)
									if BonesFmt > 0 do
									(
										case of
										(
											default:( throw ( "Unknown bones format!" ) )
											( BonesFmt == 3 ):(
												Bone1 = readbyte f #unsigned / 4
												Bone2 = readbyte f #unsigned / 4
												Bone3 = readbyte f #unsigned / 4
												Bone4 = readbyte f #unsigned / 4
												append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
											)
											( BonesFmt == 8 ):(
												Bone1 = readbyte f #unsigned / 3
												Bone2 = readbyte f #unsigned / 3
												Bone3 = readbyte f #unsigned / 3
												Bone4 = readbyte f #unsigned / 3
												append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
											)
										)
										
										
									)
									if WeightsFmt > 0 do
									(
										case of
										(
											default:( throw ( "Unknown weights format!" ) )
											( WeightsFmt == 1 ):(
												Weight1 = readfloat f
												Weight2 = readfloat f
												Weight3 = readfloat f
												Weight4 = 0
												append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
											)
											( WeightsFmt == 4 ):(
												Weight1 = ( readshort f as float / 32767 )
												Weight2 = ( readshort f as float / 32767 )
												Weight3 = ( readshort f as float / 32767 )
												Weight4 = ( readshort f as float / 32767 )
												append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
											)
											( WeightsFmt == 5 ):(
												Weight1 = ( readshort f #unsigned as float / 65535 )
												Weight2 = ( readshort f #unsigned as float / 65535 )
												Weight3 = ( readshort f #unsigned as float / 65535 )
												Weight4 = ( readshort f #unsigned as float / 65535 )
												append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
											)
										)
										
										
									)
									if NormalsFmt > 0 do
									(
										case of
										(
											default:( throw ( "Unknown normals format!" ) )
											( NormalsFmt == 2 ):(
												nx = readbyte f as float / 127
												ny = readbyte f as float / 127
												nz = readbyte f as float / 127
												nq = readbyte f as float / 127
												append Normal_array [nx, ny, nz]
											)
											( NormalsFmt == 4 ):(
												nx = readshort f as float / 32767
												ny = readshort f as float / 32767
												nz = readshort f as float / 32767
												nq = readshort f as float / 32767
												append Normal_array [nx, ny, nz]
											)
										)
										
										
									)
									if UV5Fmt > 0 do
									(
										case of
										(
											default:( throw ( "Unknown UV5 format!" ) )
											( UV5Fmt == 1 ):(
												tu5 = readfloat f
												tv5 = ( ( readfloat f ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
											( UV5Fmt == 4 ):(
												tu5 = ( ( readshort f as float / 32767 ) * UV5XMult )
												tv5 = ( ( ( readshort f as float / 32767 ) * UV5YMult ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
											( UV5Fmt == 5 ):(
												tu5 = ( ( readshort f as float / 65535 ) * UV5XMult )
												tv5 = ( ( ( readshort f as float / 65535 ) * UV5YMult ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
											( UV5Fmt == 11 ):(
												tu5 = ( readhalffloat f as float ) * 2
												tv5 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
										)
										
										
									)
									if Unknown1Fmt > 0 do
									(
										case of
										(
											default:( throw ( "Unknown unknown format!" ) )
											( Unknown1Fmt == 1 ):( unknown1 = readfloat f )
										)
										
										
									)
									if UVFmt > 0 do
									(
										case of
										(
											default:( throw ( "Unknown UV1 format!" ) )
											( UVFmt == 1 ):(
												tu = readfloat f
												tv = ( ( readfloat f ) * -1 ) + 1
												append UV_array [tu, tv, 0]
											)
											( UVFmt == 4 ):(
												tu = ( ( readshort f as float / 32767 ) * UV1XMult )
												tv = ( ( ( readshort f as float / 32767 ) * UV1YMult ) * -1 ) + 1
												append UV_array [tu, tv, 0]
											)
											( UVFmt == 5 ):(
												tu = ( ( readshort f as float / 65535 ) * UV1XMult )
												tv = ( ( ( readshort f as float / 65535 ) * UV1YMult ) * -1 ) + 1
												append UV_array [tu, tv, 0]
											)
											( UVFmt == 11 ):(
												tu = ( readhalffloat f as float ) * 2
												tv = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
												append UV_array [tu, tv, 0]
											)
										)
										
										
									)
									if UV2Fmt > 0 do
									(
										case of
										(
											default:( throw ( "Unknown UV2 format!" ) )
											( UV2Fmt == 1 ):(
												tu2 = readfloat f
												tv2 = ( ( readfloat f ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
											( UV2Fmt == 4 ):(
												tu2 = ( ( readshort f as float / 32767 ) * UV2XMult )
												tv2 = ( ( ( readshort f as float / 32767 ) * UV2YMult ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
											( UV2Fmt == 5 ):(
												tu2 = ( ( readshort f as float / 65535 ) * UV2XMult )
												tv2 = ( ( ( readshort f as float / 65535 ) * UV2YMult ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
											( UV2Fmt == 11 ):(
												tu2 = ( readhalffloat f as float ) * 2
												tv2 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
										)
										
										
									)
									if UV3Fmt > 0 do
									(
										case of
										(
											default:( throw ( "Unknown UV3 format!" ) )
											( UV3Fmt == 1 ):(
												tu3 = readfloat f
												tv3 = ( ( readfloat f ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
											( UV3Fmt == 4 ):(
												tu3 = ( ( readshort f as float / 32767 ) * UV3XMult )
												tv3 = ( ( ( readshort f as float / 32767 ) * UV3YMult ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
											( UV3Fmt == 5 ):(
												tu3 = ( ( readshort f as float / 65535 ) * UV3XMult )
												tv3 = ( ( ( readshort f as float / 65535 ) * UV3YMult ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
											( UV3Fmt == 11 ):(
												tu3 = ( readhalffloat f as float ) * 2
												tv3 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
										)
										
										
									)
									if UV4Fmt > 0 do
									(
										case of
										(
											default:( throw ( "Unknown UV4 format!" ) )
											( UV4Fmt == 1 ):(
												tu4 = readfloat f
												tv4 = ( ( readfloat f ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
											( UV4Fmt == 4 ):(
												tu4 = ( ( readshort f as float / 32767 ) * UV4XMult )
												tv4 = ( ( ( readshort f as float / 32767 ) * UV4YMult ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
											( UV4Fmt == 5 ):(
												tu4 = ( ( readshort f as float / 65535 ) * UV4XMult )
												tv4 = ( ( ( readshort f as float / 65535 ) * UV4YMult ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
											( UV4Fmt == 11 ):(
												tu4 = ( readhalffloat f as float ) * 2
												tv4 = ( ( ( readhalffloat f as float ) * 2 ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
										)
										
										
									)
									if ColorsFmt > 0 do
									(
										case of
										(
											default:( throw ( "Unknown colors format!" ) )
											( ColorsFmt == 1 ):(
												colorr = readfloat f * 255
												colorg = readfloat f * 255
												colorb = readfloat f * 255
												colora = readfloat f
												append Color_array [colorr, colorg, colorb]
												append Alpha_array colora
											)
											( ColorsFmt == 3 ):(
												colorr = readbyte f #unsigned
												colorg = readbyte f #unsigned
												colorb = readbyte f #unsigned
												colora = ( readbyte f #unsigned as float ) / 255
												append Color_array [colorr, colorg, colorb]
												append Alpha_array colora
											)
										)
										
										
									)
									if BinormalsFmt > 0 do
									(
										case of
										(
											default:( throw ( "Unknown binormals format!" ) )
											( BinormalsFmt == 2 ):(
												nx2 = readbyte f as float / 127
												ny2 = readbyte f as float / 127
												nz2 = readbyte f as float / 127
												nq2 = readbyte f as float / 127
											)
											( BinormalsFmt == 4 ):(
												nx2 = readshort f as float / 32767
												ny2 = readshort f as float / 32767
												nz2 = readshort f as float / 32767
												nq2 = readshort f as float / 32767
											)
										)
										
										
									)
									if TangentsFmt > 0 do
									(
										case of
										(
											default:( throw ( "Unknown tangents format!" ) )
											( TangentsFmt == 2 ):(
												nx3 = readbyte f as float / 127
												ny3 = readbyte f as float / 127
												nz3 = readbyte f as float / 127
												nq3 = readbyte f as float / 127
											)
											( TangentsFmt == 4 ):(
												nx3 = readshort f as float / 32767
												ny3 = readshort f as float / 32767
												nz3 = readshort f as float / 32767
												nq3 = readshort f as float / 32767
											)
										)
										
										
									)
								)
							)
							printDebug ( "End of file = " + ( ftell f as string ) )
							printDebug ( PolyStruct_array )
							if B1_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append B1_array ( Bone_Info_Struct Bone1: 0 Bone2: 0 Bone3: 0 Bone4: 0 ) )
							)
							if W1_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append W1_array ( Weight_Info_Struct Weight1: 1 Weight2: 0 Weight3: 0 Weight4: 0 ) )
							)
							if Color_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								(
									append Color_array [255, 255, 255]
									append Alpha_array 1
								)
							)
							if UV_array.count == 0 do
							(
								for x = 1 to Vert_array.count do
								( append UV_array [0, 0, 0] )
							)
							for i = 1 to PolyStruct_array.count do
							(
								ProperBoneID_array = #()
								FixedBoneID_array = #()
								ActualB1_array = #()
								Weight_array = #()
								Weight_array2 = #()
								Face_array2 = #()
								Face_array3 = #()
								Vert_array2 = #()
								Normal_array2 = #()
								Color_array2 = #()
								Alpha_array2 = #()
								UV_array2 = #()
								UV2_array2 = #()
								UV3_array2 = #()
								UV4_array2 = #()
								UV5_array2 = #()
								if BoneCount != 0 and B1_array.count > 0 do
								(
									fseek f BoneIDOffset_array[1 * PolyStruct_array[i].BoneSetNum] #seek_set
									boneidtotal = readlong f #unsigned
									ProperBoneID_array = #()
									for y = 1 to boneidtotal do
									(
										BoneHash2 = readlong f #unsigned
										BoneHash1 = readlong f #unsigned
										unkfloat1 = readfloat f
										unkfloat2 = readfloat f
										unkfloat3 = readfloat f
										unkfloat4 = readfloat f
										unkfloat5 = readfloat f
										unkfloat6 = readfloat f
										headerlength = readlong f #unsigned
										unkfloat7 = readfloat f
										unkfloat8 = readfloat f
										unkfloat9 = readfloat f
										unkfloat10 = readfloat f
										unknown = readlong f #unsigned
										BoneName = ( "0x" + bit.intAsHex ( BoneHash1 ) as string )
										for z = 1 to BoneHash_array.count do
										(
											if BoneHash1 == BoneHash_array[z].BoneHash1 and BoneHash2 == BoneHash_array[z].BoneHash2 do
											( BoneName = BoneHash_array[z].BoneString )
										)
										append ProperBoneID_array BoneName
									)
									for a = 1 to boneidtotal do
									(
										for b = 1 to BoneCount do
										(
											if ProperBoneID_array[a] == BoneName_array[b] do
											( append FixedBoneID_array b )
										)
									)
									for x = 1 to B1_array.count do
									(
										ImproperBone1 = B1_array[x].Bone1
										ImproperBone2 = B1_array[x].Bone2
										ImproperBone3 = B1_array[x].Bone3
										ImproperBone4 = B1_array[x].Bone4
										ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
										ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
										ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
										ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
										if ProperBone1 == undefined do
										( ProperBone1 = 1 )
										if ProperBone2 == undefined do
										( ProperBone2 = 1 )
										if ProperBone3 == undefined do
										( ProperBone3 = 1 )
										if ProperBone4 == undefined do
										( ProperBone4 = 1 )
										append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
									)
									for b = 1 to W1_array.count Do
									(
										w = ( weight_data boneids: #() weights: #() )
										maxweight = 0
										if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
										if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
										if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
										if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
										if ( maxweight != 0 ) then
										(
											if ( W1_array[b].Weight1 != 0 ) then
											(
												w1 = W1_array[b].Weight1 as float
												append w.boneids ( ActualB1_array[b].Bone1 )
												append w.weights ( w1 )
											)
											if ( W1_array[b].Weight2 != 0 ) then
											(
												w2 = W1_array[b].Weight2 as float
												append w.boneids ( ActualB1_array[b].Bone2 )
												append w.weights ( w2 )
											)
											if ( W1_array[b].Weight3 != 0 ) then
											(
												w3 = W1_array[b].Weight3 as float
												append w.boneids ( ActualB1_array[b].Bone3 )
												append w.weights ( w3 )
											)
											if ( W1_array[b].Weight4 != 0 ) then
											(
												w4 = W1_array[b].Weight4 as float
												append w.boneids ( ActualB1_array[b].Bone4 )
												append w.weights ( w4 )
											)
										)
										append Weight_array w
									)
								)
								for y = PolyStruct_array[i].PolygonStart to ( PolyStruct_array[i].PolygonCount + PolyStruct_array[i].PolygonStart ) do
								( append Face_array2 Face_array[y] )
								VertexMin = PolyStruct_array[i].VertexMin
								VertexMax = PolyStruct_array[i].VertexMax
								for x = VertexMin to VertexMax do
								(
									append Vert_array2 Vert_array[x]
									append Normal_array2 Normal_array[x]
									append Color_array2 Color_array[x]
									append Alpha_array2 Alpha_array[x]
									append UV_array2 UV_array[x]
									if UV2_array.count > 0 do
									( append UV2_array2 UV2_array[x] )
									if UV3_array.count > 0 do
									( append UV3_array2 UV3_array[x] )
									if UV4_array.count > 0 do
									( append UV4_array2 UV4_array[x] )
									if UV5_array.count > 0 do
									( append UV5_array2 UV5_array[x] )
									append Weight_array2 Weight_array[x]
								)
								for x = 1 to PolyStruct_array[i].PolygonCount do
								(
									Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
									append Face_array3 Faces3
								)
								local PolyMat = standardMaterial()
								PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
								PolyMat.showinviewport = true
								PolyMat.twosided = false
								if TexFormat == 1 then
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
								)
								else
								(
									if TexPath == 1 then
									( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
									else
									( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
								)
								tm.alphasource = 0
								PolyMat.diffuseMap = tm
								PolyMat.opacityMap = tm
								PolyMat.opacityMap.monoOutput = 1
								msh = mesh vertices: Vert_array2 faces: Face_array3
								msh.numTVerts = Vert_array2.count
								if VertColors == true then
								(
									setNumCPVVerts msh msh.numTVerts
									setCVertMode msh true
									setShadeCVerts msh true
								)
								defaultVCFaces msh
								buildTVFaces msh
								msh.name = ( h as string )
								msh.material = PolyMat
								if VertColors == true then
								(
									for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
									for j = 1 to Alpha_array2.count do
									( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
								)
								for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
								for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
								max modify mode
								select msh
								for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
								addmodifier msh ( Edit_Normals() ) ui: off
								msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
								EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
								EN_setNormal = msh.Edit_Normals.SetNormal
								normID = #{}
								for v = 1 to Normal_array2.count do
								(
									free normID
									EN_convertVS #{v} &normID
									for id in normID do EN_setNormal id Normal_array2[v]
								)
								if BoneCount != 0 and B1_array.count > 0 do
								(
									skinMod = skin()
									boneIDMap = #()
									addModifier msh skinMod
									for i = 1 to BoneCount do
									(
										maxbone = getnodebyname BoneSetup[i].name
										if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
									)
									local numSkinBones = skinOps.GetNumberBones skinMod
									for i = 1 to numSkinBones do
									(
										local boneName = skinOps.GetBoneName skinMod i 0
										for j = 1 to BoneCount do
										(
											if boneName == BoneSetup[j].Name then
											(
												boneIDMap[j] = i
												j = BoneCount + 1
											)
										)
									)
									modPanel.setCurrentObject skinMod
									for i = 1 to Vert_array2.count do
									(
										skinOps.SetVertexWeights skinMod i 1 1
										skinOps.unnormalizeVertex skinMod i true
										skinOps.SetVertexWeights skinMod i 1 0
									)
									skinOps.RemoveZeroWeights skinMod
									for i = 1 to Vert_array2.count do
									( skinOps.unnormalizeVertex skinMod i false )
									for i = 1 to Weight_array2.count do
									(
										w = Weight_array2[i]
										bi = #()
										wv = #()
										for j = 1 to w.boneids.count do
										(
											boneid = w.boneids[j]
											weight = w.weights[j]
											append bi boneIDMap[boneid]
											append wv weight
										)
										skinOps.ReplaceVertexWeights skinMod i bi wv
									)
								)
								if UVLayers == 1 do
								(
									if UV2_array2.count > 0 do
									(
										meshop.setNumMaps msh 3 keep: true
										for i = 1 to UV2_array2.count do
										( meshop.setMapVert msh 2 i UV2_array2[i] )
									)
									if UV3_array2.count > 0 do
									(
										meshop.setNumMaps msh 4 keep: true
										for i = 1 to UV3_array2.count do
										( meshop.setMapVert msh 3 i UV3_array2[i] )
									)
									if UV4_array2.count > 0 do
									(
										meshop.setNumMaps msh 5 keep: true
										for i = 1 to UV4_array2.count do
										( meshop.setMapVert msh 4 i UV4_array2[i] )
									)
									if UV5_array2.count > 0 do
									(
										meshop.setNumMaps msh 6 keep: true
										for i = 1 to UV5_array2.count do
										( meshop.setMapVert msh 5 i UV5_array2[i] )
									)
								)
								if UVLayers == 2 do
								(
									if UV2_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 2" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV2_array2.count do setTVert msh j UV2_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
									if UV3_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 3" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV3_array2.count do setTVert msh j UV3_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
									if UV4_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 4" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV4_array2.count do setTVert msh j UV4_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
									if UV5_array2.count > 0 do
									(
										local PolyMat = standardMaterial()
										PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
										PolyMat.showinviewport = true
										PolyMat.twosided = false
										if TexFormat == 1 then
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										)
										else
										(
											if TexPath == 1 then
											( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											else
											( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										)
										tm.alphasource = 0
										PolyMat.diffuseMap = tm
										PolyMat.opacityMap = tm
										PolyMat.opacityMap.monoOutput = 1
										msh = mesh vertices: Vert_array2 faces: Face_array3
										msh.numTVerts = Vert_array2.count
										if VertColors == true then
										(
											setNumCPVVerts msh msh.numTVerts
											setCVertMode msh true
											setShadeCVerts msh true
										)
										defaultVCFaces msh
										buildTVFaces msh
										msh.name = ( h as string + " Layer 5" )
										msh.material = PolyMat
										if VertColors == true then
										(
											for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
											for j = 1 to Alpha_array2.count do
											( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
										)
										for j = 1 to UV5_array2.count do setTVert msh j UV5_array2[j]
										for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
										max modify mode
										select msh
										for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
										addmodifier msh ( Edit_Normals() ) ui: off
										msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
										EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
										EN_setNormal = msh.Edit_Normals.SetNormal
										normID = #{}
										for v = 1 to Normal_array2.count do
										(
											free normID
											EN_convertVS #{v} &normID
											for id in normID do EN_setNormal id Normal_array2[v]
										)
										if BoneCount != 0 and B1_array.count > 0 do
										(
											skinMod = skin()
											boneIDMap = #()
											addModifier msh skinMod
											for i = 1 to BoneCount do
											(
												maxbone = getnodebyname BoneSetup[i].name
												if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
											)
											local numSkinBones = skinOps.GetNumberBones skinMod
											for i = 1 to numSkinBones do
											(
												local boneName = skinOps.GetBoneName skinMod i 0
												for j = 1 to BoneCount do
												(
													if boneName == BoneSetup[j].Name then
													(
														boneIDMap[j] = i
														j = BoneCount + 1
													)
												)
											)
											modPanel.setCurrentObject skinMod
											for i = 1 to Vert_array2.count do
											(
												skinOps.SetVertexWeights skinMod i 1 1
												skinOps.unnormalizeVertex skinMod i true
												skinOps.SetVertexWeights skinMod i 1 0
											)
											skinOps.RemoveZeroWeights skinMod
											for i = 1 to Vert_array2.count do
											( skinOps.unnormalizeVertex skinMod i false )
											for i = 1 to Weight_array2.count do
											(
												w = Weight_array2[i]
												bi = #()
												wv = #()
												for j = 1 to w.boneids.count do
												(
													boneid = w.boneids[j]
													weight = w.weights[j]
													append bi boneIDMap[boneid]
													append wv weight
												)
												skinOps.ReplaceVertexWeights skinMod i bi wv
											)
										)
									)
								)
							)
							fclose f
						)
						( VerNum == 25 ):(
							Face_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							UV2_array = #()
							UV3_array = #()
							UV4_array = #()
							UV5_array = #()
							UV6_array = #()
							B1_array = #()
							W1_array = #()
							Color_array = #()
							Alpha_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							MatHash_array = #()
							TexName_array = #()
							struct Polygon_Info_Struct
							(
								VertexStart,
								VertexMin,
								VertexMax,
								PolygonStart,
								PolygonCount,
								FacePointCount,
								MatNum,
								BoneSetNum,
								LODNum
							)
							fseek f 0x0 #seek_set
							MVS5 = readlong f #unsigned
							fseek f 0x0 #seek_set
							if MVS5 == 1297307189 do
							(
								fseek f 0x04 #seek_cur
								filesize = readlong f #unsigned
								fseek f 0x08 #seek_cur
								headerthing = readlong f #unsigned
								for v = 1 to headerthing do
								( fseek f 0x0C #seek_cur )
							)
							nameheaderlength = readlong f #unsigned
							namelength = readlong f #unsigned
							name = ReadFixedString f namelength
							printDebug ( "Model information start = " + ( ftell f as string ) )
							fseek f 0x05 #seek_cur
							printDebug ( "Material information start = " + ( ftell f as string ) )
							matcount = readlong f #unsigned
							for x = 1 to matcount do
							(
								printDebug ( "Material #" + x as string + " start = " + ( ftell f as string ) )
								MatHash2 = readlong f #unsigned
								MatHash1 = readlong f #unsigned
								UnkHash2 = readlong f #unsigned
								UnkHash1 = readlong f #unsigned
								MatHeaderSize = ( ftell f ) + ( readlong f #unsigned )
								fseek f 0x30 #seek_cur
								TexHash2 = readlong f #unsigned
								TexHash1 = readlong f #unsigned
								TexDifName = bit.intAsHex ( TexHash1 ) as string
								for y = 1 to TexHash_array.count do
								(
									if TexHash1 == TexHash_array[y].TexHash1 and TexHash2 == TexHash_array[y].TexHash2 do
									( TexDifName = TexHash_array[y].TexString )
								)
								append MatHash_array ( MatHash_Struct MatHash1: MatHash1 MatHash2: MatHash2 TexDifName: TexDifName )
								fseek f MatHeaderSize #seek_set
							)
							printDebug ( "Model information start = " + ( ftell f as string ) )
							unknown = readlong f #unsigned
							header3size = ( readlong f #unsigned - 4 )
							facedatastart = ( ftell f ) + header3size
							printDebug ( "LOD information start = " + ( ftell f as string ) )
							header3asize = ( readlong f #unsigned - 4 ) + ( ftell f )
							header3acount = readlong f #unsigned
							printDebug ( "Count = " + header3acount as string )
							for y = 1 to header3acount do
							(
								printDebug ( "Header 3A Sub start = " + ( ftell f as string ) )
								head3asubsize = ( readlong f #unsigned - 4 )
								polytotal = readlong f #unsigned
								printDebug ( "Count = " + polytotal as string )
								for x = 1 to polytotal do
								(
									boundingminx = readfloat f
									boundingminy = readfloat f
									boundingminz = readfloat f
									boundingmaxx = readfloat f
									boundingmaxy = readfloat f
									boundingmaxz = readfloat f
									headerlength = readlong f #unsigned
									unkfloat1 = readfloat f
									unkfloat2 = readfloat f
									unkfloat3 = readfloat f
									unkfloat4 = readfloat f
									unknown1 = readlong f #unsigned
									VertexStart = 0
									VertexMin = readlong f #unsigned + 1
									VertexMax = readlong f #unsigned + 1
									FacepointStart = readlong f #unsigned
									PolygonStart = ( FacepointStart / 3 ) + 1
									PolygonCount = readlong f #unsigned
									FacepointCount = PolygonCount * 3
									headerlength2 = readlong f #unsigned
									if headerlength2 == 0x10 do
									(
										unknown2A = readlong f #unsigned
										unknown2B = readlong f #unsigned
									)
									unknown2 = readlong f #unsigned
									MatNum = readlong f #unsigned + 1
									BoneSetNum = readlong f #unsigned + 1
									unknown3 = readlong f #unsigned
									if y == 1 do
									( append PolyStruct_array ( Polygon_Info_Struct VertexStart: VertexStart VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum BoneSetNum: BoneSetNum LODNum: y ) )
									if y > 1 and LODs == true do
									( append PolyStruct_array ( Polygon_Info_Struct VertexStart: VertexStart VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum BoneSetNum: BoneSetNum LODNum: y ) )
									printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
									printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
									printDebug ( "VertMin = " + VertexMin as string + ", VertMax = " + VertexMax as string + ", PolyStart = " + PolygonStart as string + ", PolyCount = " + PolygonCount as string + ", FacePointCount = " + FacePointCount as string + ", MatNum = " + MatNum as string + ", BoneSet = " + BoneSetNum as string )
									printDebug ( "Unknowns = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								)
								printDebug ( "Header 3A Footer start = " + ( ftell f as string ) )
								unknown1 = ( readlong f #unsigned - 4 )
								unknown2 = readlong f #unsigned
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								unknown3 = ( readlong f #unsigned - 4 )
								unkfloat5 = readfloat f
								unkfloat6 = readfloat f
								unkfloat7 = readfloat f
								unkfloat8 = readfloat f
								blank1 = readlong f #unsigned
								blank2 = readlong f #unsigned
							)
							printDebug ( "Header 3B start = " + ( ftell f as string ) )
							header3bsize = ( readlong f #unsigned - 4 )
							header3bcount = readlong f #unsigned
							printDebug ( "Count = " + header3bcount as string )
							for x = 1 to header3bcount do
							(
								printDebug ( "Header 3B start = " + ( ftell f as string ) )
								blank = readlong f #unsigned
								unknown1 = readlong f #unsigned
								unkhash1 = readlong f #unsigned
								unkhash2 = readlong f #unsigned
								unkhash3 = readlong f #unsigned
								unkhash4 = readlong f #unsigned
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readfloat f
								unkfloat5 = readfloat f
								unkfloat6 = readfloat f
								unknown2 = readlong f #unsigned
								unkfloat9 = readfloat f
								unkfloat10 = readfloat f
								unkfloat11 = readfloat f
								unkfloat12 = readfloat f
								unknown3 = readlong f #unsigned
								unknown4 = readlong f #unsigned
							)
							printDebug ( "Header 3C (Material Pairing) start = " + ( ftell f as string ) )
							MatGroupHeadSize = ( readlong f #unsigned - 4 )
							MatGroupCount = readlong f #unsigned
							printDebug ( "Count = " + MatGroupCount as string )
							for x = 1 to MatGroupCount do
							(
								MatSectLength = readlong f #unsigned
								MatHash2 = readlong f #unsigned
								MatHash1 = readlong f #unsigned
								MatUnkHash2 = readlong f #unsigned
								MatUnkHash1 = readlong f #unsigned
								MatFloatA = readfloat f
								MatFloatB = readfloat f
								MatFloatC = readfloat f
								MatFloatD = readfloat f
								MatFloatE = readfloat f
								MatFloatF = readfloat f
								MatSubHeaderLen = readlong f #unsigned
								MatSubFloatA = readfloat f
								MatSubFloatB = readfloat f
								MatSubFloatC = readfloat f
								MatSubFloatD = readfloat f
								MatUnk = readlong f #unsigned
								for y = 1 to MatHash_array.count do
								(
									if MatHash1 == MatHash_array[y].MatHash1 and MatHash2 == MatHash_array[y].MatHash2 do
									(
										TexName = MatHash_array[y].TexDifName
										append TexName_array TexName
									)
								)
							)
							printDebug ( "Header 3D start = " + ( ftell f as string ) )
							header3dsize = ( readlong f #unsigned - 4 )
							header3dcount = readlong f #unsigned
							printDebug ( "Count = " + header3dcount as string )
							for x = 1 to header3dcount do
							(
								unknownlength = readlong f #unsigned
								unkhash1 = readlong f #unsigned
								unkhash2 = readlong f #unsigned
								unknown = readlong f #unsigned
							)
							printDebug ( "Header 3E (Bone IDs) start = " + ( ftell f as string ) )
							IDHeaderLength = ( readlong f #unsigned - 4 )
							BoneIDSets = readlong f #unsigned
							printDebug ( "Count = " + BoneIDSets as string )
							for b = 1 to BoneIDSets do
							(
								append BoneIDOffset_Array ( ftell f )
								boneidtotal = readlong f #unsigned
								printDebug ( "Count B = " + boneidtotal as string )
								for x = 1 to boneidtotal do
								(
									properid1 = readlong f #unsigned
									properid2 = readlong f #unsigned
									unkfloat1 = readfloat f
									unkfloat2 = readfloat f
									unkfloat3 = readfloat f
									unkfloat4 = readfloat f
									unkfloat5 = readfloat f
									unkfloat6 = readfloat f
									headerlength = readlong f #unsigned
									unkfloat7 = readfloat f
									unkfloat8 = readfloat f
									unkfloat9 = readfloat f
									unkfloat10 = readfloat f
									unknown = readlong f #unsigned
									printDebug ( "Values = 0x" + ( ( bit.intAsHex ( properid1 ) ) as string ) + ", 0x" + ( ( bit.intAsHex ( properid2 ) ) as string ) + ", " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string + ", " + unkfloat5 as string + ", " + unkfloat6 as string + ", " + unkfloat7 as string + ", " + unkfloat8 as string + ", " + unkfloat9 as string + ", " + unkfloat10 as string )
								)
							)
							printDebug ( "Header 3F start = " + ( ftell f as string ) )
							header3fsize = ( readlong f #unsigned - 4 )
							fseek f header3fsize #seek_cur
							printDebug ( "Header 3G start = " + ( ftell f as string ) )
							header3gsize = ( readlong f #unsigned - 4 )
							fseek f header3gsize #seek_cur
							printDebug ( "Header 3H start = " + ( ftell f as string ) )
							unknown1 = ( readlong f #unsigned - 4 )
							unknown2 = readlong f #unsigned
							boundingminx = readfloat f
							boundingminy = readfloat f
							boundingminz = readfloat f
							boundingmaxx = readfloat f
							boundingmaxy = readfloat f
							boundingmaxz = readfloat f
							unknown3 = ( readlong f #unsigned - 4 )
							unkfloat1 = readfloat f
							unkfloat2 = readfloat f
							unkfloat3 = readfloat f
							unkfloat4 = readfloat f
							blank1 = readlong f #unsigned
							unkhash1 = readlong f #unsigned
							unkhash2 = readlong f #unsigned
							printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
							printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
							printDebug ( "Header 3H-2 (UV Clamps) start = " + ( ftell f as string ) )
							vertcount = readlong f #unsigned
							unkcount1 = readlong f #unsigned
							UVLayerCount = readlong f #unsigned
							printDebug ( "Count = " + unkcount1 as string + ", " + UVLayerCount as string )
							UV1XMult = 1
							UV1YMult = 1
							UV1XStart = 0
							UV1YStart = 0
							UV2XMult = 1
							UV2YMult = 1
							UV2XStart = 0
							UV2YStart = 0
							UV3XMult = 1
							UV3YMult = 1
							UV3XStart = 0
							UV3YStart = 0
							UV4XMult = 1
							UV4YMult = 1
							UV4XStart = 0
							UV4YStart = 0
							UV5XMult = 1
							UV5YMult = 1
							UV5XStart = 0
							UV5YStart = 0
							UV6XMult = 1
							UV6YMult = 1
							UV6XStart = 0
							UV6YStart = 0
							for x = 1 to UVLayerCount do
							(
								UVLayer = readlong f #unsigned + 1
								UVXMult = readfloat f
								UVYMult = readfloat f
								UVXStart = readfloat f
								UVYStart = readfloat f
								if UVLayer == 1 do
								(
									UV1XMult = UVXMult
									UV1YMult = UVYMult
									UV1XStart = UVXStart
									UV1YStart = UVYStart
								)
								if UVLayer == 2 do
								(
									UV2XMult = UVXMult
									UV2YMult = UVYMult
									UV2XStart = UVXStart
									UV2YStart = UVYStart
								)
								if UVLayer == 3 do
								(
									UV3XMult = UVXMult
									UV3YMult = UVYMult
									UV3XStart = UVXStart
									UV3YStart = UVYStart
								)
								if UVLayer == 4 do
								(
									UV4XMult = UVXMult
									UV4YMult = UVYMult
									UV4XStart = UVXStart
									UV4YStart = UVYStart
								)
								if UVLayer == 5 do
								(
									UV5XMult = UVXMult
									UV5YMult = UVYMult
									UV5XStart = UVXStart
									UV5YStart = UVYStart
								)
								if UVLayer == 6 do
								(
									UV6XMult = UVXMult
									UV6YMult = UVYMult
									UV6XStart = UVXStart
									UV6YStart = UVYStart
								)
								printDebug ( "X Multiply = " + UVXMult as string + ", Y Multiply = " + UVYMult as string + ", X Start = " + UVXStart as string + ", Y Start = " + UVYStart as string + ", Layer = " + UVLayer as string )
							)
							HasVertex = 0
							VertexFmt = 0
							HasNormals = 0
							NormalsFmt = 0
							HasBinormals = 0
							BinormalsFmt = 0
							HasTangents = 0
							TangentsFmt = 0
							HasWeights = 0
							WeightsFmt = 0
							HasBones = 0
							BonesFmt = 0
							HasColors = 0
							ColorsFmt = 0
							HasColors2 = 0
							Colors2Fmt = 0
							HasUV1 = 0
							UV1Fmt = 0
							HasUV2 = 0
							UV2Fmt = 0
							HasUV3 = 0
							UV3Fmt = 0
							HasUV4 = 0
							UV4Fmt = 0
							HasUV5 = 0
							UV5Fmt = 0
							HasUV6 = 0
							UV6Fmt = 0
							printDebug ( "Header 3H-3 (Vertex Buffer) start = " + ( ftell f as string ) )
							unknown = readlong f #unsigned
							unknown2 = readlong f #unsigned
							unknown3 = readlong f #unsigned
							BufferCount = readlong f #unsigned
							printDebug ( "Count = " + BufferCount as string )
							if BufferCount != undefined do
							(
								for x = 1 to BufferCount do
								(
									VertType = readlong f #unsigned + 1
									VertFormat = readlong f #unsigned + 1
									VertLayer = readlong f #unsigned + 1
									VertBuffNum = readlong f #unsigned + 1
									VertOffset = readlong f #unsigned + 1
									printDebug ( "Vertex Type = " + VertType as string + ", Format = " + VertFormat as string + ", Layer = " + VertLayer as string + ", Buffer = " + VertBuffNum as string + ", Offset = " + VertOffset as string )
									case of
									(
										default:( throw ( "Unexpected combination!" ) )
										( VertType == 1 ):(
											HasVertex = VertBuffNum
											VertexFmt = VertFormat
										)
										( VertType == 2 and VertLayer == 1 ):(
											HasNormals = VertBuffNum
											NormalsFmt = VertFormat
										)
										( VertType == 2 and VertLayer == 2 ):(
											HasBinormals = VertBuffNum
											BinormalsFmt = VertFormat
										)
										( VertType == 3 ):(
											HasTangents = VertBuffNum
											TangentsFmt = VertFormat
										)
										( VertType == 4 ):(
											HasWeights = VertBuffNum
											WeightsFmt = VertFormat
										)
										( VertType == 5 ):(
											HasBones = VertBuffNum
											BonesFmt = VertFormat
										)
										( VertType == 6 and VertLayer == 1 ):(
											HasColors = VertBuffNum
											ColorsFmt = VertFormat
										)
										( VertType == 6 and VertLayer == 2 ):(
											HasColors2 = VertBuffNum
											Colors2Fmt = VertFormat
										)
										( VertType == 7 and VertLayer == 1 ):(
											HasUV1 = VertBuffNum
											UV1Fmt = VertFormat
										)
										( VertType == 7 and VertLayer == 2 ):(
											HasUV2 = VertBuffNum
											UV2Fmt = VertFormat
										)
										( VertType == 7 and VertLayer == 3 ):(
											HasUV3 = VertBuffNum
											UV3Fmt = VertFormat
										)
										( VertType == 7 and VertLayer == 4 ):(
											HasUV4 = VertBuffNum
											UV4Fmt = VertFormat
										)
										( VertType == 7 and VertLayer == 5 ):(
											HasUV5 = VertBuffNum
											UV5Fmt = VertFormat
										)
										( VertType == 7 and VertLayer == 6 ):(
											HasUV6 = VertBuffNum
											UV6Fmt = VertFormat
										)
									)
									
									
								)
								bytepad = readbyte f #unsigned
								printDebug ( "Header 3I-1 (Polygon Count) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unknown3 = readlong f #unsigned
								facecount = readlong f #unsigned
								facelength = readlong f #unsigned
								printDebug ( "Face length = 0x" + ( ( bit.intAsHex ( facelength ) ) as string ) )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								printDebug ( "Header 3I-2 (Vertex Information) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unknown3 = readlong f #unsigned
								vertcount = readlong f #unsigned
								vertlength = readlong f #unsigned
								printDebug ( "Vertex length = 0x" + ( ( bit.intAsHex ( vertlength ) ) as string ) )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								printDebug ( "Header 3I-3 (Normal Information) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unknown3 = readlong f #unsigned
								normalscount = readlong f #unsigned
								normalslength = readlong f #unsigned
								printDebug ( "Normals length = 0x" + ( ( bit.intAsHex ( normalslength ) ) as string ) )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								printDebug ( "Header 3I-4 (UV Information) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unknown3 = readlong f #unsigned
								uvcount = readlong f #unsigned
								uvlength = readlong f #unsigned
								printDebug ( "UV length = 0x" + ( ( bit.intAsHex ( uvlength ) ) as string ) )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								fseek f facedatastart #seek_set
								printDebug ( "Face start = " + ( ftell f as string ) )
								for x = 1 to facecount / 3 do
								(
									fa = readshort f #unsigned + 1
									fb = readshort f #unsigned + 1
									fc = readshort f #unsigned + 1
									append Face_array [fa, fb, fc]
								)
								printDebug ( "Vertex start = " + ( ftell f as string ) )
								for x = 1 to vertcount do
								(
									Weight1 = 1
									Weight2 = 0
									Weight3 = 0
									Weight4 = 0
									Bone1 = 1
									Bone2 = 1
									Bone3 = 1
									Bone4 = 1
									if HasVertex == 1 do
									(
										case of
										(
											default:( throw ( "Unknown positions format!" ) )
											( VertexFmt == 3 ):(
												vx = readfloat f * ModelScale
												vy = readfloat f * ModelScale
												vz = readfloat f * ModelScale
											)
										)
										
										
									)
									if HasWeights == 1 do
									(
										case of
										(
											default:( throw ( "Unknown weights format!" ) )
											( WeightsFmt == 21 ):(
												Weight1 = ( readshort f as float / 32767 )
												Weight2 = ( readshort f as float / 32767 )
												Weight3 = ( readshort f as float / 32767 )
												Weight4 = ( readshort f as float / 32767 )
											)
										)
										
										
									)
									if HasBones == 1 do
									(
										case of
										(
											default:( throw ( "Unknown bones format!" ) )
											( BonesFmt == 24 ):(
												Bone1 = readbyte f #unsigned / 3
												Bone2 = readbyte f #unsigned / 3
												Bone3 = readbyte f #unsigned / 3
												Bone4 = readbyte f #unsigned / 3
											)
										)
										
										
									)
									append Vert_array [vx, vy, vz]
									append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
									append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
								)
								printDebug ( "Normals start = " + ( ftell f as string ) )
								for x = 1 to normalscount do
								(
									if HasNormals == 2 do
									(
										case of
										(
											default:( throw ( "Unknown normals format!" ) )
											( NormalsFmt == 21 ):(
												nx = readshort f as float / 32767
												ny = readshort f as float / 32767
												nz = readshort f as float / 32767
												nq = readshort f as float / 32767
												append Normal_array [nx, ny, nz]
											)
										)
										
										
									)
									if HasBinormals == 2 do
									(
										case of
										(
											default:( throw ( "Unknown binormals format!" ) )
											( BinormalsFmt == 21 ):(
												nx2 = readshort f as float / 32767
												ny2 = readshort f as float / 32767
												nz2 = readshort f as float / 32767
												nq2 = readshort f as float / 32767
											)
										)
										
										
									)
								)
								printDebug ( "UV start = " + ( ftell f as string ) )
								for x = 1 to uvcount do
								(
									colorr = 255
									colorg = 255
									colorb = 255
									colora = 1
									tu = 0
									tv = 0
									if HasTangents == 3 do
									(
										case of
										(
											default:( throw ( "Unknown tangents format!" ) )
											( TangentsFmt == 21 ):(
												nx3 = readshort f as float / 32767
												ny3 = readshort f as float / 32767
												nz3 = readshort f as float / 32767
												nq3 = readshort f as float / 32767
											)
										)
										
										
									)
									if HasUV6 == 3 do
									(
										case of
										(
											default:( throw ( "Unknown UV6 format!" ) )
											( UV6Fmt == 2 ):(
												tu6 = readfloat f
												tv6 = ( ( readfloat f ) * -1 ) + 1
												append UV6_array [tu6, tv6, 0]
											)
											( UV6Fmt == 19 ):(
												tu6 = ( ( readshort f as float / 32767 ) * UV6XMult ) + UV6XStart
												tv6 = ( ( ( ( readshort f as float / 32767 ) * UV6YMult ) + UV6YStart ) * -1 ) + 1
												append UV6_array [tu6, tv6, 0]
											)
										)
										
										
									)
									if HasUV5 == 3 do
									(
										case of
										(
											default:( throw ( "Unknown UV5 format!" ) )
											( UV5Fmt == 2 ):(
												tu5 = readfloat f
												tv5 = ( ( readfloat f ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
											( UV5Fmt == 19 ):(
												tu5 = ( ( readshort f as float / 32767 ) * UV5XMult ) + UV5XStart
												tv5 = ( ( ( ( readshort f as float / 32767 ) * UV5YMult ) + UV5YStart ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
										)
										
										
									)
									if HasColors == 3 do
									(
										case of
										(
											default:( throw ( "Unknown colors format!" ) )
											( ColorsFmt == 26 ):(
												colorr = readbyte f #unsigned
												colorg = readbyte f #unsigned
												colorb = readbyte f #unsigned
												colora = ( readbyte f #unsigned as float ) / 255
											)
										)
										
										
									)
									if HasColors2 == 3 do
									(
										case of
										(
											default:( throw ( "Unknown colors2 format!" ) )
											( Colors2Fmt == 26 ):(
												colorr2 = readbyte f #unsigned
												colorg2 = readbyte f #unsigned
												colorb2 = readbyte f #unsigned
												colora2 = ( readbyte f #unsigned as float ) / 255
											)
										)
										
										
									)
									if HasUV1 == 3 do
									(
										case of
										(
											default:( throw ( "Unknown UV1 format!" ) )
											( UV1Fmt == 2 ):(
												tu = readfloat f
												tv = ( ( readfloat f ) * -1 ) + 1
											)
											( UV1Fmt == 19 ):(
												tu = ( ( readshort f as float / 32767 ) * UV1XMult ) + UV1XStart
												tv = ( ( ( ( readshort f as float / 32767 ) * UV1YMult ) + UV1YStart ) * -1 ) + 1
											)
										)
										
										
									)
									if HasUV2 == 3 do
									(
										case of
										(
											default:( throw ( "Unknown UV2 format!" ) )
											( UV2Fmt == 2 ):(
												tu2 = readfloat f
												tv2 = ( ( readfloat f ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
											( UV2Fmt == 19 ):(
												tu2 = ( ( readshort f as float / 32767 ) * UV2XMult ) + UV2XStart
												tv2 = ( ( ( ( readshort f as float / 32767 ) * UV2YMult ) + UV2YStart ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
										)
										
										
									)
									if HasUV3 == 3 do
									(
										case of
										(
											default:( throw ( "Unknown UV3 format!" ) )
											( UV3Fmt == 2 ):(
												tu3 = readfloat f
												tv3 = ( ( readfloat f ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
											( UV3Fmt == 19 ):(
												tu3 = ( ( readshort f as float / 32767 ) * UV3XMult ) + UV3XStart
												tv3 = ( ( ( ( readshort f as float / 32767 ) * UV3YMult ) + UV3YStart ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
										)
										
										
									)
									if HasUV4 == 3 do
									(
										case of
										(
											default:( throw ( "Unknown UV4 format!" ) )
											( UV4Fmt == 2 ):(
												tu4 = readfloat f
												tv4 = ( ( readfloat f ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
											( UV4Fmt == 19 ):(
												tu4 = ( ( readshort f as float / 32767 ) * UV4XMult ) + UV4XStart
												tv4 = ( ( ( ( readshort f as float / 32767 ) * UV4YMult ) + UV4YStart ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
										)
										
										
									)
									append UV_array [tu, tv, 0]
									append Color_array [colorr, colorg, colorb]
									append Alpha_array colora
								)
								printDebug ( "End of file = " + ( ftell f as string ) )
								printDebug ( PolyStruct_array )
								for i = 1 to PolyStruct_array.count do
								(
									ProperBoneID_array = #()
									FixedBoneID_array = #()
									ActualB1_array = #()
									Weight_array = #()
									Weight_array2 = #()
									Face_array2 = #()
									Face_array3 = #()
									Vert_array2 = #()
									Normal_array2 = #()
									Color_array2 = #()
									Alpha_array2 = #()
									UV_array2 = #()
									UV2_array2 = #()
									UV3_array2 = #()
									UV4_array2 = #()
									UV5_array2 = #()
									UV6_array2 = #()
									if BoneCount != 0 and B1_array.count > 0 do
									(
										fseek f BoneIDOffset_array[1 * PolyStruct_array[i].BoneSetNum] #seek_set
										boneidtotal = readlong f #unsigned
										ProperBoneID_array = #()
										for y = 1 to boneidtotal do
										(
											BoneHash2 = readlong f #unsigned
											BoneHash1 = readlong f #unsigned
											unkfloat1 = readfloat f
											unkfloat2 = readfloat f
											unkfloat3 = readfloat f
											unkfloat4 = readfloat f
											unkfloat5 = readfloat f
											unkfloat6 = readfloat f
											headerlength = readlong f #unsigned
											unkfloat7 = readfloat f
											unkfloat8 = readfloat f
											unkfloat9 = readfloat f
											unkfloat10 = readfloat f
											unknown = readlong f #unsigned
											BoneName = ( "0x" + bit.intAsHex ( BoneHash1 ) as string )
											for z = 1 to BoneHash_array.count do
											(
												if BoneHash1 == BoneHash_array[z].BoneHash1 and BoneHash2 == BoneHash_array[z].BoneHash2 do
												( BoneName = BoneHash_array[z].BoneString )
											)
											append ProperBoneID_array BoneName
										)
										for a = 1 to boneidtotal do
										(
											for b = 1 to BoneCount do
											(
												if ProperBoneID_array[a] == BoneName_array[b] do
												( append FixedBoneID_array b )
											)
										)
										for x = 1 to B1_array.count do
										(
											ImproperBone1 = B1_array[x].Bone1
											ImproperBone2 = B1_array[x].Bone2
											ImproperBone3 = B1_array[x].Bone3
											ImproperBone4 = B1_array[x].Bone4
											ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
											ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
											ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
											ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
											if ProperBone1 == undefined do
											( ProperBone1 = 1 )
											if ProperBone2 == undefined do
											( ProperBone2 = 1 )
											if ProperBone3 == undefined do
											( ProperBone3 = 1 )
											if ProperBone4 == undefined do
											( ProperBone4 = 1 )
											append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
										)
										for b = 1 to W1_array.count Do
										(
											w = ( weight_data boneids: #() weights: #() )
											maxweight = 0
											if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
											if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
											if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
											if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
											if ( maxweight != 0 ) then
											(
												if ( W1_array[b].Weight1 != 0 ) then
												(
													w1 = W1_array[b].Weight1 as float
													append w.boneids ( ActualB1_array[b].Bone1 )
													append w.weights ( w1 )
												)
												if ( W1_array[b].Weight2 != 0 ) then
												(
													w2 = W1_array[b].Weight2 as float
													append w.boneids ( ActualB1_array[b].Bone2 )
													append w.weights ( w2 )
												)
												if ( W1_array[b].Weight3 != 0 ) then
												(
													w3 = W1_array[b].Weight3 as float
													append w.boneids ( ActualB1_array[b].Bone3 )
													append w.weights ( w3 )
												)
												if ( W1_array[b].Weight4 != 0 ) then
												(
													w4 = W1_array[b].Weight4 as float
													append w.boneids ( ActualB1_array[b].Bone4 )
													append w.weights ( w4 )
												)
											)
											append Weight_array w
										)
									)
									for y = PolyStruct_array[i].PolygonStart to ( PolyStruct_array[i].PolygonCount + PolyStruct_array[i].PolygonStart ) do
									( append Face_array2 Face_array[y] )
									VertexMin = PolyStruct_array[i].VertexMin + PolyStruct_array[i].VertexStart
									VertexMax = PolyStruct_array[i].VertexMax + PolyStruct_array[i].VertexStart
									for x = VertexMin to VertexMax do
									(
										append Vert_array2 Vert_array[x]
										append Normal_array2 Normal_array[x]
										append Color_array2 Color_array[x]
										append Alpha_array2 Alpha_array[x]
										append UV_array2 UV_array[x]
										if UV2_array.count > 0 do
										( append UV2_array2 UV2_array[x] )
										if UV3_array.count > 0 do
										( append UV3_array2 UV3_array[x] )
										if UV4_array.count > 0 do
										( append UV4_array2 UV4_array[x] )
										if UV5_array.count > 0 do
										( append UV5_array2 UV5_array[x] )
										if UV6_array.count > 0 do
										( append UV6_array2 UV6_array[x] )
										append Weight_array2 Weight_array[x]
									)
									for x = 1 to PolyStruct_array[i].PolygonCount do
									(
										Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
										append Face_array3 Faces3
									)
									local PolyMat = standardMaterial()
									PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
									PolyMat.showinviewport = true
									PolyMat.twosided = false
									if TexFormat == 1 then
									(
										if TexPath == 1 then
										( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										else
										( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
									)
									else
									(
										if TexPath == 1 then
										( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										else
										( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
									)
									tm.alphasource = 0
									PolyMat.diffuseMap = tm
									PolyMat.opacityMap = tm
									PolyMat.opacityMap.monoOutput = 1
									msh = mesh vertices: Vert_array2 faces: Face_array3
									msh.numTVerts = Vert_array2.count
									if VertColors == true then
									(
										setNumCPVVerts msh msh.numTVerts
										setCVertMode msh true
										setShadeCVerts msh true
									)
									defaultVCFaces msh
									buildTVFaces msh
									if PolyStruct_array[i].LODNum == 1 do
									( msh.name = ( h as string ) )
									if PolyStruct_array[i].LODNum != 1 do
									( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ")" ) )
									msh.material = PolyMat
									if VertColors == true then
									(
										for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
										for j = 1 to Alpha_array2.count do
										( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
									)
									for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
									for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
									max modify mode
									select msh
									for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
									addmodifier msh ( Edit_Normals() ) ui: off
									msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
									EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
									EN_setNormal = msh.Edit_Normals.SetNormal
									normID = #{}
									for v = 1 to Normal_array2.count do
									(
										free normID
										EN_convertVS #{v} &normID
										for id in normID do EN_setNormal id Normal_array2[v]
									)
									if BoneCount != 0 and B1_array.count > 0 do
									(
										skinMod = skin()
										boneIDMap = #()
										addModifier msh skinMod
										for i = 1 to BoneCount do
										(
											maxbone = getnodebyname BoneSetup[i].name
											if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
										)
										local numSkinBones = skinOps.GetNumberBones skinMod
										for i = 1 to numSkinBones do
										(
											local boneName = skinOps.GetBoneName skinMod i 0
											for j = 1 to BoneCount do
											(
												if boneName == BoneSetup[j].Name then
												(
													boneIDMap[j] = i
													j = BoneCount + 1
												)
											)
										)
										modPanel.setCurrentObject skinMod
										for i = 1 to Vert_array2.count do
										(
											skinOps.SetVertexWeights skinMod i 1 1
											skinOps.unnormalizeVertex skinMod i true
											skinOps.SetVertexWeights skinMod i 1 0
										)
										skinOps.RemoveZeroWeights skinMod
										for i = 1 to Vert_array2.count do
										( skinOps.unnormalizeVertex skinMod i false )
										for i = 1 to Weight_array2.count do
										(
											w = Weight_array2[i]
											bi = #()
											wv = #()
											for j = 1 to w.boneids.count do
											(
												boneid = w.boneids[j]
												weight = w.weights[j]
												append bi boneIDMap[boneid]
												append wv weight
											)
											skinOps.ReplaceVertexWeights skinMod i bi wv
										)
									)
									if UVLayers == 1 do
									(
										if UV2_array2.count > 0 do
										(
											meshop.setNumMaps msh 3 keep: true
											for i = 1 to UV2_array2.count do
											( meshop.setMapVert msh 2 i UV2_array2[i] )
										)
										if UV3_array2.count > 0 do
										(
											meshop.setNumMaps msh 4 keep: true
											for i = 1 to UV3_array2.count do
											( meshop.setMapVert msh 3 i UV3_array2[i] )
										)
										if UV4_array2.count > 0 do
										(
											meshop.setNumMaps msh 5 keep: true
											for i = 1 to UV4_array2.count do
											( meshop.setMapVert msh 4 i UV4_array2[i] )
										)
										if UV5_array2.count > 0 do
										(
											meshop.setNumMaps msh 6 keep: true
											for i = 1 to UV5_array2.count do
											( meshop.setMapVert msh 5 i UV5_array2[i] )
										)
										if UV6_array2.count > 0 do
										(
											meshop.setNumMaps msh 7 keep: true
											for i = 1 to UV6_array2.count do
											( meshop.setMapVert msh 6 i UV6_array2[i] )
										)
									)
									if UVLayers == 2 do
									(
										if UV2_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 2" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 2" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV2_array2.count do setTVert msh j UV2_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV3_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 3" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 3" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV3_array2.count do setTVert msh j UV3_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV4_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 4" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 4" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV4_array2.count do setTVert msh j UV4_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV5_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 5" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 5" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV5_array2.count do setTVert msh j UV5_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV6_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 6" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 6" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV6_array2.count do setTVert msh j UV6_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
									)
								)
							)
							fclose f
						)
						( VerNum == 33 or VerNum == 36 ):(
							Face_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							UV2_array = #()
							UV3_array = #()
							UV4_array = #()
							UV5_array = #()
							UV6_array = #()
							B1_array = #()
							W1_array = #()
							Color_array = #()
							Alpha_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							MatHash_array = #()
							TexName_array = #()
							struct Polygon_Info_Struct
							(
								VertexStart,
								VertexMin,
								VertexMax,
								PolygonStart,
								PolygonCount,
								FacePointCount,
								MatNum,
								BoneSetNum,
								LODNum
							)
							fseek f 0x0 #seek_set
							MVS6 = readlong f #unsigned
							fseek f 0x0 #seek_set
							if MVS6 == 1297307190 do
							(
								fseek f 0x04 #seek_cur
								filesize = readlong f #unsigned
								fseek f 0x08 #seek_cur
								headerthing = readlong f #unsigned
								for v = 1 to headerthing do
								( fseek f 0x0C #seek_cur )
							)
							nameheaderlength = readlong f #unsigned
							namelength = readlong f #unsigned
							name = ReadFixedString f namelength
							printDebug ( "Model information start = " + ( ftell f as string ) )
							fseek f 0x15 #seek_cur
							if VerNum == 36 do
							( fseek f 0x08 #seek_cur )
							printDebug ( "Material information start = " + ( ftell f as string ) )
							matcount = readlong f #unsigned
							for x = 1 to matcount do
							(
								printDebug ( "Material #" + x as string + " start = " + ( ftell f as string ) )
								MatHash2 = readlong f #unsigned
								MatHash1 = readlong f #unsigned
								UnkHash2 = readlong f #unsigned
								UnkHash1 = readlong f #unsigned
								MatHeaderSize = ( ftell f ) + ( readlong f #unsigned )
								MatUnk1 = readlong f #unsigned
								if MatUnk1 != 0x02 do
								( break() )
								MatUnk2 = readlong f #unsigned
								MatHeaderSizeB = readlong f #unsigned
								MatUnk3 = readlong f #unsigned
								if MatUnk3 != 0x01 do
								( break() )
								MatUnk3Hash2 = readlong f #unsigned
								MatUnk3Hash1 = readlong f #unsigned
								MatParamCount = readlong f #unsigned
								TexDifName = "null"
								for m = 1 to MatParamCount do
								(
									MatSectHash2 = bit.intAsHex ( readlong f #unsigned )
									MatSectHash1 = bit.intAsHex ( readlong f #unsigned )
									MatSectCount = readlong f #unsigned
									case of
									(
										default:( throw ( "Unknown material hashes!" ) )
										( MatSectHash1 == "0" and MatSectHash2 == "0" ):()
										( MatSectHash1 == "4f0234" and MatSectHash2 == "63d89fb0" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkHash4 = readlong f #unsigned
												MatUnkHash3 = readlong f #unsigned
											)
										)
										( MatSectHash1 == "bae4cbd7" and MatSectHash2 == "7f139a91" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat = readfloat f
											)
										)
										( MatSectHash1 == "9004c558" and MatSectHash2 == "7575d6c0" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkBytePad = readbyte f #unsigned
											)
										)
										( MatSectHash1 == "394c43af" and MatSectHash2 == "4ff52c94" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat1 = readfloat f
												MatUnkFloat2 = readfloat f
												MatUnkFloat3 = readfloat f
											)
										)
										( MatSectHash1 == "7bbca244" and MatSectHash2 == "e61f1a07" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat1 = readfloat f
												MatUnkFloat2 = readfloat f
											)
										)
										( MatSectHash1 == "c16762f7" and MatSectHash2 == "763d62ab" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat1 = readfloat f
												MatUnkFloat2 = readfloat f
												MatUnkFloat3 = readfloat f
												MatUnkFloat4 = readfloat f
											)
										)
										( MatSectHash1 == "52a09151" and MatSectHash2 == "f1c3f2c7" ):(
											for y = 1 to MatSectCount do
											(
												TypeHash2 = bit.intAsHex ( readlong f #unsigned )
												TypeHash1 = bit.intAsHex ( readlong f #unsigned )
												TexHash2 = readlong f #unsigned
												TexHash1 = readlong f #unsigned
												TexName = bit.intAsHex ( TexHash1 ) as string
												for y = 1 to TexHash_array.count do
												(
													if TexHash1 == TexHash_array[y].TexHash1 and TexHash2 == TexHash_array[y].TexHash2 do
													( TexName = TexHash_array[y].TexString )
												)
												if TypeHash1 == "8648fa82" and TypeHash2 == "d1dbee1a" do
												( TexDifName = TexName )
												printDebug ( TypeHash1 + " " + TypeHash2 as string + ": " + TexName )
											)
										)
										( MatSectHash1 == "e2ba743e" and MatSectHash2 == "952f9338" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkHash4 = readlong f #unsigned
												MatUnkHash3 = readlong f #unsigned
												MatUnkHash6 = readlong f #unsigned
												MatUnkHash5 = readlong f #unsigned
											)
										)
									)
									
									
								)
								append MatHash_array ( MatHash_Struct MatHash1: MatHash1 MatHash2: MatHash2 TexDifName: TexDifName )
								printDebug ( "-----" )
								fseek f MatHeaderSize #seek_set
							)
							printDebug ( "Model information start = " + ( ftell f as string ) )
							unknown = readlong f #unsigned
							header3size = ( readlong f #unsigned - 4 )
							facedatastart = ( ftell f ) + header3size
							printDebug ( "LOD information start = " + ( ftell f as string ) )
							header3asize = ( readlong f #unsigned - 4 ) + ( ftell f )
							header3acount = readlong f #unsigned
							printDebug ( "Count = " + header3acount as string )
							for y = 1 to header3acount do
							(
								printDebug ( "LOD # " + y as string + " information start = " + ( ftell f as string ) )
								head3asubsize = ( readlong f #unsigned - 4 )
								polytotal = readlong f #unsigned
								printDebug ( "Count = " + polytotal as string )
								for x = 1 to polytotal do
								(
									boundingminx = readfloat f
									boundingminy = readfloat f
									boundingminz = readfloat f
									boundingmaxx = readfloat f
									boundingmaxy = readfloat f
									boundingmaxz = readfloat f
									headerlength = readlong f #unsigned
									unkfloat1 = readfloat f
									unkfloat2 = readfloat f
									unkfloat3 = readfloat f
									unkfloat4 = readfloat f
									unknown1 = readlong f #unsigned
									VertexStart = 0
									VertexMin = readlong f #unsigned + 1
									VertexMax = readlong f #unsigned + 1
									FacepointStart = readlong f #unsigned
									PolygonStart = ( FacepointStart / 3 ) + 1
									PolygonCount = readlong f #unsigned
									FacepointCount = PolygonCount * 3
									headerlength2 = readlong f #unsigned
									if headerlength2 == 0x10 do
									(
										unknown2A = readlong f #unsigned
										unknown2B = readlong f #unsigned
									)
									unknown2 = readlong f #unsigned
									MatNum = readlong f #unsigned + 1
									BoneSetNum = readlong f #unsigned + 1
									unknown3 = readlong f #unsigned
									unknown4 = readlong f #unsigned
									if y == 1 do
									( append PolyStruct_array ( Polygon_Info_Struct VertexStart: VertexStart VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum BoneSetNum: BoneSetNum LODNum: y ) )
									if y > 1 and LODs == true do
									( append PolyStruct_array ( Polygon_Info_Struct VertexStart: VertexStart VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum BoneSetNum: BoneSetNum LODNum: y ) )
									printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
									printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
									printDebug ( "VertMin = " + VertexMin as string + ", VertMax = " + VertexMax as string + ", PolyStart = " + PolygonStart as string + ", PolyCount = " + PolygonCount as string + ", FacePointCount = " + FacePointCount as string + ", MatNum = " + MatNum as string + ", BoneSet = " + BoneSetNum as string )
									printDebug ( "Unknowns = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string + ", " + unknown4 as string )
								)
								if VerNum == 36 do
								(
									printDebug ( "Header 3A SubB start = " + ( ftell f as string ) )
									head3asubbsize = ( readlong f #unsigned - 4 )
									poly2total = readlong f #unsigned
									printDebug ( "Count = " + poly2total as string )
									for x = 1 to poly2total do
									(
										boundingminx = readfloat f
										boundingminy = readfloat f
										boundingminz = readfloat f
										boundingmaxx = readfloat f
										boundingmaxy = readfloat f
										boundingmaxz = readfloat f
										headerlength = readlong f #unsigned
										unkfloat1 = readfloat f
										unkfloat2 = readfloat f
										unkfloat3 = readfloat f
										unkfloat4 = readfloat f
										unknown1 = readlong f #unsigned
										VertexStart = 0
										VertexMin = readlong f #unsigned + 1
										VertexMax = readlong f #unsigned + 1
										FacepointStart = readlong f #unsigned
										PolygonStart = ( FacepointStart / 3 ) + 1
										PolygonCount = readlong f #unsigned
										FacepointCount = PolygonCount * 3
										headerlength2 = readlong f #unsigned
										if headerlength2 == 0x10 do
										(
											unknown2A = readlong f #unsigned
											unknown2B = readlong f #unsigned
										)
										unknown2 = readlong f #unsigned
										MatNum = readlong f #unsigned + 1
										BoneSetNum = readlong f #unsigned + 1
										unknown3 = readlong f #unsigned
										unknown4 = readlong f #unsigned
										printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
										printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
										printDebug ( "VertMin = " + VertexMin as string + ", VertMax = " + VertexMax as string + ", PolyStart = " + PolygonStart as string + ", PolyCount = " + PolygonCount as string + ", FacePointCount = " + FacePointCount as string + ", MatNum = " + MatNum as string + ", BoneSet = " + BoneSetNum as string )
										printDebug ( "Unknowns = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string + ", " + unknown4 as string )
									)
								)
								printDebug ( "Header 3A SubC start = " + ( ftell f as string ) )
								unknown1 = ( readlong f #unsigned - 4 )
								unknown2 = readlong f #unsigned
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								unknown3 = ( readlong f #unsigned - 4 )
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readfloat f
								blank1 = readlong f #unsigned
								unknown4 = readlong f #unsigned
								if VerNum == 36 do
								( unknown5 = readlong f #unsigned )
								blank2 = readlong f #unsigned
								printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
								printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
								printDebug ( "Values = " + unknown1 as string + ", 0x" + bit.intAsHex ( unknown2 ) as string + ", " + unknown4 as string + ", " + unknown5 as string )
								if VerNum == 36 do
								(
									printDebug ( "Header 3A SubD start = " + ( ftell f as string ) )
									header3subdsize = ( readlong f #unsigned - 4 )
									header3subdcount = readlong f #unsigned
									for y = 1 to header3subdcount do
									(
										unkhash1 = readlong f #unsigned
										unkhash2 = readlong f #unsigned
									)
								)
							)
							printDebug ( "Header 3B start = " + ( ftell f as string ) )
							header3bsize = ( readlong f #unsigned - 4 )
							header3bcount = readlong f #unsigned
							printDebug ( "Count = " + header3bcount as string )
							for x = 1 to header3bcount do
							(
								printDebug ( "Header 3B start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unkhash1 = readlong f #unsigned
								unkhash2 = readlong f #unsigned
								unkhash3 = readlong f #unsigned
								unkhash4 = readlong f #unsigned
								blank1 = readfloat f
								blank2 = readfloat f
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readfloat f
								unkfloat5 = readfloat f
								unkfloat6 = readfloat f
								unknown2 = readlong f #unsigned
								unkfloat9 = readfloat f
								unkfloat10 = readfloat f
								unkfloat11 = readfloat f
								unkfloat12 = readfloat f
								unknown3 = readlong f #unsigned
								printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string + ", " + unkfloat5 as string + ", " + unkfloat6 as string + ", " + unkfloat9 as string + ", " + unkfloat10 as string + ", " + unkfloat11 as string + ", " + unkfloat12 as string )
							)
							printDebug ( "Header 3C (Materials) start = " + ( ftell f as string ) )
							MatGroupSize = ( readlong f #unsigned - 4 )
							MatGroupCount = readlong f #unsigned
							printDebug ( "Count = " + MatGroupCount as string )
							for x = 1 to MatGroupCount do
							(
								MatSectLength = readlong f #unsigned
								MatHash2 = readlong f #unsigned
								MatHash1 = readlong f #unsigned
								MatUnkHash2 = readlong f #unsigned
								MatUnkHash1 = readlong f #unsigned
								blank1 = readfloat f
								blank2 = readfloat f
								MatFloatA = readfloat f
								MatFloatB = readfloat f
								MatFloatC = readfloat f
								MatFloatD = readfloat f
								MatFloatE = readfloat f
								MatFloatF = readfloat f
								MatSubHeaderLen = readlong f #unsigned
								MatSubFloatA = readfloat f
								MatSubFloatB = readfloat f
								MatSubFloatC = readfloat f
								MatSubFloatD = readfloat f
								MatUnk = readlong f #unsigned
								printDebug ( "Floats = " + MatFloatA as string + ", " + MatFloatB as string + ", " + MatFloatC as string + ", " + MatFloatD as string + ", " + MatFloatE as string + ", " + MatFloatF as string + ", " + MatSubFloatA as string + ", " + MatSubFloatB as string + ", " + MatSubFloatC as string + ", " + MatSubFloatD as string )
								for y = 1 to MatHash_array.count do
								(
									if MatHash1 == MatHash_array[y].MatHash1 and MatHash2 == MatHash_array[y].MatHash2 do
									(
										TexName = MatHash_array[y].TexDifName
										append TexName_array TexName
									)
								)
							)
							printDebug ( "Header 3D start = " + ( ftell f as string ) )
							header3dsize = ( readlong f #unsigned - 4 )
							header3dcount = readlong f #unsigned
							printDebug ( "Count = " + header3dcount as string )
							for x = 1 to header3dcount do
							(
								unknownlength = readlong f #unsigned
								unkhash1 = readlong f #unsigned
								unkhash2 = readlong f #unsigned
								unknown = readlong f #unsigned
							)
							printDebug ( "Header 3E (Bone IDs) start = " + ( ftell f as string ) )
							IDHeaderLength = ( readlong f #unsigned - 4 )
							BoneIDSets = readlong f #unsigned
							printDebug ( "Count = " + BoneIDSets as string )
							for b = 1 to BoneIDSets do
							(
								append BoneIDOffset_Array ( ftell f )
								boneidtotal = readlong f #unsigned
								printDebug ( "Count B = " + boneidtotal as string )
								for x = 1 to boneidtotal do
								(
									properid1 = readlong f #unsigned
									properid2 = readlong f #unsigned
									unkfloat1 = readfloat f
									unkfloat2 = readfloat f
									unkfloat3 = readfloat f
									unkfloat4 = readfloat f
									unkfloat5 = readfloat f
									unkfloat6 = readfloat f
									headerlength = readlong f #unsigned
									unkfloat7 = readfloat f
									unkfloat8 = readfloat f
									unkfloat9 = readfloat f
									unkfloat10 = readfloat f
									unknown = readlong f #unsigned
									printDebug ( "Values = 0x" + ( ( bit.intAsHex ( properid1 ) ) as string ) + ", 0x" + ( ( bit.intAsHex ( properid2 ) ) as string ) + ", " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string + ", " + unkfloat5 as string + ", " + unkfloat6 as string + ", " + unkfloat7 as string + ", " + unkfloat8 as string + ", " + unkfloat9 as string + ", " + unkfloat10 as string )
								)
							)
							printDebug ( "Header 3F start = " + ( ftell f as string ) )
							header3fsize = ( readlong f #unsigned - 4 )
							fseek f header3fsize #seek_cur
							printDebug ( "Header 3G start = " + ( ftell f as string ) )
							header3gsize = ( readlong f #unsigned - 4 )
							fseek f header3gsize #seek_cur
							printDebug ( "Header 3H start = " + ( ftell f as string ) )
							unknown1 = ( readlong f #unsigned - 4 )
							unknown2 = readlong f #unsigned
							boundingminx = readfloat f
							boundingminy = readfloat f
							boundingminz = readfloat f
							boundingmaxx = readfloat f
							boundingmaxy = readfloat f
							boundingmaxz = readfloat f
							unknown3 = ( readlong f #unsigned - 4 )
							unkfloat1 = readfloat f
							unkfloat2 = readfloat f
							unkfloat3 = readfloat f
							unkfloat4 = readfloat f
							blank1 = readlong f #unsigned
							blank2 = readlong f #unsigned
							unkhash1 = readlong f #unsigned
							unkhash2 = readlong f #unsigned
							printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
							printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
							printDebug ( "Header 3H-2 (UV Clamps) start = " + ( ftell f as string ) )
							vertcount = readlong f #unsigned
							unkcount1 = readlong f #unsigned
							UVLayerCount = readlong f #unsigned
							printDebug ( "Count = " + unkcount1 as string + ", " + UVLayerCount as string )
							UV1XMult = 1
							UV1YMult = 1
							UV1XStart = 0
							UV1YStart = 0
							UV2XMult = 1
							UV2YMult = 1
							UV2XStart = 0
							UV2YStart = 0
							UV3XMult = 1
							UV3YMult = 1
							UV3XStart = 0
							UV3YStart = 0
							UV4XMult = 1
							UV4YMult = 1
							UV4XStart = 0
							UV4YStart = 0
							UV5XMult = 1
							UV5YMult = 1
							UV5XStart = 0
							UV5YStart = 0
							UV6XMult = 1
							UV6YMult = 1
							UV6XStart = 0
							UV6YStart = 0
							for x = 1 to UVLayerCount do
							(
								UVLayer = readlong f #unsigned + 1
								UVXMult = readfloat f
								UVYMult = readfloat f
								UVXStart = readfloat f
								UVYStart = readfloat f
								if UVLayer == 1 do
								(
									UV1XMult = UVXMult
									UV1YMult = UVYMult
									UV1XStart = UVXStart
									UV1YStart = UVYStart
								)
								if UVLayer == 2 do
								(
									UV2XMult = UVXMult
									UV2YMult = UVYMult
									UV2XStart = UVXStart
									UV2YStart = UVYStart
								)
								if UVLayer == 3 do
								(
									UV3XMult = UVXMult
									UV3YMult = UVYMult
									UV3XStart = UVXStart
									UV3YStart = UVYStart
								)
								if UVLayer == 4 do
								(
									UV4XMult = UVXMult
									UV4YMult = UVYMult
									UV4XStart = UVXStart
									UV4YStart = UVYStart
								)
								if UVLayer == 5 do
								(
									UV5XMult = UVXMult
									UV5YMult = UVYMult
									UV5XStart = UVXStart
									UV5YStart = UVYStart
								)
								if UVLayer == 6 do
								(
									UV6XMult = UVXMult
									UV6YMult = UVYMult
									UV6XStart = UVXStart
									UV6YStart = UVYStart
								)
								printDebug ( "X Multiply = " + UVXMult as string + ", Y Multiply = " + UVYMult as string + ", X Start = " + UVXStart as string + ", Y Start = " + UVYStart as string + ", Layer = " + UVLayer as string )
							)
							HasVertex = 0
							VertexFmt = 0
							HasNormals = 0
							NormalsFmt = 0
							HasBinormals = 0
							BinormalsFmt = 0
							HasTangents = 0
							TangentsFmt = 0
							HasWeights = 0
							WeightsFmt = 0
							HasBones = 0
							BonesFmt = 0
							HasColors = 0
							ColorsFmt = 0
							HasColors2 = 0
							Colors2Fmt = 0
							HasUV1 = 0
							UV1Fmt = 0
							HasUV2 = 0
							UV2Fmt = 0
							HasUV3 = 0
							UV3Fmt = 0
							HasUV4 = 0
							UV4Fmt = 0
							HasUV5 = 0
							UV5Fmt = 0
							HasUV6 = 0
							UV6Fmt = 0
							printDebug ( "Header 3H-3 (Vertex Buffer) start = " + ( ftell f as string ) )
							unknown = readlong f #unsigned
							unknown2 = readlong f #unsigned
							unknown3 = readlong f #unsigned
							BufferCount = readlong f #unsigned
							printDebug ( "Count = " + BufferCount as string )
							if BufferCount != undefined do
							(
								for x = 1 to BufferCount do
								(
									VertType = readlong f #unsigned + 1
									VertFormat = readlong f #unsigned + 1
									VertLayer = readlong f #unsigned + 1
									VertBuffNum = readlong f #unsigned + 1
									VertOffset = readlong f #unsigned + 1
									if VertType == 1 do
									(
										HasVertex = VertBuffNum
										VertexFmt = VertFormat
									)
									if VertType == 2 and VertLayer == 1 do
									(
										HasNormals = VertBuffNum
										NormalsFmt = VertFormat
									)
									if VertType == 2 and VertLayer == 2 do
									(
										HasBinormals = VertBuffNum
										BinormalsFmt = VertFormat
									)
									if VertType == 3 do
									(
										HasTangents = VertBuffNum
										TangentsFmt = VertFormat
									)
									if VertType == 4 do
									(
										HasWeights = VertBuffNum
										WeightsFmt = VertFormat
									)
									if VertType == 5 do
									(
										HasBones = VertBuffNum
										BonesFmt = VertFormat
									)
									if VertType == 6 and VertLayer == 1 do
									(
										HasColors = VertBuffNum
										ColorsFmt = VertFormat
									)
									if VertType == 6 and VertLayer == 2 do
									(
										HasColors2 = VertBuffNum
										Colors2Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 1 do
									(
										HasUV1 = VertBuffNum
										UV1Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 2 do
									(
										HasUV2 = VertBuffNum
										UV2Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 3 do
									(
										HasUV3 = VertBuffNum
										UV3Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 4 do
									(
										HasUV4 = VertBuffNum
										UV4Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 5 do
									(
										HasUV5 = VertBuffNum
										UV5Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 6 do
									(
										HasUV6 = VertBuffNum
										UV6Fmt = VertFormat
									)
									printDebug ( "Vertex Type = " + VertType as string + ", Format = " + VertFormat as string + ", Layer = " + VertLayer as string + ", Buffer = " + VertBuffNum as string + ", Offset = " + VertOffset as string )
								)
								bytepad = readbyte f #unsigned
								printDebug ( "Header 3I-1 (Polygon Count) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unknown3 = readlong f #unsigned
								facecount = readlong f #unsigned
								facelength = readlong f #unsigned
								printDebug ( "Face length = 0x" + ( ( bit.intAsHex ( facelength ) ) as string ) )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								printDebug ( "Header 3I-2 (Vertex/Normals Information) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unkcount3 = readlong f #unsigned
								vertcount = readlong f #unsigned
								vertlength = readlong f #unsigned
								printDebug ( "Vertex length = 0x" + ( ( bit.intAsHex ( vertlength ) ) as string ) )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								printDebug ( "Header 3I-3 (UV Information) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unkcount3 = readlong f #unsigned
								uvcount = readlong f #unsigned
								uvlength = readlong f #unsigned
								printDebug ( "UV length = 0x" + ( ( bit.intAsHex ( uvlength ) ) as string ) )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								fseek f facedatastart #seek_set
								printDebug ( "Face start = " + ( ftell f as string ) )
								for x = 1 to facecount / 3 do
								(
									fa = readshort f #unsigned + 1
									fb = readshort f #unsigned + 1
									fc = readshort f #unsigned + 1
									append Face_array [fa, fb, fc]
								)
								printDebug ( "Vertex start = " + ( ftell f as string ) )
								for x = 1 to vertcount do
								(
									Weight1 = 1
									Weight2 = 0
									Weight3 = 0
									Weight4 = 0
									Bone1 = 1
									Bone2 = 1
									Bone3 = 1
									Bone4 = 1
									if HasVertex == 1 do
									(
										case of
										(
											default:( throw ( "Unknown positions format!" ) )
											( VertexFmt == 4 ):(
												vx = readfloat f * ModelScale
												vy = readfloat f * ModelScale
												vz = readfloat f * ModelScale
											)
										)
										
										
									)
									if HasWeights == 1 do
									(
										case of
										(
											default:( throw ( "Unknown weights format!" ) )
											( WeightsFmt == 27 ):(
												Weight1 = ( readshort f #unsigned as float / 65535 )
												Weight2 = ( readshort f #unsigned as float / 65535 )
												Weight3 = ( readshort f #unsigned as float / 65535 )
												Weight4 = ( readshort f #unsigned as float / 65535 )
											)
										)
										
										
									)
									if HasBones == 1 do
									(
										case of
										(
											default:( throw ( "Unknown bones format!" ) )
											( BonesFmt == 33 ):(
												Bone1 = readbyte f #unsigned
												Bone2 = readbyte f #unsigned
												Bone3 = readbyte f #unsigned
												Bone4 = readbyte f #unsigned
											)
										)
										
										
									)
									if HasNormals == 1 do
									(
										case of
										(
											default:( throw ( "Unknown normals format!" ) )
											( NormalsFmt == 38 ):(
												nx = readbyte f as float / 127
												ny = readbyte f as float / 127
												nz = readbyte f as float / 127
												nq = readbyte f as float / 127
												append Normal_array [nx, ny, nz]
											)
											( NormalsFmt == 26 ):(
												nx = readshort f as float / 32767
												ny = readshort f as float / 32767
												nz = readshort f as float / 32767
												nq = readshort f as float / 32767
												append Normal_array [nx, ny, nz]
											)
										)
										
										
									)
									if HasBinormals == 1 do
									(
										case of
										(
											default:( throw ( "Unknown binormals format!" ) )
											( BinormalsFmt == 38 ):(
												nx2 = readbyte f as float / 127
												ny2 = readbyte f as float / 127
												nz2 = readbyte f as float / 127
												nq2 = readbyte f as float / 127
											)
											( BinormalsFmt == 26 ):(
												nx2 = readshort f as float / 32767
												ny2 = readshort f as float / 32767
												nz2 = readshort f as float / 32767
												nq2 = readshort f as float / 32767
											)
										)
										
										
									)
									if HasTangents == 1 do
									(
										case of
										(
											default:( throw ( "Unknown tangents format!" ) )
											( TangentsFmt == 38 ):(
												nx3 = readbyte f as float / 127
												ny3 = readbyte f as float / 127
												nz3 = readbyte f as float / 127
												nq3 = readbyte f as float / 127
											)
											( TangentsFmt == 26 ):(
												nx3 = readshort f as float / 32767
												ny3 = readshort f as float / 32767
												nz3 = readshort f as float / 32767
												nq3 = readshort f as float / 32767
											)
										)
										
										
									)
									append Vert_array [vx, vy, vz]
									append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
									append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
								)
								printDebug ( "UV start = " + ( ftell f as string ) )
								for x = 1 to uvcount do
								(
									colorr = 255
									colorg = 255
									colorb = 255
									colora = 1
									tu = 0
									tv = 0
									if HasNormals == 2 do
									(
										case of
										(
											default:( throw ( "Unknown normals format!" ) )
											( NormalsFmt == 38 ):(
												nx = readbyte f as float / 127
												ny = readbyte f as float / 127
												nz = readbyte f as float / 127
												nq = readbyte f as float / 127
												append Normal_array [nx, ny, nz]
											)
											( NormalsFmt == 26 ):(
												nx = readshort f as float / 32767
												ny = readshort f as float / 32767
												nz = readshort f as float / 32767
												nq = readshort f as float / 32767
												append Normal_array [nx, ny, nz]
											)
										)
										
										
									)
									if HasBinormals == 2 do
									(
										case of
										(
											default:( throw ( "Unknown binormals format!" ) )
											( BinormalsFmt == 38 ):(
												nx2 = readbyte f as float / 127
												ny2 = readbyte f as float / 127
												nz2 = readbyte f as float / 127
												nq2 = readbyte f as float / 127
											)
											( BinormalsFmt == 26 ):(
												nx2 = readshort f as float / 32767
												ny2 = readshort f as float / 32767
												nz2 = readshort f as float / 32767
												nq2 = readshort f as float / 32767
											)
										)
										
										
									)
									if HasTangents == 2 do
									(
										case of
										(
											default:( throw ( "Unknown tangents format!" ) )
											( TangentsFmt == 38 ):(
												nx3 = readbyte f as float / 127
												ny3 = readbyte f as float / 127
												nz3 = readbyte f as float / 127
												nq3 = readbyte f as float / 127
											)
											( TangentsFmt == 26 ):(
												nx3 = readshort f as float / 32767
												ny3 = readshort f as float / 32767
												nz3 = readshort f as float / 32767
												nq3 = readshort f as float / 32767
											)
										)
										
										
									)
									if HasUV6 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV6 format!" ) )
											( UV6Fmt == 3 ):(
												tu6 = readfloat f
												tv6 = ( ( readfloat f ) * -1 ) + 1
												append UV6_array [tu6, tv6, 0]
											)
											( UV6Fmt == 24 ):(
												tu6 = ( ( readshort f as float / 32767 ) * UV6XMult ) + UV6XStart
												tv6 = ( ( ( ( readshort f as float / 32767 ) * UV6YMult ) + UV6YStart ) * -1 ) + 1
												append UV6_array [tu6, tv6, 0]
											)
											( UV6Fmt == 25 ):(
												tu6 = ( ( readshort f #unsigned as float / 65535 ) * UV6XMult ) + UV6XStart
												tv6 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV6YMult ) + UV6YStart ) * -1 ) + 1
												append UV6_array [tu6, tv6, 0]
											)
										)
										
										
									)
									if HasUV5 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV5 format!" ) )
											( UV5Fmt == 3 ):(
												tu5 = readfloat f
												tv5 = ( ( readfloat f ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
											( UV5Fmt == 24 ):(
												tu5 = ( ( readshort f as float / 32767 ) * UV5XMult ) + UV5XStart
												tv5 = ( ( ( ( readshort f as float / 32767 ) * UV5YMult ) + UV5YStart ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
											( UV5Fmt == 25 ):(
												tu5 = ( ( readshort f #unsigned as float / 65535 ) * UV5XMult ) + UV5XStart
												tv5 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV5YMult ) + UV5YStart ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
										)
										
										
									)
									if HasColors == 2 do
									(
										case of
										(
											default:( throw ( "Unknown colors format!" ) )
											( ColorsFmt == 33 ):(
												colorr = readbyte f #unsigned
												colorg = readbyte f #unsigned
												colorb = readbyte f #unsigned
												colora = ( readbyte f #unsigned as float ) / 255
											)
											( ColorsFmt == 39 ):(
												colorr = readbyte f #unsigned
												colorg = readbyte f #unsigned
												colorb = readbyte f #unsigned
												colora = ( readbyte f #unsigned as float ) / 255
											)
										)
										
										
									)
									if HasColors2 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown colors2 format!" ) )
											( Colors2Fmt == 33 ):(
												colorr2 = readbyte f #unsigned
												colorg2 = readbyte f #unsigned
												colorb2 = readbyte f #unsigned
												colora2 = ( readbyte f #unsigned as float ) / 255
											)
											( Colors2Fmt == 39 ):(
												colorr2 = readbyte f #unsigned
												colorg2 = readbyte f #unsigned
												colorb2 = readbyte f #unsigned
												colora2 = ( readbyte f #unsigned as float ) / 255
											)
										)
										
										
									)
									if HasUV1 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV1 format!" ) )
											( UV1Fmt == 3 ):(
												tu = readfloat f
												tv = ( ( readfloat f ) * -1 ) + 1
											)
											( UV1Fmt == 24 ):(
												tu = ( ( readshort f as float / 32767 ) * UV1XMult ) + UV1XStart
												tv = ( ( ( ( readshort f as float / 32767 ) * UV1YMult ) + UV1YStart ) * -1 ) + 1
											)
											( UV1Fmt == 25 ):(
												tu = ( ( readshort f #unsigned as float / 65535 ) * UV1XMult ) + UV1XStart
												tv = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV1YMult ) + UV1YStart ) * -1 ) + 1
											)
										)
										
										
									)
									if HasUV2 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV2 format!" ) )
											( UV2Fmt == 3 ):(
												tu2 = readfloat f
												tv2 = ( ( readfloat f ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
											( UV2Fmt == 24 ):(
												tu2 = ( ( readshort f as float / 32767 ) * UV2XMult ) + UV2XStart
												tv2 = ( ( ( ( readshort f as float / 32767 ) * UV2YMult ) + UV2YStart ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
											( UV2Fmt == 25 ):(
												tu2 = ( ( readshort f #unsigned as float / 65535 ) * UV2XMult ) + UV2XStart
												tv2 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV2YMult ) + UV2YStart ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
										)
										
										
									)
									if HasUV3 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV3 format!" ) )
											( UV3Fmt == 3 ):(
												tu3 = readfloat f
												tv3 = ( ( readfloat f ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
											( UV3Fmt == 24 ):(
												tu3 = ( ( readshort f as float / 32767 ) * UV3XMult ) + UV3XStart
												tv3 = ( ( ( ( readshort f as float / 32767 ) * UV3YMult ) + UV3YStart ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
											( UV3Fmt == 25 ):(
												tu3 = ( ( readshort f #unsigned as float / 65535 ) * UV3XMult ) + UV3XStart
												tv3 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV3YMult ) + UV3YStart ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
										)
										
										
									)
									if HasUV4 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV4 format!" ) )
											( UV4Fmt == 3 ):(
												tu4 = readfloat f
												tv4 = ( ( readfloat f ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
											( UV4Fmt == 24 ):(
												tu4 = ( ( readshort f as float / 32767 ) * UV4XMult ) + UV4XStart
												tv4 = ( ( ( ( readshort f as float / 32767 ) * UV4YMult ) + UV4YStart ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
											( UV4Fmt == 25 ):(
												tu4 = ( ( readshort f #unsigned as float / 65535 ) * UV4XMult ) + UV4XStart
												tv4 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV4YMult ) + UV4YStart ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
										)
										
										
									)
									append UV_array [tu, tv, 0]
									append Color_array [colorr, colorg, colorb]
									append Alpha_array colora
								)
								printDebug ( "End of file = " + ( ftell f as string ) )
								printDebug ( PolyStruct_array )
								for i = 1 to PolyStruct_array.count do
								(
									ProperBoneID_array = #()
									FixedBoneID_array = #()
									ActualB1_array = #()
									Weight_array = #()
									Weight_array2 = #()
									Face_array2 = #()
									Face_array3 = #()
									Vert_array2 = #()
									Normal_array2 = #()
									Color_array2 = #()
									Alpha_array2 = #()
									UV_array2 = #()
									UV2_array2 = #()
									UV3_array2 = #()
									UV4_array2 = #()
									UV5_array2 = #()
									UV6_array2 = #()
									if BoneCount != 0 and B1_array.count > 0 do
									(
										fseek f BoneIDOffset_array[1 * PolyStruct_array[i].BoneSetNum] #seek_set
										boneidtotal = readlong f #unsigned
										ProperBoneID_array = #()
										for y = 1 to boneidtotal do
										(
											BoneHash2 = readlong f #unsigned
											BoneHash1 = readlong f #unsigned
											unkfloat1 = readfloat f
											unkfloat2 = readfloat f
											unkfloat3 = readfloat f
											unkfloat4 = readfloat f
											unkfloat5 = readfloat f
											unkfloat6 = readfloat f
											headerlength = readlong f #unsigned
											unkfloat7 = readfloat f
											unkfloat8 = readfloat f
											unkfloat9 = readfloat f
											unkfloat10 = readfloat f
											unknown = readlong f #unsigned
											BoneName = ( "0x" + bit.intAsHex ( BoneHash1 ) as string )
											for z = 1 to BoneHash_array.count do
											(
												if BoneHash1 == BoneHash_array[z].BoneHash1 and BoneHash2 == BoneHash_array[z].BoneHash2 do
												( BoneName = BoneHash_array[z].BoneString )
											)
											append ProperBoneID_array BoneName
										)
										for a = 1 to boneidtotal do
										(
											for b = 1 to BoneCount do
											(
												if ProperBoneID_array[a] == BoneName_array[b] do
												( append FixedBoneID_array b )
											)
										)
										for x = 1 to B1_array.count do
										(
											ImproperBone1 = B1_array[x].Bone1
											ImproperBone2 = B1_array[x].Bone2
											ImproperBone3 = B1_array[x].Bone3
											ImproperBone4 = B1_array[x].Bone4
											ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
											ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
											ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
											ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
											if ProperBone1 == undefined do
											( ProperBone1 = 1 )
											if ProperBone2 == undefined do
											( ProperBone2 = 1 )
											if ProperBone3 == undefined do
											( ProperBone3 = 1 )
											if ProperBone4 == undefined do
											( ProperBone4 = 1 )
											append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
										)
										for b = 1 to W1_array.count Do
										(
											w = ( weight_data boneids: #() weights: #() )
											maxweight = 0
											if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
											if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
											if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
											if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
											if ( maxweight != 0 ) then
											(
												if ( W1_array[b].Weight1 != 0 ) then
												(
													w1 = W1_array[b].Weight1 as float
													append w.boneids ( ActualB1_array[b].Bone1 )
													append w.weights ( w1 )
												)
												if ( W1_array[b].Weight2 != 0 ) then
												(
													w2 = W1_array[b].Weight2 as float
													append w.boneids ( ActualB1_array[b].Bone2 )
													append w.weights ( w2 )
												)
												if ( W1_array[b].Weight3 != 0 ) then
												(
													w3 = W1_array[b].Weight3 as float
													append w.boneids ( ActualB1_array[b].Bone3 )
													append w.weights ( w3 )
												)
												if ( W1_array[b].Weight4 != 0 ) then
												(
													w4 = W1_array[b].Weight4 as float
													append w.boneids ( ActualB1_array[b].Bone4 )
													append w.weights ( w4 )
												)
											)
											append Weight_array w
										)
									)
									for y = PolyStruct_array[i].PolygonStart to ( PolyStruct_array[i].PolygonCount + PolyStruct_array[i].PolygonStart ) do
									( append Face_array2 Face_array[y] )
									VertexMin = PolyStruct_array[i].VertexMin + PolyStruct_array[i].VertexStart
									VertexMax = PolyStruct_array[i].VertexMax + PolyStruct_array[i].VertexStart
									for x = VertexMin to VertexMax do
									(
										append Vert_array2 Vert_array[x]
										append Normal_array2 Normal_array[x]
										append Color_array2 Color_array[x]
										append Alpha_array2 Alpha_array[x]
										append UV_array2 UV_array[x]
										if UV2_array.count > 0 do
										( append UV2_array2 UV2_array[x] )
										if UV3_array.count > 0 do
										( append UV3_array2 UV3_array[x] )
										if UV4_array.count > 0 do
										( append UV4_array2 UV4_array[x] )
										if UV5_array.count > 0 do
										( append UV5_array2 UV5_array[x] )
										if UV6_array.count > 0 do
										( append UV6_array2 UV6_array[x] )
										append Weight_array2 Weight_array[x]
									)
									for x = 1 to PolyStruct_array[i].PolygonCount do
									(
										Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
										append Face_array3 Faces3
									)
									local PolyMat = standardMaterial()
									PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
									PolyMat.showinviewport = true
									PolyMat.twosided = false
									if TexFormat == 1 then
									(
										if TexPath == 1 then
										( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										else
										( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
									)
									else
									(
										if TexPath == 1 then
										( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										else
										( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
									)
									tm.alphasource = 0
									PolyMat.diffuseMap = tm
									PolyMat.opacityMap = tm
									PolyMat.opacityMap.monoOutput = 1
									msh = mesh vertices: Vert_array2 faces: Face_array3
									msh.numTVerts = Vert_array2.count
									if VertColors == true then
									(
										setNumCPVVerts msh msh.numTVerts
										setCVertMode msh true
										setShadeCVerts msh true
									)
									defaultVCFaces msh
									buildTVFaces msh
									if PolyStruct_array[i].LODNum == 1 do
									( msh.name = ( h as string ) )
									if PolyStruct_array[i].LODNum != 1 do
									( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ")" ) )
									msh.material = PolyMat
									if VertColors == true then
									(
										for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
										for j = 1 to Alpha_array2.count do
										( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
									)
									for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
									for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
									max modify mode
									select msh
									for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
									addmodifier msh ( Edit_Normals() ) ui: off
									msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
									EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
									EN_setNormal = msh.Edit_Normals.SetNormal
									normID = #{}
									for v = 1 to Normal_array2.count do
									(
										free normID
										EN_convertVS #{v} &normID
										for id in normID do EN_setNormal id Normal_array2[v]
									)
									if BoneCount != 0 and B1_array.count > 0 do
									(
										skinMod = skin()
										boneIDMap = #()
										addModifier msh skinMod
										for i = 1 to BoneCount do
										(
											maxbone = getnodebyname BoneSetup[i].name
											if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
										)
										local numSkinBones = skinOps.GetNumberBones skinMod
										for i = 1 to numSkinBones do
										(
											local boneName = skinOps.GetBoneName skinMod i 0
											for j = 1 to BoneCount do
											(
												if boneName == BoneSetup[j].Name then
												(
													boneIDMap[j] = i
													j = BoneCount + 1
												)
											)
										)
										modPanel.setCurrentObject skinMod
										for i = 1 to Vert_array2.count do
										(
											skinOps.SetVertexWeights skinMod i 1 1
											skinOps.unnormalizeVertex skinMod i true
											skinOps.SetVertexWeights skinMod i 1 0
										)
										skinOps.RemoveZeroWeights skinMod
										for i = 1 to Vert_array2.count do
										( skinOps.unnormalizeVertex skinMod i false )
										for i = 1 to Weight_array2.count do
										(
											w = Weight_array2[i]
											bi = #()
											wv = #()
											for j = 1 to w.boneids.count do
											(
												boneid = w.boneids[j]
												weight = w.weights[j]
												append bi boneIDMap[boneid]
												append wv weight
											)
											skinOps.ReplaceVertexWeights skinMod i bi wv
										)
									)
									if UVLayers == 1 do
									(
										if UV2_array2.count > 0 do
										(
											meshop.setNumMaps msh 3 keep: true
											for i = 1 to UV2_array2.count do
											( meshop.setMapVert msh 2 i UV2_array2[i] )
										)
										if UV3_array2.count > 0 do
										(
											meshop.setNumMaps msh 4 keep: true
											for i = 1 to UV3_array2.count do
											( meshop.setMapVert msh 3 i UV3_array2[i] )
										)
										if UV4_array2.count > 0 do
										(
											meshop.setNumMaps msh 5 keep: true
											for i = 1 to UV4_array2.count do
											( meshop.setMapVert msh 4 i UV4_array2[i] )
										)
										if UV5_array2.count > 0 do
										(
											meshop.setNumMaps msh 6 keep: true
											for i = 1 to UV5_array2.count do
											( meshop.setMapVert msh 5 i UV5_array2[i] )
										)
										if UV6_array2.count > 0 do
										(
											meshop.setNumMaps msh 7 keep: true
											for i = 1 to UV6_array2.count do
											( meshop.setMapVert msh 6 i UV6_array2[i] )
										)
									)
									if UVLayers == 2 do
									(
										if UV2_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 2" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 2" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV2_array2.count do setTVert msh j UV2_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV3_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 3" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 3" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV3_array2.count do setTVert msh j UV3_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV4_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 4" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 4" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV4_array2.count do setTVert msh j UV4_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV5_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 5" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 5" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV5_array2.count do setTVert msh j UV5_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV6_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 6" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 6" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV6_array2.count do setTVert msh j UV6_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
									)
								)
							)
							fclose f
						)
						( VerNum == 37 ):(
							Face_array = #()
							FaceB_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							UV2_array = #()
							UV3_array = #()
							UV4_array = #()
							UV5_array = #()
							UV6_array = #()
							B1_array = #()
							W1_array = #()
							Color_array = #()
							Alpha_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							MatHash_array = #()
							TexName_array = #()
							struct Polygon_Info_Struct
							(
								VertexStart,
								VertexMin,
								VertexMax,
								PolygonStart,
								PolygonCount,
								FacePointCount,
								MatNum,
								BoneSetNum,
								LODNum
							)
							fseek f 0x0 #seek_set
							MVS6 = readlong f #unsigned
							fseek f 0x0 #seek_set
							if MVS6 == 1297307190 do
							(
								fseek f 0x04 #seek_cur
								filesize = readlong f #unsigned
								fseek f 0x08 #seek_cur
								headerthing = readlong f #unsigned
								for v = 1 to headerthing do
								( fseek f 0x0C #seek_cur )
							)
							nameheaderlength = readlong f #unsigned
							namelength = readlong f #unsigned
							name = ReadFixedString f namelength
							printDebug ( "Model information start = " + ( ftell f as string ) )
							fseek f 0x1D #seek_cur
							printDebug ( "Material information start = " + ( ftell f as string ) )
							matcount = readlong f #unsigned
							printDebug ( "Material Count = " + matcount as string )
							for x = 1 to matcount do
							(
								printDebug ( "Material #" + x as string + " start = " + ( ftell f as string ) )
								MatHash2 = readlong f #unsigned
								MatHash1 = readlong f #unsigned
								UnkHash2 = readlong f #unsigned
								UnkHash1 = readlong f #unsigned
								MatHeaderSize = ( ftell f ) + ( readlong f #unsigned )
								MatUnk1 = readlong f #unsigned
								if MatUnk1 != 0x02 do
								( break() )
								MatUnk2 = readlong f #unsigned
								MatHeaderSizeB = readlong f #unsigned
								MatUnk3 = readlong f #unsigned
								if MatUnk3 != 0x01 do
								( break() )
								MatUnk3Hash2 = readlong f #unsigned
								MatUnk3Hash1 = readlong f #unsigned
								MatParamCount = readlong f #unsigned
								TexDifName = "null"
								for m = 1 to MatParamCount do
								(
									MatSectHash2 = bit.intAsHex ( readlong f #unsigned )
									MatSectHash1 = bit.intAsHex ( readlong f #unsigned )
									MatSectCount = readlong f #unsigned
									case of
									(
										default:( throw ( "Unknown material hashes!" ) )
										( MatSectHash1 == "0" and MatSectHash2 == "0" ):()
										( MatSectHash1 == "4f0234" and MatSectHash2 == "63d89fb0" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkHash4 = readlong f #unsigned
												MatUnkHash3 = readlong f #unsigned
											)
										)
										( MatSectHash1 == "bae4cbd7" and MatSectHash2 == "7f139a91" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat = readfloat f
											)
										)
										( MatSectHash1 == "9004c558" and MatSectHash2 == "7575d6c0" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkBytePad = readbyte f #unsigned
											)
										)
										( MatSectHash1 == "394c43af" and MatSectHash2 == "4ff52c94" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat1 = readfloat f
												MatUnkFloat2 = readfloat f
												MatUnkFloat3 = readfloat f
											)
										)
										( MatSectHash1 == "7bbca244" and MatSectHash2 == "e61f1a07" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat1 = readfloat f
												MatUnkFloat2 = readfloat f
											)
										)
										( MatSectHash1 == "c16762f7" and MatSectHash2 == "763d62ab" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat1 = readfloat f
												MatUnkFloat2 = readfloat f
												MatUnkFloat3 = readfloat f
												MatUnkFloat4 = readfloat f
											)
										)
										( MatSectHash1 == "52a09151" and MatSectHash2 == "f1c3f2c7" ):(
											for y = 1 to MatSectCount do
											(
												TypeHash2 = bit.intAsHex ( readlong f #unsigned )
												TypeHash1 = bit.intAsHex ( readlong f #unsigned )
												TexHash2 = readlong f #unsigned
												TexHash1 = readlong f #unsigned
												TexName = bit.intAsHex ( TexHash1 ) as string
												for y = 1 to TexHash_array.count do
												(
													if TexHash1 == TexHash_array[y].TexHash1 and TexHash2 == TexHash_array[y].TexHash2 do
													( TexName = TexHash_array[y].TexString )
												)
												if TypeHash1 == "8648fa82" and TypeHash2 == "d1dbee1a" do
												( TexDifName = TexName )
												printDebug ( TypeHash1 + " " + TypeHash2 as string + ": " + TexName )
											)
										)
										( MatSectHash1 == "e2ba743e" and MatSectHash2 == "952f9338" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkHash4 = readlong f #unsigned
												MatUnkHash3 = readlong f #unsigned
												MatUnkHash6 = readlong f #unsigned
												MatUnkHash5 = readlong f #unsigned
											)
										)
									)
									
									
								)
								append MatHash_array ( MatHash_Struct MatHash1: MatHash1 MatHash2: MatHash2 TexDifName: TexDifName )
								printDebug ( "-----" )
								fseek f MatHeaderSize #seek_set
							)
							printDebug ( "Model information start = " + ( ftell f as string ) )
							unknown = readlong f #unsigned
							header3size = ( readlong f #unsigned - 4 )
							facedatastart = ( ftell f ) + header3size
							printDebug ( "LOD information start = " + ( ftell f as string ) )
							header3asize = ( readlong f #unsigned - 4 ) + ( ftell f )
							header3acount = readlong f #unsigned
							printDebug ( "Count = " + header3acount as string )
							for y = 1 to header3acount do
							(
								printDebug ( "LOD # " + y as string + " information start = " + ( ftell f as string ) )
								head3asubsize = ( readlong f #unsigned - 4 )
								polytotal = readlong f #unsigned
								printDebug ( "Count = " + polytotal as string )
								for x = 1 to polytotal do
								(
									boundingminx = readfloat f
									boundingminy = readfloat f
									boundingminz = readfloat f
									boundingmaxx = readfloat f
									boundingmaxy = readfloat f
									boundingmaxz = readfloat f
									headerlength = readlong f #unsigned
									unkfloat1 = readfloat f
									unkfloat2 = readfloat f
									unkfloat3 = readfloat f
									unkfloat4 = readfloat f
									unknown1 = readlong f #unsigned
									VertexStart = 0
									VertexMin = readlong f #unsigned + 1
									VertexMax = readlong f #unsigned + 1
									FacepointStart = readlong f #unsigned
									PolygonStart = ( FacepointStart / 3 ) + 1
									PolygonCount = readlong f #unsigned
									FacepointCount = PolygonCount * 3
									headerlength2 = readlong f #unsigned
									if headerlength2 == 0x10 do
									(
										unknown2A = readlong f #unsigned
										unknown2B = readlong f #unsigned
									)
									unknown2 = readlong f #unsigned
									MatNum = readlong f #unsigned + 1
									BoneSetNum = readlong f #unsigned + 1
									unknown3 = readlong f #unsigned
									unknown4 = readlong f #unsigned
									if y == 1 do
									( append PolyStruct_array ( Polygon_Info_Struct VertexStart: VertexStart VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum BoneSetNum: BoneSetNum LODNum: y ) )
									if y > 1 and LODs == true do
									( append PolyStruct_array ( Polygon_Info_Struct VertexStart: VertexStart VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum BoneSetNum: BoneSetNum LODNum: y ) )
									printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
									printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
									printDebug ( "VertMin = " + VertexMin as string + ", VertMax = " + VertexMax as string + ", PolyStart = " + PolygonStart as string + ", PolyCount = " + PolygonCount as string + ", FacePointCount = " + FacePointCount as string + ", MatNum = " + MatNum as string + ", BoneSet = " + BoneSetNum as string )
									printDebug ( "Unknowns = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string + ", " + unknown4 as string )
								)
								printDebug ( "Header 3A SubB start = " + ( ftell f as string ) )
								head3asubbsize = ( readlong f #unsigned - 4 )
								if head3asubbsize == 0x04 do
								( fseek f header3asize #seek_set )
								poly2total = readlong f #unsigned
								for x = 1 to poly2total do
								(
									boundingminx = readfloat f
									boundingminy = readfloat f
									boundingminz = readfloat f
									boundingmaxx = readfloat f
									boundingmaxy = readfloat f
									boundingmaxz = readfloat f
									headerlength = readlong f #unsigned
									unkfloat1 = readfloat f
									unkfloat2 = readfloat f
									unkfloat3 = readfloat f
									unkfloat4 = readfloat f
									unknown1 = readlong f #unsigned
									VertexStart = 0
									VertexMin = readlong f #unsigned + 1
									VertexMax = readlong f #unsigned + 1
									FacepointStart = readlong f #unsigned
									PolygonStart = ( FacepointStart / 3 ) + 1
									PolygonCount = readlong f #unsigned
									FacepointCount = PolygonCount * 3
									headerlength2 = readlong f #unsigned
									if headerlength2 == 0x10 do
									(
										unknown2A = readlong f #unsigned
										unknown2B = readlong f #unsigned
									)
									unknown2 = readlong f #unsigned
									MatNum = readlong f #unsigned + 1
									BoneSetNum = readlong f #unsigned + 1
									unknown3 = readlong f #unsigned
									unknown4 = readlong f #unsigned
									printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
									printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
									printDebug ( "VertMin = " + VertexMin as string + ", VertMax = " + VertexMax as string + ", PolyStart = " + PolygonStart as string + ", PolyCount = " + PolygonCount as string + ", FacePointCount = " + FacePointCount as string + ", MatNum = " + MatNum as string + ", BoneSet = " + BoneSetNum as string )
									printDebug ( "Unknowns = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string + ", " + unknown4 as string )
								)
								printDebug ( "Header 3A SubC start = " + ( ftell f as string ) )
								unknown1 = ( readlong f #unsigned - 4 )
								unknown2 = readlong f #unsigned
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								unknown3 = ( readlong f #unsigned - 4 )
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readfloat f
								blank1 = readlong f #unsigned
								unknown4 = readlong f #unsigned
								unknown5 = readlong f #unsigned
								blank2 = readlong f #unsigned
								printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
								printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
								printDebug ( "Values = " + unknown1 as string + ", 0x" + bit.intAsHex ( unknown2 ) as string + ", " + unknown4 as string + ", " + unknown5 as string )
								printDebug ( "Header 3A SubD start = " + ( ftell f as string ) )
								header3subdsize = ( readlong f #unsigned - 4 )
								header3subdcount = readlong f #unsigned
								for y = 1 to header3subdcount do
								(
									unkhash1 = readlong f #unsigned
									unkhash2 = readlong f #unsigned
								)
							)
							printDebug ( "Header 3B start = " + ( ftell f as string ) )
							header3bsize = ( readlong f #unsigned - 4 )
							header3bcount = readlong f #unsigned
							printDebug ( "Count = " + header3bcount as string )
							for x = 1 to header3bcount do
							(
								printDebug ( "Header 3B start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unkhash1 = readlong f #unsigned
								unkhash2 = readlong f #unsigned
								unkhash3 = readlong f #unsigned
								unkhash4 = readlong f #unsigned
								blank1 = readfloat f
								blank2 = readfloat f
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readfloat f
								unkfloat5 = readfloat f
								unkfloat6 = readfloat f
								unknown2 = readlong f #unsigned
								unkfloat9 = readfloat f
								unkfloat10 = readfloat f
								unkfloat11 = readfloat f
								unkfloat12 = readfloat f
								unknown3 = readlong f #unsigned
								printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string + ", " + unkfloat5 as string + ", " + unkfloat6 as string + ", " + unkfloat9 as string + ", " + unkfloat10 as string + ", " + unkfloat11 as string + ", " + unkfloat12 as string )
							)
							printDebug ( "Header 3C (Materials) start = " + ( ftell f as string ) )
							MatGroupSize = ( readlong f #unsigned - 4 )
							MatGroupCount = readlong f #unsigned
							printDebug ( "Count = " + MatGroupCount as string )
							for x = 1 to MatGroupCount do
							(
								MatSectLength = readlong f #unsigned
								MatHash2 = readlong f #unsigned
								MatHash1 = readlong f #unsigned
								MatUnkHash2 = readlong f #unsigned
								MatUnkHash1 = readlong f #unsigned
								blank1 = readfloat f
								blank2 = readfloat f
								MatFloatA = readfloat f
								MatFloatB = readfloat f
								MatFloatC = readfloat f
								MatFloatD = readfloat f
								MatFloatE = readfloat f
								MatFloatF = readfloat f
								MatSubHeaderLen = readlong f #unsigned
								MatSubFloatA = readfloat f
								MatSubFloatB = readfloat f
								MatSubFloatC = readfloat f
								MatSubFloatD = readfloat f
								MatUnk = readlong f #unsigned
								printDebug ( "Floats = " + MatFloatA as string + ", " + MatFloatB as string + ", " + MatFloatC as string + ", " + MatFloatD as string + ", " + MatFloatE as string + ", " + MatFloatF as string + ", " + MatSubFloatA as string + ", " + MatSubFloatB as string + ", " + MatSubFloatC as string + ", " + MatSubFloatD as string )
								for y = 1 to MatHash_array.count do
								(
									if MatHash1 == MatHash_array[y].MatHash1 and MatHash2 == MatHash_array[y].MatHash2 do
									(
										TexName = MatHash_array[y].TexDifName
										append TexName_array TexName
									)
								)
							)
							printDebug ( "Header 3D start = " + ( ftell f as string ) )
							header3dsize = ( readlong f #unsigned - 4 )
							header3dcount = readlong f #unsigned
							printDebug ( "Count = " + header3dcount as string )
							for x = 1 to header3dcount do
							(
								unknownlength = readlong f #unsigned
								unkhash1 = readlong f #unsigned
								unkhash2 = readlong f #unsigned
								unknown = readlong f #unsigned
							)
							printDebug ( "Header 3E (Bone IDs) start = " + ( ftell f as string ) )
							IDHeaderLength = ( readlong f #unsigned - 4 )
							BoneIDSets = readlong f #unsigned
							printDebug ( "Count = " + BoneIDSets as string )
							for b = 1 to BoneIDSets do
							(
								append BoneIDOffset_Array ( ftell f )
								boneidtotal = readlong f #unsigned
								printDebug ( "Count B = " + boneidtotal as string )
								for x = 1 to boneidtotal do
								(
									properid1 = readlong f #unsigned
									properid2 = readlong f #unsigned
									unkfloat1 = readfloat f
									unkfloat2 = readfloat f
									unkfloat3 = readfloat f
									unkfloat4 = readfloat f
									unkfloat5 = readfloat f
									unkfloat6 = readfloat f
									headerlength = readlong f #unsigned
									unkfloat7 = readfloat f
									unkfloat8 = readfloat f
									unkfloat9 = readfloat f
									unkfloat10 = readfloat f
									unknown = readlong f #unsigned
									printDebug ( "Values = 0x" + ( ( bit.intAsHex ( properid1 ) ) as string ) + ", 0x" + ( ( bit.intAsHex ( properid2 ) ) as string ) + ", " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string + ", " + unkfloat5 as string + ", " + unkfloat6 as string + ", " + unkfloat7 as string + ", " + unkfloat8 as string + ", " + unkfloat9 as string + ", " + unkfloat10 as string )
								)
							)
							printDebug ( "Header 3F start = " + ( ftell f as string ) )
							header3fsize = ( readlong f #unsigned - 4 )
							fseek f header3fsize #seek_cur
							printDebug ( "Header 3G start = " + ( ftell f as string ) )
							header3gsize = ( readlong f #unsigned - 4 )
							fseek f header3gsize #seek_cur
							printDebug ( "Header 3H start = " + ( ftell f as string ) )
							unknown1 = ( readlong f #unsigned - 4 )
							unknown2 = readlong f #unsigned
							boundingminx = readfloat f
							boundingminy = readfloat f
							boundingminz = readfloat f
							boundingmaxx = readfloat f
							boundingmaxy = readfloat f
							boundingmaxz = readfloat f
							unknown3 = ( readlong f #unsigned - 4 )
							unkfloat1 = readfloat f
							unkfloat2 = readfloat f
							unkfloat3 = readfloat f
							unkfloat4 = readfloat f
							blank1 = readlong f #unsigned
							blank2 = readlong f #unsigned
							unkhash1 = readlong f #unsigned
							unkhash2 = readlong f #unsigned
							printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
							printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
							printDebug ( "Header 3H-2 (UV Clamps) start = " + ( ftell f as string ) )
							vertcount = readlong f #unsigned
							unkcount1 = readlong f #unsigned
							UVLayerCount = readlong f #unsigned
							printDebug ( "Count = " + unkcount1 as string + ", " + UVLayerCount as string )
							UV1XMult = 1
							UV1YMult = 1
							UV1XStart = 0
							UV1YStart = 0
							UV2XMult = 1
							UV2YMult = 1
							UV2XStart = 0
							UV2YStart = 0
							UV3XMult = 1
							UV3YMult = 1
							UV3XStart = 0
							UV3YStart = 0
							UV4XMult = 1
							UV4YMult = 1
							UV4XStart = 0
							UV4YStart = 0
							UV5XMult = 1
							UV5YMult = 1
							UV5XStart = 0
							UV5YStart = 0
							UV6XMult = 1
							UV6YMult = 1
							UV6XStart = 0
							UV6YStart = 0
							for x = 1 to UVLayerCount do
							(
								UVLayer = readlong f #unsigned + 1
								UVXMult = readfloat f
								UVYMult = readfloat f
								UVXStart = readfloat f
								UVYStart = readfloat f
								if UVLayer == 1 do
								(
									UV1XMult = UVXMult
									UV1YMult = UVYMult
									UV1XStart = UVXStart
									UV1YStart = UVYStart
								)
								if UVLayer == 2 do
								(
									UV2XMult = UVXMult
									UV2YMult = UVYMult
									UV2XStart = UVXStart
									UV2YStart = UVYStart
								)
								if UVLayer == 3 do
								(
									UV3XMult = UVXMult
									UV3YMult = UVYMult
									UV3XStart = UVXStart
									UV3YStart = UVYStart
								)
								if UVLayer == 4 do
								(
									UV4XMult = UVXMult
									UV4YMult = UVYMult
									UV4XStart = UVXStart
									UV4YStart = UVYStart
								)
								if UVLayer == 5 do
								(
									UV5XMult = UVXMult
									UV5YMult = UVYMult
									UV5XStart = UVXStart
									UV5YStart = UVYStart
								)
								if UVLayer == 6 do
								(
									UV6XMult = UVXMult
									UV6YMult = UVYMult
									UV6XStart = UVXStart
									UV6YStart = UVYStart
								)
								printDebug ( "X Multiply = " + UVXMult as string + ", Y Multiply = " + UVYMult as string + ", X Start = " + UVXStart as string + ", Y Start = " + UVYStart as string + ", Layer = " + UVLayer as string )
							)
							HasVertex = 0
							VertexFmt = 0
							HasNormals = 0
							NormalsFmt = 0
							HasBinormals = 0
							BinormalsFmt = 0
							HasTangents = 0
							TangentsFmt = 0
							HasWeights = 0
							WeightsFmt = 0
							HasBones = 0
							BonesFmt = 0
							HasColors = 0
							ColorsFmt = 0
							HasColors2 = 0
							Colors2Fmt = 0
							HasUV1 = 0
							UV1Fmt = 0
							HasUV2 = 0
							UV2Fmt = 0
							HasUV3 = 0
							UV3Fmt = 0
							HasUV4 = 0
							UV4Fmt = 0
							HasUV5 = 0
							UV5Fmt = 0
							HasUV6 = 0
							UV6Fmt = 0
							printDebug ( "Header 3H-3 (Vertex Buffer) start = " + ( ftell f as string ) )
							unknown = readlong f #unsigned
							unknown2 = readlong f #unsigned
							unknown3 = readlong f #unsigned
							unknown4 = readlong f #unsigned
							BufferCount = readlong f #unsigned
							printDebug ( "Count = " + BufferCount as string )
							if BufferCount != undefined do
							(
								for x = 1 to BufferCount do
								(
									VertType = readlong f #unsigned + 1
									VertFormat = readlong f #unsigned + 1
									VertLayer = readlong f #unsigned + 1
									VertBuffNum = readlong f #unsigned + 1
									VertOffset = readlong f #unsigned + 1
									if VertType == 1 do
									(
										HasVertex = VertBuffNum
										VertexFmt = VertFormat
									)
									if VertType == 2 and VertLayer == 1 do
									(
										HasNormals = VertBuffNum
										NormalsFmt = VertFormat
									)
									if VertType == 2 and VertLayer == 2 do
									(
										HasBinormals = VertBuffNum
										BinormalsFmt = VertFormat
									)
									if VertType == 3 do
									(
										HasTangents = VertBuffNum
										TangentsFmt = VertFormat
									)
									if VertType == 4 do
									(
										HasWeights = VertBuffNum
										WeightsFmt = VertFormat
									)
									if VertType == 5 do
									(
										HasBones = VertBuffNum
										BonesFmt = VertFormat
									)
									if VertType == 6 and VertLayer == 1 do
									(
										HasColors = VertBuffNum
										ColorsFmt = VertFormat
									)
									if VertType == 6 and VertLayer == 2 do
									(
										HasColors2 = VertBuffNum
										Colors2Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 1 do
									(
										HasUV1 = VertBuffNum
										UV1Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 2 do
									(
										HasUV2 = VertBuffNum
										UV2Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 3 do
									(
										HasUV3 = VertBuffNum
										UV3Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 4 do
									(
										HasUV4 = VertBuffNum
										UV4Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 5 do
									(
										HasUV5 = VertBuffNum
										UV5Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 6 do
									(
										HasUV6 = VertBuffNum
										UV6Fmt = VertFormat
									)
									printDebug ( "Vertex Type = " + VertType as string + ", Format = " + VertFormat as string + ", Layer = " + VertLayer as string + ", Buffer = " + VertBuffNum as string + ", Offset = " + VertOffset as string )
								)
								printDebug ( "Header 3I-1 (Polygon Count) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unknown3 = readlong f #unsigned
								facecount = readlong f #unsigned
								facelength = readlong f #unsigned
								printDebug ( "Face length = 0x" + ( ( bit.intAsHex ( facelength ) ) as string ) + ", Count = " + facecount as string )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								printDebug ( "Header 3I-2 (Polygon Count B) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unknown3 = readlong f #unsigned
								facecount2 = readlong f #unsigned
								facelength2 = readlong f #unsigned
								printDebug ( "Face length B = 0x" + ( ( bit.intAsHex ( facelength2 ) ) as string ) + ", Count = " + facecount2 as string )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								printDebug ( "Header 3I-3 (Vertex/Normals Information) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unkcount3 = readlong f #unsigned
								vertcount = readlong f #unsigned
								vertlength = readlong f #unsigned
								printDebug ( "Vertex length = 0x" + ( ( bit.intAsHex ( vertlength ) ) as string ) )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								printDebug ( "Header 3I-4 (UV Information) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unkcount3 = readlong f #unsigned
								uvcount = readlong f #unsigned
								uvlength = readlong f #unsigned
								printDebug ( "UV length = 0x" + ( ( bit.intAsHex ( uvlength ) ) as string ) )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								fseek f facedatastart #seek_set
								printDebug ( "Face start = " + ( ftell f as string ) )
								for x = 1 to facecount / 3 do
								(
									fa = readshort f #unsigned + 1
									fb = readshort f #unsigned + 1
									fc = readshort f #unsigned + 1
									append Face_array [fa, fb, fc]
								)
								printDebug ( "Face start B = " + ( ftell f as string ) )
								for x = 1 to facecount2 / 3 do
								(
									fa = readshort f #unsigned + 1
									fb = readshort f #unsigned + 1
									fc = readshort f #unsigned + 1
									append FaceB_array [fa, fb, fc]
								)
								printDebug ( "Vertex start = " + ( ftell f as string ) )
								for x = 1 to vertcount do
								(
									Weight1 = 1
									Weight2 = 0
									Weight3 = 0
									Weight4 = 0
									Bone1 = 1
									Bone2 = 1
									Bone3 = 1
									Bone4 = 1
									if HasVertex == 1 do
									(
										case of
										(
											default:( throw ( "Unknown positions format!" ) )
											( VertexFmt == 4 ):(
												vx = readfloat f * ModelScale
												vy = readfloat f * ModelScale
												vz = readfloat f * ModelScale
											)
										)
										
										
									)
									if HasWeights == 1 do
									(
										case of
										(
											default:( throw ( "Unknown weights format!" ) )
											( WeightsFmt == 27 ):(
												Weight1 = ( readshort f #unsigned as float / 65535 )
												Weight2 = ( readshort f #unsigned as float / 65535 )
												Weight3 = ( readshort f #unsigned as float / 65535 )
												Weight4 = ( readshort f #unsigned as float / 65535 )
											)
										)
										
										
									)
									if HasBones == 1 do
									(
										case of
										(
											default:( throw ( "Unknown bones format!" ) )
											( BonesFmt == 33 ):(
												Bone1 = readbyte f #unsigned
												Bone2 = readbyte f #unsigned
												Bone3 = readbyte f #unsigned
												Bone4 = readbyte f #unsigned
											)
										)
										
										
									)
									if HasNormals == 1 do
									(
										case of
										(
											default:( throw ( "Unknown normals format!" ) )
											( NormalsFmt == 38 ):(
												nx = readbyte f as float / 127
												ny = readbyte f as float / 127
												nz = readbyte f as float / 127
												nq = readbyte f as float / 127
												append Normal_array [nx, ny, nz]
											)
											( NormalsFmt == 26 ):(
												nx = readshort f as float / 32767
												ny = readshort f as float / 32767
												nz = readshort f as float / 32767
												nq = readshort f as float / 32767
												append Normal_array [nx, ny, nz]
											)
										)
										
										
									)
									if HasBinormals == 1 do
									(
										case of
										(
											default:( throw ( "Unknown binormals format!" ) )
											( BinormalsFmt == 38 ):(
												nx2 = readbyte f as float / 127
												ny2 = readbyte f as float / 127
												nz2 = readbyte f as float / 127
												nq2 = readbyte f as float / 127
											)
											( BinormalsFmt == 26 ):(
												nx2 = readshort f as float / 32767
												ny2 = readshort f as float / 32767
												nz2 = readshort f as float / 32767
												nq2 = readshort f as float / 32767
											)
										)
										
										
									)
									if HasTangents == 1 do
									(
										case of
										(
											default:( throw ( "Unknown tangents format!" ) )
											( TangentsFmt == 38 ):(
												nx3 = readbyte f as float / 127
												ny3 = readbyte f as float / 127
												nz3 = readbyte f as float / 127
												nq3 = readbyte f as float / 127
											)
											( TangentsFmt == 26 ):(
												nx3 = readshort f as float / 32767
												ny3 = readshort f as float / 32767
												nz3 = readshort f as float / 32767
												nq3 = readshort f as float / 32767
											)
										)
										
										
									)
									append Vert_array [vx, vy, vz]
									append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
									append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
								)
								printDebug ( "UV start = " + ( ftell f as string ) )
								for x = 1 to uvcount do
								(
									colorr = 255
									colorg = 255
									colorb = 255
									colora = 1
									tu = 0
									tv = 0
									if HasNormals == 2 do
									(
										case of
										(
											default:( throw ( "Unknown normals format!" ) )
											( NormalsFmt == 38 ):(
												nx = readbyte f as float / 127
												ny = readbyte f as float / 127
												nz = readbyte f as float / 127
												nq = readbyte f as float / 127
												append Normal_array [nx, ny, nz]
											)
											( NormalsFmt == 26 ):(
												nx = readshort f as float / 32767
												ny = readshort f as float / 32767
												nz = readshort f as float / 32767
												nq = readshort f as float / 32767
												append Normal_array [nx, ny, nz]
											)
										)
										
										
									)
									if HasBinormals == 2 do
									(
										case of
										(
											default:( throw ( "Unknown binormals format!" ) )
											( BinormalsFmt == 38 ):(
												nx2 = readbyte f as float / 127
												ny2 = readbyte f as float / 127
												nz2 = readbyte f as float / 127
												nq2 = readbyte f as float / 127
											)
											( BinormalsFmt == 26 ):(
												nx2 = readshort f as float / 32767
												ny2 = readshort f as float / 32767
												nz2 = readshort f as float / 32767
												nq2 = readshort f as float / 32767
											)
										)
										
										
									)
									if HasTangents == 2 do
									(
										case of
										(
											default:( throw ( "Unknown tangents format!" ) )
											( TangentsFmt == 38 ):(
												nx3 = readbyte f as float / 127
												ny3 = readbyte f as float / 127
												nz3 = readbyte f as float / 127
												nq3 = readbyte f as float / 127
											)
											( TangentsFmt == 26 ):(
												nx3 = readshort f as float / 32767
												ny3 = readshort f as float / 32767
												nz3 = readshort f as float / 32767
												nq3 = readshort f as float / 32767
											)
										)
										
										
									)
									if HasUV6 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV6 format!" ) )
											( UV6Fmt == 3 ):(
												tu6 = readfloat f
												tv6 = ( ( readfloat f ) * -1 ) + 1
												append UV6_array [tu6, tv6, 0]
											)
											( UV6Fmt == 24 ):(
												tu6 = ( ( readshort f as float / 32767 ) * UV6XMult ) + UV6XStart
												tv6 = ( ( ( ( readshort f as float / 32767 ) * UV6YMult ) + UV6YStart ) * -1 ) + 1
												append UV6_array [tu6, tv6, 0]
											)
											( UV6Fmt == 25 ):(
												tu6 = ( ( readshort f #unsigned as float / 65535 ) * UV6XMult ) + UV6XStart
												tv6 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV6YMult ) + UV6YStart ) * -1 ) + 1
												append UV6_array [tu6, tv6, 0]
											)
										)
										
										
									)
									if HasUV5 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV5 format!" ) )
											( UV5Fmt == 3 ):(
												tu5 = readfloat f
												tv5 = ( ( readfloat f ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
											( UV5Fmt == 24 ):(
												tu5 = ( ( readshort f as float / 32767 ) * UV5XMult ) + UV5XStart
												tv5 = ( ( ( ( readshort f as float / 32767 ) * UV5YMult ) + UV5YStart ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
											( UV5Fmt == 25 ):(
												tu5 = ( ( readshort f #unsigned as float / 65535 ) * UV5XMult ) + UV5XStart
												tv5 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV5YMult ) + UV5YStart ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
										)
										
										
									)
									if HasColors == 2 do
									(
										case of
										(
											default:( throw ( "Unknown colors format!" ) )
											( ColorsFmt == 33 ):(
												colorr = readbyte f #unsigned
												colorg = readbyte f #unsigned
												colorb = readbyte f #unsigned
												colora = ( readbyte f #unsigned as float ) / 255
											)
											( ColorsFmt == 39 ):(
												colorr = readbyte f #unsigned
												colorg = readbyte f #unsigned
												colorb = readbyte f #unsigned
												colora = ( readbyte f #unsigned as float ) / 255
											)
										)
										
										
									)
									if HasColors2 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown colors2 format!" ) )
											( Colors2Fmt == 33 ):(
												colorr2 = readbyte f #unsigned
												colorg2 = readbyte f #unsigned
												colorb2 = readbyte f #unsigned
												colora2 = ( readbyte f #unsigned as float ) / 255
											)
											( Colors2Fmt == 39 ):(
												colorr2 = readbyte f #unsigned
												colorg2 = readbyte f #unsigned
												colorb2 = readbyte f #unsigned
												colora2 = ( readbyte f #unsigned as float ) / 255
											)
										)
										
										
									)
									if HasUV1 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV1 format!" ) )
											( UV1Fmt == 3 ):(
												tu = readfloat f
												tv = ( ( readfloat f ) * -1 ) + 1
											)
											( UV1Fmt == 24 ):(
												tu = ( ( readshort f as float / 32767 ) * UV1XMult ) + UV1XStart
												tv = ( ( ( ( readshort f as float / 32767 ) * UV1YMult ) + UV1YStart ) * -1 ) + 1
											)
											( UV1Fmt == 25 ):(
												tu = ( ( readshort f #unsigned as float / 65535 ) * UV1XMult ) + UV1XStart
												tv = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV1YMult ) + UV1YStart ) * -1 ) + 1
											)
										)
										
										
									)
									if HasUV2 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV2 format!" ) )
											( UV2Fmt == 3 ):(
												tu2 = readfloat f
												tv2 = ( ( readfloat f ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
											( UV2Fmt == 24 ):(
												tu2 = ( ( readshort f as float / 32767 ) * UV2XMult ) + UV2XStart
												tv2 = ( ( ( ( readshort f as float / 32767 ) * UV2YMult ) + UV2YStart ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
											( UV2Fmt == 25 ):(
												tu2 = ( ( readshort f #unsigned as float / 65535 ) * UV2XMult ) + UV2XStart
												tv2 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV2YMult ) + UV2YStart ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
										)
										
										
									)
									if HasUV3 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV3 format!" ) )
											( UV3Fmt == 3 ):(
												tu3 = readfloat f
												tv3 = ( ( readfloat f ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
											( UV3Fmt == 24 ):(
												tu3 = ( ( readshort f as float / 32767 ) * UV3XMult ) + UV3XStart
												tv3 = ( ( ( ( readshort f as float / 32767 ) * UV3YMult ) + UV3YStart ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
											( UV3Fmt == 25 ):(
												tu3 = ( ( readshort f #unsigned as float / 65535 ) * UV3XMult ) + UV3XStart
												tv3 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV3YMult ) + UV3YStart ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
										)
										
										
									)
									if HasUV4 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV4 format!" ) )
											( UV4Fmt == 3 ):(
												tu4 = readfloat f
												tv4 = ( ( readfloat f ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
											( UV4Fmt == 24 ):(
												tu4 = ( ( readshort f as float / 32767 ) * UV4XMult ) + UV4XStart
												tv4 = ( ( ( ( readshort f as float / 32767 ) * UV4YMult ) + UV4YStart ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
											( UV4Fmt == 25 ):(
												tu4 = ( ( readshort f #unsigned as float / 65535 ) * UV4XMult ) + UV4XStart
												tv4 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV4YMult ) + UV4YStart ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
										)
										
										
									)
									append UV_array [tu, tv, 0]
									append Color_array [colorr, colorg, colorb]
									append Alpha_array colora
								)
								printDebug ( "End of file = " + ( ftell f as string ) )
								printDebug ( PolyStruct_array )
								for i = 1 to PolyStruct_array.count do
								(
									ProperBoneID_array = #()
									FixedBoneID_array = #()
									ActualB1_array = #()
									Weight_array = #()
									Weight_array2 = #()
									Face_array2 = #()
									Face_array3 = #()
									Vert_array2 = #()
									Normal_array2 = #()
									Color_array2 = #()
									Alpha_array2 = #()
									UV_array2 = #()
									UV2_array2 = #()
									UV3_array2 = #()
									UV4_array2 = #()
									UV5_array2 = #()
									UV6_array2 = #()
									if BoneCount != 0 and B1_array.count > 0 do
									(
										fseek f BoneIDOffset_array[1 * PolyStruct_array[i].BoneSetNum] #seek_set
										boneidtotal = readlong f #unsigned
										ProperBoneID_array = #()
										for y = 1 to boneidtotal do
										(
											BoneHash2 = readlong f #unsigned
											BoneHash1 = readlong f #unsigned
											unkfloat1 = readfloat f
											unkfloat2 = readfloat f
											unkfloat3 = readfloat f
											unkfloat4 = readfloat f
											unkfloat5 = readfloat f
											unkfloat6 = readfloat f
											headerlength = readlong f #unsigned
											unkfloat7 = readfloat f
											unkfloat8 = readfloat f
											unkfloat9 = readfloat f
											unkfloat10 = readfloat f
											unknown = readlong f #unsigned
											BoneName = ( "0x" + bit.intAsHex ( BoneHash1 ) as string )
											for z = 1 to BoneHash_array.count do
											(
												if BoneHash1 == BoneHash_array[z].BoneHash1 and BoneHash2 == BoneHash_array[z].BoneHash2 do
												( BoneName = BoneHash_array[z].BoneString )
											)
											append ProperBoneID_array BoneName
										)
										for a = 1 to boneidtotal do
										(
											for b = 1 to BoneCount do
											(
												if ProperBoneID_array[a] == BoneName_array[b] do
												( append FixedBoneID_array b )
											)
										)
										for x = 1 to B1_array.count do
										(
											ImproperBone1 = B1_array[x].Bone1
											ImproperBone2 = B1_array[x].Bone2
											ImproperBone3 = B1_array[x].Bone3
											ImproperBone4 = B1_array[x].Bone4
											ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
											ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
											ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
											ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
											if ProperBone1 == undefined do
											( ProperBone1 = 1 )
											if ProperBone2 == undefined do
											( ProperBone2 = 1 )
											if ProperBone3 == undefined do
											( ProperBone3 = 1 )
											if ProperBone4 == undefined do
											( ProperBone4 = 1 )
											append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
										)
										for b = 1 to W1_array.count Do
										(
											w = ( weight_data boneids: #() weights: #() )
											maxweight = 0
											if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
											if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
											if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
											if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
											if ( maxweight != 0 ) then
											(
												if ( W1_array[b].Weight1 != 0 ) then
												(
													w1 = W1_array[b].Weight1 as float
													append w.boneids ( ActualB1_array[b].Bone1 )
													append w.weights ( w1 )
												)
												if ( W1_array[b].Weight2 != 0 ) then
												(
													w2 = W1_array[b].Weight2 as float
													append w.boneids ( ActualB1_array[b].Bone2 )
													append w.weights ( w2 )
												)
												if ( W1_array[b].Weight3 != 0 ) then
												(
													w3 = W1_array[b].Weight3 as float
													append w.boneids ( ActualB1_array[b].Bone3 )
													append w.weights ( w3 )
												)
												if ( W1_array[b].Weight4 != 0 ) then
												(
													w4 = W1_array[b].Weight4 as float
													append w.boneids ( ActualB1_array[b].Bone4 )
													append w.weights ( w4 )
												)
											)
											append Weight_array w
										)
									)
									for y = PolyStruct_array[i].PolygonStart to ( PolyStruct_array[i].PolygonCount + PolyStruct_array[i].PolygonStart ) do
									( append Face_array2 Face_array[y] )
									VertexMin = PolyStruct_array[i].VertexMin + PolyStruct_array[i].VertexStart
									VertexMax = PolyStruct_array[i].VertexMax + PolyStruct_array[i].VertexStart
									for x = VertexMin to VertexMax do
									(
										append Vert_array2 Vert_array[x]
										append Normal_array2 Normal_array[x]
										append Color_array2 Color_array[x]
										append Alpha_array2 Alpha_array[x]
										append UV_array2 UV_array[x]
										if UV2_array.count > 0 do
										( append UV2_array2 UV2_array[x] )
										if UV3_array.count > 0 do
										( append UV3_array2 UV3_array[x] )
										if UV4_array.count > 0 do
										( append UV4_array2 UV4_array[x] )
										if UV5_array.count > 0 do
										( append UV5_array2 UV5_array[x] )
										if UV6_array.count > 0 do
										( append UV6_array2 UV6_array[x] )
										append Weight_array2 Weight_array[x]
									)
									for x = 1 to PolyStruct_array[i].PolygonCount do
									(
										Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
										append Face_array3 Faces3
									)
									local PolyMat = standardMaterial()
									PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
									PolyMat.showinviewport = true
									PolyMat.twosided = false
									if TexFormat == 1 then
									(
										if TexPath == 1 then
										( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										else
										( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
									)
									else
									(
										if TexPath == 1 then
										( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										else
										( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
									)
									tm.alphasource = 0
									PolyMat.diffuseMap = tm
									PolyMat.opacityMap = tm
									PolyMat.opacityMap.monoOutput = 1
									msh = mesh vertices: Vert_array2 faces: Face_array3
									msh.numTVerts = Vert_array2.count
									if VertColors == true then
									(
										setNumCPVVerts msh msh.numTVerts
										setCVertMode msh true
										setShadeCVerts msh true
									)
									defaultVCFaces msh
									buildTVFaces msh
									if PolyStruct_array[i].LODNum == 1 do
									( msh.name = ( h as string ) )
									if PolyStruct_array[i].LODNum != 1 do
									( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ")" ) )
									msh.material = PolyMat
									if VertColors == true then
									(
										for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
										for j = 1 to Alpha_array2.count do
										( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
									)
									for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
									for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
									max modify mode
									select msh
									for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
									addmodifier msh ( Edit_Normals() ) ui: off
									msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
									EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
									EN_setNormal = msh.Edit_Normals.SetNormal
									normID = #{}
									for v = 1 to Normal_array2.count do
									(
										free normID
										EN_convertVS #{v} &normID
										for id in normID do EN_setNormal id Normal_array2[v]
									)
									if BoneCount != 0 and B1_array.count > 0 do
									(
										skinMod = skin()
										boneIDMap = #()
										addModifier msh skinMod
										for i = 1 to BoneCount do
										(
											maxbone = getnodebyname BoneSetup[i].name
											if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
										)
										local numSkinBones = skinOps.GetNumberBones skinMod
										for i = 1 to numSkinBones do
										(
											local boneName = skinOps.GetBoneName skinMod i 0
											for j = 1 to BoneCount do
											(
												if boneName == BoneSetup[j].Name then
												(
													boneIDMap[j] = i
													j = BoneCount + 1
												)
											)
										)
										modPanel.setCurrentObject skinMod
										for i = 1 to Vert_array2.count do
										(
											skinOps.SetVertexWeights skinMod i 1 1
											skinOps.unnormalizeVertex skinMod i true
											skinOps.SetVertexWeights skinMod i 1 0
										)
										skinOps.RemoveZeroWeights skinMod
										for i = 1 to Vert_array2.count do
										( skinOps.unnormalizeVertex skinMod i false )
										for i = 1 to Weight_array2.count do
										(
											w = Weight_array2[i]
											bi = #()
											wv = #()
											for j = 1 to w.boneids.count do
											(
												boneid = w.boneids[j]
												weight = w.weights[j]
												append bi boneIDMap[boneid]
												append wv weight
											)
											skinOps.ReplaceVertexWeights skinMod i bi wv
										)
									)
									if UVLayers == 1 do
									(
										if UV2_array2.count > 0 do
										(
											meshop.setNumMaps msh 3 keep: true
											for i = 1 to UV2_array2.count do
											( meshop.setMapVert msh 2 i UV2_array2[i] )
										)
										if UV3_array2.count > 0 do
										(
											meshop.setNumMaps msh 4 keep: true
											for i = 1 to UV3_array2.count do
											( meshop.setMapVert msh 3 i UV3_array2[i] )
										)
										if UV4_array2.count > 0 do
										(
											meshop.setNumMaps msh 5 keep: true
											for i = 1 to UV4_array2.count do
											( meshop.setMapVert msh 4 i UV4_array2[i] )
										)
										if UV5_array2.count > 0 do
										(
											meshop.setNumMaps msh 6 keep: true
											for i = 1 to UV5_array2.count do
											( meshop.setMapVert msh 5 i UV5_array2[i] )
										)
										if UV6_array2.count > 0 do
										(
											meshop.setNumMaps msh 7 keep: true
											for i = 1 to UV6_array2.count do
											( meshop.setMapVert msh 6 i UV6_array2[i] )
										)
									)
									if UVLayers == 2 do
									(
										if UV2_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 2" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 2" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV2_array2.count do setTVert msh j UV2_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV3_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 3" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 3" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV3_array2.count do setTVert msh j UV3_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV4_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 4" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 4" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV4_array2.count do setTVert msh j UV4_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV5_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 5" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 5" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV5_array2.count do setTVert msh j UV5_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV6_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 6" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 6" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV6_array2.count do setTVert msh j UV6_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
									)
								)
							)
							fclose f
						)
						( VerNum == 39 ):( print "The PS4 version of Marvel's Guardians of the Galaxy is unsupported. Since the disc only has Episode 1, you're better off getting the PC files anyway." )
						( VerNum == 42 or VerNum == 45 or VerNum == 46 ):(
							Face_array = #()
							FaceB_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							UV2_array = #()
							UV3_array = #()
							UV4_array = #()
							UV5_array = #()
							UV6_array = #()
							B1_array = #()
							W1_array = #()
							Color_array = #()
							Alpha_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							MatHash_array = #()
							TexName_array = #()
							struct Polygon_Info_Struct
							(
								VertexStart,
								VertexMin,
								VertexMax,
								PolygonStart,
								PolygonCount,
								FacePointCount,
								MatNum,
								LODNum
							)
							fseek f 0x0 #seek_set
							MVS6 = readlong f #unsigned
							fseek f 0x0 #seek_set
							if MVS6 == 1297307190 do
							(
								fseek f 0x04 #seek_cur
								filesize = readlong f #unsigned
								fseek f 0x08 #seek_cur
								headerthing = readlong f #unsigned
								for v = 1 to headerthing do
								( fseek f 0x0C #seek_cur )
							)
							nameheaderlength = readlong f #unsigned
							namelength = readlong f #unsigned
							name = ReadFixedString f namelength
							printDebug ( "Model information start = " + ( ftell f as string ) )
							fseek f 0x1D #seek_cur
							printDebug ( "Material information start = " + ( ftell f as string ) )
							matcount = readlong f #unsigned
							printDebug ( "Material Count = " + matcount as string )
							for x = 1 to matcount do
							(
								printDebug ( "Material #" + x as string + " start = " + ( ftell f as string ) )
								MatHash2 = readlong f #unsigned
								MatHash1 = readlong f #unsigned
								UnkHash2 = readlong f #unsigned
								UnkHash1 = readlong f #unsigned
								MatHeaderSize = ( ftell f ) + ( readlong f #unsigned )
								MatUnk1 = readlong f #unsigned
								if MatUnk1 != 0x02 do
								( break() )
								MatUnk2 = readlong f #unsigned
								MatHeaderSizeB = readlong f #unsigned
								MatUnk3 = readlong f #unsigned
								if MatUnk3 != 0x01 do
								( break() )
								MatUnk3Hash2 = readlong f #unsigned
								MatUnk3Hash1 = readlong f #unsigned
								MatParamCount = readlong f #unsigned
								TexDifName = "null"
								for m = 1 to MatParamCount do
								(
									MatSectHash2 = bit.intAsHex ( readlong f #unsigned )
									MatSectHash1 = bit.intAsHex ( readlong f #unsigned )
									MatSectCount = readlong f #unsigned
									case of
									(
										default:( throw ( "Unknown material hashes!" ) )
										( MatSectHash1 == "0" and MatSectHash2 == "0" ):()
										( MatSectHash1 == "a98f0652" and MatSectHash2 == "295de685" ):()
										( MatSectHash1 == "fa21e4c8" and MatSectHash2 == "8ae64d31" ):()
										( MatSectHash1 == "254edc51" and MatSectHash2 == "7b59bb47" ):()
										( MatSectHash1 == "4f0234" and MatSectHash2 == "63d89fb0" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkHash4 = readlong f #unsigned
												MatUnkHash3 = readlong f #unsigned
											)
										)
										( MatSectHash1 == "bae4cbd7" and MatSectHash2 == "7f139a91" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat = readfloat f
											)
										)
										( MatSectHash1 == "9004c558" and MatSectHash2 == "7575d6c0" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkBytePad = readbyte f #unsigned
											)
										)
										( MatSectHash1 == "394c43af" and MatSectHash2 == "4ff52c94" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat1 = readfloat f
												MatUnkFloat2 = readfloat f
												MatUnkFloat3 = readfloat f
											)
										)
										( MatSectHash1 == "7bbca244" and MatSectHash2 == "e61f1a07" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat1 = readfloat f
												MatUnkFloat2 = readfloat f
											)
										)
										( MatSectHash1 == "c16762f7" and MatSectHash2 == "763d62ab" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat1 = readfloat f
												MatUnkFloat2 = readfloat f
												MatUnkFloat3 = readfloat f
												MatUnkFloat4 = readfloat f
											)
										)
										( MatSectHash1 == "52a09151" and MatSectHash2 == "f1c3f2c7" ):(
											for y = 1 to MatSectCount do
											(
												TypeHash2 = bit.intAsHex ( readlong f #unsigned )
												TypeHash1 = bit.intAsHex ( readlong f #unsigned )
												TexHash2 = readlong f #unsigned
												TexHash1 = readlong f #unsigned
												TexName = bit.intAsHex ( TexHash1 ) as string
												for y = 1 to TexHash_array.count do
												(
													if TexHash1 == TexHash_array[y].TexHash1 and TexHash2 == TexHash_array[y].TexHash2 do
													( TexName = TexHash_array[y].TexString )
												)
												if TypeHash1 == "8648fa82" and TypeHash2 == "d1dbee1a" do
												( TexDifName = TexName )
												printDebug ( TypeHash1 + " " + TypeHash2 as string + ": " + TexName )
											)
										)
										( MatSectHash1 == "e2ba743e" and MatSectHash2 == "952f9338" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkHash4 = readlong f #unsigned
												MatUnkHash3 = readlong f #unsigned
												MatUnkHash6 = readlong f #unsigned
												MatUnkHash5 = readlong f #unsigned
											)
										)
									)
									
									
								)
								append MatHash_array ( MatHash_Struct MatHash1: MatHash1 MatHash2: MatHash2 TexDifName: TexDifName )
								printDebug ( "-----" )
								fseek f MatHeaderSize #seek_set
							)
							printDebug ( "Model information start = " + ( ftell f as string ) )
							unknown = readlong f #unsigned
							header3size = ( readlong f #unsigned - 4 )
							facedatastart = ( ftell f ) + header3size
							printDebug ( "LOD information start = " + ( ftell f as string ) )
							header3asize = ( readlong f #unsigned - 4 ) + ( ftell f )
							header3acount = readlong f #unsigned
							printDebug ( "Count = " + header3acount as string )
							for y = 1 to header3acount do
							(
								printDebug ( "LOD # " + y as string + " information start = " + ( ftell f as string ) )
								head3asubsize = ( readlong f #unsigned - 4 )
								polytotal = readlong f #unsigned
								printDebug ( "Count = " + polytotal as string )
								for x = 1 to polytotal do
								(
									boundingminx = readfloat f
									boundingminy = readfloat f
									boundingminz = readfloat f
									boundingmaxx = readfloat f
									boundingmaxy = readfloat f
									boundingmaxz = readfloat f
									headerlength = readlong f #unsigned
									unkfloat1 = readfloat f
									unkfloat2 = readfloat f
									unkfloat3 = readfloat f
									unkfloat4 = readfloat f
									unknown1 = readlong f #unsigned
									VertexMin = readlong f #unsigned + 1
									VertexMax = readlong f #unsigned + 1
									VertexStart = readlong f #unsigned
									FacePointStart = readlong f #unsigned
									PolygonStart = ( FacePointStart / 3 ) + 1
									PolygonCount = readlong f #unsigned
									FacePointCount = readlong f #unsigned
									headerlength2 = readlong f #unsigned
									if headerlength2 == 0x10 do
									(
										unknown2A = readlong f #unsigned
										unknown2B = readlong f #unsigned
									)
									unknown3 = readlong f #unsigned
									MatNum = readlong f #unsigned + 1
									unknown4 = readlong f #unsigned + 1
									if y == 1 do
									( append PolyStruct_array ( Polygon_Info_Struct VertexStart: VertexStart VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum LODNum: y ) )
									if y > 1 and LODs == true do
									( append PolyStruct_array ( Polygon_Info_Struct VertexStart: VertexStart VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum LODNum: y ) )
									printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
									printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
									printDebug ( "VertStart = " + VertexStart as string + ", VertMin = " + VertexMin as string + ", VertMax = " + VertexMax as string + ", PolyStart = " + PolygonStart as string + ", PolyCount = " + PolygonCount as string + ", FacePointCount = " + FacePointCount as string + ", MatNum = " + MatNum as string + ", Unknown = " + unknown4 as string )
									printDebug ( "Unknowns = " + unknown1 as string + ", " + unknown2 as string )
								)
								printDebug ( "Header 3A SubB start = " + ( ftell f as string ) )
								head3asubbsize = ( readlong f #unsigned - 4 )
								if head3asubbsize == 0x04 do
								( fseek f header3asize #seek_set )
								poly2total = readlong f #unsigned
								for x = 1 to poly2total do
								(
									boundingminx = readfloat f
									boundingminy = readfloat f
									boundingminz = readfloat f
									boundingmaxx = readfloat f
									boundingmaxy = readfloat f
									boundingmaxz = readfloat f
									headerlength = readlong f #unsigned
									unkfloat1 = readfloat f
									unkfloat2 = readfloat f
									unkfloat3 = readfloat f
									unkfloat4 = readfloat f
									unknown1 = readlong f #unsigned
									VertexMin = readlong f #unsigned + 1
									VertexMax = readlong f #unsigned + 1
									VertexStart = readlong f #unsigned
									FacePointStart = readlong f #unsigned
									PolygonStart = ( FacePointStart / 3 ) + 1
									PolygonCount = readlong f #unsigned
									FacePointCount = readlong f #unsigned
									headerlength2 = readlong f #unsigned
									if headerlength2 == 0x10 do
									(
										unknown4A = readlong f #unsigned
										unknown4B = readlong f #unsigned
									)
									unknown3 = readlong f #unsigned
									MatNum = readlong f #unsigned + 1
									BoneSetNum = readlong f #unsigned + 1
									printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
									printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
									printDebug ( "VertStart = " + VertexStart as string + ", VertMin = " + VertexMin as string + ", VertMax = " + VertexMax as string + ", PolyStart = " + PolygonStart as string + ", PolyCount = " + PolygonCount as string + ", FacePointCount = " + FacePointCount as string + ", MatNum = " + MatNum as string + ", BoneSet = " + BoneSetNum as string )
									printDebug ( "Unknowns = " + unknown1 as string + ", " + unknown2 as string )
								)
								printDebug ( "Header 3A SubC start = " + ( ftell f as string ) )
								unknown1 = ( readlong f #unsigned - 4 )
								unknown2 = readlong f #unsigned
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								unknown3 = ( readlong f #unsigned - 4 )
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readfloat f
								blank1 = readlong f #unsigned
								unknown4 = readlong f #unsigned
								unknown5 = readlong f #unsigned
								blank2 = readlong f #unsigned
								printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
								printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
								printDebug ( "Values = " + unknown1 as string + ", 0x" + bit.intAsHex ( unknown2 ) as string + ", " + unknown4 as string + ", " + unknown5 as string )
								printDebug ( "Header 3A SubD start = " + ( ftell f as string ) )
								header3subdsize = ( readlong f #unsigned - 4 )
								header3subdcount = readlong f #unsigned
								for y = 1 to header3subdcount do
								(
									unkhash1 = readlong f #unsigned
									unkhash2 = readlong f #unsigned
								)
							)
							printDebug ( "Header 3B start = " + ( ftell f as string ) )
							header3bsize = ( readlong f #unsigned - 4 )
							header3bcount = readlong f #unsigned
							printDebug ( "Count = " + header3bcount as string )
							for x = 1 to header3bcount do
							(
								printDebug ( "Header 3B Sub start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unkhash1 = readlong f #unsigned
								unkhash2 = readlong f #unsigned
								unkhash3 = readlong f #unsigned
								unkhash4 = readlong f #unsigned
								blank1 = readfloat f
								blank2 = readfloat f
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readfloat f
								unkfloat5 = readfloat f
								unkfloat6 = readfloat f
								unknown2 = readlong f #unsigned
								unkfloat9 = readfloat f
								unkfloat10 = readfloat f
								unkfloat11 = readfloat f
								unkfloat12 = readfloat f
								unknown3 = readlong f #unsigned
								printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string + ", " + unkfloat5 as string + ", " + unkfloat6 as string + ", " + unkfloat9 as string + ", " + unkfloat10 as string + ", " + unkfloat11 as string + ", " + unkfloat12 as string )
							)
							printDebug ( "Header 3C (Materials) start = " + ( ftell f as string ) )
							MatGroupSize = ( readlong f #unsigned - 4 )
							MatGroupCount = readlong f #unsigned
							printDebug ( "Count = " + MatGroupCount as string )
							for x = 1 to MatGroupCount do
							(
								MatSectLength = readlong f #unsigned
								MatHash2 = readlong f #unsigned
								MatHash1 = readlong f #unsigned
								MatUnkHash2 = readlong f #unsigned
								MatUnkHash1 = readlong f #unsigned
								blank1 = readfloat f
								blank2 = readfloat f
								MatFloatA = readfloat f
								MatFloatB = readfloat f
								MatFloatC = readfloat f
								MatFloatD = readfloat f
								MatFloatE = readfloat f
								MatFloatF = readfloat f
								MatSubHeaderLen = readlong f #unsigned
								MatSubFloatA = readfloat f
								MatSubFloatB = readfloat f
								MatSubFloatC = readfloat f
								MatSubFloatD = readfloat f
								MatUnk = readlong f #unsigned
								printDebug ( "Floats = " + MatFloatA as string + ", " + MatFloatB as string + ", " + MatFloatC as string + ", " + MatFloatD as string + ", " + MatFloatE as string + ", " + MatFloatF as string + ", " + MatSubFloatA as string + ", " + MatSubFloatB as string + ", " + MatSubFloatC as string + ", " + MatSubFloatD as string )
								for y = 1 to MatHash_array.count do
								(
									if MatHash1 == MatHash_array[y].MatHash1 and MatHash2 == MatHash_array[y].MatHash2 do
									(
										TexName = MatHash_array[y].TexDifName
										append TexName_array TexName
									)
								)
							)
							printDebug ( "Header 3D start = " + ( ftell f as string ) )
							header3dsize = ( readlong f #unsigned - 4 )
							header3dcount = readlong f #unsigned
							printDebug ( "Count = " + header3dcount as string )
							for x = 1 to header3dcount do
							(
								unknownlength = readlong f #unsigned
								unkhash1 = readlong f #unsigned
								unkhash2 = readlong f #unsigned
								unknown = readlong f #unsigned
							)
							printDebug ( "Header 3E (Bone IDs) start = " + ( ftell f as string ) )
							IDHeaderLength = ( readlong f #unsigned - 4 )
							append BoneIDOffset_Array ( ftell f )
							boneidtotal = readlong f #unsigned
							printDebug ( "Count = " + boneidtotal as string )
							for x = 1 to boneidtotal do
							(
								properid1 = readlong f #unsigned
								properid2 = readlong f #unsigned
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readfloat f
								unkfloat5 = readfloat f
								unkfloat6 = readfloat f
								headerlength = readlong f #unsigned
								unkfloat7 = readfloat f
								unkfloat8 = readfloat f
								unkfloat9 = readfloat f
								unkfloat10 = readfloat f
								unknown = readlong f #unsigned
								printDebug ( "Values = 0x" + ( ( bit.intAsHex ( properid1 ) ) as string ) + ", 0x" + ( ( bit.intAsHex ( properid2 ) ) as string ) + ", " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string + ", " + unkfloat5 as string + ", " + unkfloat6 as string + ", " + unkfloat7 as string + ", " + unkfloat8 as string + ", " + unkfloat9 as string + ", " + unkfloat10 as string )
							)
							printDebug ( "Header 3F start = " + ( ftell f as string ) )
							header3fsize = ( readlong f #unsigned - 4 )
							fseek f header3fsize #seek_cur
							printDebug ( "Header 3G start = " + ( ftell f as string ) )
							header3gsize = ( readlong f #unsigned - 4 )
							fseek f header3gsize #seek_cur
							printDebug ( "Header 3H start = " + ( ftell f as string ) )
							unknown1 = ( readlong f #unsigned - 4 )
							unknown2 = readlong f #unsigned
							boundingminx = readfloat f
							boundingminy = readfloat f
							boundingminz = readfloat f
							boundingmaxx = readfloat f
							boundingmaxy = readfloat f
							boundingmaxz = readfloat f
							unknown3 = ( readlong f #unsigned - 4 )
							unkfloat1 = readfloat f
							unkfloat2 = readfloat f
							unkfloat3 = readfloat f
							unkfloat4 = readfloat f
							fseek f 0x24 #seek_cur
							blank1 = readlong f #unsigned
							blank2 = readlong f #unsigned
							unkhash1 = readlong f #unsigned
							unkhash2 = readlong f #unsigned
							printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
							printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
							printDebug ( "Header 3H-2 (UV Clamps) start = " + ( ftell f as string ) )
							vertcount = readlong f #unsigned
							unkcount1 = readlong f #unsigned
							UVLayerCount = readlong f #unsigned
							printDebug ( "Count = " + unkcount1 as string + ", " + UVLayerCount as string )
							UV1XMult = 1
							UV1YMult = 1
							UV1XStart = 0
							UV1YStart = 0
							UV2XMult = 1
							UV2YMult = 1
							UV2XStart = 0
							UV2YStart = 0
							UV3XMult = 1
							UV3YMult = 1
							UV3XStart = 0
							UV3YStart = 0
							UV4XMult = 1
							UV4YMult = 1
							UV4XStart = 0
							UV4YStart = 0
							UV5XMult = 1
							UV5YMult = 1
							UV5XStart = 0
							UV5YStart = 0
							UV6XMult = 1
							UV6YMult = 1
							UV6XStart = 0
							UV6YStart = 0
							for x = 1 to UVLayerCount do
							(
								UVLayer = readlong f #unsigned + 1
								UVXMult = readfloat f
								UVYMult = readfloat f
								UVXStart = readfloat f
								UVYStart = readfloat f
								if UVLayer == 1 do
								(
									UV1XMult = UVXMult
									UV1YMult = UVYMult
									UV1XStart = UVXStart
									UV1YStart = UVYStart
								)
								if UVLayer == 2 do
								(
									UV2XMult = UVXMult
									UV2YMult = UVYMult
									UV2XStart = UVXStart
									UV2YStart = UVYStart
								)
								if UVLayer == 3 do
								(
									UV3XMult = UVXMult
									UV3YMult = UVYMult
									UV3XStart = UVXStart
									UV3YStart = UVYStart
								)
								if UVLayer == 4 do
								(
									UV4XMult = UVXMult
									UV4YMult = UVYMult
									UV4XStart = UVXStart
									UV4YStart = UVYStart
								)
								if UVLayer == 5 do
								(
									UV5XMult = UVXMult
									UV5YMult = UVYMult
									UV5XStart = UVXStart
									UV5YStart = UVYStart
								)
								if UVLayer == 6 do
								(
									UV6XMult = UVXMult
									UV6YMult = UVYMult
									UV6XStart = UVXStart
									UV6YStart = UVYStart
								)
								printDebug ( "X Multiply = " + UVXMult as string + ", Y Multiply = " + UVYMult as string + ", X Start = " + UVXStart as string + ", Y Start = " + UVYStart as string + ", Layer = " + UVLayer as string )
							)
							HasVertex = 0
							VertexFmt = 0
							HasNormals = 0
							NormalsFmt = 0
							HasBinormals = 0
							BinormalsFmt = 0
							HasTangents = 0
							TangentsFmt = 0
							HasWeights = 0
							WeightsFmt = 0
							HasBones = 0
							BonesFmt = 0
							HasColors = 0
							ColorsFmt = 0
							HasColors2 = 0
							Colors2Fmt = 0
							HasUV1 = 0
							UV1Fmt = 0
							HasUV2 = 0
							UV2Fmt = 0
							HasUV3 = 0
							UV3Fmt = 0
							HasUV4 = 0
							UV4Fmt = 0
							HasUV5 = 0
							UV5Fmt = 0
							HasUV6 = 0
							UV6Fmt = 0
							printDebug ( "Header 3H-3 (Vertex Buffer) start = " + ( ftell f as string ) )
							unknown = readlong f #unsigned
							unknown2 = readlong f #unsigned
							unknown3 = readlong f #unsigned
							unknown4 = readlong f #unsigned
							BufferCount = readlong f #unsigned
							printDebug ( "Count = " + BufferCount as string )
							if BufferCount != undefined do
							(
								for x = 1 to BufferCount do
								(
									VertType = readlong f #unsigned + 1
									VertFormat = readlong f #unsigned + 1
									VertLayer = readlong f #unsigned + 1
									VertBuffNum = readlong f #unsigned + 1
									VertOffset = readlong f #unsigned + 1
									if VertType == 1 do
									(
										HasVertex = VertBuffNum
										VertexFmt = VertFormat
									)
									if VertType == 2 and VertLayer == 1 do
									(
										HasNormals = VertBuffNum
										NormalsFmt = VertFormat
									)
									if VertType == 2 and VertLayer == 2 do
									(
										HasBinormals = VertBuffNum
										BinormalsFmt = VertFormat
									)
									if VertType == 3 do
									(
										HasTangents = VertBuffNum
										TangentsFmt = VertFormat
									)
									if VertType == 4 do
									(
										HasWeights = VertBuffNum
										WeightsFmt = VertFormat
									)
									if VertType == 5 do
									(
										HasBones = VertBuffNum
										BonesFmt = VertFormat
									)
									if VertType == 6 and VertLayer == 1 do
									(
										HasColors = VertBuffNum
										ColorsFmt = VertFormat
									)
									if VertType == 6 and VertLayer == 2 do
									(
										HasColors2 = VertBuffNum
										Colors2Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 1 do
									(
										HasUV1 = VertBuffNum
										UV1Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 2 do
									(
										HasUV2 = VertBuffNum
										UV2Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 3 do
									(
										HasUV3 = VertBuffNum
										UV3Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 4 do
									(
										HasUV4 = VertBuffNum
										UV4Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 5 do
									(
										HasUV5 = VertBuffNum
										UV5Fmt = VertFormat
									)
									if VertType == 7 and VertLayer == 6 do
									(
										HasUV6 = VertBuffNum
										UV6Fmt = VertFormat
									)
									printDebug ( "Vertex Type = " + VertType as string + ", Format = " + VertFormat as string + ", Layer = " + VertLayer as string + ", Buffer = " + VertBuffNum as string + ", Offset = " + VertOffset as string )
								)
								printDebug ( "Header 3I-1 (Polygon Count) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unknown3 = readlong f #unsigned
								facecount = readlong f #unsigned
								facelength = readlong f #unsigned
								printDebug ( "Face length = 0x" + ( ( bit.intAsHex ( facelength ) ) as string ) )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								printDebug ( "Header 3I-2 (Polygon B Count) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unknown3 = readlong f #unsigned
								facecountB = readlong f #unsigned
								facelengthB = readlong f #unsigned
								printDebug ( "Face length = 0x" + ( ( bit.intAsHex ( facelengthB ) ) as string ) )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								if facelengthB != 0x02 do
								(
									printDebug ( "Wait, that's not right." )
									fseek f -0x14 #seek_cur
									faceCountB = 0
								)
								printDebug ( "Header 3I-3 (Vertex/Normals Information) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unkcount3 = readlong f #unsigned
								vertcount = readlong f #unsigned
								vertlength = readlong f #unsigned
								printDebug ( "Vertex length = 0x" + ( ( bit.intAsHex ( vertlength ) ) as string ) )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								printDebug ( "Header 3I-4 (UV Information) start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								unkcount3 = readlong f #unsigned
								uvcount = readlong f #unsigned
								uvlength = readlong f #unsigned
								printDebug ( "UV length = 0x" + ( ( bit.intAsHex ( uvlength ) ) as string ) )
								printDebug ( "Values = " + unknown1 as string + ", " + unknown2 as string + ", " + unknown3 as string )
								fseek f facedatastart #seek_set
								printDebug ( "Face start = " + ( ftell f as string ) )
								for x = 1 to facecount / 3 do
								(
									fa = readshort f #unsigned + 1
									fb = readshort f #unsigned + 1
									fc = readshort f #unsigned + 1
									append Face_array [fa, fb, fc]
								)
								printDebug ( "Face start B = " + ( ftell f as string ) )
								for x = 1 to facecountB / 3 do
								(
									fa = readshort f #unsigned + 1
									fb = readshort f #unsigned + 1
									fc = readshort f #unsigned + 1
									append FaceB_array [fa, fb, fc]
								)
								printDebug ( "Vertex start = " + ( ftell f as string ) )
								for x = 1 to vertcount do
								(
									Weight1 = 1
									Weight2 = 0
									Weight3 = 0
									Weight4 = 0
									Bone1 = 1
									Bone2 = 1
									Bone3 = 1
									Bone4 = 1
									if HasVertex == 1 do
									(
										case of
										(
											default:( throw ( "Unknown positions format!" ) )
											( VertexFmt == 4 ):(
												vx = readfloat f * ModelScale
												vy = readfloat f * ModelScale
												vz = readfloat f * ModelScale
											)
										)
										
										
									)
									if HasWeights == 1 do
									(
										case of
										(
											default:( throw ( "Unknown weights format!" ) )
											( WeightsFmt == 27 ):(
												Weight1 = ( readshort f #unsigned as float / 65535 )
												Weight2 = ( readshort f #unsigned as float / 65535 )
												Weight3 = ( readshort f #unsigned as float / 65535 )
												Weight4 = ( readshort f #unsigned as float / 65535 )
											)
										)
										
										
									)
									if HasBones == 1 do
									(
										case of
										(
											default:( throw ( "Unknown bones format!" ) )
											( BonesFmt == 33 ):(
												Bone1 = readbyte f #unsigned
												Bone2 = readbyte f #unsigned
												Bone3 = readbyte f #unsigned
												Bone4 = readbyte f #unsigned
											)
										)
										
										
									)
									if HasNormals == 1 do
									(
										case of
										(
											default:( throw ( "Unknown normals format!" ) )
											( NormalsFmt == 38 ):(
												nx = readbyte f as float / 127
												ny = readbyte f as float / 127
												nz = readbyte f as float / 127
												nq = readbyte f as float / 127
												append Normal_array [nx, ny, nz]
											)
											( NormalsFmt == 26 ):(
												nx = readshort f as float / 32767
												ny = readshort f as float / 32767
												nz = readshort f as float / 32767
												nq = readshort f as float / 32767
												append Normal_array [nx, ny, nz]
											)
										)
										
										
									)
									if HasBinormals == 1 do
									(
										case of
										(
											default:( throw ( "Unknown binormals format!" ) )
											( BinormalsFmt == 38 ):(
												nx2 = readbyte f as float / 127
												ny2 = readbyte f as float / 127
												nz2 = readbyte f as float / 127
												nq2 = readbyte f as float / 127
											)
											( BinormalsFmt == 26 ):(
												nx2 = readshort f as float / 32767
												ny2 = readshort f as float / 32767
												nz2 = readshort f as float / 32767
												nq2 = readshort f as float / 32767
											)
										)
										
										
									)
									if HasTangents == 1 do
									(
										case of
										(
											default:( throw ( "Unknown tangents format!" ) )
											( TangentsFmt == 38 ):(
												nx3 = readbyte f as float / 127
												ny3 = readbyte f as float / 127
												nz3 = readbyte f as float / 127
												nq3 = readbyte f as float / 127
											)
											( TangentsFmt == 26 ):(
												nx3 = readshort f as float / 32767
												ny3 = readshort f as float / 32767
												nz3 = readshort f as float / 32767
												nq3 = readshort f as float / 32767
											)
										)
										
										
									)
									append Vert_array [vx, vy, vz]
									append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
									append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
								)
								printDebug ( "UV start = " + ( ftell f as string ) )
								for x = 1 to uvcount do
								(
									colorr = 255
									colorg = 255
									colorb = 255
									colora = 1
									tu = 0
									tv = 0
									if HasNormals == 2 do
									(
										case of
										(
											default:( throw ( "Unknown normals format!" ) )
											( NormalsFmt == 38 ):(
												nx = readbyte f as float / 127
												ny = readbyte f as float / 127
												nz = readbyte f as float / 127
												nq = readbyte f as float / 127
												append Normal_array [nx, ny, nz]
											)
											( NormalsFmt == 26 ):(
												nx = readshort f as float / 32767
												ny = readshort f as float / 32767
												nz = readshort f as float / 32767
												nq = readshort f as float / 32767
												append Normal_array [nx, ny, nz]
											)
										)
										
										
									)
									if HasBinormals == 2 do
									(
										case of
										(
											default:( throw ( "Unknown binormals format!" ) )
											( BinormalsFmt == 38 ):(
												nx2 = readbyte f as float / 127
												ny2 = readbyte f as float / 127
												nz2 = readbyte f as float / 127
												nq2 = readbyte f as float / 127
											)
											( BinormalsFmt == 26 ):(
												nx2 = readshort f as float / 32767
												ny2 = readshort f as float / 32767
												nz2 = readshort f as float / 32767
												nq2 = readshort f as float / 32767
											)
										)
										
										
									)
									if HasTangents == 2 do
									(
										case of
										(
											default:( throw ( "Unknown tangents format!" ) )
											( TangentsFmt == 38 ):(
												nx3 = readbyte f as float / 127
												ny3 = readbyte f as float / 127
												nz3 = readbyte f as float / 127
												nq3 = readbyte f as float / 127
											)
											( TangentsFmt == 26 ):(
												nx3 = readshort f as float / 32767
												ny3 = readshort f as float / 32767
												nz3 = readshort f as float / 32767
												nq3 = readshort f as float / 32767
											)
										)
										
										
									)
									if HasUV6 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV6 format!" ) )
											( UV6Fmt == 3 ):(
												tu6 = readfloat f
												tv6 = ( ( readfloat f ) * -1 ) + 1
												append UV6_array [tu6, tv6, 0]
											)
											( UV6Fmt == 24 ):(
												tu6 = ( ( readshort f as float / 32767 ) * UV6XMult ) + UV6XStart
												tv6 = ( ( ( ( readshort f as float / 32767 ) * UV6YMult ) + UV6YStart ) * -1 ) + 1
												append UV6_array [tu6, tv6, 0]
											)
											( UV6Fmt == 25 ):(
												tu6 = ( ( readshort f #unsigned as float / 65535 ) * UV6XMult ) + UV6XStart
												tv6 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV6YMult ) + UV6YStart ) * -1 ) + 1
												append UV6_array [tu6, tv6, 0]
											)
										)
										
										
									)
									if HasUV5 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV5 format!" ) )
											( UV5Fmt == 3 ):(
												tu5 = readfloat f
												tv5 = ( ( readfloat f ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
											( UV5Fmt == 24 ):(
												tu5 = ( ( readshort f as float / 32767 ) * UV5XMult ) + UV5XStart
												tv5 = ( ( ( ( readshort f as float / 32767 ) * UV5YMult ) + UV5YStart ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
											( UV5Fmt == 25 ):(
												tu5 = ( ( readshort f #unsigned as float / 65535 ) * UV5XMult ) + UV5XStart
												tv5 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV5YMult ) + UV5YStart ) * -1 ) + 1
												append UV5_array [tu5, tv5, 0]
											)
										)
										
										
									)
									if HasColors == 2 do
									(
										case of
										(
											default:( throw ( "Unknown colors format!" ) )
											( ColorsFmt == 33 ):(
												colorr = readbyte f #unsigned
												colorg = readbyte f #unsigned
												colorb = readbyte f #unsigned
												colora = ( readbyte f #unsigned as float ) / 255
											)
											( ColorsFmt == 39 ):(
												colorr = readbyte f #unsigned
												colorg = readbyte f #unsigned
												colorb = readbyte f #unsigned
												colora = ( readbyte f #unsigned as float ) / 255
											)
										)
										
										
									)
									if HasColors2 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown colors2 format!" ) )
											( Colors2Fmt == 33 ):(
												colorr2 = readbyte f #unsigned
												colorg2 = readbyte f #unsigned
												colorb2 = readbyte f #unsigned
												colora2 = ( readbyte f #unsigned as float ) / 255
											)
											( Colors2Fmt == 39 ):(
												colorr2 = readbyte f #unsigned
												colorg2 = readbyte f #unsigned
												colorb2 = readbyte f #unsigned
												colora2 = ( readbyte f #unsigned as float ) / 255
											)
										)
										
										
									)
									if HasUV1 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV1 format!" ) )
											( UV1Fmt == 3 ):(
												tu = readfloat f
												tv = ( ( readfloat f ) * -1 ) + 1
											)
											( UV1Fmt == 24 ):(
												tu = ( ( readshort f as float / 32767 ) * UV1XMult ) + UV1XStart
												tv = ( ( ( ( readshort f as float / 32767 ) * UV1YMult ) + UV1YStart ) * -1 ) + 1
											)
											( UV1Fmt == 25 ):(
												tu = ( ( readshort f #unsigned as float / 65535 ) * UV1XMult ) + UV1XStart
												tv = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV1YMult ) + UV1YStart ) * -1 ) + 1
											)
										)
										
										
									)
									if HasUV2 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV2 format!" ) )
											( UV2Fmt == 3 ):(
												tu2 = readfloat f
												tv2 = ( ( readfloat f ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
											( UV2Fmt == 24 ):(
												tu2 = ( ( readshort f as float / 32767 ) * UV2XMult ) + UV2XStart
												tv2 = ( ( ( ( readshort f as float / 32767 ) * UV2YMult ) + UV2YStart ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
											( UV2Fmt == 25 ):(
												tu2 = ( ( readshort f #unsigned as float / 65535 ) * UV2XMult ) + UV2XStart
												tv2 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV2YMult ) + UV2YStart ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
										)
										
										
									)
									if HasUV3 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV3 format!" ) )
											( UV3Fmt == 3 ):(
												tu3 = readfloat f
												tv3 = ( ( readfloat f ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
											( UV3Fmt == 24 ):(
												tu3 = ( ( readshort f as float / 32767 ) * UV3XMult ) + UV3XStart
												tv3 = ( ( ( ( readshort f as float / 32767 ) * UV3YMult ) + UV3YStart ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
											( UV3Fmt == 25 ):(
												tu3 = ( ( readshort f #unsigned as float / 65535 ) * UV3XMult ) + UV3XStart
												tv3 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV3YMult ) + UV3YStart ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
										)
										
										
									)
									if HasUV4 == 2 do
									(
										case of
										(
											default:( throw ( "Unknown UV4 format!" ) )
											( UV4Fmt == 3 ):(
												tu4 = readfloat f
												tv4 = ( ( readfloat f ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
											( UV4Fmt == 24 ):(
												tu4 = ( ( readshort f as float / 32767 ) * UV4XMult ) + UV4XStart
												tv4 = ( ( ( ( readshort f as float / 32767 ) * UV4YMult ) + UV4YStart ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
											( UV4Fmt == 25 ):(
												tu4 = ( ( readshort f #unsigned as float / 65535 ) * UV4XMult ) + UV4XStart
												tv4 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV4YMult ) + UV4YStart ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
										)
										
										
									)
									append UV_array [tu, tv, 0]
									append Color_array [colorr, colorg, colorb]
									append Alpha_array colora
								)
								printDebug ( "End of file = " + ( ftell f as string ) )
								printDebug ( PolyStruct_array )
								for i = 1 to PolyStruct_array.count do
								(
									ProperBoneID_array = #()
									FixedBoneID_array = #()
									ActualB1_array = #()
									Weight_array = #()
									Weight_array2 = #()
									Face_array2 = #()
									Face_array3 = #()
									Vert_array2 = #()
									Normal_array2 = #()
									Color_array2 = #()
									Alpha_array2 = #()
									UV_array2 = #()
									UV2_array2 = #()
									UV3_array2 = #()
									UV4_array2 = #()
									UV5_array2 = #()
									UV6_array2 = #()
									if BoneCount != 0 and B1_array.count > 0 do
									(
										fseek f BoneIDOffset_array[1] #seek_set
										boneidtotal = readlong f #unsigned
										ProperBoneID_array = #()
										for y = 1 to boneidtotal do
										(
											BoneHash2 = readlong f #unsigned
											BoneHash1 = readlong f #unsigned
											unkfloat1 = readfloat f
											unkfloat2 = readfloat f
											unkfloat3 = readfloat f
											unkfloat4 = readfloat f
											unkfloat5 = readfloat f
											unkfloat6 = readfloat f
											headerlength = readlong f #unsigned
											unkfloat7 = readfloat f
											unkfloat8 = readfloat f
											unkfloat9 = readfloat f
											unkfloat10 = readfloat f
											unknown = readlong f #unsigned
											BoneName = ( "0x" + bit.intAsHex ( BoneHash1 ) as string )
											for z = 1 to BoneHash_array.count do
											(
												if BoneHash1 == BoneHash_array[z].BoneHash1 and BoneHash2 == BoneHash_array[z].BoneHash2 do
												( BoneName = BoneHash_array[z].BoneString )
											)
											append ProperBoneID_array BoneName
										)
										for a = 1 to boneidtotal do
										(
											for b = 1 to BoneCount do
											(
												if ProperBoneID_array[a] == BoneName_array[b] do
												( append FixedBoneID_array b )
											)
										)
										for x = 1 to B1_array.count do
										(
											ImproperBone1 = B1_array[x].Bone1
											ImproperBone2 = B1_array[x].Bone2
											ImproperBone3 = B1_array[x].Bone3
											ImproperBone4 = B1_array[x].Bone4
											ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
											ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
											ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
											ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
											if ProperBone1 == undefined do
											( ProperBone1 = 1 )
											if ProperBone2 == undefined do
											( ProperBone2 = 1 )
											if ProperBone3 == undefined do
											( ProperBone3 = 1 )
											if ProperBone4 == undefined do
											( ProperBone4 = 1 )
											append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
										)
										for b = 1 to W1_array.count Do
										(
											w = ( weight_data boneids: #() weights: #() )
											maxweight = 0
											if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
											if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
											if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
											if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
											if ( maxweight != 0 ) then
											(
												if ( W1_array[b].Weight1 != 0 ) then
												(
													w1 = W1_array[b].Weight1 as float
													append w.boneids ( ActualB1_array[b].Bone1 )
													append w.weights ( w1 )
												)
												if ( W1_array[b].Weight2 != 0 ) then
												(
													w2 = W1_array[b].Weight2 as float
													append w.boneids ( ActualB1_array[b].Bone2 )
													append w.weights ( w2 )
												)
												if ( W1_array[b].Weight3 != 0 ) then
												(
													w3 = W1_array[b].Weight3 as float
													append w.boneids ( ActualB1_array[b].Bone3 )
													append w.weights ( w3 )
												)
												if ( W1_array[b].Weight4 != 0 ) then
												(
													w4 = W1_array[b].Weight4 as float
													append w.boneids ( ActualB1_array[b].Bone4 )
													append w.weights ( w4 )
												)
											)
											append Weight_array w
										)
									)
									for y = PolyStruct_array[i].PolygonStart to ( PolyStruct_array[i].PolygonCount + PolyStruct_array[i].PolygonStart ) do
									( append Face_array2 Face_array[y] )
									VertexMin = PolyStruct_array[i].VertexMin + PolyStruct_array[i].VertexStart
									VertexMax = PolyStruct_array[i].VertexMax + PolyStruct_array[i].VertexStart
									for x = VertexMin to VertexMax do
									(
										append Vert_array2 Vert_array[x]
										append Normal_array2 Normal_array[x]
										append Color_array2 Color_array[x]
										append Alpha_array2 Alpha_array[x]
										append UV_array2 UV_array[x]
										if UV2_array.count > 0 do
										( append UV2_array2 UV2_array[x] )
										if UV3_array.count > 0 do
										( append UV3_array2 UV3_array[x] )
										if UV4_array.count > 0 do
										( append UV4_array2 UV4_array[x] )
										if UV5_array.count > 0 do
										( append UV5_array2 UV5_array[x] )
										if UV6_array.count > 0 do
										( append UV6_array2 UV6_array[x] )
										append Weight_array2 Weight_array[x]
									)
									for x = 1 to PolyStruct_array[i].PolygonCount do
									(
										Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
										append Face_array3 Faces3
									)
									local PolyMat = standardMaterial()
									PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
									PolyMat.showinviewport = true
									PolyMat.twosided = false
									if TexFormat == 1 then
									(
										if TexPath == 1 then
										( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										else
										( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
									)
									else
									(
										if TexPath == 1 then
										( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										else
										( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
									)
									tm.alphasource = 0
									PolyMat.diffuseMap = tm
									PolyMat.opacityMap = tm
									PolyMat.opacityMap.monoOutput = 1
									msh = mesh vertices: Vert_array2 faces: Face_array3
									msh.numTVerts = Vert_array2.count
									if VertColors == true then
									(
										setNumCPVVerts msh msh.numTVerts
										setCVertMode msh true
										setShadeCVerts msh true
									)
									defaultVCFaces msh
									buildTVFaces msh
									if PolyStruct_array[i].LODNum == 1 do
									( msh.name = ( h as string ) )
									if PolyStruct_array[i].LODNum != 1 do
									( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ")" ) )
									msh.material = PolyMat
									if VertColors == true then
									(
										for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
										for j = 1 to Alpha_array2.count do
										( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
									)
									for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
									for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
									max modify mode
									select msh
									for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
									addmodifier msh ( Edit_Normals() ) ui: off
									msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
									EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
									EN_setNormal = msh.Edit_Normals.SetNormal
									normID = #{}
									for v = 1 to Normal_array2.count do
									(
										free normID
										EN_convertVS #{v} &normID
										for id in normID do EN_setNormal id Normal_array2[v]
									)
									if BoneCount != 0 and B1_array.count > 0 do
									(
										skinMod = skin()
										boneIDMap = #()
										addModifier msh skinMod
										for i = 1 to BoneCount do
										(
											maxbone = getnodebyname BoneSetup[i].name
											if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
										)
										local numSkinBones = skinOps.GetNumberBones skinMod
										for i = 1 to numSkinBones do
										(
											local boneName = skinOps.GetBoneName skinMod i 0
											for j = 1 to BoneCount do
											(
												if boneName == BoneSetup[j].Name then
												(
													boneIDMap[j] = i
													j = BoneCount + 1
												)
											)
										)
										modPanel.setCurrentObject skinMod
										for i = 1 to Vert_array2.count do
										(
											skinOps.SetVertexWeights skinMod i 1 1
											skinOps.unnormalizeVertex skinMod i true
											skinOps.SetVertexWeights skinMod i 1 0
										)
										skinOps.RemoveZeroWeights skinMod
										for i = 1 to Vert_array2.count do
										( skinOps.unnormalizeVertex skinMod i false )
										for i = 1 to Weight_array2.count do
										(
											w = Weight_array2[i]
											bi = #()
											wv = #()
											for j = 1 to w.boneids.count do
											(
												boneid = w.boneids[j]
												weight = w.weights[j]
												append bi boneIDMap[boneid]
												append wv weight
											)
											skinOps.ReplaceVertexWeights skinMod i bi wv
										)
									)
									if UVLayers == 1 do
									(
										if UV2_array2.count > 0 do
										(
											meshop.setNumMaps msh 3 keep: true
											for i = 1 to UV2_array2.count do
											( meshop.setMapVert msh 2 i UV2_array2[i] )
										)
										if UV3_array2.count > 0 do
										(
											meshop.setNumMaps msh 4 keep: true
											for i = 1 to UV3_array2.count do
											( meshop.setMapVert msh 3 i UV3_array2[i] )
										)
										if UV4_array2.count > 0 do
										(
											meshop.setNumMaps msh 5 keep: true
											for i = 1 to UV4_array2.count do
											( meshop.setMapVert msh 4 i UV4_array2[i] )
										)
										if UV5_array2.count > 0 do
										(
											meshop.setNumMaps msh 6 keep: true
											for i = 1 to UV5_array2.count do
											( meshop.setMapVert msh 5 i UV5_array2[i] )
										)
										if UV6_array2.count > 0 do
										(
											meshop.setNumMaps msh 7 keep: true
											for i = 1 to UV6_array2.count do
											( meshop.setMapVert msh 6 i UV6_array2[i] )
										)
									)
									if UVLayers == 2 do
									(
										if UV2_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 2" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 2" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV2_array2.count do setTVert msh j UV2_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV3_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 3" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 3" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV3_array2.count do setTVert msh j UV3_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV4_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 4" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 4" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV4_array2.count do setTVert msh j UV4_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV5_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 5" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 5" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV5_array2.count do setTVert msh j UV5_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV6_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 6" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 6" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV6_array2.count do setTVert msh j UV6_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
									)
								)
							)
							fclose f
						)
						( VerNum == 55 ):(
							Face_array = #()
							FaceB_array = #()
							Vert_array = #()
							Normal_array = #()
							UV_array = #()
							UV2_array = #()
							UV3_array = #()
							UV4_array = #()
							B1_array = #()
							W1_array = #()
							Color_array = #()
							Alpha_array = #()
							FixedBoneID_array = #()
							BoneIDOffset_array = #()
							PolyStruct_array = #()
							MatHash_array = #()
							TexName_array = #()
							FacePointCount = 0
							FacePointCountB = 0
							struct Polygon_Info_Struct
							(
								VertexStart,
								VertexMin,
								VertexMax,
								PolygonStart,
								PolygonCount,
								FacePointCount,
								MatNum,
								LODNum
							)
							fseek f 0x0 #seek_set
							MVS6 = readlong f #unsigned
							fseek f 0x0 #seek_set
							if MVS6 == 1297307190 do
							(
								fseek f 0x04 #seek_cur
								filesize = readlong f #unsigned
								fseek f 0x08 #seek_cur
								headerthing = readlong f #unsigned
								for v = 1 to headerthing do
								( fseek f 0x0C #seek_cur )
							)
							nameheaderlength = readlong f #unsigned
							namelength = readlong f #unsigned
							name = ReadFixedString f namelength
							printDebug ( "Section 1 (Model info) start = " + ( ftell f as string ) )
							fseek f 0x15 #seek_cur
							printDebug ( "Section 2 (Material info) start = " + ( ftell f as string ) )
							MatCount = readlong f #unsigned
							printDebug ( "Material Count = " + matcount as string )
							for x = 1 to MatCount do
							(
								printDebug ( "Material #" + x as string + " start = " + ( ftell f as string ) )
								MatHash2 = readlong f #unsigned
								MatHash1 = readlong f #unsigned
								UnkHash2 = readlong f #unsigned
								UnkHash1 = readlong f #unsigned
								MatHeaderSize = ( ftell f ) + ( readlong f #unsigned )
								MatUnk1 = readlong f #unsigned
								MatUnk2 = readlong f #unsigned
								MatHeaderSizeB = readlong f #unsigned
								MatUnk3 = readlong f #unsigned
								MatUnk3Hash2 = readlong f #unsigned
								MatUnk3Hash1 = readlong f #unsigned
								MatParamCount = readlong f #unsigned
								TexDifName = "null"
								printDebug ( "Material parameter count = " + MatParamCount as string )
								for m = 1 to MatParamCount do
								(
									MatSectHash2 = bit.intAsHex ( readlong f #unsigned )
									MatSectHash1 = bit.intAsHex ( readlong f #unsigned )
									MatSectCount = readlong f #unsigned
									printDebug ( "Material hash: " + MatSectHash1 + " " + MatSectHash2 + ", Count = " + MatSectCount as string + ", Offset = " + ( ftell f ) as string )
									case of
									(
										default:( throw ( "Unknown material hashes!" ) )
										( MatSectHash1 == "0" and MatSectHash2 == "0" ):()
										( MatSectHash1 == "a98f0652" and MatSectHash2 == "295de685" ):()
										( MatSectHash1 == "fa21e4c8" and MatSectHash2 == "8ae64d31" ):()
										( MatSectHash1 == "254edc51" and MatSectHash2 == "7b59bb47" ):()
										( MatSectHash1 == "873c2f18" and MatSectHash2 == "35428297" ):( fseek f 0x08 #seek_cur )
										( MatSectHash1 == "4e7d91f1" and MatSectHash2 == "6f97a3c2" ):( fseek f -0x04 #seek_cur )
										( MatSectHash1 == "181afb3e" and MatSectHash2 == "bb8f90ae" ):()
										( MatSectHash1 == "fec9ffdf" and MatSectHash2 == "25b43917" ):( fseek f -0x04 #seek_cur )
										( MatSectHash1 == "8c44858f" and MatSectHash2 == "42cd32d5" ):()
										( MatSectHash1 == "b76e07d6" and MatSectHash2 == "bb899bfe" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat1 = readfloat f
												MatUnkFloat2 = readfloat f
												MatUnkFloat3 = readfloat f
												MatUnkFloat4 = readfloat f
											)
										)
										( MatSectHash1 == "4f0234" and MatSectHash2 == "63d89fb0" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkHash4 = readlong f #unsigned
												MatUnkHash3 = readlong f #unsigned
											)
										)
										( MatSectHash1 == "bae4cbd7" and MatSectHash2 == "7f139a91" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat = readfloat f
											)
										)
										( MatSectHash1 == "9004c558" and MatSectHash2 == "7575d6c0" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkBytePad = readbyte f #unsigned
											)
										)
										( MatSectHash1 == "394c43af" and MatSectHash2 == "4ff52c94" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat1 = readfloat f
												MatUnkFloat2 = readfloat f
												MatUnkFloat3 = readfloat f
											)
										)
										( MatSectHash1 == "7bbca244" and MatSectHash2 == "e61f1a07" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat1 = readfloat f
												MatUnkFloat2 = readfloat f
											)
										)
										( MatSectHash1 == "c16762f7" and MatSectHash2 == "763d62ab" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkFloat1 = readfloat f
												MatUnkFloat2 = readfloat f
												MatUnkFloat3 = readfloat f
												MatUnkFloat4 = readfloat f
											)
										)
										( MatSectHash1 == "52a09151" and MatSectHash2 == "f1c3f2c7" ):(
											for y = 1 to MatSectCount do
											(
												TypeHash2 = bit.intAsHex ( readlong f #unsigned )
												TypeHash1 = bit.intAsHex ( readlong f #unsigned )
												TexHash2 = readlong f #unsigned
												TexHash1 = readlong f #unsigned
												TexName = bit.intAsHex ( TexHash1 ) as string
												for y = 1 to TexHash_array.count do
												(
													if TexHash1 == TexHash_array[y].TexHash1 and TexHash2 == TexHash_array[y].TexHash2 do
													( TexName = TexHash_array[y].TexString )
												)
												if TypeHash1 == "8648fa82" and TypeHash2 == "d1dbee1a" do
												( TexDifName = TexName )
												printDebug ( TypeHash1 + " " + TypeHash2 as string + ": " + TexName )
											)
										)
										( MatSectHash1 == "e2ba743e" and MatSectHash2 == "952f9338" ):(
											for y = 1 to MatSectCount do
											(
												MatUnkHash2 = readlong f #unsigned
												MatUnkHash1 = readlong f #unsigned
												MatUnkHash4 = readlong f #unsigned
												MatUnkHash3 = readlong f #unsigned
												MatUnkHash6 = readlong f #unsigned
												MatUnkHash5 = readlong f #unsigned
											)
										)
									)
									
									
								)
								append MatHash_array ( MatHash_Struct MatHash1: MatHash1 MatHash2: MatHash2 TexDifName: TexDifName )
								printDebug ( "-----" )
								fseek f MatHeaderSize #seek_set
							)
							printDebug ( "Section 2 end = " + ( ftell f as string ) )
							unknown = readlong f #unsigned
							pad = readbyte f #unsigned
							FaceDataStart = ( ftell f ) + readlong f #unsigned
							Sect3Size = ( ftell f ) + readlong f #unsigned
							Sect3Count = readlong f #unsigned
							printDebug ( "Section 3 (LOD info) start = " + ( ftell f as string ) + ", Count = " + Sect3Count as string )
							for y = 1 to Sect3Count do
							(
								printDebug ( "LOD # " + y as string + " information start = " + ( ftell f as string ) )
								Sect3ASize = ( ftell f ) + ( readlong f #unsigned )
								PolyTotal = readlong f #unsigned
								printDebug ( "Count = " + polytotal as string )
								for x = 1 to PolyTotal do
								(
									boundingminx = readfloat f
									boundingminy = readfloat f
									boundingminz = readfloat f
									boundingmaxx = readfloat f
									boundingmaxy = readfloat f
									boundingmaxz = readfloat f
									headerlength = readlong f #unsigned
									unknown1 = readlong f #unsigned
									unkfloat2 = readfloat f
									unkfloat3 = readfloat f
									unkfloat4 = readfloat f
									unknown2 = readlong f #unsigned
									VertexMin = readlong f #unsigned + 1
									VertexMax = readlong f #unsigned + 1
									VertexStart = readlong f #unsigned
									FacePointStart = readlong f #unsigned
									PolygonStart = ( FacePointStart / 3 ) + 1
									PolygonCount = readlong f #unsigned
									FacePointCount = readlong f #unsigned
									headerlength2 = readlong f #unsigned
									if headerlength2 == 0x10 do
									(
										unknown2A = readlong f #unsigned
										unknown2B = readlong f #unsigned
									)
									unknown3 = readlong f #unsigned
									MatNum = readlong f #unsigned + 1
									unknown4 = readlong f #unsigned + 1
									if y == 1 do
									( append PolyStruct_array ( Polygon_Info_Struct VertexStart: VertexStart VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum LODNum: y ) )
									if y > 1 and LODs == true do
									( append PolyStruct_array ( Polygon_Info_Struct VertexStart: VertexStart VertexMin: VertexMin VertexMax: VertexMax PolygonStart: PolygonStart PolygonCount: PolygonCount FacePointCount: FacePointCount MatNum: MatNum LODNum: y ) )
									printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
									printDebug ( "Floats = " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
									printDebug ( "VertStart = " + VertexStart as string + ", VertMin = " + VertexMin as string + ", VertMax = " + VertexMax as string + ", PolyStart = " + PolygonStart as string + ", PolyCount = " + PolygonCount as string + ", FacePointCount = " + FacePointCount as string + ", MatNum = " + MatNum as string + ", Unknowns = " + unknown2 as string + ", " + unknown3 as string + ", " + unknown4 as string )
								)
								fseek f Sect3ASize #seek_set
								printDebug ( "Section 3B start = " + ( ftell f as string ) )
								Sect3BSize = ( ftell f ) + ( readlong f #unsigned )
								Poly2Total = readlong f #unsigned
								for x = 1 to Poly2Total do
								(
									boundingminx = readfloat f
									boundingminy = readfloat f
									boundingminz = readfloat f
									boundingmaxx = readfloat f
									boundingmaxy = readfloat f
									boundingmaxz = readfloat f
									headerlength = readlong f #unsigned
									unknown1 = readlong f #unsigned
									unkfloat2 = readfloat f
									unkfloat3 = readfloat f
									unkfloat4 = readfloat f
									unknown2 = readlong f #unsigned
									VertexMin = readlong f #unsigned + 1
									VertexMax = readlong f #unsigned + 1
									VertexStart = readlong f #unsigned
									FacePointStart = readlong f #unsigned
									PolygonStart = ( FacePointStart / 3 ) + 1
									PolygonCount = readlong f #unsigned
									FacePointCount = readlong f #unsigned
									headerlength2 = readlong f #unsigned
									if headerlength2 == 0x10 do
									(
										unknown2A = readlong f #unsigned
										unknown2B = readlong f #unsigned
									)
									unknown3 = readlong f #unsigned
									MatNum = readlong f #unsigned + 1
									unknown4 = readlong f #unsigned + 1
									printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
									printDebug ( "Floats = " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
									printDebug ( "VertStart = " + VertexStart as string + ", VertMin = " + VertexMin as string + ", VertMax = " + VertexMax as string + ", PolyStart = " + PolygonStart as string + ", PolyCount = " + PolygonCount as string + ", FacePointCount = " + FacePointCount as string + ", MatNum = " + MatNum as string + ", Unknowns = " + unknown2 as string + ", " + unknown3 as string + ", " + unknown4 as string )
								)
								fseek f Sect3BSize #seek_set
								printDebug ( "Section 3C start = " + ( ftell f as string ) )
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								boundingminx = readfloat f
								boundingminy = readfloat f
								boundingminz = readfloat f
								boundingmaxx = readfloat f
								boundingmaxy = readfloat f
								boundingmaxz = readfloat f
								unknown3 = ( readlong f #unsigned - 4 )
								unkfloat1 = readfloat f
								unkfloat2 = readfloat f
								unkfloat3 = readfloat f
								unkfloat4 = readfloat f
								blank1 = readlong f #unsigned
								blank2 = readlong f #unsigned
								unknown4 = readlong f #unsigned
								unknown5 = readlong f #unsigned
								blank3 = readlong f #unsigned
								unknown6 = readlong f #unsigned
								unknown7 = readlong f #unsigned
								unknown8 = readlong f #unsigned
								unknown9 = readlong f #unsigned
								unknown10 = readlong f #unsigned
								printDebug ( "Bounding Box = " + boundingminx as string + ", " + boundingminy as string + ", " + boundingminz as string + " | " + boundingmaxx as string + ", " + boundingmaxy as string + ", " + boundingmaxz as string )
								printDebug ( "Floats = " + unkfloat1 as string + ", " + unkfloat2 as string + ", " + unkfloat3 as string + ", " + unkfloat4 as string )
								printDebug ( "Values = " + unknown1 as string + ", 0x" + bit.intAsHex ( unknown2 ) as string + ", " + unknown4 as string + ", " + unknown6 as string + ", " + unknown5 as string + ", " + unknown7 as string + ", " + unknown8 as string + ", " + unknown9 as string + ", " + unknown10 as string )
								IDHeaderLength = ( readlong f #unsigned - 4 )
								append BoneIDOffset_Array ( ftell f )
								BoneIDTotal = readlong f #unsigned
								printDebug ( "Section 3D (Bone IDs) start = " + ( ftell f as string ) + ", Count = " + BoneIDTotal as string )
								for x = 1 to BoneIDTotal do
								(
									BoneHash2 = readlong f #unsigned
									BoneHash1 = readlong f #unsigned
								)
							)
							fseek f Sect3Size #seek_set
							Sect4Size = ( ftell f ) + readlong f #unsigned
							Sect4Count = readlong f #unsigned
							printDebug ( "Section 4 (Empty?) start = " + ( ftell f as string ) + ", Count = " + Sect4Count as string )
							fseek f Sect4Size #seek_set
							Sect5Size = ( ftell f ) + readlong f #unsigned
							MatGroupSectCount = readlong f #unsigned
							printDebug ( "Section 5 (Material Groups) start = " + ( ftell f as string ) + ", Count = " + MatGroupSectCount as string )
							for x = 1 to MatGroupSectCount do
							(
								MatSectLength = readlong f #unsigned
								MatHash2 = readlong f #unsigned
								MatHash1 = readlong f #unsigned
								MatUnkHash2 = readlong f #unsigned
								MatUnkHash1 = readlong f #unsigned
								blank1 = readfloat f
								blank2 = readfloat f
								MatFloatA = readfloat f
								MatFloatB = readfloat f
								MatFloatC = readfloat f
								MatFloatD = readfloat f
								MatFloatE = readfloat f
								MatFloatF = readfloat f
								MatSubHeaderLen = readlong f #unsigned
								MatSubFloatA = readfloat f
								MatSubFloatB = readfloat f
								MatSubFloatC = readfloat f
								MatSubFloatD = readfloat f
								MatUnk = readlong f #unsigned
								printDebug ( "Floats = " + MatFloatA as string + ", " + MatFloatB as string + ", " + MatFloatC as string + ", " + MatFloatD as string + ", " + MatFloatE as string + ", " + MatFloatF as string + ", " + MatSubFloatA as string + ", " + MatSubFloatB as string + ", " + MatSubFloatC as string + ", " + MatSubFloatD as string )
								for y = 1 to MatHash_array.count do
								(
									if MatHash1 == MatHash_array[y].MatHash1 and MatHash2 == MatHash_array[y].MatHash2 do
									(
										TexName = MatHash_array[y].TexDifName
										append TexName_array TexName
									)
								)
							)
							fseek f Sect5Size #seek_set
							Sect6Size = ( ftell f ) + readlong f #unsigned
							Sect6Count = readlong f #unsigned
							printDebug ( "Section 6 start = " + ( ftell f as string ) + ", Count = " + Sect6Count as string )
							for x = 1 to Sect6Count do
							(
								Sect6HeaderLength = readlong f #unsigned
								Sect6Hash2 = readlong f #unsigned
								Sect6Hash1 = readlong f #unsigned
								Sect6Unk = readlong f #unsigned
							)
							fseek f Sect6Size #seek_set
							Sect7Size = ( ftell f ) + readlong f #unsigned
							BoneIDCount = readlong f #unsigned
							printDebug ( "Section 7 (Bone IDs) start = " + ( ftell f as string ) + ", Count = " + BoneIDCount as string )
							BoneIDOffset = ( ftell f )
							for x = 1 to BoneIDCount do
							(
								BoneHash2 = readlong f #unsigned
								BoneHash1 = readlong f #unsigned
								BoneFloatA = readfloat f
								BoneFloatB = readfloat f
								BoneFloatC = readfloat f
								BoneFloatD = readfloat f
								BoneFloatE = readfloat f
								BoneFloatF = readfloat f
								BoneSubHeaderLength = readlong f #unsigned
								BoneSubFloatA = readfloat f
								BoneSubFloatB = readfloat f
								BoneSubFloatC = readfloat f
								BoneSubFloatD = readfloat f
								BoneSubUnk = readlong f
							)
							fseek f Sect7Size #seek_set
							Sect8Size = ( ftell f ) + readlong f #unsigned
							Sect8Count = readlong f #unsigned
							printDebug ( "Section 8 (Empty?) start = " + ( ftell f as string ) + ", Count = " + Sect8Count as string )
							fseek f Sect8Size #seek_set
							Sect9Size = ( ftell f ) + readlong f #unsigned
							Sect9Count = readlong f #unsigned
							printDebug ( "Section 9 start = " + ( ftell f as string ) + ", Count = " + Sect9Count as string )
							fseek f Sect9Size #seek_set
							printDebug ( "Section 10 (Model Clamps) start = " + ( ftell f as string ) )
							MeshUnk1 = readlong f #unsigned
							MeshFlag1 = readbyte f #unsigned
							MeshFlag2 = readbyte f #unsigned
							MeshFlag3 = readbyte f #unsigned
							MeshFlag4 = readbyte f #unsigned
							MeshXMin = readfloat f
							MeshYMin = readfloat f
							MeshZMin = readfloat f
							MeshXMax = readfloat f
							MeshYMax = readfloat f
							MeshZMax = readfloat f
							MeshXMult = MeshXMax - MeshXMin
							MeshYMult = MeshYMax - MeshYMin
							MeshZMult = MeshZMax - MeshZMin
							MeshSubSectLength = readlong f #unsigned
							MeshFloatA = readfloat f
							MeshFloatB = readfloat f
							MeshFloatC = readfloat f
							MeshFloatD = readfloat f
							MeshUnk3 = readlong f #unsigned
							MeshFloat1 = readfloat f
							MeshFloat2 = readfloat f
							MeshFloat3 = readfloat f
							MeshFloatX = readfloat f
							MeshFloatY = readfloat f
							MeshFloatZ = readfloat f
							MeshFloat4 = readfloat f
							MeshFloat5 = readfloat f
							MeshFloat6 = readfloat f
							MeshUnk4 = readlong f #unsigned
							MeshHash2 = readlong f #unsigned
							MeshHash1 = readlong f #unsigned
							MeshOrient = "Q"
							if MeshFloatX != 0x00 do
							( MeshOrient = "X" )
							if MeshFloatY != 0x00 do
							( MeshOrient = "Y" )
							if MeshFloatZ != 0x00 do
							( MeshOrient = "Z" )
							printDebug ( "Section 11 start = " + ( ftell f as string ) )
							VertCount = readlong f #unsigned
							UnkCount1 = readlong f #unsigned
							Sect11ASize = ( ftell f ) + readlong f #unsigned
							Sect11ACount = readlong f #unsigned
							printDebug ( "Counts: " + UnkCount1 as string + ", " + Sect11ACount as string )
							fseek f Sect11ASize #seek_set
							printDebug ( "Section 11B (UV Clamps) start = " + ( ftell f as string ) )
							UVLayerCount = readlong f #unsigned
							printDebug ( "Count = " + unkcount1 as string + ", " + UVLayerCount as string )
							UV1XMult = 1
							UV1YMult = 1
							UV1XStart = 0
							UV1YStart = 0
							UV2XMult = 1
							UV2YMult = 1
							UV2XStart = 0
							UV2YStart = 0
							UV3XMult = 1
							UV3YMult = 1
							UV3XStart = 0
							UV3YStart = 0
							UV4XMult = 1
							UV4YMult = 1
							UV4XStart = 0
							UV4YStart = 0
							for x = 1 to UVLayerCount do
							(
								UVLayer = readlong f #unsigned + 1
								UVXMult = readfloat f
								UVYMult = readfloat f
								UVXStart = readfloat f
								UVYStart = readfloat f
								case UVLayer of
								(
									1 :(
										UV1XMult = UVXMult
										UV1YMult = UVYMult
										UV1XStart = UVXStart
										UV1YStart = UVYStart
									)
									2 :(
										UV2XMult = UVXMult
										UV2YMult = UVYMult
										UV2XStart = UVXStart
										UV2YStart = UVYStart
									)
									3 :(
										UV3XMult = UVXMult
										UV3YMult = UVYMult
										UV3XStart = UVXStart
										UV3YStart = UVYStart
									)
									4 :(
										UV4XMult = UVXMult
										UV4YMult = UVYMult
										UV4XStart = UVXStart
										UV4YStart = UVYStart
									)
								)
								
								
								printDebug ( "X Multiply = " + UVXMult as string + ", Y Multiply = " + UVYMult as string + ", X Start = " + UVXStart as string + ", Y Start = " + UVYStart as string + ", Layer = " + UVLayer as string )
							)
							if VertCount != 0 do
							(
								printDebug ( "Section 11C start = " + ( ftell f as string ) )
								HasVertex = 0
								VertexFmt = 0
								HasNormals = 0
								NormalsFmt = 0
								HasTangents = 0
								TangentsFmt = 0
								HasWeights = 0
								WeightsFmt = 0
								HasBones = 0
								BonesFmt = 0
								HasColors = 0
								ColorsFmt = 0
								HasColors2 = 0
								Colors2Fmt = 0
								HasUV1 = 0
								UV1Fmt = 0
								HasUV2 = 0
								UV2Fmt = 0
								HasUV3 = 0
								UV3Fmt = 0
								HasUV4 = 0
								UV4Fmt = 0
								case MeshFlag1 of
								(
									default:()
									0x09 :()
									0x19 :()
									0x00 :()
									0x01 :()
									0x03 :()
									0x05 :()
									0x09 :()
									0x21 :()
									0x31 :(
										VertBuffUnk1 = readlong f #unsigned
										VertBuffUnk2 = readlong f #unsigned
										VertBuffUnk3 = readlong f #unsigned
										VertBuffUnk4 = readlong f #unsigned
										VertBuffUnk5 = readlong f #unsigned
										VertBuffUnk6 = readlong f #unsigned
										VertBuffUnk7 = readlong f #unsigned
										VertBuffUnk8 = readlong f #unsigned
										VertBuffUnk9 = readlong f #unsigned
										VertParamStart = ( ftell f ) + readlong f #unsigned
										VertBuffSize = readlong f #unsigned
										VertStart = ( ftell f )
										fseek f VertParamStart #seek_set
									)
								)
								
								
								printDebug ( "Section 12 (Vertex/Face Buffer Info) start = " + ( ftell f as string ) )
								BuffUnk1 = readlong f #unsigned
								BuffUnk2 = readlong f #unsigned
								FaceBufferCount = readlong f #unsigned
								BufferCount1 = readlong f #unsigned
								BufferCount2 = readlong f #unsigned
								for y = 1 to BufferCount1 do
								(
									VertType = readlong f #unsigned + 1
									VertFormat = readlong f #unsigned + 1
									VertLayer = readlong f #unsigned + 1
									VertBuffNum = readlong f #unsigned + 1
									VertOffset = readlong f #unsigned + 1
									printDebug ( "Vertex Type = " + VertType as string + ", Format = " + VertFormat as string + ", Layer = " + VertLayer as string + ", Buffer = " + VertBuffNum as string + ", Offset = " + VertOffset as string )
									case of
									(
										default:( throw "Unknown vertex buffer combination!" )
										( VertType == 1 and VertLayer == 1 ):(
											HasVertex = VertBuffNum
											VertexFmt = VertFormat
										)
										( VertType == 4 and VertLayer == 1 ):(
											HasWeights = VertBuffNum
											WeightsFmt = VertFormat
										)
										( VertType == 5 and VertLayer == 1 ):(
											HasBones = VertBuffNum
											BonesFmt = VertFormat
										)
										( VertType == 2 and VertLayer == 1 ):(
											HasNormals = VertBuffNum
											NormalsFmt = VertFormat
										)
										( VertType == 3 and VertLayer == 1 ):(
											HasTangents = VertBuffNum
											TangentsFmt = VertFormat
										)
										( VertType == 2 and VertLayer == 2 ):(
											HasBinormals = VertBuffNum
											BinormalsFmt = VertFormat
										)
										( VertType == 7 and VertLayer == 5 ):(
											HasUV5 = VertBuffNum
											UV5Fmt = VertFormat
										)
										( VertType == 7 and VertLayer == 6 ):(
											HasUV6 = VertBuffNum
											UV6Fmt = VertFormat
										)
										( VertType == 6 and VertLayer == 1 ):(
											HasColors = VertBuffNum
											ColorsFmt = VertFormat
										)
										( VertType == 6 and VertLayer == 2 ):(
											HasColors2 = VertBuffNum
											Colors2Fmt = VertFormat
										)
										( VertType == 7 and VertLayer == 1 ):(
											HasUV1 = VertBuffNum
											UV1Fmt = VertFormat
										)
										( VertType == 7 and VertLayer == 2 ):(
											HasUV2 = VertBuffNum
											UV2Fmt = VertFormat
										)
										( VertType == 7 and VertLayer == 3 ):(
											HasUV3 = VertBuffNum
											UV3Fmt = VertFormat
										)
										( VertType == 7 and VertLayer == 4 ):(
											HasUV4 = VertBuffNum
											UV4Fmt = VertFormat
										)
									)
									
									
								)
								for y = 1 to FaceBufferCount do
								(
									FaceBuffUnk1 = readlong f #unsigned
									FaceBuffUnk2 = readlong f #unsigned
									FaceBuffUnk3 = readlong f #unsigned
									FaceBuffCount = readlong f #unsigned
									FaceBuffLength = readlong f #unsigned
									case y of
									(
										1 :(
											FacePointCount = FaceBuffCount
											FaceLength = FaceBuffLength
										)
										2 :(
											FacePointCountB = FaceBuffCount
											FaceLengthB = FaceBuffLength
										)
									)
									
									
								)
								for y = 1 to BufferCount2 do
								(
									Buff2Unk1 = readlong f #unsigned
									Buff2Format = readlong f #unsigned
									Buff2Unk2 = readlong f #unsigned
									Buff2Count = readlong f #unsigned
									Buff2Length = readlong f #unsigned
								)
								fseek f FaceDataStart #seek_set
								printDebug ( "Facepoint buffer A start = " + ( ftell f as string ) )
								for x = 1 to FacePointCount / 3 do
								(
									fa = readshort f #unsigned + 1
									fb = readshort f #unsigned + 1
									fc = readshort f #unsigned + 1
									append Face_array [fa, fb, fc]
								)
								if FaceBufferCount == 2 do
								(
									printDebug ( "Facepoint buffer B start = " + ( ftell f as string ) )
									for x = 1 to FacePointCountB / 3 do
									(
										fa = readshort f #unsigned + 1
										fb = readshort f #unsigned + 1
										fc = readshort f #unsigned + 1
										append FaceB_array [fa, fb, fc]
									)
									printDebug ( "Facepoint buffer B end = " + ( ftell f as string ) )
								)
								case MeshFlag1 of
								(
									default:()
									0x09 :()
									0x19 :()
									0x1F:(
										VertStartB = ( ftell f )
										fseek f VertStart #seek_set
										printDebug ( "Vertex buffer A start = " + ( ftell f as string ) )
										for x = 1 to VertCount do
										(
											vx = readfloat f * ModelScale
											vy = readfloat f * ModelScale
											vz = readfloat f * ModelScale
											Bone1 = readbyte f #unsigned
											Bone2 = readbyte f #unsigned
											Bone3 = readbyte f #unsigned
											Bone4 = readbyte f #unsigned
											append B1_array ( Bone_Info_Struct Bone1: Bone1 Bone2: Bone2 Bone3: Bone3 Bone4: Bone4 )
											fseek f 0x08 #seek_cur
											append Vert_array [vx, vy, vz]
										)
										fseek f VertStartB #seek_set
									)
								)
								
								
								if HasVertex > 0 do
								(
									printDebug ( "Positions start = " + ( ftell f as string ) )
									case of
									(
										default:( throw ( "Unknown position format!" ) )
										( VertexFmt == 4 ):(
											for x = 1 to VertCount do
											(
												vx = readfloat f * ModelScale
												vy = readfloat f * ModelScale
												vz = readfloat f * ModelScale
												if MeshFlag1 != 0x1F do
												( append Vert_array [vx, vy, vz] )
											)
										)
										( VertexFmt == 27 ):(
											for x = 1 to VertCount do
											(
												vx = ( ( ( readshort f #unsigned as float / 65535 ) * MeshXMult ) + MeshXMin ) * ModelScale
												vy = ( ( ( readshort f #unsigned as float / 65535 ) * MeshYMult ) + MeshYMin ) * ModelScale
												vz = ( ( ( readshort f #unsigned as float / 65535 ) * MeshZMult ) + MeshZMin ) * ModelScale
												vq = ( readshort f #unsigned as float / 65535 )
												if MeshFlag1 != 0x1F do
												( append Vert_array [vx, vy, vz] )
											)
										)
										( VertexFmt == 42 ):(
											print ( "Model has awkward vertex setup, may be incorrect?" )
											for x = 1 to VertCount do
											(
												PosVars = readlong f
												vx = ( ( bit.and ( PosVars ) 0x3FF ) as float / 1023 )
												vy = ( ( bit.and ( bit.shift PosVars -10 ) 0x3FF ) as float / 1023 )
												vz = ( ( bit.and ( bit.shift PosVars - 20 ) 0x3FF ) as float / 1023 )
												case MeshOrient of
												(
													"Q":()
													"X":( vx = vx / 4 + ( ( bit.shift PosVars - 30 ) as float / 4 ) )
													"Y":( vy = vy / 4 + ( ( bit.shift PosVars -30 ) as float / 4 ) )
													"Z":( vz = vz / 4 + ( ( bit.shift PosVars - 30 ) as float / 4 ) )
												)
												
												
												vx = ( ( vx * MeshXMult ) + MeshXMin ) * ModelScale
												vy = ( ( vy * MeshYMult ) + MeshYMin ) * ModelScale
												vz = ( ( vz * MeshZMult ) + MeshZMin ) * ModelScale
												if MeshFlag1 != 0x1F do
												( append Vert_array [vx, vy, vz] )
											)
										)
									)
									
									
								)
								if HasWeights > 0 do
								(
									printDebug ( "Weights start = " + ( ftell f as string ) )
									case of
									(
										default:( throw ( "Unknown weights format!" ) )
										( WeightsFmt == 27 ):(
											for x = 1 to VertCount do
											(
												Weight1 = ( readshort f #unsigned as float / 65535 )
												Weight2 = ( readshort f #unsigned as float / 65535 )
												Weight3 = ( readshort f #unsigned as float / 65535 )
												Weight4 = ( readshort f #unsigned as float / 65535 )
												append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
											)
										)
										( WeightsFmt == 42 ):(
											for x = 1 to VertCount do
											(
												WeightVars = readlong f
												Weight2 = ( ( ( bit.and ( WeightVars ) 0x3FF ) as float / 1023 ) / 8 ) + ( ( bit.shift WeightVars -30 ) as float / 8 )
												Weight3 = ( ( bit.and ( bit.shift WeightVars - 10 ) 0x3FF ) as float / 1023 ) / 3
												Weight4 = ( ( bit.and ( bit.shift WeightVars -20 ) 0x3FF ) as float / 1023 ) / 4
												Weight1 = ( 1 as float - Weight2 - Weight3 - Weight4 )
												append W1_array ( Weight_Info_Struct Weight1: Weight1 Weight2: Weight2 Weight3: Weight3 Weight4: Weight4 )
											)
										)
									)
									
									
								)
								if HasBones > 0 do
								(
									printDebug ( "Bone IDs start = " + ( ftell f as string ) )
									case of
									(
										default:( throw ( "Unknown bones format!" ) )
										( BonesFmt == 33 ):(
											for x = 1 to VertCount do
											(
												Bone1 = readbyte f #unsigned
												Bone2 = readbyte f #unsigned
												Bone3 = readbyte f #unsigned
												Bone4 = readbyte f #unsigned
											)
										)
									)
									
									
								)
								if HasNormals > 0 do
								(
									printDebug ( "Normals start = " + ( ftell f as string ) )
									case of
									(
										default:( throw ( "Unknown normals format!" ) )
										( NormalsFmt == 38 ):(
											for x = 1 to VertCount do
											(
												nx = readbyte f as float / 127
												ny = readbyte f as float / 127
												nz = readbyte f as float / 127
												nq = readbyte f as float / 127
												append Normal_array [nx, ny, nz]
											)
										)
										( NormalsFmt == 26 ):(
											for x = 1 to VertCount do
											(
												nx = readshort f as float / 32767
												ny = readshort f as float / 32767
												nz = readshort f as float / 32767
												nq = readshort f as float / 32767
												append Normal_array [nx, ny, nz]
											)
										)
									)
									
									
								)
								if HasTangents > 0 do
								(
									printDebug ( "Tangents(?) start = " + ( ftell f as string ) )
									case of
									(
										default:( throw ( "Unknown tangents format!" ) )
										( TangentsFmt == 38 ):(
											for x = 1 to VertCount do
											(
												nx3 = readbyte f as float / 127
												ny3 = readbyte f as float / 127
												nz3 = readbyte f as float / 127
												nq3 = readbyte f as float / 127
											)
										)
									)
									
									
								)
								if HasColors > 0 do
								(
									printDebug ( "Colors start = " + ( ftell f as string ) )
									case of
									(
										default:( throw ( "Unknown colors format!" ) )
										( ColorsFmt == 33 ):(
											for x = 1 to VertCount do
											(
												colorr = readbyte f #unsigned
												colorg = readbyte f #unsigned
												colorb = readbyte f #unsigned
												colora = ( readbyte f #unsigned as float ) / 255
												append Color_array [colorr, colorg, colorb]
											)
										)
										( ColorsFmt == 39 ):(
											for x = 1 to VertCount do
											(
												colorr = readbyte f #unsigned
												colorg = readbyte f #unsigned
												colorb = readbyte f #unsigned
												colora = ( readbyte f #unsigned as float ) / 255
												append Color_array [colorr, colorg, colorb]
											)
										)
									)
									
									
								)
								if HasColors2 > 0 do
								(
									printDebug ( "Colors B start = " + ( ftell f as string ) )
									case of
									(
										default:( throw ( "Unknown colors2 format!" ) )
										( Colors2Fmt == 33 ):(
											for x = 1 to VertCount do
											(
												colorr2 = readbyte f #unsigned
												colorg2 = readbyte f #unsigned
												colorb2 = readbyte f #unsigned
												colora2 = ( readbyte f #unsigned as float ) / 255
											)
										)
										( Colors2Fmt == 39 ):(
											for x = 1 to VertCount do
											(
												colorr2 = readbyte f #unsigned
												colorg2 = readbyte f #unsigned
												colorb2 = readbyte f #unsigned
												colora2 = ( readbyte f #unsigned as float ) / 255
											)
										)
									)
									
									
								)
								if HasUV1 > 0 do
								(
									printDebug ( "UVs start = " + ( ftell f as string ) )
									case of
									(
										default:( throw ( "Unknown UV1 format!" ) )
										( UV1Fmt == 3 ):(
											for x = 1 to VertCount do
											(
												tu = readfloat f
												tv = ( ( readfloat f ) * -1 ) + 1
												append UV_array [tu, tv, 0]
											)
										)
										( UV1Fmt == 24 ):(
											for x = 1 to VertCount do
											(
												tu = ( ( readshort f as float / 32767 ) * UV1XMult ) + UV1XStart
												tv = ( ( ( ( readshort f as float / 32767 ) * UV1YMult ) + UV1YStart ) * -1 ) + 1
												append UV_array [tu, tv, 0]
											)
										)
										( UV1Fmt == 25 ):(
											for x = 1 to VertCount do
											(
												tu = ( ( readshort f #unsigned as float / 65535 ) * UV1XMult ) + UV1XStart
												tv = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV1YMult ) + UV1YStart ) * -1 ) + 1
												append UV_array [tu, tv, 0]
											)
										)
									)
									
									
								)
								if HasUV2 > 0 do
								(
									printDebug ( "UVs 2 start = " + ( ftell f as string ) )
									case of
									(
										default:( throw ( "Unknown UV2 format!" ) )
										( UV2Fmt == 3 ):(
											for x = 1 to VertCount do
											(
												tu2 = readfloat f
												tv2 = ( ( readfloat f ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
										)
										( UV2Fmt == 24 ):(
											for x = 1 to VertCount do
											(
												tu2 = ( ( readshort f as float / 32767 ) * UV2XMult ) + UV2XStart
												tv2 = ( ( ( ( readshort f as float / 32767 ) * UV2YMult ) + UV2YStart ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
										)
										( UV2Fmt == 25 ):(
											for x = 1 to VertCount do
											(
												tu2 = ( ( readshort f #unsigned as float / 65535 ) * UV2XMult ) + UV2XStart
												tv2 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV2YMult ) + UV2YStart ) * -1 ) + 1
												append UV2_array [tu2, tv2, 0]
											)
										)
									)
									
									
								)
								if HasUV3 > 0 do
								(
									printDebug ( "UVs 3 start = " + ( ftell f as string ) )
									case of
									(
										default:( throw ( "Unknown UV3 format!" ) )
										( UV3Fmt == 3 ):(
											for x = 1 to VertCount do
											(
												tu3 = readfloat f
												tv3 = ( ( readfloat f ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
										)
										( UV3Fmt == 24 ):(
											for x = 1 to VertCount do
											(
												tu3 = ( ( readshort f as float / 32767 ) * UV3XMult ) + UV3XStart
												tv3 = ( ( ( ( readshort f as float / 32767 ) * UV3YMult ) + UV3YStart ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
										)
										( UV3Fmt == 25 ):(
											for x = 1 to VertCount do
											(
												tu3 = ( ( readshort f #unsigned as float / 65535 ) * UV3XMult ) + UV3XStart
												tv3 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV3YMult ) + UV3YStart ) * -1 ) + 1
												append UV3_array [tu3, tv3, 0]
											)
										)
									)
									
									
								)
								if HasUV4 > 0 do
								(
									printDebug ( "UVs 4 start = " + ( ftell f as string ) )
									case of
									(
										default:( throw ( "Unknown UV4 format!" ) )
										( UV4Fmt == 3 ):(
											for x = 1 to VertCount do
											(
												tu4 = readfloat f
												tv4 = ( ( readfloat f ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
										)
										( UV4Fmt == 24 ):(
											for x = 1 to VertCount do
											(
												tu4 = ( ( readshort f as float / 32767 ) * UV4XMult ) + UV4XStart
												tv4 = ( ( ( ( readshort f as float / 32767 ) * UV4YMult ) + UV4YStart ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
										)
										( UV4Fmt == 25 ):(
											for x = 1 to VertCount do
											(
												tu4 = ( ( readshort f #unsigned as float / 65535 ) * UV4XMult ) + UV4XStart
												tv4 = ( ( ( ( readshort f #unsigned as float / 65535 ) * UV4YMult ) + UV4YStart ) * -1 ) + 1
												append UV4_array [tu4, tv4, 0]
											)
										)
									)
									
									
								)
								printDebug ( "End of file = " + ( ftell f as string ) )
								printDebug ( PolyStruct_array )
								for i = 1 to PolyStruct_array.count do
								(
									ProperBoneID_array = #()
									FixedBoneID_array = #()
									ActualB1_array = #()
									Weight_array = #()
									Weight_array2 = #()
									Face_array2 = #()
									Face_array3 = #()
									Vert_array2 = #()
									Normal_array2 = #()
									Color_array2 = #()
									Alpha_array2 = #()
									UV_array2 = #()
									UV2_array2 = #()
									UV3_array2 = #()
									UV4_array2 = #()
									if BoneCount != 0 and B1_array.count > 0 do
									(
										fseek f BoneIDOffset #seek_set
										ProperBoneID_array = #()
										for x = 1 to BoneIDCount do
										(
											BoneHash2 = readlong f #unsigned
											BoneHash1 = readlong f #unsigned
											BoneFloatA = readfloat f
											BoneFloatB = readfloat f
											BoneFloatC = readfloat f
											BoneFloatD = readfloat f
											BoneFloatE = readfloat f
											BoneFloatF = readfloat f
											BoneSubHeaderLength = readlong f #unsigned
											BoneSubFloatA = readfloat f
											BoneSubFloatB = readfloat f
											BoneSubFloatC = readfloat f
											BoneSubFloatD = readfloat f
											BoneSubUnk = readlong f
											BoneName = ( "0x" + bit.intAsHex ( BoneHash1 ) as string )
											for z = 1 to BoneHash_array.count do
											(
												if BoneHash1 == BoneHash_array[z].BoneHash1 and BoneHash2 == BoneHash_array[z].BoneHash2 do
												( BoneName = BoneHash_array[z].BoneString )
											)
											append ProperBoneID_array BoneName
										)
										for a = 1 to BoneIDCount do
										(
											for b = 1 to BoneCount do
											(
												if ProperBoneID_array[a] == BoneName_array[b] do
												( append FixedBoneID_array b )
											)
										)
										for x = 1 to B1_array.count do
										(
											ImproperBone1 = B1_array[x].Bone1
											ImproperBone2 = B1_array[x].Bone2
											ImproperBone3 = B1_array[x].Bone3
											ImproperBone4 = B1_array[x].Bone4
											ProperBone1 = FixedBoneID_array[ImproperBone1 + 1]
											ProperBone2 = FixedBoneID_array[ImproperBone2 + 1]
											ProperBone3 = FixedBoneID_array[ImproperBone3 + 1]
											ProperBone4 = FixedBoneID_array[ImproperBone4 + 1]
											if ProperBone1 == undefined do
											( ProperBone1 = 1 )
											if ProperBone2 == undefined do
											( ProperBone2 = 1 )
											if ProperBone3 == undefined do
											( ProperBone3 = 1 )
											if ProperBone4 == undefined do
											( ProperBone4 = 1 )
											append ActualB1_array ( Bone_Info_Struct Bone1: ProperBone1 Bone2: ProperBone2 Bone3: ProperBone3 Bone4: ProperBone4 )
										)
										for b = 1 to W1_array.count Do
										(
											w = ( weight_data boneids: #() weights: #() )
											maxweight = 0
											if ( W1_array[b].Weight1 != 0 ) then maxweight = maxweight + W1_array[b].Weight1
											if ( W1_array[b].Weight2 != 0 ) then maxweight = maxweight + W1_array[b].Weight2
											if ( W1_array[b].Weight3 != 0 ) then maxweight = maxweight + W1_array[b].Weight3
											if ( W1_array[b].Weight4 != 0 ) then maxweight = maxweight + W1_array[b].Weight4
											if ( maxweight != 0 ) then
											(
												if ( W1_array[b].Weight1 != 0 ) then
												(
													w1 = W1_array[b].Weight1 as float
													append w.boneids ( ActualB1_array[b].Bone1 )
													append w.weights ( w1 )
												)
												if ( W1_array[b].Weight2 != 0 ) then
												(
													w2 = W1_array[b].Weight2 as float
													append w.boneids ( ActualB1_array[b].Bone2 )
													append w.weights ( w2 )
												)
												if ( W1_array[b].Weight3 != 0 ) then
												(
													w3 = W1_array[b].Weight3 as float
													append w.boneids ( ActualB1_array[b].Bone3 )
													append w.weights ( w3 )
												)
												if ( W1_array[b].Weight4 != 0 ) then
												(
													w4 = W1_array[b].Weight4 as float
													append w.boneids ( ActualB1_array[b].Bone4 )
													append w.weights ( w4 )
												)
											)
											append Weight_array w
										)
									)
									for y = PolyStruct_array[i].PolygonStart to ( PolyStruct_array[i].PolygonCount + PolyStruct_array[i].PolygonStart ) do
									( append Face_array2 Face_array[y] )
									VertexMin = PolyStruct_array[i].VertexMin + PolyStruct_array[i].VertexStart
									VertexMax = PolyStruct_array[i].VertexMax + PolyStruct_array[i].VertexStart
									for x = VertexMin to VertexMax do
									(
										append Vert_array2 Vert_array[x]
										append Normal_array2 Normal_array[x]
										append Color_array2 Color_array[x]
										append Alpha_array2 Alpha_array[x]
										append UV_array2 UV_array[x]
										if UV2_array.count > 0 do
										( append UV2_array2 UV2_array[x] )
										if UV3_array.count > 0 do
										( append UV3_array2 UV3_array[x] )
										if UV4_array.count > 0 do
										( append UV4_array2 UV4_array[x] )
										append Weight_array2 Weight_array[x]
									)
									for x = 1 to PolyStruct_array[i].PolygonCount do
									(
										Faces3 = ( ( Face_array2[x] - PolyStruct_array[i].VertexMin ) + 1 )
										append Face_array3 Faces3
									)
									local PolyMat = standardMaterial()
									PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
									PolyMat.showinviewport = true
									PolyMat.twosided = false
									if TexFormat == 1 then
									(
										if TexPath == 1 then
										( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
										else
										( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
									)
									else
									(
										if TexPath == 1 then
										( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
										else
										( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
									)
									tm.alphasource = 0
									PolyMat.diffuseMap = tm
									PolyMat.opacityMap = tm
									PolyMat.opacityMap.monoOutput = 1
									msh = mesh vertices: Vert_array2 faces: Face_array3
									msh.numTVerts = Vert_array2.count
									if VertColors == true then
									(
										setNumCPVVerts msh msh.numTVerts
										setCVertMode msh true
										setShadeCVerts msh true
									)
									defaultVCFaces msh
									buildTVFaces msh
									if PolyStruct_array[i].LODNum == 1 do
									( msh.name = ( h as string ) )
									if PolyStruct_array[i].LODNum != 1 do
									( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ")" ) )
									msh.material = PolyMat
									if VertColors == true then
									(
										for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
										for j = 1 to Alpha_array2.count do
										( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
									)
									for j = 1 to UV_array2.count do setTVert msh j UV_array2[j]
									for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
									max modify mode
									select msh
									for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
									addmodifier msh ( Edit_Normals() ) ui: off
									msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
									EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
									EN_setNormal = msh.Edit_Normals.SetNormal
									normID = #{}
									for v = 1 to Normal_array2.count do
									(
										free normID
										EN_convertVS #{v} &normID
										for id in normID do EN_setNormal id Normal_array2[v]
									)
									if BoneCount != 0 and B1_array.count > 0 do
									(
										skinMod = skin()
										boneIDMap = #()
										addModifier msh skinMod
										for i = 1 to BoneCount do
										(
											maxbone = getnodebyname BoneSetup[i].name
											if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
										)
										local numSkinBones = skinOps.GetNumberBones skinMod
										for i = 1 to numSkinBones do
										(
											local boneName = skinOps.GetBoneName skinMod i 0
											for j = 1 to BoneCount do
											(
												if boneName == BoneSetup[j].Name then
												(
													boneIDMap[j] = i
													j = BoneCount + 1
												)
											)
										)
										modPanel.setCurrentObject skinMod
										for i = 1 to Vert_array2.count do
										(
											skinOps.SetVertexWeights skinMod i 1 1
											skinOps.unnormalizeVertex skinMod i true
											skinOps.SetVertexWeights skinMod i 1 0
										)
										skinOps.RemoveZeroWeights skinMod
										for i = 1 to Vert_array2.count do
										( skinOps.unnormalizeVertex skinMod i false )
										for i = 1 to Weight_array2.count do
										(
											w = Weight_array2[i]
											bi = #()
											wv = #()
											for j = 1 to w.boneids.count do
											(
												boneid = w.boneids[j]
												weight = w.weights[j]
												append bi boneIDMap[boneid]
												append wv weight
											)
											skinOps.ReplaceVertexWeights skinMod i bi wv
										)
									)
									if UVLayers == 1 do
									(
										if UV2_array2.count > 0 do
										(
											meshop.setNumMaps msh 3 keep: true
											for i = 1 to UV2_array2.count do
											( meshop.setMapVert msh 2 i UV2_array2[i] )
										)
										if UV3_array2.count > 0 do
										(
											meshop.setNumMaps msh 4 keep: true
											for i = 1 to UV3_array2.count do
											( meshop.setMapVert msh 3 i UV3_array2[i] )
										)
										if UV4_array2.count > 0 do
										(
											meshop.setNumMaps msh 5 keep: true
											for i = 1 to UV4_array2.count do
											( meshop.setMapVert msh 4 i UV4_array2[i] )
										)
									)
									if UVLayers == 2 do
									(
										if UV2_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 2" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 2" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV2_array2.count do setTVert msh j UV2_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV3_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 3" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 3" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV3_array2.count do setTVert msh j UV3_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
										if UV4_array2.count > 0 do
										(
											local PolyMat = standardMaterial()
											PolyMat.name = TexName_array[PolyStruct_array[i].MatNum]
											PolyMat.showinviewport = true
											PolyMat.twosided = false
											if TexFormat == 1 then
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".dds" ) )
											)
											else
											(
												if TexPath == 1 then
												( tm = Bitmaptexture filename: ( p + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
												else
												( tm = Bitmaptexture filename: ( p + "Textures/" + TexName_array[PolyStruct_array[i].MatNum] + ".png" ) )
											)
											tm.alphasource = 0
											PolyMat.diffuseMap = tm
											PolyMat.opacityMap = tm
											PolyMat.opacityMap.monoOutput = 1
											msh = mesh vertices: Vert_array2 faces: Face_array3
											msh.numTVerts = Vert_array2.count
											if VertColors == true then
											(
												setNumCPVVerts msh msh.numTVerts
												setCVertMode msh true
												setShadeCVerts msh true
											)
											defaultVCFaces msh
											buildTVFaces msh
											if PolyStruct_array[i].LODNum == 1 do
											( msh.name = ( h as string + " Layer 4" ) )
											if PolyStruct_array[i].LODNum != 1 do
											( msh.name = ( h as string + " (LOD " + PolyStruct_array[i].LODNum as string + ") Layer 4" ) )
											msh.material = PolyMat
											if VertColors == true then
											(
												for j = 1 to Color_array2.count do setvertcolor msh j Color_array2[j]
												for j = 1 to Alpha_array2.count do
												( meshop.setVertAlpha msh -2 j Alpha_array2[j] )
											)
											for j = 1 to UV4_array2.count do setTVert msh j UV4_array2[j]
											for j = 1 to Face_array3.count do setTVFace msh j Face_array3[j]
											max modify mode
											select msh
											for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
											addmodifier msh ( Edit_Normals() ) ui: off
											msh.Edit_Normals.MakeExplicit selection: #{1..Normal_array2.count}
											EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
											EN_setNormal = msh.Edit_Normals.SetNormal
											normID = #{}
											for v = 1 to Normal_array2.count do
											(
												free normID
												EN_convertVS #{v} &normID
												for id in normID do EN_setNormal id Normal_array2[v]
											)
											if BoneCount != 0 and B1_array.count > 0 do
											(
												skinMod = skin()
												boneIDMap = #()
												addModifier msh skinMod
												for i = 1 to BoneCount do
												(
													maxbone = getnodebyname BoneSetup[i].name
													if i != BoneCount then skinOps.addBone skinMod maxbone 0 else skinOps.addBone skinMod maxbone 1
												)
												local numSkinBones = skinOps.GetNumberBones skinMod
												for i = 1 to numSkinBones do
												(
													local boneName = skinOps.GetBoneName skinMod i 0
													for j = 1 to BoneCount do
													(
														if boneName == BoneSetup[j].Name then
														(
															boneIDMap[j] = i
															j = BoneCount + 1
														)
													)
												)
												modPanel.setCurrentObject skinMod
												for i = 1 to Vert_array2.count do
												(
													skinOps.SetVertexWeights skinMod i 1 1
													skinOps.unnormalizeVertex skinMod i true
													skinOps.SetVertexWeights skinMod i 1 0
												)
												skinOps.RemoveZeroWeights skinMod
												for i = 1 to Vert_array2.count do
												( skinOps.unnormalizeVertex skinMod i false )
												for i = 1 to Weight_array2.count do
												(
													w = Weight_array2[i]
													bi = #()
													wv = #()
													for j = 1 to w.boneids.count do
													(
														boneid = w.boneids[j]
														weight = w.weights[j]
														append bi boneIDMap[boneid]
														append wv weight
													)
													skinOps.ReplaceVertexWeights skinMod i bi wv
												)
											)
										)
									)
								)
							)
							fclose f
						)
					)
					
					
				)
			)
			Print ( "Done! (" + ( ( ( ( timestamp() ) -st ) * 0.001 ) as string ) + " Seconds)" )
		)
		enableSceneRedraw()
		gc()
	)
)
CreateDialog TelltaleImporter