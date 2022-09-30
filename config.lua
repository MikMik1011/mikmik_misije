Config = {}
Config.Debug = {}

Config.Debug.Print = true
Config.Debug.RandomBoolAlwaysTrue = false
Config.Debug.Commands = false 

-- POCETAK MISIJE COORDS 707.21740722656,-966.90234375,30.412853240967
Config.LesterNPCModel = "ig_lestercrest" 
Config.LesterNPCCoords = {
	Factory = vector4(705.79870605469,-963.70623779297,30.395345687866, 168.0), 
	Garage = vector4(1208.7364501953,-3115.0866699219,5.540301322937, 35.00)
}

Config.DrawDistance = 30.0

Config.RewardItem = "pancir"
Config.RewardMinMax = vector2(10, 30)

Config.CooldownDuration = 10 * 1000
Config.MaxHackAttempts = 4


Config.MarkerLokacije = {

	Kraj = {
		{
			--name = "dock", 
			Pos   = { x = 1204.0261230469, y = -3116.9357910156, z = 4.5438208580017 }, -- 1204.0261230469,-3116.9357910156, 5.5403003692627
			Size  = { x = 5.0, y = 5.0, z = 5.0 },
			Color = { r = 255, g = 0, b = 0 },
			Type  = 23
		},
	},

	Kljuc = {
		{
			--name = "skroz iza",
			Pos   = { x = 3538.6076660156, y = 3667.68359375, z = 27.121864318848 }, -- 3538.6076660156, 3667.68359375,28.121864318848  
			Size  = { x = 2.0, y = 2.0, z = 2.0 },
			Color = { r = 0, g = 0, b = 255 },
			Type  = 23
		},

		{
			--name = "ne bas skroz iza",
			Pos   = { x = 3559.5603027344, y = 3671.5051269531, z = 27.12188911438 }, -- 3559.5603027344, 3671.5051269531, 28.12188911438
			Size  = { x = 2.0, y = 2.0, z = 2.0 },
			Color = { r = 0, g = 0, b = 255 },
			Type  = 23
		},
	},
}

Config.CarSpawns = {

	{		-- donja garaza desno
		coords = vector3(3612.9125976563, 3740.7314453125, 28.69602394104),
		rotation = 143.00
	},

	{		-- donja garaza levo
		coords = vector3(3619.6665039063, 3735.6374511719, 28.589618682861),
		rotation = 141.00
	},

	{		-- gornja garaza levo
		coords = vector3(3598.3637695313, 3670.0219726563, 33.774074554443),
		rotation = 261.50
	},

	{		-- gornja garaza desno
		coords = vector3(3598.25, 3661.6628417969, 33.771778106689),
		rotation = 258.50,
	},

}

Config.SpawnChance = 100 -- in %
Config.DropChance = 10 -- in %


Config.PedSpawns = {

	{	-- sniper na zgradi kod ulaza
		coords = vector3(3459.5212402344, 3760.9504394531, 43.369163513184), --OBAVEZNO 
		rot = 74.00, -- OBAVEZNO
		weapon = "WEAPON_HEAVYSNIPER", -- NEOBAVEZNO KAO I SVE ISPOD OVOGA ZA OVOG PEDA
		spawnChance = 100,
		movement = 0,
		range = 2,
		health = 150,
		armor = 100,
		dropChance = 0 -- in %
	},

	{
		coords = vector3(3456.1303710938, 3745.7604980469, 36.642715454102), -- ustekan kod ovog snajpera i gleda prema napolje
		rot = 85.00,
	},

	{
		coords = vector3(3572.8666992188, 3704.6926269531, 50.771228790283), -- gore u dvoristu
		rot = 50.00,
	},

	{
		coords = vector3(3430.4182128906, 3763.7565917969, 30.832052230835), -- na kapiji
		rot = 120.00,
	},

	{
		coords = vector3(3458.6472167969,3769.9479980469,30.409948348999), -- ljudska mini barikada ka levoj strani
		rot = 115.00,
		spawnChance = 100,
		movement = 2,
		health = 150,
		armor = 100,
	},

	{
		coords = vector3(3458.67578125, 3775.2087402344, 30.434051513672), -- ljudska mini barikada ka levoj strani
		rot = 105.00,
		spawnChance = 100,
		movement = 2,
		health = 150,
		armor = 100,
	},

	{
		coords = vector3(3456.5700683594, 3779.9138183594, 30.435796737671), -- ljudska mini barikada ka levoj strani
		rot = 115.00,
		spawnChance = 100,
		movement = 2,
		health = 150,
		armor = 100,
	},

	{
		coords = vector3(3471.4165039063, 3800.4833984375, 30.423677444458), -- prva sahta na putu levo levo
		rot = 150.00,
		spawnChance = 100,
	},

	{
		coords = vector3(3525.6320800781, 3811.9692382813, 30.515129089355), -- друга sahta na putu levo levo
		rot = 115.00,
		spawnChance = 100,
	},

	{
		coords = vector3(3532.1875, 3807.3891601563, 30.479692459106), -- treca sahta na putu levo levo
		rot = 115.00,
		spawnChance = 100,
	},

	{
		coords = vector3(3619.162109375, 3792.9519042969, 29.290557861328), -- peta sahta na putu levo levo
		rot = 45.00,
		spawnChance = 100,
	},

	{
		coords = vector3(3569.7412109375, 3810.0163574219, 30.295812606812), -- cetvrta sahta na putu levo levo
		rot = 90.00,
		spawnChance = 100,
	},

	{
		coords = vector3(3509.595703125, 3793.95703125, 30.18553352356), -- prva sahta na parkingu levo levo
		rot = 100.00,
		spawnChance = 100,
	},

	{
		coords = vector3(3547.3459472656, 3792.6975097656, 30.138959884644), -- izmedju ove 2 sahte na parkingu levo levo
		rot = 90.00,
		spawnChance = 100,
	},

	{
		coords = vector3(3572.0573730469, 3786.1115722656, 29.977027893066), -- druga sahta na parkingu levo levo
		rot = 90.00,
		spawnChance = 100,
	},

	{
		coords = vector3(3465.4831542969, 3765.1206054688, 30.278600692749), -- zbun kod duplih stepenica
		rot = 350.00,
	},

	{
		coords = vector3(3483.2360839844, 3763.4833984375, 29.968015670776), -- duple stepenice levo
		rot = 55.00,
	},


	{
		coords = vector3(3480.4951171875, 3765.3723144531, 29.988134384155), -- duple stepenice levo
		rot = 235.00,
	},

	{
		coords = vector3(3478.5891113281, 3755.3562011719, 32.679698944092), -- duple stepenice levo
		rot = 350.00,
	},

	{
		coords = vector3(3481.2568359375, 3754.8776855469, 32.679698944092), -- duple stepenice levo
		rot = 350.00,
	},

	{
		coords = vector3(3498.7817382813, 3786.3088378906, 30.072036743164), -- drvo belo na prakingu prvo
		rot = 100.00,
	},

	{
		coords = vector3(3500.6130371094, 3782.1096191406, 29.922298431396), -- drvo belo na prakingu drugo
		rot = 105.00,
	},

	{
		coords = vector3(3507.8525390625, 3761.4526367188, 30.046615600586), -- prve obicne stepenice levo
		rot = 350.00,
	},

	{
		coords = vector3(3504.009765625,3750.1108398438, 33.070213317871), -- prve obicne stepenice levo
		rot = 350.00,
	},

	{
		coords = vector3(3522.5075683594, 3756.7102050781 ,29.982767105103), -- druge obicne stepenice levo
		rot = 50.00,
	},

	{
		coords = vector3(3520.3017578125, 3745.8740234375, 33.9501953125), -- druge obicne stepenice levo
		rot = 350.00,
	},

	{
		coords = vector3(3529.7915039063, 3779.3139648438, 30.072267532349), -- drvo belo na prakingu trece
		rot = 85.00,
	},

	{
		coords = vector3(3531.2846679688, 3788.8962402344, 29.932968139648), -- drvo belo na prakingu cetvrto
		rot = 100.00,
	},

	{
		coords = vector3(3535.5012207031,3745.0595703125,33.722518920898), -- trece obicne stepenice levo
		rot = 350.00,
	},

	{
		coords = vector3(3537.501953125, 3754.3029785156, 29.922527313232), -- trece obicne stepenice levo
		rot = 0.00,
	},

	{
		coords = vector3(3557.6403808594, 3773.8557128906, 30.072246551514), -- drvo belo na prakingu peto
		rot = 90.00,
	},

	{
		coords = vector3(3559.3181152344, 3779.8388671875, 30.072246551514), -- drvo belo na prakingu sesto
		rot = 95.00,
	},

	{
		coords = vector3(3548.5388183594, 3752.1096191406, 30.072244644165), -- zbun kod ovih gore drveca i trecoh stepenica
		rot = 0.00,
	},

	{
		coords = vector3(3583.5952148438, 3773.8642578125, 29.921030044556), -- drvo belo na prakingu sedmo
		rot = 85.00,
	},

	{
		coords = vector3(3588.8955078125, 3780.1799316406, 29.932662963867), -- drvo belo na prakingu osmo
		rot = 90.00,
	},

	{
		coords = vector3(3592.9655761719, 3748.7026367188, 30.072683334351), -- zbun kod kraja polizes mi jaja
		rot = 0.00,
	},

	{
		coords = vector3(3596.2463378906, 3748.3120117188, 30.072708129883), -- zbun kod kraja polizes mi jaja
		rot = 0.00,
	},

	{
		coords = vector3(3471.4165039063, 3800.4833984375, 30.423677444458), -- prva sahta na putu levo levo
		rot = 150.00,
	},
	
	{
		coords = vector3(3420.2214355469, 3681.931640625, 41.340221405029),-- 2 sa strane desno nazad
		rot = 255.00,
	},

	{
		coords = vector3(3422.9838867188, 3681.2766113281, 41.340244293213),
		rot = 75.00,
	},

	{
		coords = vector3(3435.9099121094, 3676.6083984375, 41.336456298828), -- treci sto je pored ove dvojice
		rot = 280.00,
	},

	{
		coords = vector3(3478.5305175781, 3657.6354980469, 42.596244812012), -- ustekan desno na krovu
		rot = 50.00,
	},

	{
		coords = vector3(3486.5317382813, 3697.9189453125, 33.88842010498), -- desto kod kontenjera
		rot = 77.77,
	},

	{
		coords = vector3(3470.7612304688, 3715.8762207031, 36.642677307129), -- 4
		rot = 77.77,
	},

	{
		coords = vector3(3495.6999511719, 3741.8383789063, 36.642707824707), -- 1
		rot = 85.00,
	},

	{
		coords = vector3(3526.6967773438, 3736.1828613281, 36.686946868896), -- 2
		rot = 260.00,
	},

	{
		coords = vector3(3568.9143066406, 3734.0998535156, 36.298564910889), -- iza 2
		rot = 260.00,
	},

	{
		coords = vector3(3601.6064453125, 3715.7175292969, 36.642734527588), -- 
		rot = 77.77,
	},

	{
		coords = vector3(3594.1906738281, 3699.830078125, 36.642780303955), -- 9
		rot = 50.00,
	},

	{
		coords = vector3(3577.5031738281, 3707.5310058594, 36.642677307129), -- 8
		rot = 70.00,
	},

	{
		coords = vector3(3565.5952148438, 3707.3466796875, 36.642623901367), -- 7
		rot = 30.00,
	},

	{
		coords = vector3(3548.4167480469, 3702.7338867188, 36.642608642578), -- 6
		rot = 10.00,
	},

	{
		coords = vector3(3528.8740234375, 3722.4689941406, 36.446277618408), -- kurac drvo
		rot = 335.00,
	},

	{
		coords = vector3(3497.2287597656, 3707.3508300781, 35.488502502441), -- alley kod kontenjera
		rot = 165.00,
	},

	{
		coords = vector3(3505.5534667969, 3685.7880859375, 45.221363067627), -- snajper desno na levom krovu
		rot = 100.00

	},

	{
		coords = vector3(3520.8325195313, 3682.7761230469, 33.888751983643), -- desno alley levo
		rot = 165.00,
	},

	{
		coords = vector3(3524.2453613281, 3704.2629394531, 36.637573242188), -- isti alley ali na suprotnom kraju
		rot = 345.00,
	},

	{
		coords = vector3(3555.9641113281, 3684.8146972656, 33.88875579834), -- gore desno kod velike cisterne sto ekspolodirava
		rot = 345.00,
	},


	{
		coords = vector3(3534.5871582031, 3656.2800292969, 33.888751983643), -- kod stepenica desno desno
		rot = 65.00,
	},

	{
		coords = vector3(3532.6333007813, 3657.203125, 33.888751983643), 
		rot = 245.00,
	},

	{
		coords = vector3(3532.4997558594, 3649.4775390625, 36.984066009521),  -- na stepenicama gorepomenutim
		rot = 350.00,
	},

	{
		coords = vector3(3551.7019042969, 3649.9125976563, 46.027755737305), -- snajper kod stepenica na cisterni desno desno
		rot = 65.00,
		weapon = "WEAPON_HEAVYSNIPER",
		dropChance = 0, -- in %
		movement = 0,
		range = 2,
		health = 150,
		armor = 100

	},

	{
		coords = vector3(3553.1655273438, 3676.1845703125, 56.354011535645), -- snajper na tornju desno levo
		rot = 90.00,
		weapon = "WEAPON_HEAVYSNIPER",
		dropChance = 0, -- in %
		spawnChance = 85,
		movement = 0,
		range = 2,
		health = 150,
		armor = 100

	},

	{
		coords = vector3(3554.5532226563, 3675.703125, 48.365966796875), -- metraljez na tornju desno levo
		rot = 90.00,
		weapon = "WEAPON_COMBATMG",
		dropChance = 0, -- in %
		spawnChance = 85,
		range = 2,
		health = math.random(150, 200)
	},

	{
		coords = vector3(3555.9641113281, 3684.8146972656, 33.88875579834), -- ispod tornja gorepomenutog
		rot = 165.00,
	},

	{
		coords = vector3(3571.3806152344, 3676.8806152344, 41.001873016357), -- platforma levo od garaza desno
		rot = 110.00,
	},

	{
		coords = vector3(3558.27734375, 3655.9404296875, 33.888710021973), -- ispred garaza desnpo
		rot = 80.00,
	},

	{
		coords = vector3(3569.9516601563, 3665.0754394531, 33.895454406738), -- ispred garaza desnpo
		rot = 85.00,
	},
	

	{
		coords = vector3(3586.0805664063, 3648.896484375, 38.88256072998), -- desno od garaza desno
		rot = 80.00,
	},

	{
		coords = vector3(3585.1911621094, 3665.982421875, 42.434490203857), -- na garazama desno
		rot = 90.00,
	},

	{
		coords = vector3(3586.2819824219, 3674.5200195313, 42.405643463135), 
		rot = 100.00,
	},

	{
		coords = vector3(3596.3190917969, 3676.1787109375, 40.808338165283), 
		rot = 80.00,
		weapon = "WEAPON_PISTOL50"
	},


	{
		coords = vector3(3592.8352050781, 3672.6083984375, 33.871788024902), --garaza desno levo
		rot = 165.00,
		mustSpawn = true,
	},

	{
		coords = vector3(3592.3298339844, 3670.4516601563, 33.871784210205),
		rot = 345.00,
		mustSpawn = true,
	},

	{
		coords = vector3(3597.6772460938, 3664.2321777344, 33.871799468994), -- garaza desno desno
		rot = 100.00,
		mustSpawn = true,
	},

	{
		coords = vector3(3590.7770996094, 3659.9184570313, 33.871784210205),
		rot = 35.00,
		mustSpawn = true,
	},

	{
		coords = vector3(3600.4367675781, 3703.1545410156, 50.025672912598), -- snajper na ygradi u dvoristu desno
		rot = 65.00,
		weapon = "WEAPON_HEAVYSNIPER",
		dropChance = 0, -- in %
		spawnChance = 85,
		movement = 0,
		range = 2,
		health = 150,
		armor = 100

	},

	{
		coords = vector3(3618.5078125, 3715.1708984375, 43.500141143799), -- dvoriste platforma sredina
		rot = 80.00,
	},

	{
		coords = vector3(3606.5085449219, 3756.2172851563, 43.368564605713), -- snajper na ygradikod garaza levo
		rot = 75.00,
		weapon = "WEAPON_HEAVYSNIPER",
		dropChance = 0, -- in %
		spawnChance = 90,
		movement = 0,
		range = 2,
		health = 150,
		armor = 100

	},

	{
		coords = vector3(3573.9699707031, 3737.9702148438, 41.76354598999), -- velika zgrada kod garaze levo gleda ka dvoristu 
		rot = 110.00,
	},

	{
		coords = vector3(3568.0107421875 ,3747.0444335938, 41.763488769531), -- velika zgrada kod garaze levo gleda ka garazi 
		rot = 55.00,
	},

	{
		coords = vector3(3589.5808105469, 3736.6220703125, 41.763500213623), -- velika zgrada kod garaze levo gleda ka dvoristu 
		rot = 199.00,
	},

	{
		coords = vector3(3587.9221191406, 3745.1213378906, 41.763500213623), -- velika zgrada kod garaze levo gleda ka garazi 
		rot = 55.00,
	},

	{
		coords = vector3(3627.9406738281, 3752.4345703125, 37.135864257813), -- na garazama levo
		rot = 330.00,
	},


	----------------------------------------------------------------------------------------------------------------------------------
	-- 					UNUTRA
	----------------------------------------------------------------------------------------------------------------------------------

	{
		coords = vector3(3614.6491699219, 3736.1511230469, 28.690088272095), -- garaza levo ulaz
		rot = 330.00,
	},

	{
		coords = vector3(3618.8129882813, 3738.9455566406, 28.690093994141),
		rot = 350.00,
	},

	{
		coords = vector3(3614.1455078125, 3745.5463867188, 28.69010925293),
		rot = 310.00,
	},

	{
		coords = vector3(3606.9533691406, 3718.8488769531, 29.689399719238),
		rot = 300.00,
	},

	{
		coords = vector3(3594.2778320313, 3703.4467773438, 29.689399719238),
		rot = 280.00,
	},

	{
		coords = vector3(3604.0964355469, 3721.9528808594, 29.689399719238),
		rot = 140.00,
	},

	{
		coords = vector3(3593.234375, 3712.6743164063, 29.689399719238),
		rot = 260.00,
	},

	{
		coords = vector3(3587.3942871094, 3709.0278320313, 29.689399719238),
		rot = 260.00,
	},

	{
		coords = vector3(3595.0090332031, 3706.4797363281, 29.689399719238),
		rot = 60.00,
	},

	{
		coords = vector3(3583.6049804688, 3697.5600585938, 28.821380615234),
		rot = 330.00,
	},

	{
		coords = vector3(3595.4296875, 3697.40625, 28.821382522583),
		rot = 150.00,
	},

	{
		coords = vector3(3597.9794921875, 3692.904296875, 28.821382522583),
		rot = 70.00,
	},

	{
		coords = vector3(3595.7456054688, 3687.5798339844, 28.135848999023),
		rot = 325.00,
	},

	{
		coords = vector3(3586.6784667969, 3687.7932128906, 27.621482849121),
		rot = 230.00,
	},

	{
		coords = vector3(3586.1032714844, 3692.2238769531, 27.121856689453),
		rot = 150.00,
	},

	{
		coords = vector3(3566.4504394531, 3695.1000976563, 28.121868133545),
		rot = 260.00,
	},

	{
		coords = vector3(3558.9287109375, 3695.5627441406, 30.121438980103),
		rot = 260.00,
	},

	{
		coords = vector3(3567.7109375, 3700.8012695313, 28.12148475647),
		rot = 170.00,
	},

	{
		coords = vector3(3562.0732421875, 3691.0627441406, 28.121408462524),
		rot = 295.00,
	},

	{
		coords = vector3(3565.90625, 3681.4975585938, 28.121868133545),
		rot = 350.00,
	},

	{
		coords = vector3(3554.2319335938, 3685.2788085938, 28.121868133545),
		rot = 260.00,
	},

	{
		coords = vector3(3564.3569335938, 3679.509765625, 28.121891021729),
		rot = 90.00,
	},

	{
		coords = vector3(3556.0903320313, 3678.2797851563, 28.121891021729),
		rot = 90.00,
	},

	{
		coords = vector3(3559.7578125, 3674.54296875, 28.12188911438),
		rot = 170.00,
	},

	{
		coords = vector3(3561.0144042969, 3665.4645996094, 28.121875762939),
		rot = 80.00,
	},

	{
		coords = vector3(3553.1213378906, 3661.8479003906, 28.121891021729),
		rot = 345.00,
	},

	{
		coords = vector3(3558.2543945313, 3662.8981933594, 28.121892929077),
		rot = 80.00,
	},

	{
		coords = vector3(3549.4892578125, 3654.7915039063, 28.121891021729),
		rot = 350.00,
	},

	{
		coords = vector3(3553.5590820313, 3656.1120605469, 28.121891021729),
		rot = 80.00,
	},

	{
		coords = vector3(3542.3974609375, 3645.5979003906, 28.121891021729),
		rot = 260.00,
	},

	{
		coords = vector3(3547.9948730469, 3640.4035644531, 28.121891021729),
		rot = 65.00,
	},

	{
		coords = vector3(3536.9020996094, 3646.4921875, 27.849885940552),
		rot = 260.00,
	},

	{
		coords = vector3(3529.51953125, 3653.8039550781, 27.521575927734),
		rot = 175.00,
	},

	{
		coords = vector3(3537.5842285156, 3667.2563476563, 28.121873855591),
		rot = 115.00,
	},

	{
		coords = vector3(3539.4636230469, 3660.2075195313, 28.121891021729),
		rot = 50.00,
	},

	{
		coords = vector3(3528.0080566406, 3673.0612792969, 28.121137619019),
		rot = 260.00,
	},

	{
		coords = vector3(3528.0080566406, 3673.0612792969, 28.121137619019),
		rot = 260.00,
	},

	{
		coords = vector3(3538.5173339844, 3671.265625, 28.121139526367),
		rot = 75.00,
	},

	{
		coords = vector3(3540.9255371094, 3676.5473632813, 28.121139526367),
		rot = 170.00,
	}

}

Config.PedModels = {
	"g_m_y_korlieut_01",
	"g_m_m_casrn_01",
	"mp_m_securoguard_01",
	"mp_m_waremech_01",
	"s_m_m_armoured_01",
	"s_m_m_armoured_02",
	"s_m_m_bouncer_01",
	"s_m_m_chemsec_01",
	"s_m_m_highsec_01",
	"s_m_m_highsec_02",
	"s_m_m_strpreach_01",
	"s_m_m_ups_01",
	"s_m_m_ups_02",
	"s_m_y_blackops_01",
	"s_m_y_blackops_02",
	"s_m_y_doorman_01",
	"s_m_y_waretech_01",
	"s_m_y_xmech_02",
	--"ig_lestercrest_2",
	"ig_michelle",



}

Config.Weapons = {
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_CARBINERIFLE",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_PISTOL",

}