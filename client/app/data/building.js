buildingData = {}
buildingData['list']=[]
buildingData['number available']={}

buildingData['list'].push('Town Hall')
buildingData['number available']['townhall']=[1,1,1,1,1,1,1,1,1,1,]
buildingData['townhall']=[]
buildingData['townhall']['type']="Other"
buildingData['townhall']['required town hall']=[0,1,2,3,4,5,6,7,8,9,]
buildingData['townhall']['upgrade time']=[0,1,180,1440,2880,5760,8640,11520,14400,20160,]
buildingData['townhall']['upgrade cost']=[[0,0,0],[1000,0,0],[4000,0,0],[25000,0,0],[150000,0,0],[750000,0,0],[1200000,0,0],[2000000,0,0],[3000000,0,0],[4000000,0,0],]

buildingData['list'].push('Clan Castle')
buildingData['number available']['clancastle']=[0,0,1,1,1,1,1,1,1,1,]
buildingData['clancastle']=[]
buildingData['clancastle']['type']="Other"
buildingData['clancastle']['required town hall']=[3,4,6,8,9,10,]
buildingData['clancastle']['upgrade time']=[0,360,1440,2880,10080,20160,]
buildingData['clancastle']['upgrade cost']=[[10000,0,0],[100000,0,0],[800000,0,0],[1800000,0,0],[5000000,0,0],[7000000,0,0],]

buildingData['list'].push('Cannon')
buildingData['number available']['cannon']=[2,2,2,2,3,3,5,5,5,6,]
buildingData['cannon']=[]
buildingData['cannon']['type']="Defense"
buildingData['cannon']['required town hall']=[1,1,2,3,4,5,6,7,8,8,9,10,10,]
buildingData['cannon']['upgrade time']=[1,15,45,120,360,720,1440,2880,4320,5760,7200,8640,10080,]
buildingData['cannon']['upgrade cost']=[[250,0,0],[1000,0,0],[4000,0,0],[16000,0,0],[50000,0,0],[100000,0,0],[200000,0,0],[400000,0,0],[800000,0,0],[1600000,0,0],[3200000,0,0],[6400000,0,0],[7500000,0,0],]

buildingData['list'].push('Archer Tower')
buildingData['number available']['archertower']=[0,1,1,2,3,3,4,5,6,7,]
buildingData['archertower']=[]
buildingData['archertower']['type']="Defense"
buildingData['archertower']['required town hall']=[2,2,3,4,5,5,6,7,8,8,9,10,10,]
buildingData['archertower']['upgrade time']=[15,30,45,240,720,1440,2880,4320,5760,7200,8640,10080,11520,]
buildingData['archertower']['upgrade cost']=[[1000,0,0],[2000,0,0],[5000,0,0],[20000,0,0],[80000,0,0],[180000,0,0],[360000,0,0],[720000,0,0],[1500000,0,0],[2500000,0,0],[4500000,0,0],[6500000,0,0],[7500000,0,0],]

buildingData['list'].push('Mortar')
buildingData['number available']['mortar']=[0,0,1,1,1,2,3,4,4,4,]
buildingData['mortar']=[]
buildingData['mortar']['type']="Defense"
buildingData['mortar']['required town hall']=[3,4,5,6,7,8,9,10,]
buildingData['mortar']['upgrade time']=[480,720,1440,2880,5760,7200,10080,14400,]
buildingData['mortar']['upgrade cost']=[[8000,0,0],[32000,0,0],[120000,0,0],[400000,0,0],[800000,0,0],[1600000,0,0],[3200000,0,0],[6400000,0,0],]

buildingData['list'].push('Air Defense')
buildingData['number available']['airdefense']=[0,0,0,1,1,1,2,3,4,4,]
buildingData['airdefense']=[]
buildingData['airdefense']['type']="Defense"
buildingData['airdefense']['required town hall']=[4,4,5,6,7,8,9,10,]
buildingData['airdefense']['upgrade time']=[300,1440,4320,7200,8640,11520,14400,17280,]
buildingData['airdefense']['upgrade cost']=[[22500,0,0],[90000,0,0],[270000,0,0],[540000,0,0],[1080000,0,0],[2160000,0,0],[4320000,0,0],[7560000,0,0],]

buildingData['list'].push('Wizard Tower')
buildingData['number available']['wizardtower']=[0,0,0,0,1,2,2,3,4,4,]
buildingData['wizardtower']=[]
buildingData['wizardtower']['type']="Defense"
buildingData['wizardtower']['required town hall']=[5,5,6,7,8,8,9,10,]
buildingData['wizardtower']['upgrade time']=[720,1440,2880,4320,5760,7200,10080,14400,]
buildingData['wizardtower']['upgrade cost']=[[180000,0,0],[360000,0,0],[720000,0,0],[1280000,0,0],[1960000,0,0],[2680000,0,0],[5360000,0,0],[6480000,0,0],]

buildingData['list'].push('Hidden Tesla')
buildingData['number available']['hiddentesla']=[0,0,0,0,0,0,2,3,4,4,]
buildingData['hiddentesla']=[]
buildingData['hiddentesla']['type']="Defense"
buildingData['hiddentesla']['required town hall']=[7,7,7,8,8,8,9,10,]
buildingData['hiddentesla']['upgrade time']=[1440,4320,7200,8640,11520,14400,17280,20160,]
buildingData['hiddentesla']['upgrade cost']=[[1000000,0,0],[1250000,0,0],[1500000,0,0],[2000000,0,0],[2500000,0,0],[3000000,0,0],[3500000,0,0],[5000000,0,0],]

buildingData['list'].push('X-Bow')
buildingData['number available']['x-bow']=[0,0,0,0,0,0,0,0,2,3,]
buildingData['x-bow']=[]
buildingData['x-bow']['type']="Defense"
buildingData['x-bow']['required town hall']=[9,9,9,10,]
buildingData['x-bow']['upgrade time']=[10080,14400,20160,20160,]
buildingData['x-bow']['upgrade cost']=[[3000000,0,0],[5000000,0,0],[7000000,0,0],[8000000,0,0],]

buildingData['list'].push('Inferno Tower')
buildingData['number available']['infernotower']=[0,0,0,0,0,0,0,0,0,2,]
buildingData['infernotower']=[]
buildingData['infernotower']['type']="Defense"
buildingData['infernotower']['required town hall']=[10,10,10,]
buildingData['infernotower']['upgrade time']=[10080,14400,20160,]
buildingData['infernotower']['upgrade cost']=[[5000000,0,0],[6500000,0,0],[8000000,0,0],]

buildingData['list'].push('Bomb')
buildingData['number available']['bomb']=[0,0,2,2,4,4,6,6,6,6,]
buildingData['bomb']=[]
buildingData['bomb']['type']="Trap"
buildingData['bomb']['required town hall']=[3,3,5,7,8,9,]
buildingData['bomb']['upgrade time']=[0,15,120,480,1440,2880,]
buildingData['bomb']['upgrade cost']=[[400,0,0],[1000,0,0],[10000,0,0],[100000,0,0],[1000000,0,0],[1500000,0,0],]

buildingData['list'].push('Spring Trap')
buildingData['number available']['springtrap']=[0,0,0,2,2,4,4,6,6,6,]
buildingData['springtrap']=[]
buildingData['springtrap']['type']="Trap"
buildingData['springtrap']['required town hall']=[4,]
buildingData['springtrap']['upgrade time']=[0,]
buildingData['springtrap']['upgrade cost']=[[2000,0,0],]

buildingData['list'].push('Giant Bomb')
buildingData['number available']['giantbomb']=[0,0,0,0,0,1,2,3,4,5,]
buildingData['giantbomb']=[]
buildingData['giantbomb']['type']="Trap"
buildingData['giantbomb']['required town hall']=[6,6,8,10,]
buildingData['giantbomb']['upgrade time']=[0,360,1440,4320,]
buildingData['giantbomb']['upgrade cost']=[[12500,0,0],[75000,0,0],[750000,0,0],[2500000,0,0],]

buildingData['list'].push('Air Bomb')
buildingData['number available']['airbomb']=[0,0,0,0,2,2,2,4,4,5,]
buildingData['airbomb']=[]
buildingData['airbomb']['type']="Trap"
buildingData['airbomb']['required town hall']=[5,5,7,9,]
buildingData['airbomb']['upgrade time']=[0,240,720,1440,]
buildingData['airbomb']['upgrade cost']=[[4000,0,0],[20000,0,0],[200000,0,0],[1500000,0,0],]

buildingData['list'].push('Seeking Air Mine')
buildingData['number available']['seekingairmine']=[0,0,0,0,0,0,1,2,4,5,]
buildingData['seekingairmine']=[]
buildingData['seekingairmine']['type']="Trap"
buildingData['seekingairmine']['required town hall']=[7,9,10,]
buildingData['seekingairmine']['upgrade time']=[0,1440,4320,]
buildingData['seekingairmine']['upgrade cost']=[[15000,0,0],[2000000,0,0],[4000000,0,0],]

buildingData['list'].push('Skeleton Trap')
buildingData['number available']['skeletontrap']=[0,0,0,0,0,0,0,2,2,3,]
buildingData['skeletontrap']=[]
buildingData['skeletontrap']['type']="Trap"
buildingData['skeletontrap']['required town hall']=[8,8,9,]
buildingData['skeletontrap']['upgrade time']=[0,360,1440,]
buildingData['skeletontrap']['upgrade cost']=[[6000,0,0],[600000,0,0],[1300000,0,0],]

buildingData['list'].push('Walls')
buildingData['number available']['walls']=[0,25,50,75,100,125,175,225,250,250,]
buildingData['walls']=[]
buildingData['walls']['type']="Walls"
buildingData['walls']['required town hall']=[2,2,3,4,5,6,7,8,9,9,10,]
buildingData['walls']['upgrade time']=[0,0,0,0,0,0,0,0,0,0,0,]
buildingData['walls']['upgrade cost']=[[200,0,0],[1000,0,0],[5000,0,0],[10000,0,0],[30000,0,0],[75000,0,0],[200000,0,0],[500000,0,0],[1000000,1000000,0],[3000000,3000000,0],[4000000,4000000,0],]

buildingData['list'].push('Gold Mine')
buildingData['number available']['goldmine']=[1,2,3,4,5,6,6,6,6,7,]
buildingData['goldmine']=[]
buildingData['goldmine']['type']="Resource"
buildingData['goldmine']['required town hall']=[1,1,2,2,3,3,4,4,5,5,7,8,]
buildingData['goldmine']['upgrade time']=[1,5,15,60,120,360,720,1440,2880,4320,5760,7200,]
buildingData['goldmine']['production']=[[200,0,0],[400,0,0],[600,0,0],[800,0,0],[1000,0,0],[1300,0,0],[1600,0,0],[1900,0,0],[2200,0,0],[2500,0,0],[3000,0,0],[3500,0,0],]
buildingData['goldmine']['upgrade cost']=[[0,150,0],[0,300,0],[0,700,0],[0,1400,0],[0,3000,0],[0,7000,0],[0,14000,0],[0,28000,0],[0,56000,0],[0,84000,0],[0,168000,0],[0,336000,0],]

buildingData['list'].push('Elixir Collector')
buildingData['number available']['elixircollector']=[1,2,3,4,5,6,6,6,6,7,]
buildingData['elixircollector']=[]
buildingData['elixircollector']['type']="Resource"
buildingData['elixircollector']['required town hall']=[1,1,2,2,3,3,4,4,5,5,7,8,]
buildingData['elixircollector']['upgrade time']=[1,5,15,60,120,360,720,1440,2880,4320,5760,7200,]
buildingData['elixircollector']['production']=[[0,200,0],[0,400,0],[0,600,0],[0,800,0],[0,1000,0],[0,1300,0],[0,1600,0],[0,1900,0],[0,2200,0],[0,2500,0],[0,3000,0],[0,3500,0],]
buildingData['elixircollector']['upgrade cost']=[[150,0,0],[300,0,0],[700,0,0],[1400,0,0],[3500,0,0],[7000,0,0],[14000,0,0],[28000,0,0],[56000,0,0],[84000,0,0],[168000,0,0],[336000,0,0],]

buildingData['list'].push('Dark Elixir Drill')
buildingData['number available']['darkelixirdrill']=[0,0,0,0,0,0,1,2,2,3,]
buildingData['darkelixirdrill']=[]
buildingData['darkelixirdrill']['type']="Resource"
buildingData['darkelixirdrill']['required town hall']=[7,7,7,9,9,9,]
buildingData['darkelixirdrill']['upgrade time']=[1440,2880,4320,5760,8640,11520,]
buildingData['darkelixirdrill']['production']=[[0,0,20],[0,0,30],[0,0,45],[0,0,60],[0,0,80],[0,0,100],]
buildingData['darkelixirdrill']['upgrade cost']=[[0,1000000,0],[0,1500000,0],[0,2000000,0],[0,3000000,0],[0,4000000,0],[0,5000000,0],]

buildingData['list'].push('Gold Storage')
buildingData['number available']['goldstorage']=[1,1,2,2,2,2,2,3,4,4,]
buildingData['goldstorage']=[]
buildingData['goldstorage']['type']="Resource"
buildingData['goldstorage']['required town hall']=[1,2,2,3,3,3,4,4,5,6,7,]
buildingData['goldstorage']['upgrade time']=[1,30,60,120,180,240,360,480,720,1440,2880,]
buildingData['goldstorage']['capacity']=[[1500,0,0],[3000,0,0],[6000,0,0],[12000,0,0],[25000,0,0],[50000,0,0],[100000,0,0],[250000,0,0],[500000,0,0],[1000000,0,0],[2000000,0,0],]
buildingData['goldstorage']['production']=[[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],]
buildingData['goldstorage']['upgrade cost']=[[0,300,0],[0,750,0],[0,1500,0],[0,3000,0],[0,6000,0],[0,12000,0],[0,25000,0],[0,50000,0],[0,100000,0],[0,250000,0],[0,500000,0],]

buildingData['list'].push('Elixir Storage')
buildingData['number available']['elixirstorage']=[1,1,2,2,2,2,2,3,4,4,]
buildingData['elixirstorage']=[]
buildingData['elixirstorage']['type']="Resource"
buildingData['elixirstorage']['required town hall']=[1,2,2,3,3,3,4,4,5,6,7,]
buildingData['elixirstorage']['upgrade time']=[1,30,60,120,180,240,360,480,720,1440,2880,]
buildingData['elixirstorage']['capacity']=[[0,1500,0],[0,3000,0],[0,6000,0],[0,12000,0],[0,25000,0],[0,50000,0],[0,100000,0],[0,250000,0],[0,500000,0],[0,1000000,0],[0,2000000,0],]
buildingData['elixirstorage']['upgrade cost']=[[300,0,0],[750,0,0],[1500,0,0],[3000,0,0],[6000,0,0],[12000,0,0],[25000,0,0],[50000,0,0],[100000,0,0],[250000,0,0],[500000,0,0],]

buildingData['list'].push('Dark Elixir Storage')
buildingData['number available']['darkelixirstorage']=[0,0,0,0,0,0,1,1,1,1,]
buildingData['darkelixirstorage']=[]
buildingData['darkelixirstorage']['type']="Resource"
buildingData['darkelixirstorage']['required town hall']=[7,7,8,8,9,9,]
buildingData['darkelixirstorage']['upgrade time']=[1440,2880,4320,5760,7200,8640,]
buildingData['darkelixirstorage']['capacity']=[[0,0,10000],[0,0,20000],[0,0,40000],[0,0,80000],[0,0,150000],[0,0,200000],]
buildingData['darkelixirstorage']['production']=[[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],]
buildingData['darkelixirstorage']['upgrade cost']=[[0,600000,0],[0,1200000,0],[0,1800000,0],[0,2400000,0],[0,3000000,0],[0,3600000,0],]

buildingData['list'].push('Army Camp')
buildingData['number available']['armycamp']=[1,1,2,2,3,3,4,4,4,4,]
buildingData['armycamp']=[]
buildingData['armycamp']['type']="Army"
buildingData['armycamp']['required town hall']=[1,2,3,4,5,6,9,10,]
buildingData['armycamp']['upgrade time']=[5,60,180,480,1440,4320,7200,14400,]
buildingData['armycamp']['upgrade cost']=[[0,250,0],[0,2500,0],[0,10000,0],[0,100000,0],[0,250000,0],[0,750000,0],[0,2250000,0],[0,6750000,0],]

buildingData['list'].push('Barracks')
buildingData['number available']['barracks']=[1,2,2,3,3,3,4,4,4,4,]
buildingData['barracks']=[]
buildingData['barracks']['type']="Army"
buildingData['barracks']['required town hall']=[1,1,1,2,3,4,5,6,7,8,]
buildingData['barracks']['upgrade time']=[1,15,120,240,600,960,1440,2880,5760,8640,]
buildingData['barracks']['upgrade cost']=[[0,200,0],[0,1000,0],[0,2500,0],[0,5000,0],[0,10000,0],[0,80000,0],[0,240000,0],[0,700000,0],[0,1500000,0],[0,2000000,0],]

buildingData['list'].push('Dark Barracks')
buildingData['number available']['darkbarracks']=[0,0,0,0,0,0,1,2,2,2,]
buildingData['darkbarracks']=[]
buildingData['darkbarracks']['type']="Army"
buildingData['darkbarracks']['required town hall']=[7,7,8,8,9,9,]
buildingData['darkbarracks']['upgrade time']=[4320,7200,8640,10080,11520,12960,]
buildingData['darkbarracks']['upgrade cost']=[[0,750000,0],[0,1250000,0],[0,1750000,0],[0,2250000,0],[0,2750000,0],[0,3500000,0],]

buildingData['list'].push('Laboratory')
buildingData['number available']['laboratory']=[0,0,1,1,1,1,1,1,1,1,]
buildingData['laboratory']=[]
buildingData['laboratory']['type']="Army"
buildingData['laboratory']['required town hall']=[3,4,5,6,7,8,9,10,]
buildingData['laboratory']['upgrade time']=[30,300,720,1440,2880,5760,7200,8640,]
buildingData['laboratory']['upgrade cost']=[[0,25000,0],[0,50000,0],[0,90000,0],[0,270000,0],[0,500000,0],[0,1000000,0],[0,2500000,0],[0,4000000,0],]

buildingData['list'].push('Spell Factory')
buildingData['number available']['spellfactory']=[0,0,0,0,1,1,1,1,1,1,]
buildingData['spellfactory']=[]
buildingData['spellfactory']['type']="Army"
buildingData['spellfactory']['required town hall']=[5,6,7,9,10,]
buildingData['spellfactory']['upgrade time']=[1440,2880,5760,7200,8640,]
buildingData['spellfactory']['production']=[[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],]
buildingData['spellfactory']['upgrade cost']=[[0,200000,0],[0,400000,0],[0,800000,0],[0,1600000,0],[0,3200000,0],]

// if (typeof window !== 'undefined') {
//     window.buildingData = buildingData
// }
// else {
//     module.exports.buildingData = buildingData;
// }