-- Telltale Games "Almost-All-In-One" model importer by Random Talking Bush
-- As the name suggests, this currently supports almost all of Telltale's games library. Rather than list what it *does* work with (lots!), I'll list what *doesn't*.
-- Doesn't work with the original PC version of Back to the Future: The Game (or the 360's 30th Anniversary -- PS4 works though!), CSI: Deadly Intent / Fatal Conspiracy...
-- ...Poker Night at the Inventory, Sam & Max Season 3, Tales of Monkey Island or Wallace & Gromit's Grand Adventures Episode 4 (only Episodes 1-3 work).
-- That's not to say they won't be supported in the future, I just gotta figure out what the heck's going on with their formats. Some kinda compression, that's for sure.
-- Only PC and (most) PS4 versions are supported, stuff ripped from XBox 360, Wii, PS Vita, Nintendo Switch, iOS etc. won't work.

-- Known version numbers:
-- "NIBM" (a.k.a. "Version 0"): Bone: Out from Boneville / The Great Cow Race, CSI: 3 Dimensions of Murder / Hard Evidence, Sam & Max: Save the World / Beyond Time and Space, Telltale Texas Hold'em
-- "ERTM" (a.k.a. "Version 0.5"): Strong Bad's Cool Game for Attractive People, Wallace & Gromit's Grand Adventures Ep. 1-3
-- Version 1 [UNSUPPORTED]: Back to the Future: The Game [PC], CSI: Deadly Intent / Fatal Conspiracy, Poker Night at the Inventory, Sam & Max: The Devil's Playhouse, Tales of Monkey Island, Wallace & Gromit Ep. 4
-- Version 2: Jurassic Park: The Game, Law & Order: Legacies
-- Version 5: The Walking Dead: Season 1
-- Version 12: Poker Night 2
-- Version 13: The Wolf Among Us [PC]
-- Version 14: The Wolf Among Us [PS4], The Walking Dead: Season 1 [PS4], The Walking Dead: Season 2 [PC / PS4]
-- Version 17: Back to the Future: The Game (30th Anniversary) [PS4], Game of Thrones [PC / PS4], Tales from the Borderlands [PC / PS4], Minecraft: Story Mode [PS4 Ep. 1]
-- Version 18: Minecraft: Story Mode [PC / PS4 Ep. 2-8]
-- Version 25: The Walking Dead: Michonne [PC]
-- Version 33: Batman: The Telltale Series [PC (08/05/16, pre-Ep. 5), PS4 Ep. 1]
-- Version 36: Batman: The Telltale Series [PC (12/02/16, Ep. 5, pre-"Noir")]
-- Version 37: Minecraft: Story Mode [Switch, UNSUPPORTED], The Walking Dead: A New Frontier [PC / PS4]
-- Version 38: The Walking Dead: A New Frontier [PC / PS4, "EOS" / "UpdatedMeshes"]
-- Version 39 [UNSUPPORTED]: Guardians of the Galaxy: The Telltale Series [PS4 Ep. 1]
-- Version 42: Guardians of the Galaxy: The Telltale Series [PC]
-- Version 45: Batman: The Enemy Within, Minecraft: Story Mode � Season Two [PC / PS4]
-- Version 46: Batman: The Telltale Series [PC, newest (08/08/17, "Noir" patch)], Minecraft: Story Mode � Season Two [PC / PS4, Miscellaneous] The Walking Dead Collection [PS4]
-- Version 55: The Walking Dead: The Final Season [PC], The Walking Dead: The Telltale Definitive Series [PC], Sam & Max: Save the World / Beyond Time and Space Remastered [PC]

-- Known bugs:
-- Most of the "Version 0" games don't import with their normals. I'm still trying to figure out how to get those working...
-- ui_dealerbutton in Telltale Texas Hold'em doesn't work because it uses a different format for some reason.
-- Models with over 65,535 vertex points on a single material (eg. adv_richmondOverpass_meshesDCarPile and adv_virginiaRailroad_meshesD) from TWD: Season 3 won't import correctly. The later PS4/PC collections don't have this issue!
-- adv_selinaKyleApartmentNight_meshesE.d3dmesh in pre-Episode 5 (v33) Batman: The Telltale Series doesn't work. This is basically a non-issue since both never versions of it (v36 and v46) work just fine.
-- Minecraft: Story Mode Season 2's "Version 46 models ("French201" and "German201") don't work currently and I'm not sure why.

-- Oddities:
-- skB3_moxxi and skB0_battleDroid_hologram in TftBL both have no rigging. This isn't the fault of the importer, it's just the way they are.
-- Most Minecraft Story Mode Season 2 characters don't seem to have texture sets in their D3DMesh files, so unfortunately you'll still need to texture those manually.
-- obj_roofFoliageA.d3dmesh from the PS4 The Walking Dead Collection's Season 1 Episode 5 is ridiculously huge (106,266 polygons and 38.7MB!) and takes an eternity to import... with errors. Wonderful.

-- Changelog:
-- August 9th, 2022:
-- Added a whole bunch of bone and texture hashes from Sam & Max: Beyond Time and Space Remastered.

-- February 24th, 2021:
-- Fixed models refusing to import in 3DS Max 2021 (the "twoSided" error was due to it trying to apply "Standard" material settings to a "Physical" material, which apparently is the new default).

-- December 24th, 2020:
-- Added one additional texture hash from Sam & Max: Save the World Remastered's v1.03 patch (env_credits106_streetTexture.d3dtx). Yep.

-- December 3nd, 2020:
-- Added a whole bunch of bone and texture hashes from Sam & Max: Save the World Remastered.

-- November 24th, 2020:
-- Fixed SKL files being broken for Back to the Future's PS4 version (thanks, Strick!).

-- October 19th, 2020:
-- Fixed SKL files being broken for Strong Bad's CG4AP Episodes 2-5 and Wallace & Gromit, I accidentally removed a line of code I shouldn't have before the previous update's release.

-- October 17th, 2020:
-- Added support for Strong Bad's Cool Game for Attractive People Episodes 2-5, and Wallace & Gromit's Grand Adventures Episodes 1-3. "Version 1" games are still unsupported though...
-- Added support for The Walking Dead: The Telltale Definitive Series models. Can you believe that the only reason they weren't working was because I had the script check the wrong mesh flags for The Final Season's importer? Go figure.
-- Script was tidied up a lot, shaving off about 100KB of redundant coding which is redundant (mainly due to the change below).
-- Models and materials are now grouped together and import as a single mesh group and Multi-Material respectively, greatly improving importing times.
-- Added over 10,000 new bone names to the hash database, and as a result most characters are no longer missing any bone names!
-- Added the texture names from Batman: Shadows Edition (both Season 1 and 2) and The Walking Dead: The Telltale Definitive Series to the hash database, along with a couple dozen missing (unused?) names.
-- Rearranged the texture hashes list so that "color_" names (specifically "color_000", used for "null" entries) are read first and lightmaps last, which speeds up texture-to-hash pairing significantly.
-- Textures used for material sets are now properly paired and print to the Listener window by default, and diffuse colors are automatically applied to the materials for earlier games (namely TWD Season 1).
-- Rewrote the way "Version 0" vertex buffers are read, now additional UV layers (mainly used for bake maps) will import instead of being skipped.
-- Fixed unrigged "Version 0" game models not importing due to a mistake in the script with automatic version-detection (Thanks, daniar23337!).
-- Fixed an issue where zero-length texture names (".d3dtx", seen in obj_c3nursebeds and obj_c5contractorpokertable in CSI 3) caused the script to get confused and error.
-- Fixed obj_chairLoungeB and sk80_pomPom having broken rigging in SBCG4AP Ep. 1 due to an issue with bone hash case-sensitivity ("pompom" != "pomPom").
-- Re-fixed models with single-bind rigging from The Walking Dead Season 1, which was accidentally broken since the May 11th, 2019 update.
-- Fixed "Version 12" models with ".PROP" information in their headers, now every model from Poker Night 2 is functional and imports without issues (60 were previously broken).
-- Fixed models with an invalid material ID not importing (i.e. "adv_previouslyOn204_hardwareStoreExteriorRearFoliageBrushA" from TWD Season 2).
-- Fixed a mistake with bone auto-detection for "Version 17" models (Game of Thrones's horse and most "skB0" models from Tales from the Borderlands).
-- Technically added support for "Version 38" models (TWD Season 3's "EOS" / "UpdatedMeshes" archives), which are practically identical to the "Version 37" format. Support is support, though.
-- Invalid / missing materials will now be listed as "undefined" so the script doesn't error (e.g. Minecraft Story Mode: Season 2 character models).
-- Fixed an oversight with "Version 45" models (Batman: The Enemy Within) with no UV mapping channels (e.g. various "fx_" models) which caused the script to crash.

-- May 30th, 2019:
-- Added a failsafe should the hash databases not be in the expected folder.

-- May 11th, 2019:
-- Finally added support for The Walking Dead: The Final Season.
-- Added automatic texture importing for the rest of the games, thanks to daemon1 for pointing me in the right direction!
-- Added a ton of bone names, validated using the method used for the above.
-- Added model version auto-detection so the per-game options are no longer necessary, UI rearranged accordingly.
-- Fixed support for Batman: The Telltale Series in the process of the above change.

-- March 3rd, 2018:
-- Added support for Back to the Future: The Game (30th Anniversary Edition), PS4 version only!

-- January 4th, 2018:
-- Fixed the ordering for UV mapping layers so they're not being improperly scaled. Not fully tested, though.
-- Fixed models with vertex colours causing the script to pause for certain importers due to accidentally leaving in a break command.

-- October 10th, 2017:
-- Fixed importing models with vertex colours enabled because I'm a dumb fart who doesn't test everything.

-- October 5th, 2017:
-- Updated the Guardians of the Galaxy importer to also support Batman: The Enemy Within and Minecraft: Story Mode Season Two.
-- Added some more options to change texture format (from DDS to PNG), path (either in the same folder or in a separate "Textures" folder), and outputting debug crap if you want.
-- Fixed rigging for single-bind models for The Walking Dead Season 1 models (e.g. the cop car).
-- Re-fixed maps and such not loading properly for TWDS3, Batman S1 and GotG due to accidentally breaking it in the previous update. Whoops!

-- May 14th, 2017:
-- Fixed up a rigging issue with certain importers.

-- May 6th, 2017:
-- Revised the UI to be more polished.
-- Added support for Batman: The Telltale Series, Marvel's Guardians of the Galaxy, The Walking Dead: A New Frontier and TWD: Michonne.
-- Changed bone numbers to bone checksums instead.
-- Added a ton of replacement bone names to replace the checksums, anything that doesn't have an official name will display numbers instead.
-- Optimized polygon group importing a bit so things will load a bit faster.
-- Fixed rigging being broken in one way or another for newer 3DS Max versions.
-- Updated the heck out of all of the older importers so that nothing should error anymore.
-- Fixed certain SBCG4AP Episode 1 models with triangle strips (eg. adv_strongbadhouseinterior_meshesa/c) so they are no longer missing polygons.

-- print"Setting things up..."
BoneHash_array = #()
TexHash_array = #()
AllVert_array = #()
AllNormal_array = #()
AllUV_array = #()
AllUV2_array = #()
AllUV3_array = #()
AllUV4_array = #()
AllUV5_array = #()
AllUV6_array = #()
AllColor_array = #()
AllAlpha_array = #()
AllWeight_array = #()
AllFace_array = #()
AllMatID_array = #()
BoneSetup = #()
BoneCount = 0
BoneIDSets = 0
LODNum = 1
UVLayers = 1
MultiMat = #()
BaseName = ""
if heapSize < 100000000L do (heapSize = 100000000L) -- This should be more than enough for these.

for x = 1 to 1 do (
	struct BoneHash_Struct (BoneHash1, BoneHash2, BoneString)
	struct TexHash_Struct (TexHash1, TexHash2, TexString)

	fname = (scriptsPath + "TelltaleHashDBs/BoneNames.HashDB") as string
	db = fopen fname "rb"
	
	if db == undefined do (
		print "Error: Bone database not found in 3DS Max's Scripts folder! Please manually locate it."
		fname = getOpenFileName \ 
		caption:"Import Telltale Games Bone Hash Database" \
		types:"Telltale Games Bone Hash Database (BoneNames.HashDB)|BoneNames.HashDB" \
		historyCategory:"TelltaleHashDB"
		if fname != undefined do (
			db = fopen fname "rb"
		)
	)
	
	if db != undefined do (
		print "Parsing bone hashes..."
		BoneHashNum = readlong db
		for x = 1 to BoneHashNum do (
			BoneHash2 = readlong db
			BoneHash1 = readlong db
			BoneString = readstring db
			append BoneHash_array (BoneHash_struct BoneHash1:BoneHash1 BoneHash2:BoneHash2 BoneString:BoneString)
		)
		fclose db
	)

	fname = (scriptsPath + "TelltaleHashDBs/TexNames.HashDB") as string
	db = fopen fname "rb"
	
	if db == undefined do (
		print "Error: Texture database not found in 3DS Max's Scripts folder! Please manually locate it."
		fname = getOpenFileName \ 
		caption:"Import Telltale Games Texture Hash Database" \
		types:"Telltale Games Texture Hash Database (TexNames.HashDB)|TexNames.HashDB" \
		historyCategory:"TelltaleHashDB"
		if fname != undefined do (
			db = fopen fname "rb"
		)
	)

	if db != undefined do (
		print "Parsing texture hashes..."
		TexHashNum = readlong db
		for x = 1 to TexHashNum do (
			TexHash2 = readlong db
			TexHash1 = readlong db
			TexString = readstring db
			append TexHash_array (TexHash_struct TexHash1:TexHash1 TexHash2:TexHash2 TexString:TexString)
		)
		fclose db
	)

	clearlistener()
	enableSceneRedraw()
	print "Ready to import!"
	print ("Bone hash total: " + BoneHash_array.count as string)
	print ("Texture hash total: " + TexHash_array.count as string))

rollout TelltaleImporter "Telltale Games 'Almost All-In-One' Model Importer" width:655 height:330(
	groupBox OptionsBox "Options" pos:[8,55] width:370 height:195
	button btnImport "Import Model" pos:[8,8] width:370 height:40	
	label lblUVLayers "UV Layers:" pos:[17,70]
	radiobuttons tglUVLayers labels:#("Merge","Split","No") pos:[77,70] tooltip: "'Merge' applies additional UV mapping layers to the same mesh, 'Split' makes additional layers separate meshes instead, and 'No' just ignores them entirely."
	spinner spnModelScale "Model Scale:" width:80 pos:[290,70] range: [1,99999,100]
	label lblTexFormat "Texture format:" pos:[17,90]
	radiobuttons tglTexFormat labels:#("DDS","PNG") pos:[102,90]
	label lblTexPath "Texture path:" pos:[17,110]
	radiobuttons tglTexPath labels:#("Relative","'Textures' subfolder") pos:[92,110] tooltip: "'Relative' reads the textures from the same folder as the D3DMESH files, 'Textures subfolder' reads them from a folder with the same name as the D3DMESH files, for neat freaks."
	checkbox tglLODs "Enable LoD models?" pos:[17,130] tooltip: "If enabled, this will import the Level-of-Detail models for Version 33-46 games (both Batman seasons, The Walking Dead: A New Frontier and the PS4 Collection, and Marvel's Guardians of the Galaxy)." checked: false
	checkbox tglVertColors "Vertex colours?" pos:[160,130] tooltip: "If enabled, this will import the vertex colouring to models (if available). Certain games treat vertex coloring differently, so for example if a model appears black, you can disable this option and re-import." checked: true
	checkbox tglDebug "Print debug?" pos:[280,130] tooltip: "Enable this to print useless information to the Listener window." checked: false
	label lblEarlyGameOptions "Early Game Import Fixes:" pos:[17,150]
	dropDownList lstEarlyGameFix width:350 pos:[17,165] 
    items:#(
        "Texas Hold'em / Bone / CSI 3/4 / Sam and Max S1/S2 (Ep. 1/2)",
        "Sam and Max Season 2 (Ep. 3/4)",
		"Sam and Max Season 2 (Ep. 5 - What's New, Beelzebub?)",
        "Strong Bad's CG4AP (Ep. 1 - Homestar Ruiner)",
        "Strong Bad's CG4AP (Ep. 2 - Strong Badia the Free)",
        "Strong Bad's CG4AP (Ep. 3 - Baddest of the Bands)",
        "Strong Bad's CG4AP (Ep. 4 - Dangeresque 3)",
        "Strong Bad's CG4AP (Ep. 5 - 8-Bit is Enough)",
        "Wallace and Gromit (Ep. 1-3)")
	label SetTextExplanation "Telltale did multiple tweaks to the file formats for their earliest games (even mid-season!) and didn't use proper model version numbering until Jurassic Park, so you'll have to manually choose the game you're importing from above, as I can't automate the entire process."  pos:[17,190] width:350 height:55
	
	groupBox SupportedGames "Supported Games:" pos:[388,8] width:260 height:290
	label YesBTTFPS4 "Back to the Future 30th Anniversary [PS4]" pos:[398,23]
	label YesBatman "Batman: The Telltale Series + The Enemy Within" pos:[398,38]
	label YesBone "Bone: Out from Boneville + The Great Cow Race" pos:[398,53]
	label YesCSI "CSI: 3 Dimensions of Murder / Hard Evidence" pos:[398,68]
	label YesGoT "Game of Thrones" pos:[398,83]
	label YesJP "Jurassic Park: The Game" pos:[398,98]
	label YesLaOL "Law and Order: Legacies" pos:[398,113]
	label YesGotG "Marvel's Guardians of the Galaxy [PC]" pos:[398,128]
	label YesMSM "Minecraft: Story Mode Season 1 + 2" pos:[398,143]
	label YesPN2 "Poker Night 2" pos:[398,158]
	label YesSaM "Sam and Max Season 1 + 2 / 1 + 2 Remastered" pos:[398,173]
	label YesSBCG4AP "Strong Bad's Cool Game for Attractive People" pos:[398,188]
	label YesTftBL "Tales from the Borderlands" pos:[398,203]
	label YesTTH "Telltale Texas Hold'em" pos:[398,218]
	label YesTWD "The Walking Dead Season 1-4 + Michonne" pos:[398,233]
	label YesTWD2 "... + Collection [PS4] + Definitive Series [PC]" pos:[398,248]
	label YesTWAU "The Wolf Among Us" pos:[398,263]
	label YesWaG "Wallace and Gromit's Grand Adventures (Ep. 1-3)" pos:[398,278]

	label lblDisclaimer "This batch of scripts was written by Random Talking Bush, if you use it, please remember to give thanks to both me and especially Telltale Games. If something doesn't work right, please contact me on The VG Resource (Random Talking Bush), XeNTaX, Twitter or Steam (RandomTBush) and let me know, and I'll try to fix it." pos:[10,254] width:360 height:85
	label lblUpdate "(Updated: 02-21-2021)" pos:[TelltaleImporter.width-120,TelltaleImporter.height-19] width:115

	fn ReadFixedString bstream fixedLen = (
		local str = ""
		for i = 1 to fixedLen do
		(
			str += bit.intAsChar (ReadByte bstream #unsigned)
		)
		str
	)
	fn floatSwap2 f = (
		i = bit.floatAsInt f
		h = bit.intashex i
		while h.count < 8 do h = "0" + h
		
		s = (substring h 7 2) + (substring h 5 2) + (substring h 3 2) + (substring h 1 2)
		bit.intAsFloat (bit.hexasint s)
	)
	fn convertTo32 input16 = (
		inputAsInt = input16
		sign = bit.get inputAsInt 16
		exponent = (bit.shift (bit.and inputAsInt (bit.hexasint "7C00")) -10) as integer - 16
		fraction = bit.and inputAsInt (bit.hexasint "03FF")
		if sign==true then sign = 1 else sign = 0
		exponentF = exponent + 127
		outputAsFloat = bit.or (bit.or (bit.shift fraction 13) (bit.shift exponentF 23)) (bit.shift sign 31)
		return bit.intasfloat outputasfloat
	)
	fn readHalfFloat fstream = (
		return convertTo32(Readshort fstream)
	)
	fn ReadBEShort fstream = (bit.swapBytes (readshort fstream #unsigned) 1 2)
	fn ReadBELong fstream = (bit.swapBytes (bit.swapBytes (readlong f #unsignedstream #unsigned) 1 4) 2 3)
	fn ReadBEFloat fstream = (bit.intAsFloat (bit.swapBytes (bit.swapBytes (readlong f #unsignedstream #unsigned) 1 4) 2 3))
	fn ReadBEHalfFloat fstream = (return convertTo32(ReadBEshort fstream))
	fn printDebug pr = (if tglDebug.state do print(pr))
	fn BuildModel = (
		msh = mesh vertices:AllVert_array faces:AllFace_array
		msh.numTVerts = AllVert_array.count
		defaultVCFaces msh
		buildTVFaces msh
		if LODNum == 1 then (msh.name = (BaseName as string)) else (msh.name = (BaseName as string + " (LOD " + LODNum as string + ")"))
		msh.material = MultiMat
		if AllColor_array.count > 0 then (
			setNumCPVVerts msh msh.numTVerts
			setCVertMode msh true
			setShadeCVerts msh true
			for j = 1 to AllColor_array.count do setvertcolor msh j AllColor_array [j]
			for j = 1 to AllAlpha_array.count do (meshop.setVertAlpha msh -2 j AllAlpha_array [j])
		)
		for j = 1 to AllUV_array.count do setTVert msh j AllUV_array [j]
		if UVLayers == 1 do(
			if AllUV2_array.count > 0 do (meshop.setNumMaps msh 3 keep:true; for i = 1 to AllUV2_array.count do (meshop.setMapVert msh 2 i AllUV2_array [i]))
			if AllUV3_array.count > 0 do (meshop.setNumMaps msh 4 keep:true; for i = 1 to AllUV3_array.count do (meshop.setMapVert msh 3 i AllUV3_array [i]))
			if AllUV4_array.count > 0 do (meshop.setNumMaps msh 5 keep:true; for i = 1 to AllUV4_array.count do (meshop.setMapVert msh 4 i AllUV4_array [i]))
			if AllUV5_array.count > 0 do (meshop.setNumMaps msh 6 keep:true; for i = 1 to AllUV5_array.count do (meshop.setMapVert msh 5 i AllUV5_array [i]))
			if AllUV6_array.count > 0 do (meshop.setNumMaps msh 7 keep:true; for i = 1 to AllUV6_array.count do (meshop.setMapVert msh 6 i AllUV6_array [i]))
		)
		for j = 1 to AllFace_array.count do (
			setTVFace msh j AllFace_array [j]
			setFaceMatID msh j AllMatID_array [j]
		)
		max modify mode
		select msh
		for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
		if AllNormal_array.count > 0 do (
			addmodifier msh (Edit_Normals ()) ui:off
			msh.Edit_Normals.MakeExplicit selection:#{1..AllNormal_array.count}
			EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
			EN_setNormal = msh.Edit_Normals.SetNormal
			normID = #{}
			for v = 1 to AllNormal_array.count do
			(
				free normID
				EN_convertVS #{v} &normID
				for id in normID do EN_setNormal id AllNormal_array [v]
			)
			collapseStack msh
		) -- This is the slowest part of the importing process. Sorry.
		if BoneCount != 0 and BoneIDSets > 0 do (
			skinMod = skin ()
			BoneIDMap = #()
			addModifier msh skinMod
			for i = 1 to BoneCount do (
			   maxbone = getnodebyname BoneSetup[i].name
			   if i != BoneCount then
				  skinOps.addBone skinMod maxbone 0
			   else
				  skinOps.addBone skinMod maxbone 1
			)
			local numSkinBones = skinOps.GetNumberBones skinMod
			for i = 1 to numSkinBones do (
				local BoneName = skinOps.GetBoneName skinMod i 0
				for j = 1 to BoneCount do (
					if BoneName == BoneSetup[j].Name then (
						BoneIDMap[j] = i
						j = BoneCount + 1
					)
				)
			) -- This fixes bone ordering in 3DS Max 2012. Thanks to sunnydavis for the fix!

			modPanel.setCurrentObject skinMod

			for i = 1 to AllVert_array.count do (
				skinOps.SetVertexWeights skinMod i 1 1
				skinOps.unnormalizeVertex skinMod i true 
				skinOps.SetVertexWeights skinMod i 1 0
			)
				skinOps.RemoveZeroWeights skinMod
			for i = 1 to AllVert_array.count do (
				skinOps.unnormalizeVertex skinMod i false
			) -- These fix broken rigging for 3DS Max 2015 and above.

			for i = 1 to AllWeight_array.count do (
				w = AllWeight_array [i]
				bi = #()
				wv = #()
				
				for j = 1 to w.BoneIDs.count do (
					BoneID = w.BoneIDs[j]
					weight = w.weights[j]
					append bi BoneIDMap[BoneID]
					append wv weight
				)
				skinOps.ReplaceVertexWeights skinMod i bi wv
			)
		)
	
		if UVLayers == 2 do (
			if AllUV2_array.count > 0 do(
				msh = mesh vertices:AllVert_array faces:AllFace_array
				msh.numTVerts = AllVert_array.count
				defaultVCFaces msh
				buildTVFaces msh
				if LODNum == 1 then (msh.name = (BaseName as string) + " (Layer 2)") else (msh.name = (BaseName as string + " (LOD " + LODNum as string + ", Layer 2)"))
				msh.material = MultiMat
				if AllColor_array.count > 0 then (
					setNumCPVVerts msh msh.numTVerts
					setCVertMode msh true
					setShadeCVerts msh true
					for j = 1 to AllColor_array.count do setvertcolor msh j AllColor_array [j]
					for j = 1 to AllAlpha_array.count do (meshop.setVertAlpha msh -2 j AllAlpha_array [j])
				)
				for j = 1 to AllUV2_array.count do setTVert msh j AllUV2_array [j]
				for j = 1 to AllFace_array.count do (
					setTVFace msh j AllFace_array [j]
					setFaceMatID msh j AllMatID_array [j]
				)
				max modify mode
				select msh
				for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
				if AllNormal_array.count > 0 do (
					addmodifier msh (Edit_Normals ()) ui:off
					msh.Edit_Normals.MakeExplicit selection:#{1..AllNormal_array.count}
					EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
					EN_setNormal = msh.Edit_Normals.SetNormal
					normID = #{}
					for v = 1 to AllNormal_array.count do
					(
						free normID
						EN_convertVS #{v} &normID
						for id in normID do EN_setNormal id AllNormal_array [v]
					)
					collapseStack msh
				) -- This is the slowest part of the importing process. Sorry.
				if BoneCount != 0 and BoneIDSets > 0 do (
					skinMod = skin ()
					BoneIDMap = #()
					addModifier msh skinMod
					for i = 1 to BoneCount do (
					   maxbone = getnodebyname BoneSetup[i].name
					   if i != BoneCount then
						  skinOps.addBone skinMod maxbone 0
					   else
						  skinOps.addBone skinMod maxbone 1
					)
					local numSkinBones = skinOps.GetNumberBones skinMod
					for i = 1 to numSkinBones do (
						local BoneName = skinOps.GetBoneName skinMod i 0
						for j = 1 to BoneCount do (
							if BoneName == BoneSetup[j].Name then (
								BoneIDMap[j] = i
								j = BoneCount + 1
							)
						)
					) -- This fixes bone ordering in 3DS Max 2012. Thanks to sunnydavis for the fix!

					modPanel.setCurrentObject skinMod

					for i = 1 to AllVert_array.count do (
						skinOps.SetVertexWeights skinMod i 1 1
						skinOps.unnormalizeVertex skinMod i true 
						skinOps.SetVertexWeights skinMod i 1 0
					)
						skinOps.RemoveZeroWeights skinMod
					for i = 1 to AllVert_array.count do (
						skinOps.unnormalizeVertex skinMod i false
					) -- These fix broken rigging for 3DS Max 2015 and above.

					for i = 1 to AllWeight_array.count do (
						w = AllWeight_array [i]
						bi = #()
						wv = #()
						
						for j = 1 to w.BoneIDs.count do (
							BoneID = w.BoneIDs[j]
							weight = w.weights[j]
							append bi BoneIDMap[BoneID]
							append wv weight
						)
						skinOps.ReplaceVertexWeights skinMod i bi wv
					)
				)
			)
			if AllUV3_array.count > 0 do(
				msh = mesh vertices:AllVert_array faces:AllFace_array
				msh.numTVerts = AllVert_array.count
				defaultVCFaces msh
				buildTVFaces msh
				if LODNum == 1 then (msh.name = (BaseName as string) + " (Layer 3)") else (msh.name = (BaseName as string + " (LOD " + LODNum as string + ", Layer 3)"))
				msh.material = MultiMat
				if AllColor_array.count > 0 then (
					setNumCPVVerts msh msh.numTVerts
					setCVertMode msh true
					setShadeCVerts msh true
					for j = 1 to AllColor_array.count do setvertcolor msh j AllColor_array [j]
					for j = 1 to AllAlpha_array.count do (meshop.setVertAlpha msh -2 j AllAlpha_array [j])
				)
				for j = 1 to AllUV3_array.count do setTVert msh j AllUV3_array [j]
				for j = 1 to AllFace_array.count do (
					setTVFace msh j AllFace_array [j]
					setFaceMatID msh j AllMatID_array [j]
				)
				max modify mode
				select msh
				for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
				if AllNormal_array.count > 0 do (
					addmodifier msh (Edit_Normals ()) ui:off
					msh.Edit_Normals.MakeExplicit selection:#{1..AllNormal_array.count}
					EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
					EN_setNormal = msh.Edit_Normals.SetNormal
					normID = #{}
					for v = 1 to AllNormal_array.count do
					(
						free normID
						EN_convertVS #{v} &normID
						for id in normID do EN_setNormal id AllNormal_array [v]
					)
					collapseStack msh
				) -- This is the slowest part of the importing process. Sorry.
				if BoneCount != 0 and BoneIDSets > 0 do (
					skinMod = skin ()
					BoneIDMap = #()
					addModifier msh skinMod
					for i = 1 to BoneCount do (
					   maxbone = getnodebyname BoneSetup[i].name
					   if i != BoneCount then
						  skinOps.addBone skinMod maxbone 0
					   else
						  skinOps.addBone skinMod maxbone 1
					)
					local numSkinBones = skinOps.GetNumberBones skinMod
					for i = 1 to numSkinBones do (
						local BoneName = skinOps.GetBoneName skinMod i 0
						for j = 1 to BoneCount do (
							if BoneName == BoneSetup[j].Name then (
								BoneIDMap[j] = i
								j = BoneCount + 1
							)
						)
					) -- This fixes bone ordering in 3DS Max 2012. Thanks to sunnydavis for the fix!

					modPanel.setCurrentObject skinMod

					for i = 1 to AllVert_array.count do (
						skinOps.SetVertexWeights skinMod i 1 1
						skinOps.unnormalizeVertex skinMod i true 
						skinOps.SetVertexWeights skinMod i 1 0
					)
						skinOps.RemoveZeroWeights skinMod
					for i = 1 to AllVert_array.count do (
						skinOps.unnormalizeVertex skinMod i false
					) -- These fix broken rigging for 3DS Max 2015 and above.

					for i = 1 to AllWeight_array.count do (
						w = AllWeight_array [i]
						bi = #()
						wv = #()
						
						for j = 1 to w.BoneIDs.count do (
							BoneID = w.BoneIDs[j]
							weight = w.weights[j]
							append bi BoneIDMap[BoneID]
							append wv weight
						)
						skinOps.ReplaceVertexWeights skinMod i bi wv
					)
				)
			)
			if AllUV4_array.count > 0 do(
				msh = mesh vertices:AllVert_array faces:AllFace_array
				msh.numTVerts = AllVert_array.count
				defaultVCFaces msh
				buildTVFaces msh
				if LODNum == 1 then (msh.name = (BaseName as string) + " (Layer 4)") else (msh.name = (BaseName as string + " (LOD " + LODNum as string + ", Layer 4)"))
				msh.material = MultiMat
				if AllColor_array.count > 0 then (
					setNumCPVVerts msh msh.numTVerts
					setCVertMode msh true
					setShadeCVerts msh true
					for j = 1 to AllColor_array.count do setvertcolor msh j AllColor_array [j]
					for j = 1 to AllAlpha_array.count do (meshop.setVertAlpha msh -2 j AllAlpha_array [j])
				)
				for j = 1 to AllUV4_array.count do setTVert msh j AllUV4_array [j]
				for j = 1 to AllFace_array.count do (
					setTVFace msh j AllFace_array [j]
					setFaceMatID msh j AllMatID_array [j]
				)
				max modify mode
				select msh
				for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
				if AllNormal_array.count > 0 do (
					addmodifier msh (Edit_Normals ()) ui:off
					msh.Edit_Normals.MakeExplicit selection:#{1..AllNormal_array.count}
					EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
					EN_setNormal = msh.Edit_Normals.SetNormal
					normID = #{}
					for v = 1 to AllNormal_array.count do
					(
						free normID
						EN_convertVS #{v} &normID
						for id in normID do EN_setNormal id AllNormal_array [v]
					)
					collapseStack msh
				) -- This is the slowest part of the importing process. Sorry.
				if BoneCount != 0 and BoneIDSets > 0 do (
					skinMod = skin ()
					BoneIDMap = #()
					addModifier msh skinMod
					for i = 1 to BoneCount do (
					   maxbone = getnodebyname BoneSetup[i].name
					   if i != BoneCount then
						  skinOps.addBone skinMod maxbone 0
					   else
						  skinOps.addBone skinMod maxbone 1
					)
					local numSkinBones = skinOps.GetNumberBones skinMod
					for i = 1 to numSkinBones do (
						local BoneName = skinOps.GetBoneName skinMod i 0
						for j = 1 to BoneCount do (
							if BoneName == BoneSetup[j].Name then (
								BoneIDMap[j] = i
								j = BoneCount + 1
							)
						)
					) -- This fixes bone ordering in 3DS Max 2012. Thanks to sunnydavis for the fix!

					modPanel.setCurrentObject skinMod

					for i = 1 to AllVert_array.count do (
						skinOps.SetVertexWeights skinMod i 1 1
						skinOps.unnormalizeVertex skinMod i true 
						skinOps.SetVertexWeights skinMod i 1 0
					)
						skinOps.RemoveZeroWeights skinMod
					for i = 1 to AllVert_array.count do (
						skinOps.unnormalizeVertex skinMod i false
					) -- These fix broken rigging for 3DS Max 2015 and above.

					for i = 1 to AllWeight_array.count do (
						w = AllWeight_array [i]
						bi = #()
						wv = #()
						
						for j = 1 to w.BoneIDs.count do (
							BoneID = w.BoneIDs[j]
							weight = w.weights[j]
							append bi BoneIDMap[BoneID]
							append wv weight
						)
						skinOps.ReplaceVertexWeights skinMod i bi wv
					)
				)
			)
			if AllUV5_array.count > 0 do(
				msh = mesh vertices:AllVert_array faces:AllFace_array
				msh.numTVerts = AllVert_array.count
				defaultVCFaces msh
				buildTVFaces msh
				if LODNum == 1 then (msh.name = (BaseName as string) + " (Layer 5)") else (msh.name = (BaseName as string + " (LOD " + LODNum as string + ", Layer 5)"))
				msh.material = MultiMat
				if AllColor_array.count > 0 then (
					setNumCPVVerts msh msh.numTVerts
					setCVertMode msh true
					setShadeCVerts msh true
					for j = 1 to AllColor_array.count do setvertcolor msh j AllColor_array [j]
					for j = 1 to AllAlpha_array.count do (meshop.setVertAlpha msh -2 j AllAlpha_array [j])
				)
				for j = 1 to AllUV5_array.count do setTVert msh j AllUV5_array [j]
				for j = 1 to AllFace_array.count do (
					setTVFace msh j AllFace_array [j]
					setFaceMatID msh j AllMatID_array [j]
				)
				max modify mode
				select msh
				for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
				if AllNormal_array.count > 0 do (
					addmodifier msh (Edit_Normals ()) ui:off
					msh.Edit_Normals.MakeExplicit selection:#{1..AllNormal_array.count}
					EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
					EN_setNormal = msh.Edit_Normals.SetNormal
					normID = #{}
					for v = 1 to AllNormal_array.count do
					(
						free normID
						EN_convertVS #{v} &normID
						for id in normID do EN_setNormal id AllNormal_array [v]
					)
					collapseStack msh
				) -- This is the slowest part of the importing process. Sorry.
				if BoneCount != 0 and BoneIDSets > 0 do (
					skinMod = skin ()
					BoneIDMap = #()
					addModifier msh skinMod
					for i = 1 to BoneCount do (
					   maxbone = getnodebyname BoneSetup[i].name
					   if i != BoneCount then
						  skinOps.addBone skinMod maxbone 0
					   else
						  skinOps.addBone skinMod maxbone 1
					)
					local numSkinBones = skinOps.GetNumberBones skinMod
					for i = 1 to numSkinBones do (
						local BoneName = skinOps.GetBoneName skinMod i 0
						for j = 1 to BoneCount do (
							if BoneName == BoneSetup[j].Name then (
								BoneIDMap[j] = i
								j = BoneCount + 1
							)
						)
					) -- This fixes bone ordering in 3DS Max 2012. Thanks to sunnydavis for the fix!

					modPanel.setCurrentObject skinMod

					for i = 1 to AllVert_array.count do (
						skinOps.SetVertexWeights skinMod i 1 1
						skinOps.unnormalizeVertex skinMod i true 
						skinOps.SetVertexWeights skinMod i 1 0
					)
						skinOps.RemoveZeroWeights skinMod
					for i = 1 to AllVert_array.count do (
						skinOps.unnormalizeVertex skinMod i false
					) -- These fix broken rigging for 3DS Max 2015 and above.

					for i = 1 to AllWeight_array.count do (
						w = AllWeight_array [i]
						bi = #()
						wv = #()
						
						for j = 1 to w.BoneIDs.count do (
							BoneID = w.BoneIDs[j]
							weight = w.weights[j]
							append bi BoneIDMap[BoneID]
							append wv weight
						)
						skinOps.ReplaceVertexWeights skinMod i bi wv
					)
				)
			)
			if AllUV6_array.count > 0 do(
				msh = mesh vertices:AllVert_array faces:AllFace_array
				msh.numTVerts = AllVert_array.count
				defaultVCFaces msh
				buildTVFaces msh
				if LODNum == 1 then (msh.name = (BaseName as string) + " (Layer 6)") else (msh.name = (BaseName as string + " (LOD " + LODNum as string + ", Layer 6)"))
				msh.material = MultiMat
				if AllColor_array.count > 0 then (
					setNumCPVVerts msh msh.numTVerts
					setCVertMode msh true
					setShadeCVerts msh true
					for j = 1 to AllColor_array.count do setvertcolor msh j AllColor_array [j]
					for j = 1 to AllAlpha_array.count do (meshop.setVertAlpha msh -2 j AllAlpha_array [j])
				)
				for j = 1 to AllUV6_array.count do setTVert msh j AllUV6_array [j]
				for j = 1 to AllFace_array.count do (
					setTVFace msh j AllFace_array [j]
					setFaceMatID msh j AllMatID_array [j]
				)
				max modify mode
				select msh
				for face = 1 to msh.numfaces do setFaceSmoothGroup msh face 1
				if AllNormal_array.count > 0 do (
					addmodifier msh (Edit_Normals ()) ui:off
					msh.Edit_Normals.MakeExplicit selection:#{1..AllNormal_array.count}
					EN_convertVS = msh.Edit_Normals.ConvertVertexSelection
					EN_setNormal = msh.Edit_Normals.SetNormal
					normID = #{}
					for v = 1 to AllNormal_array.count do
					(
						free normID
						EN_convertVS #{v} &normID
						for id in normID do EN_setNormal id AllNormal_array [v]
					)
					collapseStack msh
				) -- This is the slowest part of the importing process. Sorry.
				if BoneCount != 0 and BoneIDSets > 0 do (
					skinMod = skin ()
					BoneIDMap = #()
					addModifier msh skinMod
					for i = 1 to BoneCount do (
					   maxbone = getnodebyname BoneSetup[i].name
					   if i != BoneCount then
						  skinOps.addBone skinMod maxbone 0
					   else
						  skinOps.addBone skinMod maxbone 1
					)
					local numSkinBones = skinOps.GetNumberBones skinMod
					for i = 1 to numSkinBones do (
						local BoneName = skinOps.GetBoneName skinMod i 0
						for j = 1 to BoneCount do (
							if BoneName == BoneSetup[j].Name then (
								BoneIDMap[j] = i
								j = BoneCount + 1
							)
						)
					) -- This fixes bone ordering in 3DS Max 2012. Thanks to sunnydavis for the fix!

					modPanel.setCurrentObject skinMod

					for i = 1 to AllVert_array.count do (
						skinOps.SetVertexWeights skinMod i 1 1
						skinOps.unnormalizeVertex skinMod i true 
						skinOps.SetVertexWeights skinMod i 1 0
					)
						skinOps.RemoveZeroWeights skinMod
					for i = 1 to AllVert_array.count do (
						skinOps.unnormalizeVertex skinMod i false
					) -- These fix broken rigging for 3DS Max 2015 and above.

					for i = 1 to AllWeight_array.count do (
						w = AllWeight_array [i]
						bi = #()
						wv = #()
						
						for j = 1 to w.BoneIDs.count do (
							BoneID = w.BoneIDs[j]
							weight = w.weights[j]
							append bi BoneIDMap[BoneID]
							append wv weight
						)
						skinOps.ReplaceVertexWeights skinMod i bi wv
					)
				)
			)
		)
	)

	on btnImport pressed do (
		local ModelScale = spnModelScale.value
		local VertColors = tglVertColors.checked
		local LODs = tglLODs.checked
		UVLayers = tglUVLayers.state
		local TexFormat = tglTexFormat.state
		local TexPath = tglTexPath.state
		local EarlyGameFix = lstEarlyGameFix.selection
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
		if MultiD3DMeshFilenames.count > 0 do (
			disableSceneRedraw()
			st = timestamp() --get start time in milliseconds

			BoneName_array = #()
			BoneParent_array = #()
			BoneSetup = #()
			BoneCount = 0
			for q = 1 to MultiD3DMeshFilenames.count do (
				f = fopen MultiD3DMeshFilenames[q] "rb"
				fname = MultiD3DMeshFilenames[q]
				BasePath = getFilenamePath fname
				BaseName = getFilenameFile fname

				fseek f 0x00 #seek_set
				HeaderMagic = readlong f #unsigned

				case HeaderMagic of (
					default:(
						if HeaderMagic < 0 or HeaderMagic > 128 then (
							print "Mesh header seems malformed, attempting to parse anyway."
							ParamCount = readlong f #unsigned
							ParamHashCheck = readlong f #unsigned
							fseek f -0x04 #seek_cur
							if ParamHashCheck > 0 and ParamHashCheck < 128 then (
								for x = 1 to ParamCount do (
									ParamNameLength = readlong f #unsigned
									ParamName = ReadFixedString f ParamNameLength
									ParamUnk = readlong f #unsigned
								)
							) else (
								for x = 1 to ParamCount do (
									fseek f 0x0C #seek_cur
								)
							)
						) else (printDebug("Headerless D3DMesh"); fseek f 0x00 #seek_set)
					)
					1296189774:( -- "MBIN"
						
						ParamCount = readlong f #unsigned
						ParamHashCheck = readlong f #unsigned
						fseek f -0x04 #seek_cur
						if ParamHashCheck > 0 and ParamHashCheck < 128 then (
							for x = 1 to ParamCount do (
								ParamNameLength = readlong f #unsigned
								ParamName = ReadFixedString f ParamNameLength
								ParamUnk = readlong f #unsigned
							)
						) else (
							for x = 1 to ParamCount do (
								fseek f 0x0C #seek_cur
							)
						)
					)
					1297371717:( -- "MTRE"
						
						ParamCount = readlong f #unsigned
						ParamHashCheck = readlong f #unsigned
						fseek f -0x04 #seek_cur
						if ParamHashCheck > 0 and ParamHashCheck < 128 then (
							for x = 1 to ParamCount do (
								ParamNameLength = readlong f #unsigned
								ParamName = ReadFixedString f ParamNameLength
								ParamUnk = readlong f #unsigned
							)
						) else (
							for x = 1 to ParamCount do (
								fseek f 0x0C #seek_cur
							)
						)
					)
					1297307189:( -- "MSV5"
						
						FileSize = readlong f #unsigned
						fseek f 0x08 #seek_cur
						ParamCount = readlong f #unsigned
						for x = 1 to ParamCount do (
							fseek f 0x0C #seek_cur
						)
					)
					1297307190:( -- "MSV6"
						
						FileSize = readlong f #unsigned
						fseek f 0x08 #seek_cur
						ParamCount = readlong f #unsigned
						for x = 1 to ParamCount do (
							fseek f 0x0C #seek_cur
						)
					)
				)

				D3DNameHeaderLength = readlong f #unsigned
				D3DNameLength = readlong f #unsigned
				if D3DNameLength > D3DNameHeaderLength do (
					printDebug("Quietly fixing offset...")
					fseek f -0x04 #seek_cur
					D3DNameLength = D3DNameHeaderLength
				)
				D3DName = ReadFixedString f D3DNameLength
				VerNum = readbyte f #unsigned
				if (VerNum == 48) or (VerNum == 49) do (VerNum = 0) 
				-- "Version 0" games use the ASCII hex code for "0" or "1" to indicate unrigged or rigged models, in the place where the version number would be in later titles. Thankfully no other games use these two numbers!
				print ("Importing " + D3DName + " (Version " + VerNum as string + ")...")

				-- Import/Skip skeleton
				if q == 1 do (
					bname = getOpenFileName \ 
					caption:"Import Telltale Games SKL file (hit Cancel for none)" \
					types:"Telltale Games Skeleton Files (*.skl)|*.skl" \
					historyCategory:"TelltaleD3DMesh"
					if bname != undefined do (
						g = fopen bname "rb"
						BttFFix = 0
						if VerNum == 17 do (
							fseek g 0x28 #seek_set
							BttFCheck = readlong g
							fseek g 0x00 #seek_set
							if BttFCheck == -1339414801 do (BttFFix = 1)
							-- Back to the Future PS4 uses "Version 17" models with "Version 18" bone structures for some reason.
						)
						BoneHeaderMagic = readlong g
						case BoneHeaderMagic of (
							default:(
								print "Bone header seems malformed, attempting to parse anyway."
								ParamCount = readlong g #unsigned
								ParamHashCheck = readlong g #unsigned
								fseek g -0x04 #seek_cur
								if ParamHashCheck > 0 and ParamHashCheck < 128 then (
									for x = 1 to ParamCount do (
										ParamNameLength = readlong g #unsigned
										ParamName = ReadFixedString g ParamNameLength
										ParamUnk = readlong g #unsigned
									)
								) else (
									for x = 1 to ParamCount do (
										fseek g 0x0C #seek_cur
									)
								)
							)
							1296189774:(
								print "MBIN"
								ParamCount = readlong g #unsigned
								ParamHashCheck = readlong g #unsigned
								fseek g -0x04 #seek_cur
								if ParamHashCheck > 0 and ParamHashCheck < 128 then (
									for x = 1 to ParamCount do (
										ParamNameLength = readlong g #unsigned
										ParamName = ReadFixedString g ParamNameLength
										ParamUnk = readlong g #unsigned
									)
								) else (
									for x = 1 to ParamCount do (
										fseek g 0x0C #seek_cur
									)
								)
							)
							1297371717:(
								print "MTRE"
								ParamCount = readlong g #unsigned
								ParamHashCheck = readlong g #unsigned
								fseek g -0x04 #seek_cur
								if ParamHashCheck > 0 and ParamHashCheck < 128 then (
									for x = 1 to ParamCount do (
										ParamNameLength = readlong g #unsigned
										ParamName = ReadFixedString g ParamNameLength
										ParamUnk = readlong g #unsigned
									)
								) else (
									for x = 1 to ParamCount do (
										fseek g 0x0C #seek_cur
									)
								)
							)
							1297307189:(
								print "MSV5"
								FileSize = readlong g #unsigned
								fseek g 0x08 #seek_cur
								ParamCount = readlong g #unsigned
								for x = 1 to ParamCount do (
									fseek g 0x0C #seek_cur
								)
							)
							1297307190:(
								print "MSV6"
								FileSize = readlong g #unsigned
								fseek g 0x08 #seek_cur
								ParamCount = readlong g #unsigned
								for x = 1 to ParamCount do (
									fseek g 0x0C #seek_cur
								)
							)
						)
						if VerNum == 0 and EarlyGameFix > 4 and EarlyGameFix < 8 do (fseek g 0x01 #seek_cur)
						BoneFileSize = readlong g #unsigned

						BoneCount = readlong g #unsigned
						if BoneCount != 0 do (
							for b = 1 to BoneCount do (
								if VerNum > 0 or (VerNum == 0 and EarlyGameFix > 3) then (
									BoneHash2 = readlong g #unsigned
									BoneHash1 = readlong g #unsigned
									BoneName = ("0x" + bit.intAsHex(BoneHash1) as string)
									for y = 1 to BoneHash_array.count do (
										if BoneHash1 == BoneHash_array[y].BoneHash1 and BoneHash2 == BoneHash_array[y].BoneHash2 do (
											BoneName = BoneHash_array[y].BoneString
											-- exit()
										)
									)
									append BoneName_array BoneName
									if VerNum < 13 do (Padding = readlong g)
									
								) else (
									BoneNameSectLength = readlong g
									BoneNameLength = readlong g
									BoneName = ReadFixedString g BoneNameLength
									append BoneName_array BoneName
								)
								if VerNum > 0 or (VerNum == 0 and EarlyGameFix > 3) then (
									BoneParentHash2 = readlong g #unsigned
									BoneParentHash1 = readlong g #unsigned
									BoneParentName = bit.intAsHex(BoneParentHash1) as string
									if VerNum < 13 do (Padding = readfloat g)
									
								) else (
									BoneParentNameSectLength = readlong g
									BoneParentNameLength = readlong g
									BoneParentName = ReadFixedString g BoneParentNameLength
								)

							BoneParent = readlong g #unsigned
							if BoneParent < -1 do BoneParent = -1
							append BoneParent_array BoneParent
							if VerNum >= 18 or BttFFix == 1 do (
								BoneUnk1 = readfloat g
								BoneUnk2 = readfloat g
								BoneUnk3 = readfloat g
								)
							BoneTX = readfloat g * ModelScale; BoneTY = readfloat g * ModelScale; BoneTZ = readfloat g * ModelScale
							BoneRX = readfloat g; BoneRY = readfloat g; BoneRZ = readfloat g; BoneRW = readfloat g * -1
							MayBeHeader = readlong g
							nothing3 = readfloat g
							nothing4 = readfloat g
							nothing5 = readfloat g
							BoneQ = readfloat g
							nothing6 = readfloat g
							nothing7 = readfloat g
							nothing8 = readfloat g
							BoneXX = readfloat g; BoneXY = readfloat g; BoneXZ = readfloat g
							BoneYX = readfloat g; BoneYY = readfloat g; BoneYZ = readfloat g
							BoneZX = readfloat g; BoneZY = readfloat g; BoneZZ = readfloat g
							IKHeaderLength = readlong g
							IKAmount = readlong g
							for x = 1 to IKAmount do (
								if VerNum == 55 then (
									IKNameHash1 = readlong g
									IKNameHash2 = readlong g
								) else (
									IKNameLength = readlong g
									IKName = ReadFixedString g IKNameLength
								)
								IKInfluence = readfloat g
							)
							if VerNum == 0 and EarlyGameFix > 4 do(Padding = readlong g)
							if VerNum > 1 do (
								landofpilength = readlong g
								piamountlength = readlong g
								for x = 1 to piamountlength do (
									float1 = readfloat g
									float2 = readfloat g
									float3 = readfloat g
								)
								piHeaderLength = readlong g
								pinx = readfloat g; pipx = readfloat g
								piny = readfloat g; pipy = readfloat g
								pinz = readfloat g; pipz = readfloat g
								piend = readfloat g
							)
							tfm = (quat bonerx bonery bonerz bonerw) as matrix3
							tfm.row4 = [bonetx, bonety, bonetz]
							if (getNodeByName BoneName) != undefined do (
								append BoneSetup (getNodeByName BoneName)
							)
							if (getNodeByName BoneName) == undefined do (
								if (BoneParent != -1) do (
									tfm = tfm * BoneSetup[(boneparent + 1)].objecttransform
								)
							)
							newBone = bonesys.createbone   \
										  tfm.row4   \
										  (tfm.row4 + 0.01 * (normalize tfm.row1)) \
										  (normalize tfm.row3)
									 newBone.name = BoneName
									 newBone.width  = 0.01
									 newBone.height = 0.01
									 newBone.transform = tfm
									 newBone.setBoneEnable false 0
									 newBone.wirecolor = yellow
									 newbone.showlinks = true
									 newBone.pos.controller      = TCB_position ()
									 newBone.rotation.controller = TCB_rotation ()
							if (BoneParent != -1) then
							newBone.parent = BoneSetup[(BoneParent + 1)]
							append BoneSetup newBone
							)
						)
						fclose g
					)
				)

				if D3DName != "" do (
					AllVert_array = #()
					AllNormal_array = #()
					AllUV_array = #()
					AllUV2_array = #()
					AllUV3_array = #()
					AllUV4_array = #()
					AllUV5_array = #()
					AllUV6_array = #()
					AllColor_array = #()
					AllAlpha_array = #()
					AllWeight_array = #()
					AllFace_array = #()
					AllMatID_array = #()
					MultiMat = MultiMaterial()
					LODNum = 1
					case of (
						default:(print "Unknown version!"; fclose f)
						(VerNum == 55):(
							-- Version 55: The Walking Dead: The Final Season [PC], 
							-- The Walking Dead: The Telltale Definitive Series [PC], 
							-- Sam & Max: Save the World / Beyond Time and Space Remastered [PC]
							struct Bone_Info_Struct (Bone1, Bone2, Bone3, Bone4)
							struct Weight_Info_Struct (Weight1, Weight2, Weight3, Weight4)
							struct Weight_data (BoneIDs, weights)
							struct Polygon_Info_Struct (VertexStart, VertexMin, VertexMax, PolygonStart, PolygonCount, FacePointCount, MatNum, LODNum)
							struct MatHash_Struct (MatHash1, MatHash2, TexDifName)
							Face_array = #()
							FaceB_array = #()
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
							FacePointCount = 0
							FacePointCountB = 0

							fseek f 0x0 #seek_set
							MVS6 = readlong f #unsigned
							fseek f 0x0 #seek_set
							if MVS6 == 1297307190 do (
								fseek f 0x04 #seek_cur
								filesize = readlong f #unsigned
								fseek f 0x08 #seek_cur
								headerthing = readlong f #unsigned
								for v = 1 to headerthing do (
									fseek f 0x0C #seek_cur
								)
							)
							NameHeaderLength = readlong f #unsigned
							NameLength = readlong f #unsigned
							name = ReadFixedString f NameLength

							printDebug ("Section 1 (Model info) start = " + (ftell f as string))
							fseek f 0x15 #seek_cur

							printDebug ("Section 2 (Material info) start = " + (ftell f as string))
							MatCount = readlong f #unsigned
							printDebug ("Material Count = " + MatCount as string)

							for x = 1 to MatCount do (
								printDebug ("Material #" + x as string + " start = " + (ftell f as string))
								MatHash2 = readlong f #unsigned
								MatHash1 = readlong f #unsigned
								UnkHash2 = readlong f #unsigned
								UnkHash1 = readlong f #unsigned
								MatHeaderSize = (ftell f) + readlong f #unsigned
									
								MatUnk1 = readlong f #unsigned
								MatUnk2 = readlong f #unsigned
								MatHeaderSizeB = readlong f #unsigned

								MatUnk3Count = readlong f #unsigned
								for m = 1 to MatUnk3Count do (
									MatUnk3Hash2 = readlong f #unsigned
									MatUnk3Hash1 = readlong f #unsigned
								)

								MatParamCount = readlong f #unsigned
								TexDifName = "undefined"
								printDebug("Material parameter count = " + MatParamCount as string)

								for m = 1 to MatParamCount do (
									MatSectHash2 = bit.intAsHex(readlong f #unsigned)
									MatSectHash1 = bit.intAsHex(readlong f #unsigned)
									MatSectCount = readlong f #unsigned
									printDebug("Material hash: " + MatSectHash1 + " " + MatSectHash2 + ", Count = " + MatSectCount as string + ", Offset = " + (ftell f) as string)

									case of (
										default: (throw("Unknown material hashes!"))
										(MatSectHash1 == "0" and MatSectHash2 == "0"):(
											-- ...Nothing?
										)
										(MatSectHash1 == "a98f0652" and MatSectHash2 == "295de685"):(
											-- ...Nothing?
										)
										(MatSectHash1 == "fa21e4c8" and MatSectHash2 == "8ae64d31"):(
											-- ...Nothing?
										)
										(MatSectHash1 == "254edc51" and MatSectHash2 == "7b59bb47"):(
											-- ...Nothing?
										)
										(MatSectHash1 == "7caceebc" and MatSectHash2 == "d26d075c"):(
											-- ...Nothing?
										)
										(MatSectHash1 == "ded5e193" and MatSectHash2 == "7b1689ef"):(
											-- ...Nothing?
										)
										(MatSectHash1 == "264ac2f2" and MatSectHash2 == "544e517c"):(
											-- Hacky fix for "adv_boardingSchoolExterior_meshesABuilding" to prevent erroring.
											fseek f -0x04 #seek_cur
										)
										(MatSectHash1 == "873c2f18" and MatSectHash2 == "35428297"):(
											-- Hacky fix for "obj_vehicleTruckForestShack" to prevent erroring.
											fseek f 0x08 #seek_cur
										)
										(MatSectHash1 == "4e7d91f1" and MatSectHash2 == "6f97a3c2"):(
											-- Hacky fix for "ui_icon" to prevent erroring.
											fseek f -0x04 #seek_cur
										)
										(MatSectHash1 == "181afb3e" and MatSectHash2 == "bb8f90ae"):(
											-- Hacky fix for "ui_icon" to prevent erroring.
										)
										(MatSectHash1 == "fec9ffdf" and MatSectHash2 == "25b43917"):(
											-- Hacky fix for "ui_mask" to prevent erroring.
											fseek f -0x04 #seek_cur
										)
										(MatSectHash1 == "8c44858f" and MatSectHash2 == "42cd32d5"):(
											-- Hacky fix for "ui_mask" to prevent erroring.
										)
										(MatSectHash1 == "b76e07d6" and MatSectHash2 == "bb899bfe"):(
											for y = 1 to MatSectCount do (
											-- Four floats (alternate?)
											MatUnkHash2 = readlong f #unsigned
											MatUnkHash1 = readlong f #unsigned
											MatUnkFloat1 = readfloat f
											MatUnkFloat2 = readfloat f
											MatUnkFloat3 = readfloat f
											MatUnkFloat4 = readfloat f
											)
										)
										(MatSectHash1 == "4f0234" and MatSectHash2 == "63d89fb0"):(
											for y = 1 to MatSectCount do (
											-- One hash set
											MatUnkHash2 = readlong f #unsigned
											MatUnkHash1 = readlong f #unsigned
											MatUnkHash4 = readlong f #unsigned
											MatUnkHash3 = readlong f #unsigned
											)
										)
										(MatSectHash1 == "bae4cbd7" and MatSectHash2 == "7f139a91"):(
											for y = 1 to MatSectCount do (
											-- One float
											MatUnkHash2 = readlong f #unsigned
											MatUnkHash1 = readlong f #unsigned
											MatUnkFloat = readfloat f
											)
										)
										(MatSectHash1 == "9004c558" and MatSectHash2 == "7575d6c0"):(
											for y = 1 to MatSectCount do (
												-- One byte, boolean?
											MatUnkHash2 = readlong f #unsigned
											MatUnkHash1 = readlong f #unsigned
											MatUnkBytePad = readbyte f #unsigned
											)
										)
										(MatSectHash1 == "394c43af" and MatSectHash2 == "4ff52c94"):(
											for y = 1 to MatSectCount do (
											-- Three floats
											MatUnkHash2 = readlong f #unsigned
											MatUnkHash1 = readlong f #unsigned
											MatUnkFloat1 = readfloat f
											MatUnkFloat2 = readfloat f
											MatUnkFloat3 = readfloat f
											)
										)
										(MatSectHash1 == "7bbca244" and MatSectHash2 == "e61f1a07"):(
											for y = 1 to MatSectCount do (
											-- Two floats
											MatUnkHash2 = readlong f #unsigned
											MatUnkHash1 = readlong f #unsigned
											MatUnkFloat1 = readfloat f
											MatUnkFloat2 = readfloat f
											)
										)
										(MatSectHash1 == "c16762f7" and MatSectHash2 == "763d62ab"):(
											for y = 1 to MatSectCount do (
											-- Four floats
											MatUnkHash2 = readlong f #unsigned
											MatUnkHash1 = readlong f #unsigned
											MatUnkFloat1 = readfloat f
											MatUnkFloat2 = readfloat f
											MatUnkFloat3 = readfloat f
											MatUnkFloat4 = readfloat f
											)
										)
										(MatSectHash1 == "52a09151" and MatSectHash2 == "f1c3f2c7"):(
											print "--------------------"
											print ("Material #" + x as string + " uses the following textures:")
											for y = 1 to MatSectCount do (
												TypeHash2 = bit.intAsHex(readlong f #unsigned)
												TypeHash1 = bit.intAsHex(readlong f #unsigned)

												-- 98369708 82a34f02: Anisotropy Map
												-- 714d2344 5936b35d: Anisotropy Mask Map
												-- 7501e041 ac72a988: Anisotropy Tangent Map
												-- dff83873 dff83873: ? Map
												-- 2b6c4784 5f607734: Damage Mask Map A
												-- ec7d65b8 a55e2c81: Damage Mask Map B
												-- 4930b970 a7fd511f: Detail Map
												-- 72507eea 6ef21aee: Color Mask Map
												-- cb433436 edca9efb: Detail Gloss Map
												-- bf468ef4 80aeeb89: Detail Mask Map
												-- 706cf2aa 57a7a206: Detail Normal Map
												-- d49d30f6 4a580c6f: Detail Normal Map A
												-- 138c12ca b06657da: Detail Normal Map B
												-- 517cf321 198c6149: Detail Normal Map C
												-- 8648fa82 d1dbee1a: Diffuse Map
												-- dc6e83a0 253f163a: Diffuse LOD Map
												-- b3022ea7 fd418b40: Emission Map
												-- 257c2a45 683f7d2f: Environment Map
												-- df7e4122 56e87e74: Detail Map B
												-- 94a590de 74b1f5c1: Diffuse Map B
												-- bdb4c92a 546fb889: Emission Map B
												-- 436206e6 8a9e7cca: Normal Map B
												-- 3f380050 afd9f81f: Normal Map B
												-- 120621d5 fad4c090: Specular Map B
												-- 87b579ec 18fbd4d: Visibility Mask Map
												-- 64fba83e 34dd3959: Gloss Map
												-- 73ba445a 1845e143: ? Map
												-- a45200a2 22dc2d80: Thickness Map
												-- bdcd25f2 f4199e3: Packed Detail Map
												-- 1e3f6b9f 2550389d: Normal Map
												-- 533f479d 8bf0e5e: Rain Fall Map
												-- d5b57775 db361670: Specular Map
												-- 8cf38a52 66aaa7a4: Transition Normal Map
												-- 2eba1f4b ba7a1543: Rain Wet Map
												-- d7ea3553 4dbc457d: Wrinkle Mask Map A
												-- 10fb176f b7821ec8: Wrinkle Mask Map B
												-- 340c569 ce9e059f: Wrinkle Normal Map
												-- caaae643 2af348c0: Occlusion Map
												-- 63ee638 83014f19: Detail Normal Map
												-- 4930b970 a7fd511f: Detail Map
												-- 8648fa82 d1dbee1a: Diffuse Map
												-- 13eee658 65dfc90f: Environment Map
												-- b8b04ddf 1796f446: Bump Map
												-- 8cadb260 98df1108: Flow Map
												-- 2642d6b4 c8eccaa9: Gradient Map
												-- 66cd6e57 fa58a246: Height Map
												-- ff787a61 eac8a5b5: Ink Map
												-- 7498a5f1 b80ad419: Normal Alternate Map
												-- 17afd53 2445b8b8: Microdetail Diffuse Map
												-- cb5b9a7f 52168a41: Microdetail Normal Map
												-- 2aa89260 d8661f89: Grime Map
												-- 36170f97 445b6e2e: Decal Diffuse Map
												-- a1f1257a 331854c4: Decal Mask Map
												-- 9cf676c6 403c9784: Decal Normal Map
												-- a13d14fb b436f23b: Wrinkle Normal Map
												-- 37571b60 b1f61180: Tangent Map
												-- a334f76c 317a0c02: Gradient Map
												-- 62c49575 78189f07: Occlusion Map
												-- 4e2ed73c e95b0e15: Reflection Map

												case of (
													default: ()
													(TypeHash1 == "98369708" and TypeHash2 == "82a34f02"):(TypeHash1 = "Anisotropy"; TypeHash2 = "Map")
													(TypeHash1 == "714d2344" and TypeHash2 == "5936b35d"):(TypeHash1 = "Anisotropy Mask"; TypeHash2 = "Map")
													(TypeHash1 == "7501e041" and TypeHash2 == "ac72a988"):(TypeHash1 = "Anisotropy Tangent"; TypeHash2 = "Map")
													(TypeHash1 == "b8b04ddf" and TypeHash2 == "1796f446"):(TypeHash1 = "Bump"; TypeHash2 = "Map")
													(TypeHash1 == "72507eea" and TypeHash2 == "6ef21aee"):(TypeHash1 = "Color Mask"; TypeHash2 = "Map")
													(TypeHash1 == "2b6c4784" and TypeHash2 == "5f607734"):(TypeHash1 = "Damage Mask"; TypeHash2 = "Map A")
													(TypeHash1 == "ec7d65b8" and TypeHash2 == "a55e2c81"):(TypeHash1 = "Damage Mask"; TypeHash2 = "Map B")
													(TypeHash1 == "36170f97" and TypeHash2 == "445b6e2e"):(TypeHash1 = "Decal Diffuse"; TypeHash2 = "Map")
													(TypeHash1 == "a1f1257a" and TypeHash2 == "331854c4"):(TypeHash1 = "Decal Mask"; TypeHash2 = "Map")
													(TypeHash1 == "9cf676c6" and TypeHash2 == "403c9784"):(TypeHash1 = "Decal Normal"; TypeHash2 = "Map")
													(TypeHash1 == "4930b970" and TypeHash2 == "a7fd511f"):(TypeHash1 = "Detail"; TypeHash2 = "Map")
													(TypeHash1 == "df7e4122" and TypeHash2 == "56e87e74"):(TypeHash1 = "Detail"; TypeHash2 = "Map B")
													(TypeHash1 == "cb433436" and TypeHash2 == "edca9efb"):(TypeHash1 = "Detail Gloss"; TypeHash2 = "Map")
													(TypeHash1 == "bf468ef4" and TypeHash2 == "80aeeb89"):(TypeHash1 = "Detail Mask"; TypeHash2 = "Map")
													(TypeHash1 == "63ee638" and TypeHash2 == "83014f19"):(TypeHash1 = "Detail Normal"; TypeHash2 = "Map")
													(TypeHash1 == "706cf2aa" and TypeHash2 == "57a7a206"):(TypeHash1 = "Detail Normal"; TypeHash2 = "Map")
													(TypeHash1 == "d49d30f6" and TypeHash2 == "4a580c6f"):(TypeHash1 = "Detail Normal"; TypeHash2 = "Map A")
													(TypeHash1 == "138c12ca" and TypeHash2 == "b06657da"):(TypeHash1 = "Detail Normal"; TypeHash2 = "Map B")
													(TypeHash1 == "517cf321" and TypeHash2 == "198c6149"):(TypeHash1 = "Detail Normal"; TypeHash2 = "Map C")
													(TypeHash1 == "bdcd25f2" and TypeHash2 == "f4199e3"):(TypeHash1 = "Packed Detail"; TypeHash2 = "Map")
													(TypeHash1 == "8648fa82" and TypeHash2 == "d1dbee1a"):(TypeHash1 = "Diffuse"; TypeHash2 = "Map")
													(TypeHash1 == "94a590de" and TypeHash2 == "74b1f5c1"):(TypeHash1 = "Diffuse"; TypeHash2 = "Map B")
													(TypeHash1 == "dc6e83a0" and TypeHash2 == "253f163a"):(TypeHash1 = "Diffuse LOD"; TypeHash2 = "Map")
													(TypeHash1 == "b3022ea7" and TypeHash2 == "fd418b40"):(TypeHash1 = "Emission"; TypeHash2 = "Map")
													(TypeHash1 == "bdb4c92a" and TypeHash2 == "546fb889"):(TypeHash1 = "Emission"; TypeHash2 = "Map B")
													(TypeHash1 == "13eee658" and TypeHash2 == "65dfc90f"):(TypeHash1 = "Environment"; TypeHash2 = "Map")
													(TypeHash1 == "257c2a45" and TypeHash2 == "683f7d2f"):(TypeHash1 = "Environment"; TypeHash2 = "Map")
													(TypeHash1 == "8cadb260" and TypeHash2 == "98df1108"):(TypeHash1 = "Flow"; TypeHash2 = "Map")
													(TypeHash1 == "64fba83e" and TypeHash2 == "34dd3959"):(TypeHash1 = "Gloss"; TypeHash2 = "Map")
													(TypeHash1 == "2642d6b4" and TypeHash2 == "c8eccaa9"):(TypeHash1 = "Gradient"; TypeHash2 = "Map")
													(TypeHash1 == "a334f76c" and TypeHash2 == "317a0c02"):(TypeHash1 = "Gradient"; TypeHash2 = "Map")
													(TypeHash1 == "2aa89260" and TypeHash2 == "d8661f89"):(TypeHash1 = "Grime"; TypeHash2 = "Map")
													(TypeHash1 == "66cd6e57" and TypeHash2 == "fa58a246"):(TypeHash1 = "Height"; TypeHash2 = "Map")
													(TypeHash1 == "ff787a61" and TypeHash2 == "eac8a5b5"):(TypeHash1 = "Ink"; TypeHash2 = "Map")
													(TypeHash1 == "17afd53" and TypeHash2 == "2445b8b8"):(TypeHash1 = "Microdetail Diffuse"; TypeHash2 = "Map")
													(TypeHash1 == "cb5b9a7f" and TypeHash2 == "52168a41"):(TypeHash1 = "Microdetail Normal"; TypeHash2 = "Map")
													(TypeHash1 == "1e3f6b9f" and TypeHash2 == "2550389d"):(TypeHash1 = "Normal"; TypeHash2 = "Map")
													(TypeHash1 == "3f380050" and TypeHash2 == "afd9f81f"):(TypeHash1 = "Normal"; TypeHash2 = "Map B")
													(TypeHash1 == "436206e6" and TypeHash2 == "8a9e7cca"):(TypeHash1 = "Normal"; TypeHash2 = "Map B")
													(TypeHash1 == "7498a5f1" and TypeHash2 == "b80ad419"):(TypeHash1 = "Normal Alternate"; TypeHash2 = "Map")
													(TypeHash1 == "caaae643" and TypeHash2 == "2af348c0"):(TypeHash1 = "Occlusion"; TypeHash2 = "Map")
													(TypeHash1 == "62c49575" and TypeHash2 == "78189f07"):(TypeHash1 = "Occlusion"; TypeHash2 = "Map")
													(TypeHash1 == "533f479d" and TypeHash2 == "8bf0e5e"):(TypeHash1 = "Rain Fall"; TypeHash2 = "Map")
													(TypeHash1 == "2eba1f4b" and TypeHash2 == "ba7a1543"):(TypeHash1 = "Rain Wet"; TypeHash2 = "Map")
													(TypeHash1 == "4e2ed73c" and TypeHash2 == "e95b0e15"):(TypeHash1 = "Reflection"; TypeHash2 = "Map")
													(TypeHash1 == "c8c94155" and TypeHash2 == "fb7c634b"):(TypeHash1 = "Specular"; TypeHash2 = "Map")
													(TypeHash1 == "d5b57775" and TypeHash2 == "db361670"):(TypeHash1 = "Specular"; TypeHash2 = "Map")
													(TypeHash1 == "120621d5" and TypeHash2 == "fad4c090"):(TypeHash1 = "Specular"; TypeHash2 = "Map B")
													(TypeHash1 == "37571b60" and TypeHash2 == "b1f61180"):(TypeHash1 = "Tangent"; TypeHash2 = "Map B")
													(TypeHash1 == "a45200a2" and TypeHash2 == "22dc2d80"):(TypeHash1 = "Thickness"; TypeHash2 = "Map") 
													(TypeHash1 == "8cf38a52" and TypeHash2 == "66aaa7a4"):(TypeHash1 = "Transition Normal"; TypeHash2 = "Map")
													(TypeHash1 == "87b579ec" and TypeHash2 == "18fbd4d"):(TypeHash1 = "Visibility Mask"; TypeHash2 = "Map")
													(TypeHash1 == "d7ea3553" and TypeHash2 == "4dbc457d"):(TypeHash1 = "Wrinkle Mask"; TypeHash2 = "Map A")
													(TypeHash1 == "10fb176f" and TypeHash2 == "b7821ec8"):(TypeHash1 = "Wrinkle Mask"; TypeHash2 = "Map B")
													(TypeHash1 == "340c569" and TypeHash2 == "ce9e059f"):(TypeHash1 = "Wrinkle Normal"; TypeHash2 = "Map")
													(TypeHash1 == "a13d14fb" and TypeHash2 == "b436f23b"):(TypeHash1 = "Wrinkle Normal"; TypeHash2 = "Map")
												)
												TexHash2 = readlong f #unsigned
												TexHash1 = readlong f #unsigned
												TexName = bit.intAsHex(TexHash1) as string
												for y = 1 to TexHash_array.count do (
													if TexHash1 == TexHash_array [y].TexHash1 and TexHash2 == TexHash_array [y].TexHash2 do (
														TexName = TexHash_array [y].TexString
														-- exit()
													)
												)
												if (TypeHash1 == "Diffuse" and TypeHash2 == "Map") or (TypeHash1 == "Diffuse LOD" and TypeHash2 == "Map") do (TexDifName = TexName)
												print (TypeHash1 + " " + TypeHash2 as string + ": " + TexName)
											)
											-- exit() -- We got what we came here for, time to get out.
										)
										(MatSectHash1 == "e2ba743e" and MatSectHash2 == "952f9338"):(
											for y = 1 to MatSectCount do (
											--- Two hash sets
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
								append MatHash_array (MatHash_Struct MatHash1:MatHash1 MatHash2:MatHash2 TexDifName:TexDifName)
								fseek f MatHeaderSize #seek_set
							)
							print "--------------------"
							printDebug ("Section 2 end = " + (ftell f as string))
							unknown = readlong f #unsigned
							pad = readbyte f #unsigned
							FaceDataStart = (ftell f) + readlong f #unsigned

							Sect3Size = (ftell f) + readlong f #unsigned
							Sect3Count = readlong f #unsigned
							printDebug ("Section 3 (LOD info) start = " + (ftell f as string) + ", Count = " + Sect3Count as string)

							for y = 1 to Sect3Count do (
								printDebug ("LOD # " + y as string + " information start = " + (ftell f as string))
								Sect3ASize = (ftell f) + readlong f #unsigned
								PolyTotal = readlong f #unsigned
								printDebug ("Count = " + PolyTotal as string)
								for x = 1 to PolyTotal do (
									BoundingMinX = readfloat f; BoundingMinY = readfloat f; BoundingMinZ = readfloat f
									BoundingMaxX = readfloat f; BoundingMaxY = readfloat f; BoundingMaxZ = readfloat f
									HeaderLength = readlong f #unsigned
									unknown1 = readlong f #unsigned
									UnkFloat2 = readfloat f
									UnkFloat3 = readfloat f
									UnkFloat4 = readfloat f
									unknown2 = readlong f #unsigned
									VertexMin = readlong f #unsigned + 1
									VertexMax = readlong f #unsigned + 1
									VertexStart = readlong f #unsigned
									FacePointStart = readlong f #unsigned
									PolygonStart = (FacePointStart / 3) + 1
									PolygonCount = readlong f #unsigned
									FacePointCount = readlong f #unsigned
									HeaderLength2 = readlong f #unsigned
									if HeaderLength2 == 0x10 do (
										unknown2A = readlong f #unsigned
										unknown2B = readlong f #unsigned
									)
									unknown3 = readlong f #unsigned
									MatNum = readlong f #unsigned + 1
									unknown4 = readlong f #unsigned + 1

									if y == 1 do (
										append PolyStruct_array (Polygon_Info_Struct VertexStart:VertexStart VertexMin:VertexMin VertexMax:VertexMax PolygonStart:PolygonStart PolygonCount:PolygonCount FacePointCount:FacePointCount MatNum:MatNum LODNum:y)
									)

									if y > 1 and LODs == true do (
										append PolyStruct_array (Polygon_Info_Struct VertexStart:VertexStart VertexMin:VertexMin VertexMax:VertexMax PolygonStart:PolygonStart PolygonCount:PolygonCount FacePointCount:FacePointCount MatNum:MatNum LODNum:y)
									)

									printDebug ("Bounding Box = " + BoundingMinX as string + ", " + BoundingMinY as string + ", " + BoundingMinZ as string + " | " + BoundingMaxX as string + ", " + BoundingMaxY as string + ", " + BoundingMaxZ as string)
									printDebug ("Floats = " + UnkFloat2 as string + ", " + UnkFloat3 as string + ", " + UnkFloat4 as string)
									printDebug ("VertStart = " + VertexStart as string + ", VertMin = " + VertexMin as string + ", VertMax = " + VertexMax as string + ", PolyStart = " + PolygonStart as string + ", PolyCount = " + PolygonCount as string + ", FacePointCount = " + FacePointCount as string + ", MatNum = " + MatNum as string + ", Unknowns = " + unknown2 as string + ", " + unknown3 as string + ", " + unknown4 as string)
								)
								fseek f Sect3ASize #seek_set

								printDebug ("Section 3B start = " + (ftell f as string))
								Sect3BSize = (ftell f) + readlong f #unsigned
								Poly2Total = readlong f #unsigned
								for x = 1 to Poly2Total do (
									BoundingMinX = readfloat f; BoundingMinY = readfloat f; BoundingMinZ = readfloat f
									BoundingMaxX = readfloat f; BoundingMaxY = readfloat f; BoundingMaxZ = readfloat f
									HeaderLength = readlong f #unsigned
									unknown1 = readlong f #unsigned
									UnkFloat2 = readfloat f
									UnkFloat3 = readfloat f
									UnkFloat4 = readfloat f
									unknown2 = readlong f #unsigned
									VertexMin = readlong f #unsigned + 1
									VertexMax = readlong f #unsigned + 1
									VertexStart = readlong f #unsigned
									FacePointStart = readlong f #unsigned
									PolygonStart = (FacePointStart / 3) + 1
									PolygonCount = readlong f #unsigned
									FacePointCount = readlong f #unsigned
									HeaderLength2 = readlong f #unsigned
									if HeaderLength2 == 0x10 do (
										unknown2A = readlong f #unsigned
										unknown2B = readlong f #unsigned
									)
									unknown3 = readlong f #unsigned
									MatNum = readlong f #unsigned + 1
									unknown4 = readlong f #unsigned + 1

									printDebug ("Bounding Box = " + BoundingMinX as string + ", " + BoundingMinY as string + ", " + BoundingMinZ as string + " | " + BoundingMaxX as string + ", " + BoundingMaxY as string + ", " + BoundingMaxZ as string)
									printDebug ("Floats = " + UnkFloat2 as string + ", " + UnkFloat3 as string + ", " + UnkFloat4 as string)
									printDebug ("VertStart = " + VertexStart as string + ", VertMin = " + VertexMin as string + ", VertMax = " + VertexMax as string + ", PolyStart = " + PolygonStart as string + ", PolyCount = " + PolygonCount as string + ", FacePointCount = " + FacePointCount as string + ", MatNum = " + MatNum as string + ", Unknowns = " + unknown2 as string + ", " + unknown3 as string + ", " + unknown4 as string)
								)

								fseek f Sect3BSize #seek_set

								printDebug ("Section 3C start = " + (ftell f as string))
								unknown1 = readlong f #unsigned
								unknown2 = readlong f #unsigned
								BoundingMinX = readfloat f; BoundingMinY = readfloat f; BoundingMinZ = readfloat f
								BoundingMaxX = readfloat f; BoundingMaxY = readfloat f; BoundingMaxZ = readfloat f
								unknown3 = (readlong f #unsigned) - 4
								UnkFloat1 = readfloat f
								UnkFloat2 = readfloat f
								UnkFloat3 = readfloat f
								UnkFloat4 = readfloat f
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
								
								printDebug ("Bounding Box = " + BoundingMinX as string + ", " + BoundingMinY as string + ", " + BoundingMinZ as string + " | " + BoundingMaxX as string + ", " + BoundingMaxY as string + ", " + BoundingMaxZ as string)
								printDebug ("Floats = " + UnkFloat1 as string + ", " + UnkFloat2 as string + ", " + UnkFloat3 as string + ", " + UnkFloat4 as string)
								printDebug ("Values = " + unknown1 as string + ", 0x" + bit.intAsHex(unknown2) as string + ", " + unknown4 as string + ", " + unknown6 as string + ", " + unknown5 as string + ", " + unknown7 as string + ", " + unknown8 as string + ", " + unknown9 as string + ", " + unknown10 as string)

								IDHeaderLength = (readlong f #unsigned) - 4
								append BoneIDOffset_Array (ftell f)
								BoneIDTotal = readlong f #unsigned
								printDebug ("Section 3D (Bone IDs) start = " + (ftell f as string) + ", Count = " + BoneIDTotal as string)
								for x = 1 to BoneIDTotal do (
									BoneHash2 = readlong f #unsigned
									BoneHash1 = readlong f #unsigned
								)
							)
							fseek f Sect3Size #seek_set

							Sect4Size = (ftell f) + readlong f #unsigned
							Sect4Count = readlong f #unsigned
							printDebug ("Section 4 (Empty?) start = " + (ftell f as string) + ", Count = " + Sect4Count as string)
							fseek f Sect4Size #seek_set

							Sect5Size = (ftell f) + readlong f #unsigned
							MatGroupCount = readlong f #unsigned
							printDebug ("Section 5 (Material Groups) start = " + (ftell f as string) + ", Count = " + MatGroupCount as string)
							for x = 1 to MatGroupCount do (
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
								printDebug ("Floats = " + MatFloatA as string + ", " + MatFloatB as string + ", " + MatFloatC as string + ", " + MatFloatD as string + ", " + MatFloatE as string + ", " + MatFloatF as string + ", " + MatSubFloatA as string + ", " + MatSubFloatB as string + ", " + MatSubFloatC as string + ", " + MatSubFloatD as string)
								for y = 1 to MatHash_array.count do (
									if MatHash1 == MatHash_array [y].MatHash1 and MatHash2 == MatHash_array [y].MatHash2 do (
										TexName = MatHash_array [y].TexDifName
										append TexName_array TexName
										-- exit()
									)
								)
							)
							fseek f Sect5Size #seek_set

							Sect6Size = (ftell f) + readlong f #unsigned
							Sect6Count = readlong f #unsigned
							printDebug ("Section 6 start = " + (ftell f as string) + ", Count = " + Sect6Count as string)
							for x = 1 to Sect6Count do (
								Sect6HeaderLength = readlong f #unsigned
								Sect6Hash2 = readlong f #unsigned
								Sect6Hash1 = readlong f #unsigned
								Sect6Unk = readlong f #unsigned
							)
							fseek f Sect6Size #seek_set

							Sect7Size = (ftell f) + readlong f #unsigned
							BoneIDCount = readlong f #unsigned
							if BoneIDCount > 0 do (BoneIDSets = 1)
							printDebug ("Section 7 (Bone IDs) start = " + (ftell f as string) + ", Count = " + BoneIDCount as string)
							BoneIDOffset = (ftell f)
							for x = 1 to BoneIDCount do (
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

							Sect8Size = (ftell f) + readlong f #unsigned
							Sect8Count = readlong f #unsigned
							printDebug ("Section 8 (Empty?) start = " + (ftell f as string) + ", Count = " + Sect8Count as string)
							fseek f Sect8Size #seek_set

							Sect9Size = (ftell f) + readlong f #unsigned
							Sect9Count = readlong f #unsigned
							printDebug ("Section 9 start = " + (ftell f as string) + ", Count = " + Sect9Count as string)
							fseek f Sect9Size #seek_set

							printDebug ("Section 10 (Model Clamps) start = " + (ftell f as string))
							for x = 1 to 1 do (
								MeshUnk1 = readlong f #unsigned
								MeshFlag1 = readbyte f #unsigned
								MeshFlag2 = readbyte f #unsigned
								MeshFlag3 = readbyte f #unsigned
								MeshFlag4 = readbyte f #unsigned
								MeshXMin = readfloat f; MeshYMin = readfloat f; MeshZMin = readfloat f
								MeshXMax = readfloat f; MeshYMax = readfloat f; MeshZMax = readfloat f
								MeshXMult = MeshXMax - MeshXMin; MeshYMult = MeshYMax - MeshYMin; MeshZMult = MeshZMax - MeshZMin

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
								if MeshFloatX != 0x00 do (MeshOrient = "X")
								if MeshFloatY != 0x00 do (MeshOrient = "Y")
								if MeshFloatZ != 0x00 do (MeshOrient = "Z")
								printDebug ("Flags = 0x" + bit.intAsHex(MeshFlag1) as string + ", 0x" + bit.intAsHex(MeshFlag2) as string + ", 0x" + bit.intAsHex(MeshFlag3) as string + ", 0x" + bit.intAsHex(MeshFlag4) as string + ", Orientation = " + MeshOrient as string)
							)	
							
							printDebug ("Section 11 start = " + (ftell f as string))

							VertCount = readlong f #unsigned
							VertFlags = readlong f #unsigned
							Sect11ASize = (ftell f) + readlong f #unsigned
							Sect11ACount = readlong f #unsigned
							printDebug("Flags: 0x" + bit.intAsHex(VertFlags) as string + ", Count: " + Sect11ACount as string)

							fseek f Sect11ASize #seek_set

							printDebug ("Section 11B (UV Clamps) start = " + (ftell f as string))
							UVLayerCount = readlong f #unsigned
							printDebug("UV Clamp Count: " + UVLayerCount as string)

							UV1XMult = 1; UV1YMult = 1; UV1XStart = 0; UV1YStart = 0
							UV2XMult = 1; UV2YMult = 1; UV2XStart = 0; UV2YStart = 0
							UV3XMult = 1; UV3YMult = 1; UV3XStart = 0; UV3YStart = 0
							UV4XMult = 1; UV4YMult = 1; UV4XStart = 0; UV4YStart = 0
							UV5XMult = 1; UV5YMult = 1; UV5XStart = 0; UV5YStart = 0
							UV6XMult = 1; UV6YMult = 1; UV6XStart = 0; UV6YStart = 0

							for x = 1 to UVLayerCount do (
								UVLayer = readlong f #unsigned + 1
								UVXMult = readfloat f; UVYMult = readfloat f
								UVXStart = readfloat f; UVYStart = readfloat f
								case UVLayer of (
									default: (throw("Unknown UV layer!"))
									1:(
										UV1XMult = UVXMult; UV1YMult = UVYMult
										UV1XStart = UVXStart; UV1YStart = UVYStart
									)
									2:(
										UV2XMult = UVXMult; UV2YMult = UVYMult
										UV2XStart = UVXStart; UV2YStart = UVYStart
									)
									3:(
										UV3XMult = UVXMult; UV3YMult = UVYMult
										UV3XStart = UVXStart; UV3YStart = UVYStart
									)
									4:(
										UV4XMult = UVXMult; UV4YMult = UVYMult
										UV4XStart = UVXStart; UV4YStart = UVYStart
									)
									5:(
										UV5XMult = UVXMult; UV5YMult = UVYMult
										UV5XStart = UVXStart; UV5YStart = UVYStart
									)
									6:(
										UV6XMult = UVXMult; UV6YMult = UVYMult
										UV6XStart = UVXStart; UV6YStart = UVYStart
									)
								)
								printDebug ("X Multiply = " + UVXMult as string + ", Y Multiply = " + UVYMult as string + ", X Start = " + UVXStart as string + ", Y Start = " + UVYStart as string + ", Layer = " + UVLayer as string)
							)

							if VertCount != 0 do (
								printDebug ("Section 11C start = " + (ftell f as string))

								HasVertex = 0; VertexFmt = 0
								HasNormals = 0; NormalsFmt = 0
								HasTangents = 0; TangentsFmt = 0
								HasBinormals = 0; BinormalsFmt = 0
								HasWeights = 0; WeightsFmt = 0
								HasBones = 0; BonesFmt = 0
								HasColors = 0; ColorsFmt = 0
								HasColors2 = 0; Colors2Fmt = 0
								HasUV1 = 0; UV1Fmt = 0
								HasUV2 = 0; UV2Fmt = 0
								HasUV3 = 0; UV3Fmt = 0
								HasUV4 = 0; UV4Fmt = 0
								HasUV5 = 0; UV5Fmt = 0
								HasUV6 = 0; UV6Fmt = 0

								case VertFlags of (
									default:(throw("Unknown vertex flags!"))
									0x00:()
									0x01:()
									0x03:()
									0x05:()
									0x09:()
									0x21:()
									0x31:(
										VertBuffUnk1 = readlong f #unsigned
										VertBuffUnk2 = readlong f #unsigned
										VertBuffUnk3 = readlong f #unsigned
										VertBuffUnk4 = readlong f #unsigned
										VertBuffUnk5 = readlong f #unsigned
										VertBuffUnk6 = readlong f #unsigned
										VertBuffUnk7 = readlong f #unsigned
										VertBuffUnk8 = readlong f #unsigned
										VertBuffUnk9 = readlong f #unsigned
										VertParamStart = (ftell f) + readlong f #unsigned
										VertBuffSize = readlong f #unsigned
										VertStart = (ftell f)
										fseek f VertParamStart #seek_set
									)
								)
								
								printDebug ("Section 12 (Vertex/Face Buffer Info) start = " + (ftell f as string))

								BuffUnk1 = readlong f #unsigned
								BuffUnk2 = readlong f #unsigned
								FaceBufferCount = readlong f #unsigned
								BufferCount1 = readlong f #unsigned
								BufferCount2 = readlong f #unsigned

								for y = 1 to BufferCount1 do (
									VertType = readlong f #unsigned + 1
									VertFormat = readlong f #unsigned + 1
									VertLayer = readlong f #unsigned + 1
									VertBuffNum = readlong f #unsigned + 1
									VertOffset = readlong f #unsigned + 1
									printDebug ("Vertex Type = " + VertType as string + ", Format = " + VertFormat as string + ", Layer = " + VertLayer as string + ", Buffer = " + VertBuffNum as string + ", Offset = " + VertOffset as string)
									case of (
										default: (throw "Unknown vertex buffer combination!")
										(VertType == 1 and VertLayer == 1):(HasVertex = VertBuffNum; VertexFmt = VertFormat)
										(VertType == 4 and VertLayer == 1):(HasWeights = VertBuffNum; WeightsFmt = VertFormat)
										(VertType == 5 and VertLayer == 1):(HasBones = VertBuffNum; BonesFmt = VertFormat)
										(VertType == 2 and VertLayer == 1):(HasNormals = VertBuffNum; NormalsFmt = VertFormat)
										(VertType == 3 and VertLayer == 1):(HasTangents = VertBuffNum; TangentsFmt = VertFormat)
										(VertType == 2 and VertLayer == 2):(HasBinormals = VertBuffNum; BinormalsFmt = VertFormat)
										(VertType == 7 and VertLayer == 5):(HasUV5 = VertBuffNum; UV5Fmt = VertFormat)
										(VertType == 7 and VertLayer == 6):(HasUV6 = VertBuffNum; UV6Fmt = VertFormat)
										(VertType == 6 and VertLayer == 1):(HasColors = VertBuffNum; ColorsFmt = VertFormat)
										(VertType == 6 and VertLayer == 2):(HasColors2 = VertBuffNum; Colors2Fmt = VertFormat)
										(VertType == 7 and VertLayer == 1):(HasUV1 = VertBuffNum; UV1Fmt = VertFormat)
										(VertType == 7 and VertLayer == 2):(HasUV2 = VertBuffNum; UV2Fmt = VertFormat)
										(VertType == 7 and VertLayer == 3):(HasUV3 = VertBuffNum; UV3Fmt = VertFormat)
										(VertType == 7 and VertLayer == 4):(HasUV4 = VertBuffNum; UV4Fmt = VertFormat)
									)
								)

								for y = 1 to FaceBufferCount do (
									FaceBuffUnk1 = readlong f #unsigned
									FaceBuffUnk2 = readlong f #unsigned
									FaceBuffUnk3 = readlong f #unsigned
									FaceBuffCount = readlong f #unsigned
									FaceBuffLength = readlong f #unsigned
									case y of (
										1:(FacePointCount = FaceBuffCount; FaceLength = FaceBuffLength)
										2:(FacePointCountB = FaceBuffCount; FaceLengthB = FaceBuffLength)
									)
								)

								for y = 1 to BufferCount2 do (
									Buff2Unk1 = readlong f #unsigned
									Buff2Format = readlong f #unsigned
									Buff2Unk2 = readlong f #unsigned
									Buff2Count = readlong f #unsigned
									Buff2Length = readlong f #unsigned
								)

								fseek f FaceDataStart #seek_set
								printDebug ("Facepoint buffer A start = " + (ftell f as string))

								for x = 1 to FacePointCount / 3 do (
									fa = readshort f #unsigned + 1
									fb = readshort f #unsigned + 1
									fc = readshort f #unsigned + 1
									append Face_array [fa, fb, fc]
								)

								if FaceBufferCount == 2 do (
									printDebug ("Facepoint buffer B start = " + (ftell f as string))

									for x = 1 to FacePointCountB / 3 do (
										fa = readshort f #unsigned + 1
										fb = readshort f #unsigned + 1
										fc = readshort f #unsigned + 1
										append FaceB_array [fa,fb,fc]
									)
									printDebug ("Facepoint buffer B end = " + (ftell f as string))
								)

								case VertFlags of (
									default:(throw("Unknown MeshFlags combination!"))
									0x00:()
									0x01:()
									0x03:()
									0x05:()
									0x09:()
									0x21:()
									0x31:(
										VertStartB = (ftell f)
										fseek f VertStart #seek_set
										printDebug ("Vertex buffer A start = " + (ftell f as string))

										for x = 1 to VertCount do (
											vx = readfloat f * ModelScale
											vy = readfloat f * ModelScale
											vz = readfloat f * ModelScale
											Bone1 = readbyte f #unsigned
											Bone2 = readbyte f #unsigned
											Bone3 = readbyte f #unsigned
											Bone4 = readbyte f #unsigned
											fseek f 0x08 #seek_cur
											append AllVert_array [vx, vy, vz]
											append B1_array (Bone_Info_Struct Bone1:Bone1 Bone2:Bone2 Bone3:Bone3 Bone4:Bone4)
										)				

										fseek f VertStartB #seek_set
									)
								)

								if HasVertex > 0 do (
									printDebug ("Positions start = " + (ftell f as string))
									case of (
										default: (throw("Unknown position format!"))
										(VertexFmt == 4):(
											for x = 1 to VertCount do (
												vx = readfloat f * ModelScale
												vy = readfloat f * ModelScale
												vz = readfloat f * ModelScale
												append AllVert_array [vx,vy,vz]
											)
										)
										(VertexFmt == 27):(
											for x = 1 to VertCount do (
												vx = (((readshort f #unsigned as float / 65535) * MeshXMult) + MeshXMin) * ModelScale
												vy = (((readshort f #unsigned as float / 65535) * MeshYMult) + MeshYMin) * ModelScale
												vz = (((readshort f #unsigned as float / 65535) * MeshZMult) + MeshZMin) * ModelScale
												vq = (readshort f #unsigned as float / 65535)
												append AllVert_array [vx,vy,vz]
											)
										)
										(VertexFmt == 42):(
											-- Just... why?
											print("Model has awkward vertex setup, may be incorrect?")
											for x = 1 to VertCount do (
												PosVars = readlong f
												vx = ((bit.and (PosVars) 0x3FF) as float / 1023)
												vy = ((bit.and (bit.shift PosVars -10) 0x3FF) as float / 1023)
												vz = ((bit.and (bit.shift PosVars -20) 0x3FF) as float / 1023)
												case MeshOrient of (
													"Q":()
													"X":(vx = vx / 4 + ((bit.shift PosVars -30) as float / 4))
													"Y":(vy = vy / 4 + ((bit.shift PosVars -30) as float / 4))
													"Z":(vz = vz / 4 + ((bit.shift PosVars -30) as float / 4))
												)
												vx = ((vx * MeshXMult) + MeshXMin) * ModelScale
												vy = ((vy * MeshYMult) + MeshYMin) * ModelScale
												vz = ((vz * MeshZMult) + MeshZMin) * ModelScale
												append AllVert_array [vx,vy,vz]
											)
										)
									)
								)
								if HasWeights > 0 do (
									printDebug ("Weights start = " + (ftell f as string))
									case of (
										default: (throw("Unknown weights format!"))
										(WeightsFmt == 27):(
											for x = 1 to VertCount do (
												Weight1 = (readshort f #unsigned as float / 65535)
												Weight2 = (readshort f #unsigned as float / 65535)
												Weight3 = (readshort f #unsigned as float / 65535)
												Weight4 = (readshort f #unsigned as float / 65535)
												append W1_array (Weight_Info_Struct Weight1:Weight1 Weight2:Weight2 Weight3:Weight3 Weight4:Weight4)
												)
										)
										(WeightsFmt == 42):(
											-- "Why fix what isn't broken?" didn't apply to Telltale, it seems.
											-- This was way too frustrating to figure out, so I'll grumble here to explain how this crap works.
											-- First, you have to read all four weight bytes as a "long" value, and then break that apart into 2/10/10/10-bit binary segments.
											-- Those are used for weights 2, 4, 3 and 2 respectively. Why is 2 listed twice? The upper 2 bits add an extra 0.125 each to the second weight's value (0.375 max).
											-- And then the three sets of 10 bits each are the weights in descending order (#4 -> #3 -> #2), and need to be divided by 1023 (0x3FF) and then again for the following:
											-- 2nd = divide by 8 (0.125 max) + 0.125/0.25/0.375 from the upper bits, 3rd = divide by 3 (0.333 max), 4th = divide by 4 (0.25 max).
											-- And finally weight #1 is the remainder, 1.0 minus #2, #3 and #4 combined.
											-- In retrospect, I can see how this works... but what, exactly, was the problem with using float values for this sorta thing again???
											-- Either way, thanks to that recycled hare model for being there, making me not want to rip out my hair.
											for x = 1 to VertCount do (
												WeightVars = readlong f
												Weight2 = (((bit.and (WeightVars) 0x3FF) as float / 1023) / 8) + ((bit.shift WeightVars -30) as float / 8)
												Weight3 = ((bit.and (bit.shift WeightVars -10) 0x3FF) as float / 1023) / 3
												Weight4 = ((bit.and (bit.shift WeightVars -20) 0x3FF) as float / 1023) / 4
												Weight1 = (1 as float - Weight2 - Weight3 - Weight4)
												append W1_array (Weight_Info_Struct Weight1:Weight1 Weight2:Weight2 Weight3:Weight3 Weight4:Weight4)
											)
										)
									)
								)
								if HasBones > 0 do (
									printDebug ("Bone IDs start = " + (ftell f as string))
									case of (
										default: (throw("Unknown bones format!"))
										(BonesFmt == 33):(
											for x = 1 to VertCount do (
												Bone1 = readbyte f #unsigned
												Bone2 = readbyte f #unsigned
												Bone3 = readbyte f #unsigned
												Bone4 = readbyte f #unsigned
												append B1_array (Bone_Info_Struct Bone1:Bone1 Bone2:Bone2 Bone3:Bone3 Bone4:Bone4)
											)
										)
									)
								)
								if HasNormals > 0 do (
									printDebug ("Normals start = " + (ftell f as string))
									case of (
										default: (throw("Unknown normals format!"))
										(NormalsFmt == 38):(
											for x = 1 to VertCount do (
												nx = readbyte f as float / 127
												ny = readbyte f as float / 127
												nz = readbyte f as float / 127
												nq = readbyte f as float / 127
												append AllNormal_array [nx, ny, nz]
											)
										)
										(NormalsFmt == 26):(
											for x = 1 to VertCount do (
												nx = readshort f as float / 32767
												ny = readshort f as float / 32767
												nz = readshort f as float / 32767
												nq = readshort f as float / 32767
												append AllNormal_array [nx, ny, nz]
											)
										)
									)
								)
								if HasTangents > 0 do (
									printDebug ("Tangents(?) start = " + (ftell f as string))
									case of (
										default: (throw("Unknown tangents format!"))
										(TangentsFmt == 38):(
											for x = 1 to VertCount do (
												nx3 = readbyte f as float / 127
												ny3 = readbyte f as float / 127
												nz3 = readbyte f as float / 127
												nq3 = readbyte f as float / 127
											)
										)
										--(TangentsFmt == 26):(
				 						--	for x = 1 to VertCount do (
				 						--		nx3 = readshort f as float / 32767
				 						--		ny3 = readshort f as float / 32767
				 						--		nz3 = readshort f as float / 32767
				 						--		nq3 = readshort f as float / 32767
				 						--	)
				 						--)
									)
								)
								if HasBinormals > 0 do (
									printDebug ("Binormals(?) start = " + (ftell f as string))
									case of (
										default: (throw("Unknown binormals format!"))
										(BinormalsFmt == 38):(
											for x = 1 to VertCount do (
												nx2 = readbyte f as float / 127
												ny2 = readbyte f as float / 127
												nz2 = readbyte f as float / 127
												nq2 = readbyte f as float / 127
											)
										)
				 						--(BinormalsFmt == 26):(
				 						--	for x = 1 to VertCount do (
				 						--		nx2 = readshort f as float / 32767
				 						--		ny2 = readshort f as float / 32767
				 						--		nz2 = readshort f as float / 32767
				 						--		nq2 = readshort f as float / 32767
				 						--	)
				 						--)
									)
								)
								if HasUV5 > 0 do (
									printDebug ("UVs 5 start = " + (ftell f as string))
									case of (
										default: (throw("Unknown UV5 format!"))
										(UV5Fmt == 3):(
											for x = 1 to VertCount do (
												tu5 = readfloat f
												tv5 = ((readfloat f) * -1) + 1
												append AllUV5_array [tu5, tv5, 0]
											)
										)
										(UV5Fmt == 24):(
											for x = 1 to VertCount do (
												tu5 = ((readshort f as float / 32767) * UV5XMult) + UV5XStart
												tv5 = ((((readshort f as float / 32767) * UV5YMult) + UV5YStart) * -1) + 1
												append AllUV5_array [tu5, tv5, 0]
											)
										)
										(UV5Fmt == 25):(
											for x = 1 to VertCount do (
												tu5 = ((readshort f #unsigned as float / 65535) * UV5XMult) + UV5XStart
												tv5 = ((((readshort f #unsigned as float / 65535) * UV5YMult) + UV5YStart) * -1) + 1
												append AllUV5_array [tu5, tv5, 0]
											)
										)
									)
								)
								if HasUV6 > 0 do (
									printDebug ("UVs 6 start = " + (ftell f as string))
									case of (
										default: (throw("Unknown UV6 format!"))
										(UV6Fmt == 3):(
											for x = 1 to VertCount do (
												tu6 = readfloat f
												tv6 = ((readfloat f) * -1) + 1
												append AllUV6_array [tu6, tv6, 0]
											)
										)
										(UV6Fmt == 24):(
											for x = 1 to VertCount do (
												tu6 = ((readshort f as float / 32767) * UV6XMult) + UV6XStart
												tv6 = ((((readshort f as float / 32767) * UV6YMult) + UV6YStart) * -1) + 1
												append AllUV6_array [tu6, tv6, 0]
											)
										)
										(UV6Fmt == 25):(
											for x = 1 to VertCount do (
												tu6 = ((readshort f #unsigned as float / 65535) * UV6XMult) + UV6XStart
												tv6 = ((((readshort f #unsigned as float / 65535) * UV6YMult) + UV5YStart) * -1) + 1
												append AllUV6_array [tu6, tv6, 0]
											)
										)
									)
								)
								if HasColors > 0 do (
									printDebug ("Colors start = " + (ftell f as string))
									case of (
										default: (throw("Unknown colors format!"))
										(ColorsFmt == 33):(
											for x = 1 to VertCount do (
												ColorR = readbyte f #unsigned
												ColorG = readbyte f #unsigned
												ColorB = readbyte f #unsigned
												ColorA = (readbyte f #unsigned as float) / 255
												if VertColors == true do (
													append AllColor_array [ColorR, ColorG, ColorB]
													append AllAlpha_array ColorA
												)
											)
										)
										(ColorsFmt == 39):(
											for x = 1 to VertCount do (
												ColorR = readbyte f #unsigned
												ColorG = readbyte f #unsigned
												ColorB = readbyte f #unsigned
												ColorA = (readbyte f #unsigned as float) / 255
												if VertColors == true do (
													append AllColor_array [ColorR, ColorG, ColorB]
													append AllAlpha_array ColorA
												)
											)
										)
									)
								)
								if HasColors2 > 0 do (
									printDebug ("Colors B start = " + (ftell f as string))
									case of (
										default: (throw("Unknown colors2 format!"))
										(Colors2Fmt == 33):(
											for x = 1 to VertCount do (
												ColorR2 = readbyte f #unsigned
												ColorG2 = readbyte f #unsigned
												ColorB2 = readbyte f #unsigned
												ColorA2 = (readbyte f #unsigned as float) / 255
											)
										)
										(Colors2Fmt == 39):(
											for x = 1 to VertCount do (
												ColorR2 = readbyte f #unsigned
												ColorG2 = readbyte f #unsigned
												ColorB2 = readbyte f #unsigned
												ColorA2 = (readbyte f #unsigned as float) / 255
											)
										)
									)
								)
								if HasUV1 > 0 do (
									printDebug ("UVs start = " + (ftell f as string))
									case of (
										default: (throw("Unknown UV1 format!"))
										(UV1Fmt == 3):(
											for x = 1 to VertCount do (
												tu = readfloat f
												tv = ((readfloat f) * -1) + 1
												append AllUV_array [tu, tv, 0]
											)
										)
										(UV1Fmt == 24):(
											for x = 1 to VertCount do (
												tu = ((readshort f as float / 32767) * UV1XMult) + UV1XStart
												tv = ((((readshort f as float / 32767) * UV1YMult) + UV1YStart) * -1) + 1
												append AllUV_array [tu, tv, 0]
											)
										)
										(UV1Fmt == 25):(
											for x = 1 to VertCount do (
												tu = ((readshort f #unsigned as float / 65535) * UV1XMult) + UV1XStart
												tv = ((((readshort f #unsigned as float / 65535) * UV1YMult) + UV1YStart) * -1) + 1
												append AllUV_array [tu, tv, 0]
											)
										)
									)
								)
								if HasUV2 > 0 do (
									printDebug ("UVs 2 start = " + (ftell f as string))
									case of (
										default: (throw("Unknown UV2 format!"))
										(UV2Fmt == 3):(
											for x = 1 to VertCount do (
												tu2 = readfloat f
												tv2 = ((readfloat f) * -1) + 1
												append AllUV2_array [tu2, tv2, 0]
											)
										)
										(UV2Fmt == 24):(
											for x = 1 to VertCount do (
												tu2 = ((readshort f as float / 32767) * UV2XMult) + UV2XStart
												tv2 = ((((readshort f as float / 32767) * UV2YMult) + UV2YStart) * -1) + 1
												append AllUV2_array [tu2, tv2, 0]
											)
										)
										(UV2Fmt == 25):(
											for x = 1 to VertCount do (
												tu2 = ((readshort f #unsigned as float / 65535) * UV2XMult) + UV2XStart
												tv2 = ((((readshort f #unsigned as float / 65535) * UV2YMult) + UV2YStart) * -1) + 1
												append AllUV2_array [tu2, tv2, 0]
											)
										)
									)
								)
								if HasUV3 > 0 do (
									printDebug ("UVs 3 start = " + (ftell f as string))
									case of (
										default: (throw("Unknown UV3 format!"))
										(UV3Fmt == 3):(
											for x = 1 to VertCount do (
												tu3 = readfloat f
												tv3 = ((readfloat f) * -1) + 1
												append AllUV3_array [tu3, tv3, 0]
											)
										)
										(UV3Fmt == 24):(
											for x = 1 to VertCount do (
												tu3 = ((readshort f as float / 32767) * UV3XMult) + UV3XStart
												tv3 = ((((readshort f as float / 32767) * UV3YMult) + UV3YStart) * -1) + 1
												append AllUV3_array [tu3, tv3, 0]
											)
										)
										(UV3Fmt == 25):(
											for x = 1 to VertCount do (
												tu3 = ((readshort f #unsigned as float / 65535) * UV3XMult) + UV3XStart
												tv3 = ((((readshort f #unsigned as float / 65535) * UV3YMult) + UV3YStart) * -1) + 1
												append AllUV3_array [tu3, tv3, 0]
											)
										)
									)
								)
								if HasUV4 > 0 do (
									printDebug ("UVs 4 start = " + (ftell f as string))
									case of (
										default: (throw("Unknown UV4 format!"))
										(UV4Fmt == 3):(
											for x = 1 to VertCount do (
												tu4 = readfloat f
												tv4 = ((readfloat f) * -1) + 1
												append AllUV4_array [tu4, tv4, 0]
											)
										)
										(UV4Fmt == 24):(
											for x = 1 to VertCount do (
												tu4 = ((readshort f as float / 32767) * UV4XMult) + UV4XStart
												tv4 = ((((readshort f as float / 32767) * UV4YMult) + UV4YStart) * -1) + 1
												append AllUV4_array [tu4, tv4, 0]
											)
										)
										(UV4Fmt == 25):(
											for x = 1 to VertCount do (
												tu4 = ((readshort f #unsigned as float / 65535) * UV4XMult) + UV4XStart
												tv4 = ((((readshort f #unsigned as float / 65535) * UV4YMult) + UV4YStart) * -1) + 1
												append AllUV4_array [tu4, tv4, 0]
											)
										)
									)
								)

								printDebug ("End of file = " + (ftell f as string))
								printDebug (PolyStruct_array)

								if B1_array.count == 0 do (
									for x = 1 to AllVert_array.count do (
										append B1_array (Bone_Info_Struct Bone1:0 Bone2:0 Bone3:0 Bone4:0)
									)
								)

								if W1_array.count == 0 do (
									for x = 1 to AllVert_array.count do (
										append W1_array (Weight_Info_Struct Weight1:1 Weight2:0 Weight3:0 Weight4:0)
									)
								)

								if AllUV_array.count == 0 do (
									for x = 1 to AllVert_array.count do (
										append AllUV_array [0, 0, 0]
									)
								)

								ProperBoneID_array = #()
								FixedBoneID_array = #()
								ActualB1_array = #()

								if BoneCount != 0 and BoneIDSets > 0 do (
									fseek f BoneIDOffset #seek_set
									ProperBoneID_array = #()
									for y = 1 to BoneIDTotal do (
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
										BoneName = ("0x" + bit.intAsHex(BoneHash1) as string)
										for z = 1 to BoneHash_array.count do (
											if BoneHash1 == BoneHash_array [z].BoneHash1 and BoneHash2 == BoneHash_array [z].BoneHash2 do (
												BoneName = BoneHash_array [z].BoneString
												-- exit()
											)
										)
										append ProperBoneID_array BoneName
									)
									for a = 1 to BoneIDTotal do (
										for b = 1 to BoneCount do (
											if ProperBoneID_array [a] == BoneName_array [b] do (
												append FixedBoneID_array b
											)
										)
									)	
									for x = 1 to B1_array.count do (
										ProperBone1 = FixedBoneID_array [B1_array [x].Bone1 + 1]
										ProperBone2 = FixedBoneID_array [B1_array [x].Bone2 + 1]
										ProperBone3 = FixedBoneID_array [B1_array [x].Bone3 + 1]
										ProperBone4 = FixedBoneID_array [B1_array [x].Bone4 + 1]
										if ProperBone1 == undefined do (ProperBone1 = 1)
										if ProperBone2 == undefined do (ProperBone2 = 1)
										if ProperBone3 == undefined do (ProperBone3 = 1)
										if ProperBone4 == undefined do (ProperBone4 = 1)
										append ActualB1_array (Bone_Info_Struct Bone1:ProperBone1 Bone2:ProperBone2 Bone3:ProperBone3 Bone4:ProperBone4)
									)
									for b = 1 to W1_array.count do (
										w = (Weight_data BoneIDs:#() weights:#())
										maxweight = 0

										if(W1_array [b].Weight1 != 0) then (maxweight = maxweight + W1_array [b].Weight1)
										if(W1_array [b].Weight2 != 0) then (maxweight = maxweight + W1_array [b].Weight2)
										if(W1_array [b].Weight3 != 0) then (maxweight = maxweight + W1_array [b].Weight3)
										if(W1_array [b].Weight4 != 0) then (maxweight = maxweight + W1_array [b].Weight4)
										if(maxweight != 0) then (
											if(W1_array [b].Weight1 != 0) then (
												w1 = W1_array [b].Weight1 as float
												append w.BoneIDs (ActualB1_array [b].Bone1)
												append w.weights (w1)
											)
											if(W1_array [b].Weight2 != 0) then (
												w2 = W1_array [b].Weight2 as float
												append w.BoneIDs (ActualB1_array [b].Bone2)
												append w.weights (w2)
											)
											if(W1_array [b].Weight3 != 0) then (
												w3 = W1_array [b].Weight3 as float
												append w.BoneIDs (ActualB1_array [b].Bone3)
												append w.weights (w3)
											)
											if(W1_array [b].Weight4 != 0) then (
												w4 = W1_array [b].Weight4 as float
												append w.BoneIDs (ActualB1_array [b].Bone4)
												append w.weights (w4)
											)
										)
										append AllWeight_array w
									)
								)
								MultiMat.name = (BaseName as string)
								MultiMat.numsubs = MatGroupCount
								for m = 1 to MatGroupCount do (
									MultiMat.materialList[m] = StandardMaterial()
									mat = MultiMat.materialList[m]
									mat.name = TexName_array [m] as string
									mat.showinviewport = true
	 								-- mat.diffuse = (MatColor_array[m] * 255)
									case of (
										(TexFormat == 1 and TexPath == 1):(tm = Bitmaptexture filename:(BasePath + mat.name + ".dds"))
										(TexFormat == 1 and TexPath == 2):(tm = Bitmaptexture filename:(BasePath + "Textures/" + mat.name + ".dds"))
										(TexFormat == 2 and TexPath == 1):(tm = Bitmaptexture filename:(BasePath + mat.name + ".png"))
										(TexFormat == 2 and TexPath == 2):(tm = Bitmaptexture filename:(BasePath + "Textures/" + mat.name + ".png"))
									)
									tm.alphasource = 0
									mat.twosided = false
									mat.diffuseMap = tm
									mat.opacityMap = tm
									mat.opacityMap.monoOutput = 1
								)
								if LODs == false do (Sect3Count = 1)
								for l = 1 to Sect3Count do (
									AllFace_array = #()
									AllMatID_array = #()
									for i = 1 to PolyStruct_array.count do (
										if PolyStruct_array [i].LODNum == l do (
											for y = 1 to PolyStruct_array [i].PolygonCount do (
												Faces3 = (Face_array [(PolyStruct_array [i].PolygonStart) + y - 1]) + PolyStruct_array [i].VertexStart
												append AllFace_array Faces3
												append AllMatID_array PolyStruct_array [i].MatNum
											)
										)
									)
									LODNum = l
									if AllVert_array.count > 0 do (BuildModel())
								)
							)
							fclose f
						)
					)
				)
			)
			Print ("Done! ("+((((timestamp())-st)*0.001)as string)+" Seconds)")
		)

		enableSceneRedraw()
		gc()
	)
)
CreateDialog TelltaleImporter