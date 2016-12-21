bD = {}
bD['list']=[]
bD['number available']={}

bD['list'].push('Town Hall')
bD['number available']['townhall']=[1,1,1,1,1,1,1,1,1,1,1,]
bD['townhall']=[]
bD['townhall']['type']="Other"
bD['townhall']['required town hall']=[0,1,2,3,4,5,6,7,8,9,10]
bD['townhall']['upgrade time']=[0,1,180,1440,2880,5760,8640,11520,14400,17280,20160]
bD['townhall']['upgrade cost']=[[0,0,0],[1000,0,0],[4000,0,0],[25000,0,0],[150000,0,0],[750000,0,0],[1200000,0,0],[2000000,0,0],[3000000,0,0],[5000000,0,0],[7000000,0,0]]

bD['list'].push('Clan Castle')
bD['number available']['clancastle']=[0,0,1,1,1,1,1,1,1,1,1,]
bD['clancastle']=[]
bD['clancastle']['type']="Other"
bD['clancastle']['required town hall']=[3,4,6,8,9,10,11]
bD['clancastle']['upgrade time']=[0,60*6,60*24,60*24*2,60*24*6,60*24*10,60*24*14,]
bD['clancastle']['upgrade cost']=[[10000,0,0],[100000,0,0],[800000,0,0],[1800000,0,0],[4000000,0,0],[7000000,0,0],[10000000,0,0],]

bD['list'].push('Cannon')
bD['number available']['cannon']=[2,2,2,2,3,3,5,5,5,6,7,]
bD['cannon']=[]
bD['cannon']['type']="Defense"
bD['cannon']['required town hall']=[1,1,2,3,4,5,6,7,8,8,9,10,10,11]
bD['cannon']['upgrade time']=[1,15,45,120,360,720,1440,2880,4320,5760,7200,8640,10080,60*24*8]
bD['cannon']['upgrade cost']=[[250,0,0],[1000,0,0],[4000,0,0],[16000,0,0],[50000,0,0],[100000,0,0],[200000,0,0],[400000,0,0],[800000,0,0],[1600000,0,0],[3200000,0,0],[5000000,0,0],[6500000,0,0],[8500000,0,0]]

bD['list'].push('Archer Tower')
bD['number available']['archertower']=[0,1,1,2,3,3,4,5,6,7,8,]
bD['archertower']=[]
bD['archertower']['type']="Defense"
bD['archertower']['required town hall']=[2,2,3,4,5,5,6,7,8,8,9,10,10,11]
bD['archertower']['upgrade time']=[1,30,45,60*4,60*12,60*24,60*24*2,60*24*3,60*24*4,60*24*5,60*24*6,60*24*7,60*24*8,60*24*9]
bD['archertower']['upgrade cost']=[[1000,0,0],[2000,0,0],[5000,0,0],[20000,0,0],[80000,0,0],[180000,0,0],[360000,0,0],[720000,0,0],[1500000,0,0],[2500000,0,0],[3800000,0,0],[5500000,0,0],[7000000,0,0],[9000000,0,0]]

bD['list'].push('Air Sweeper')
bD['number available']['airsweeper']=[0,0,0,0,0,1,1,1,2,2,2,]
bD['airsweeper']=[]
bD['airsweeper']['type']="Defense"
bD['airsweeper']['required town hall']=[6,6,7,8,9,10,]
bD['airsweeper']['upgrade time']=[1440,1440*3,1440*5,1440*7,1440*8,1440*9,]
bD['airsweeper']['upgrade cost']=[[500000,0,0],[750000,0,0],[1250000,0,0],[2400000,0,0],[4800000,0,0],[7200000,0,0],]

bD['list'].push('Mortar')
bD['number available']['mortar']=[0,0,1,1,1,2,3,4,4,4,4,]
bD['mortar']=[]
bD['mortar']['type']="Defense"
bD['mortar']['required town hall']=[3,4,5,6,7,8,9,10,11,11]
bD['mortar']['upgrade time']=[60*8,60*12,60*24,60*24*2,60*24*4,60*24*5,60*24*7,60*24*8,60*24*10,60*24*12]
bD['mortar']['upgrade cost']=[[8000,0,0],[32000,0,0],[120000,0,0],[400000,0,0],[800000,0,0],[1600000,0,0],[3200000,0,0],[5000000,0,0],[7000000,0,0],[9000000,0,0]]

bD['list'].push('Air Defense')
bD['number available']['airdefense']=[0,0,0,1,1,2,3,3,4,4,4,]
bD['airdefense']=[]
bD['airdefense']['type']="Defense"
bD['airdefense']['required town hall']=[4,4,5,6,7,8,9,10,]
bD['airdefense']['upgrade time']=[300,1440,4320,7200,8640,11520,14400,17280,]
bD['airdefense']['upgrade cost']=[[22500,0,0],[90000,0,0],[270000,0,0],[540000,0,0],[1080000,0,0],[2160000,0,0],[4320000,0,0],[7560000,0,0],]

bD['list'].push('Wizard Tower')
bD['number available']['wizardtower']=[0,0,0,0,1,2,2,3,4,4,5,]
bD['wizardtower']=[]
bD['wizardtower']['type']="Defense"
bD['wizardtower']['required town hall']=[5,5,6,7,8,8,9,10,10,11,]
bD['wizardtower']['upgrade time']=[60*12,60*24,60*24*2,60*24*3,60*24*4,60*24*5,60*24*6,60*24*8,60*24*10,60*24*12]
bD['wizardtower']['upgrade cost']=[[180000,0,0],[360000,0,0],[700000,0,0],[1200000,0,0],
    [1700000,0,0],[2200000,0,0],[3700000,0,0],[5200000,0,0],[7200000,0,0],[9200000,0,0]]

bD['list'].push('Hidden Tesla')
bD['number available']['hiddentesla']=[0,0,0,0,0,0,2,3,4,4,4]
bD['hiddentesla']=[]
bD['hiddentesla']['type']="Defense"
bD['hiddentesla']['required town hall']=[7,7,7,8,8,8,9,10,11]
bD['hiddentesla']['upgrade time']=[60*24*1,60*24*3,60*24*5,60*24*6,60*24*7,60*24*8,60*24*10,60*24*12,60*24*14,]
bD['hiddentesla']['upgrade cost']=[[1000000,0,0],[1250000,0,0],[1500000,0,0],[2000000,0,0],[2500000,0,0],[3000000,0,0],[3500000,0,0],[5000000,0,0],[8000000,0,0],]

bD['list'].push('Bomb Tower')
bD['number available']['bombtower']=[0,0,0,0,0,0,0,1,1,2,2]
bD['bombtower']=[]
bD['bombtower']['type']="Defense"
bD['bombtower']['required town hall']=[8,8,9,10,11]
bD['bombtower']['upgrade time']=[60*24*4,60*24*6,60*24*8,60*24*10,60*24*14,]
bD['bombtower']['upgrade cost']=[[2000000,0,0],[3500000,0,0],[5000000,0,0],[7000000,0,0],[9000000,0,0],]

bD['list'].push('X-Bow')
bD['number available']['xbow']=[0,0,0,0,0,0,0,0,2,3,4,]
bD['xbow']=[]
bD['xbow']['type']="Defense"
bD['xbow']['required town hall']=[9,9,9,10,11]
bD['xbow']['upgrade time']=[1440*7,1440*8,1440*10,1440*12,1440*14]
bD['xbow']['upgrade cost']=[[3000000,0,0],[4000000,0,0],[5000000,0,0],[7000000,0,0],[9500000,0,0],]

bD['list'].push('Inferno Tower')
bD['number available']['infernotower']=[0,0,0,0,0,0,0,0,0,2,2,]
bD['infernotower']=[]
bD['infernotower']['type']="Defense"
bD['infernotower']['required town hall']=[10,10,10,11]
bD['infernotower']['upgrade time']=[10080,14400,60*24*14,60*24*14]
bD['infernotower']['upgrade cost']=[[5000000,0,0],[6500000,0,0],[8000000,0,0],[10000000,0,0]]

bD['list'].push('Eagle Artillery')
bD['number available']['eagleartillery']=[0,0,0,0,0,0,0,0,0,0,1,]
bD['eagleartillery']=[]
bD['eagleartillery']['type']="Defense"
bD['eagleartillery']['required town hall']=[11,11,]
bD['eagleartillery']['upgrade time']=[14400,20160,]
bD['eagleartillery']['upgrade cost']=[[8000000,0,0],[10000000,0,0],]

bD['list'].push('Bomb')
bD['number available']['bomb']=[0,0,2,2,4,4,6,6,6,6,6,]
bD['bomb']=[]
bD['bomb']['type']="Trap"
bD['bomb']['required town hall']=[3,3,5,7,8,9,]
bD['bomb']['upgrade time']=[0,15,120,480,1440,2880,]
bD['bomb']['upgrade cost']=[[400,0,0],[1000,0,0],[10000,0,0],[100000,0,0],[1000000,0,0],[1500000,0,0],]

bD['list'].push('Spring Trap')
bD['number available']['springtrap']=[0,0,0,2,2,4,4,6,6,6,6,]
bD['springtrap']=[]
bD['springtrap']['type']="Trap"
bD['springtrap']['required town hall']=[4,7,8,9,10]
bD['springtrap']['upgrade time']=[0,60*16,60*24,60*24*2,60*24*3]
bD['springtrap']['upgrade cost']=[[2000,0,0],[500000,0,0],[1000000,0,0],[1500000,0,0],[2000000,0,0]]

bD['list'].push('Giant Bomb')
bD['number available']['giantbomb']=[0,0,0,0,0,1,2,3,4,5,5]
bD['giantbomb']=[]
bD['giantbomb']['type']="Trap"
bD['giantbomb']['required town hall']=[6,6,8,10,]
bD['giantbomb']['upgrade time']=[0,360,1440,4320,]
bD['giantbomb']['upgrade cost']=[[12500,0,0],[75000,0,0],[750000,0,0],[2500000,0,0],]

bD['list'].push('Air Bomb')
bD['number available']['airbomb']=[0,0,0,0,2,2,2,4,4,5,5,]
bD['airbomb']=[]
bD['airbomb']['type']="Trap"
bD['airbomb']['required town hall']=[5,5,7,9,]
bD['airbomb']['upgrade time']=[0,240,720,1440,]
bD['airbomb']['upgrade cost']=[[4000,0,0],[20000,0,0],[200000,0,0],[1500000,0,0],]

bD['list'].push('Seeking Air Mine')
bD['number available']['seekingairmine']=[0,0,0,0,0,0,1,2,4,5,5,]
bD['seekingairmine']=[]
bD['seekingairmine']['type']="Trap"
bD['seekingairmine']['required town hall']=[7,9,10,]
bD['seekingairmine']['upgrade time']=[0,1440,4320,]
bD['seekingairmine']['upgrade cost']=[[15000,0,0],[2000000,0,0],[4000000,0,0],]

bD['list'].push('Skeleton Trap')
bD['number available']['skeletontrap']=[0,0,0,0,0,0,0,2,2,3,3,]
bD['skeletontrap']=[]
bD['skeletontrap']['type']="Trap"
bD['skeletontrap']['required town hall']=[8,8,9,]
bD['skeletontrap']['upgrade time']=[0,360,1440,]
bD['skeletontrap']['upgrade cost']=[[6000,0,0],[600000,0,0],[1300000,0,0],]

bD['list'].push('Walls')
bD['number available']['walls']=[0,25,50,75,100,125,175,225,250,275,300,]
bD['walls']=[]
bD['walls']['type']="Walls"
bD['walls']['required town hall']=[2,2,3,4,5,6,7,8,9,9,10,11,]
bD['walls']['upgrade time']=[0,0,0,0,0,0,0,0,0,0,0,0,]
bD['walls']['upgrade cost']=[[50,0,0],[1000,0,0],[5000,0,0],[10000,0,0],[30000,0,0],[75000,0,0],
    [200000,0,0],[500000,0,0],[1000000,1000000,0],[2000000,2000000,0],[3000000,3000000,0],[4000000,4000000,0],]

bD['list'].push('Gold Mine')
bD['number available']['goldmine']=[1,2,3,4,5,6,6,6,6,7,7,]
bD['goldmine']=[]
bD['goldmine']['type']="Resource"
bD['goldmine']['required town hall']=[1,1,2,2,3,3,4,4,5,5,7,8,]
bD['goldmine']['upgrade time']=[1,5,15,60,120,360,720,1440,2880,4320,5760,7200,]
bD['goldmine']['production']=[[200,0,0],[400,0,0],[600,0,0],[800,0,0],[1000,0,0],[1300,0,0],[1600,0,0],[1900,0,0],[2200,0,0],[2500,0,0],[3000,0,0],[3500,0,0],]
bD['goldmine']['upgrade cost']=[[0,150,0],[0,300,0],[0,700,0],[0,1400,0],[0,3500,0],[0,7000,0],[0,14000,0],[0,28000,0],[0,56000,0],[0,84000,0],[0,168000,0],[0,336000,0],]

bD['list'].push('Elixir Collector')
bD['number available']['elixircollector']=[1,2,3,4,5,6,6,6,6,7,7,]
bD['elixircollector']=[]
bD['elixircollector']['type']="Resource"
bD['elixircollector']['required town hall']=[1,1,2,2,3,3,4,4,5,5,7,8,]
bD['elixircollector']['upgrade time']=[1,5,15,60,120,360,720,1440,2880,4320,5760,7200,]
bD['elixircollector']['production']=[[0,200,0],[0,400,0],[0,600,0],[0,800,0],[0,1000,0],[0,1300,0],[0,1600,0],[0,1900,0],[0,2200,0],[0,2500,0],[0,3000,0],[0,3500,0],]
bD['elixircollector']['upgrade cost']=[[150,0,0],[300,0,0],[700,0,0],[1400,0,0],[3500,0,0],[7000,0,0],[14000,0,0],[28000,0,0],[56000,0,0],[84000,0,0],[168000,0,0],[336000,0,0],]

bD['list'].push('Dark Elixir Drill')
bD['number available']['darkelixirdrill']=[0,0,0,0,0,0,1,2,2,3,3,]
bD['darkelixirdrill']=[]
bD['darkelixirdrill']['type']="Resource"
bD['darkelixirdrill']['required town hall']=[7,7,7,9,9,9,]
bD['darkelixirdrill']['upgrade time']=[1440,2880,4320,5760,8640,11520,]
bD['darkelixirdrill']['production']=[[0,0,20],[0,0,30],[0,0,45],[0,0,60],[0,0,80],[0,0,100],]
bD['darkelixirdrill']['upgrade cost']=[[0,1000000,0],[0,1500000,0],[0,2000000,0],[0,3000000,0],[0,4000000,0],[0,5000000,0],]

bD['list'].push('Gold Storage')
bD['number available']['goldstorage']=[1,1,2,2,2,2,2,3,4,4,4,]
bD['goldstorage']=[]
bD['goldstorage']['type']="Resource"
bD['goldstorage']['required town hall']=[1,2,2,3,3,3,4,4,5,6,7,11,]
bD['goldstorage']['upgrade time']=[1,30,60,120,180,240,360,480,720,1440,2880,10080]
bD['goldstorage']['capacity']=[[1500,0,0],[3000,0,0],[6000,0,0],[12000,0,0],[25000,0,0],[45000,0,0],[100000,0,0],[225000,0,0],[450000,0,0],[850000,0,0],[1750000,0,0],[2000000,0,0],]
bD['goldstorage']['upgrade cost']=[[0,300,0],[0,750,0],[0,1500,0],[0,3000,0],[0,6000,0],[0,12000,0],[0,25000,0],[0,50000,0],[0,100000,0],[0,250000,0],[0,500000,0],[0,2500000,0],]

bD['list'].push('Elixir Storage')
bD['number available']['elixirstorage']=[1,1,2,2,2,2,2,3,4,4,4,]
bD['elixirstorage']=[]
bD['elixirstorage']['type']="Resource"
bD['elixirstorage']['required town hall']=[1,2,2,3,3,3,4,4,5,6,7,11]
bD['elixirstorage']['upgrade time']=[1,30,60,120,180,240,360,480,720,1440,2880,10080]
bD['elixirstorage']['capacity']=[[0,1500,0],[0,3000,0],[0,6000,0],[0,12000,0],[0,25000,0],[0,45000,0],[0,100000,0],[0,225000,0],[0,450000,0],[0,850000,0],[0,1750000,0],[0,2000000,0],]
bD['elixirstorage']['upgrade cost']=[[300,0,0],[750,0,0],[1500,0,0],[3000,0,0],[6000,0,0],[12000,0,0],[25000,0,0],[50000,0,0],[100000,0,0],[250000,0,0],[500000,0,0],[2500000,0,0],]

bD['list'].push('Dark Elixir Storage')
bD['number available']['darkelixirstorage']=[0,0,0,0,0,0,1,1,1,1,1,]
bD['darkelixirstorage']=[]
bD['darkelixirstorage']['type']="Resource"
bD['darkelixirstorage']['required town hall']=[7,7,8,8,9,9,]
bD['darkelixirstorage']['upgrade time']=[1440,2880,4320,5760,7200,8640,]
bD['darkelixirstorage']['capacity']=[[0,0,10000],[0,0,20000],[0,0,40000],[0,0,80000],[0,0,150000],[0,0,200000],]
bD['darkelixirstorage']['upgrade cost']=[[0,600000,0],[0,1200000,0],[0,1800000,0],[0,2400000,0],[0,3000000,0],[0,3600000,0],]

bD['list'].push('Army Camp')
bD['number available']['armycamp']=[1,1,2,2,3,3,4,4,4,4,4,]
bD['armycamp']=[]
bD['armycamp']['type']="Army"
bD['armycamp']['required town hall']=[1,2,3,4,5,6,9,10,]
bD['armycamp']['upgrade time']=[5,60,180,480,1440,4320,7200,14400,]
bD['armycamp']['upgrade cost']=[[0,250,0],[0,2500,0],[0,10000,0],[0,100000,0],[0,250000,0],[0,750000,0],[0,2250000,0],[0,6750000,0],]

bD['list'].push('Barracks')
bD['number available']['barracks']=[1,2,2,3,3,3,4,4,4,4,4,]
bD['barracks']=[]
bD['barracks']['type']="Army"
bD['barracks']['required town hall']=[1,1,1,2,3,4,5,6,7,8,9,10]
bD['barracks']['upgrade time']=[1,15,120,240,600,960,1440,2880,5760,8640,60*24*8,60*24*10]
bD['barracks']['upgrade cost']=[[0,200,0],[0,1000,0],[0,2500,0],[0,5000,0],[0,10000,0],[0,80000,0],
    [0,240000,0],[0,700000,0],[0,1500000,0],[0,2000000,0],[0,3000000,0],[0,4000000,0]]

bD['list'].push('Dark Barracks')
bD['number available']['darkbarracks']=[0,0,0,0,0,0,1,2,2,2,2,]
bD['darkbarracks']=[]
bD['darkbarracks']['type']="Army"
bD['darkbarracks']['required town hall']=[7,7,8,8,9,9,10]
bD['darkbarracks']['upgrade time']=[4320,7200,8640,10080,11520,12960,17280]
bD['darkbarracks']['upgrade cost']=[[0,750000,0],[0,1250000,0],[0,1750000,0],[0,2250000,0],[0,2750000,0],[0,3500000,0],[0,6000000,0]]

bD['list'].push('Laboratory')
bD['number available']['laboratory']=[0,0,1,1,1,1,1,1,1,1,1,]
bD['laboratory']=[]
bD['laboratory']['type']="Army"
bD['laboratory']['required town hall']=[3,4,5,6,7,8,9,10,11]
bD['laboratory']['upgrade time']=[30,300,720,1440,2880,5760,7200,8640,10080]
bD['laboratory']['upgrade cost']=[[0,25000,0],[0,50000,0],[0,90000,0],[0,270000,0],[0,500000,0],[0,1000000,0],[0,2500000,0],[0,4000000,0],[0,6000000,0],]

bD['list'].push('Spell Factory')
bD['number available']['spellfactory']=[0,0,0,0,1,1,1,1,1,1,1,]
bD['spellfactory']=[]
bD['spellfactory']['type']="Army"
bD['spellfactory']['required town hall']=[5,6,7,9,10,]
bD['spellfactory']['upgrade time']=[1440,2880,5760,7200,8640,]
bD['spellfactory']['upgrade cost']=[[0,200000,0],[0,400000,0],[0,800000,0],[0,1600000,0],[0,3200000,0],]

bD['list'].push('Dark Spell Factory')
bD['number available']['darkspellfactory']=[0,0,0,0,0,0,0,1,1,1,1,]
bD['darkspellfactory']=[]
bD['darkspellfactory']['type']="Army"
bD['darkspellfactory']['required town hall']=[8,8,9,9]
bD['darkspellfactory']['upgrade time']=[1440*4,1440*6,1440*8,1440*10]
bD['darkspellfactory']['upgrade cost']=[[0,1500000,0],[0,2500000,0],[0,3500000,0],[0,4500000,0]]
