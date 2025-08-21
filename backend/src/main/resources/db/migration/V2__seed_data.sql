-- ====================================================================
-- V2__seed_data.sql  (All seed INSERTs only)
-- ====================================================================

-- Helper for the one known alias: WICKED_DWARVES -> BLACKLOCKS
CREATE OR REPLACE FUNCTION normalize_faction_code(p TEXT) RETURNS TEXT
LANGUAGE sql IMMUTABLE AS $$
  SELECT CASE p WHEN 'WICKED_DWARVES' THEN 'BLACKLOCKS' ELSE p END
$$;

-- Minimal example user/biomes/factions (optional seeds you had)
INSERT INTO factions (code, display_name, banner, capital_waypoint, lord_name)
VALUES
('GONDOR','Gondor','gondor','MINAS_TIRITH','Denethor II'),
('ROHAN','Rohan','rohan','EDORAS','Théoden'),
('MORDOR','Mordor','mordor','BARAD_DUR','Sauron')
ON CONFLICT (code) DO UPDATE SET
  display_name=EXCLUDED.display_name,
  banner=EXCLUDED.banner,
  capital_waypoint=EXCLUDED.capital_waypoint,
  lord_name=EXCLUDED.lord_name,
  updated_at=now();

INSERT INTO biome (code,display_name,region,climate,primary_tree,secondary_tree,tags) VALUES
('ANDUIN_VALES','Anduin Vales','Rhovanion','Temperate','Beech','Oak','["RIVER","FORESTED"]'),
('HARAD_DESERT','Red Deserts','Harad','Arid','Acacia','Date Palm','["DESERT"]'),
('EPHEL_DUATH','Ephel Dúath','Mordor','Arid','None','None','["MOUNTAIN","BARREN"]')
ON CONFLICT (code) DO NOTHING;

INSERT INTO faction_biome (faction_code, biome_id, control)
SELECT 'GONDOR', id, 'CONTROLLED'::control_level FROM biome WHERE code = 'EPHEL_DUATH'
ON CONFLICT DO NOTHING;

INSERT INTO faction_relations (src_faction, dst_faction, kind) VALUES
('GONDOR','ROHAN','ALLY'),
('GONDOR','MORDOR','MORTAL_ENEMY'),
('ROHAN','MORDOR','ENEMY')
ON CONFLICT (src_faction,dst_faction) DO UPDATE SET kind=EXCLUDED.kind;

INSERT INTO app_user (email, display_name, password_hash, role)
VALUES ('frodo@shire.me','Frodo Baggins','{noop}password','USER')
ON CONFLICT (email) DO NOTHING;

INSERT INTO account_faction (account_id, faction_code, title)
VALUES ((SELECT id FROM app_user WHERE email='frodo@shire.me'), 'GONDOR', 'Messenger')
ON CONFLICT DO NOTHING;

-- =====================
-- Full faction seeds (from Java)
-- =====================
INSERT INTO factions (code, display_name, banner, capital_waypoint, lord_name)
VALUES
  ('AENURIN','Aenurin','aenurin','shiningPort',NULL)
, ('ANGMAR','Angmar','angmar','CARN_DUM',NULL)
, ('AR_ADUNAIM','Ar-adunaim','ar-adunaim','darkhaven',NULL)
, ('AVARI','Avari','avari','trevaari',NULL)
, ('BLACKLOCKS','Wicked Dwarves','wicked_dwarves','burnedMansion',NULL)
, ('BLUE_MOUNTAINS','Blue Mountain Dwarves','blue_mountains','BELEGOST',NULL)
, ('BREE','Bree','bree','BREE',NULL)
, ('CARDOLAN','Cardolan','cardolan','ruinedCardolan',NULL)
, ('CERINRIM','Cerinrim','cerinrim','mazantsi',NULL)
, ('DALE','Dale','dale','DALE_CITY',NULL)
, ('DOL_GULDUR','Dol Guldur','dol_guldur','DOL_GULDUR',NULL)
, ('DORWINION','Dorwinion','dorwinion','DORWINION_PORT',NULL)
, ('DRUEDAIN','Druedain','druedain','EILENACH',NULL)
, ('DUNLAND','Dunland','dunland','NORTH_DUNLAND',NULL)
, ('DURINS_FOLK','Durin''s Folk','durin','EAST_PEAK',NULL)
, ('EREBOR','Erebor','erebor','EREBOR',NULL)
, ('EREGION','Eregion','eregion','OST_IN_EDHIL',NULL)
, ('FANGORN','Fangorn','fangorn','TREEBEARD_HILL',NULL)
, ('FOROCHEL_ORC','Forochel Orcs','forochel_orcs','fatoftKul',NULL)
, ('GONDOR','Gondor','gondor','MINAS_TIRITH',NULL)
, ('GUNDABAD','Gundabad','gundabad','MOUNT_GUNDABAD',NULL)
, ('HALF_TROLL','Half-trolls','half_troll','gorrind',NULL)
, ('HARAD_DWARF','Harad Dwarves','harad_dwarf','MOUNT_SAND',NULL)
, ('HIGH_ELF','High Elves','high_elf','AMON_EREB',NULL)
, ('HOBBIT','Hobbit','hobbit','MICHEL_DELVING',NULL)
, ('ISENGARD','Isengard','isengard','ISENGARD',NULL)
, ('JINZHUN','Jinzhun','jinzhun','inzhuun',NULL)
, ('KARAVALI','Karavali','karavali','khera',NULL)
, ('KHAND','Khand','khand','bekElma',NULL)
, ('KHAZAD_DUM','Khazad-dum','khazad_dum','MOUNT_CARADHRAS',NULL)
, ('LIMWAITH','Limwaith','limwaith','ikkilAht',NULL)
, ('LOGATHRIM','Logathrim','logath','minasseHatal',NULL)
, ('LOSSOTH','Lossoth','lossoth','helcaMinasse',NULL)
, ('LOTHLORIEN','Lothlorien','lothlorien','CARAS_GALADHON',NULL)
, ('MAHUDUIN','Mahuduin','mahuduin','haudhShivajine',NULL)
, ('MEN_OF_ANDUIN','Men of Anduin','men_of_anduin','OLD_FORD',NULL)
, ('MORDOR','Mordor','mordor','BARAD_DUR',NULL)
, ('MORTAURRI','Mortaurri','mortauri','ivienu',NULL)
, ('MORWAITH','Morwaith','morwaith','GREAT_PLAINS_EAST',NULL)
, ('NEAR_HARAD','Near Harad','near_harad','FERTILE_VALLEY',NULL)
, ('NGOAIRU','N''goairu','ngoairu','ngoai',NULL)
, ('OROCARNI','Orocarni','orocarni','BARAZ_DUM',NULL)
, ('PARALIAKOS','Paraliakos','paraliakos','liakoIslands',NULL)
, ('PROSHYVIL','PROSHYVIL','PROSHYVIL','grondyvil',NULL)
, ('QASINADRIM','Qasinadrim','qasinadrim','hallasholm',NULL)
, ('RANGER_NORTH','Dunedain Rangers','dunedain_ranger','theAngle',NULL)
, ('RHUDEL','Rhudel','rhudel','RHUN_CAPITAL',NULL)
, ('ROHAN','Rohan','rohan','EDORAS',NULL)
, ('STONEFOOTS','Stonefoots','stonefoots','regno',NULL)
, ('TAITAE','Ta''itae','taitae','myaotyk',NULL)
, ('TAIYOBU','Taiyobu','taiyobu','korotoyo',NULL)
, ('TAURETHRIM','Taurethrim','taurethrim','JUNGLE_CITY_CAPITAL',NULL)
, ('UDDARI','Uddari','uddari','saurrung',NULL)
, ('VARILLESRA','Varillesra','varillesra','paramakudi',NULL)
, ('VSEGO','Vsego','vsego','jinalOrn',NULL)
, ('WOOD_ELF','Woodland Realm','WOOD_ELF','THRANDUIL_HALLS',NULL)
ON CONFLICT (code) DO UPDATE SET
  display_name     = EXCLUDED.display_name,
  banner           = EXCLUDED.banner,
  capital_waypoint = EXCLUDED.capital_waypoint,
  lord_name        = EXCLUDED.lord_name,
  updated_at       = now();

-- Realms seeds
INSERT INTO realms (code, display_name, banner, capital_waypoint, lord_name) VALUES
('AdornlandMan','Adornland','adornland','FRECA_HOLD',NULL),
('AenurinMan','Aenurin','aenurin','shiningPort',NULL),
('AndrastMan','Andrast','andrast','cairAndrast',NULL),
('AnduinMan','Anduin','men_of_anduin','OLD_FORD',NULL),
('AnfalasMan','Anfalas','anfalas','portOfLangordui',NULL),
('AngmarOrc','Angmar','angmar','CARN_DUM',NULL),
('AnorienMan','Anorien','anorien','CAIR_ANDROS',NULL),
('ArAdunaimMan','Ar-adunaim','ar-adunaim','darkhaven',NULL),
('AvariElf','Avari','avari','trevaari',NULL),
('BagginsHobbit','Baggins','baggins','HOBBITON',NULL),
('BalchothMan','Balchoth','balchoth','burzRoth',NULL),
('Beorning','Beorning','beorning','BEORN',NULL),
('BlackrootValeMan','Blackroot Vale','blackroot_vale','ERECH',NULL),
('BlackUruk','Black Uruks','black_uruk','SEREGOST',NULL),
('BlueDwarf','Blue Mountains','blue_mountains','BELEGOST',NULL),
('BreeHobbit','Bree Hobbits','breehobbit','STADDLE',NULL),
('BreeMan','Bree Men','bree','BREE',NULL),
('BroadbeamsDwarf','Broadbeams','broadbeams','THRAIN_HALLS',NULL),
('BucklandHobbit','Buckland','buckland','BUCKLEBURY',NULL),
('CardolanMan','Cardolan','cardolan','ruinedCardolan',NULL),
('CerinrimMan','Cerinrim','cerinrim','mazantsi',NULL),
('ChelkarMan','Chelkar','chelkar','chelherem',NULL),
('CoastSouthronMan','Coast Southron','near_harad','FERTILE_VALLEY',NULL),
('CorsairOfUmbar','Corsair','corsair','azzatar',NULL),
('CuivienenElf','Cuivienen','cuivienen','cuivanari',NULL),
('DaleMan','Dale','dale','DALE_CITY',NULL),
('DolAmrothMan','Dol Amroth','dol_amroth','DOL_AMROTH',NULL),
('DolGuldurOrc','Dol Guldur','dol_guldur','DOL_GULDUR',NULL),
('DorwinionElf','Dorwinion Elves','dorwinion','DORWINION_PORT',NULL),
('DorwinionMan','Dorwinion','dorwinion','DORWINION_COURT',NULL),
('DruedainMan','Druedain','druedain','EILENACH',NULL),
('DruethirrimMan','Druethirrim','druethirrim','MOUTHS_ISEN',NULL),
('DruwaithIaurMan','Druwaith Iaur','druwaithiaur','jurraur',NULL),
('DunedainRanger','Dunedain','dunedain_ranger','theAngle',NULL),
('DunharrowMan','Dunharrow','dunharrow','DUNHARROW',NULL),
('DunlandMan','Dunland','dunland','NORTH_DUNLAND',NULL),
('EastemnetMan','Eastemnet','eastemnet','EASTMARK',NULL),
('EasternDesolationUruk','Desolation Uruks','desolation_uruk','rothKatund',NULL),
('EastfoldMan','Eastfold','rohan','EDORAS',NULL),
('ElvenWanderer','Elven Wanderers','elven_wanderer','OLD_ELF_WAY',NULL),
('EnedwaithMan','Enedwaith','enedwaith','ostduunarath',NULL),
('EreborDwarf','Erebor','erebor','EREBOR',NULL),
('EregionElf','Eregion','eregion','OST_IN_EDHIL',NULL),
('FangornEnt','Fangorn','fangorn','TREEBEARD_HILL',NULL),
('ForochelOrc','Forochel Orcs','forochel_orcs','fatoftKul',NULL),
('GondorMan','Gondor','gondor','MINAS_TIRITH',NULL),
('GreenwoodElf','Greenwood Elves','greenwood_elves','emynLum',NULL),
('GulfSouthronMan','Gulfing Southrons','harad_gulf','GULF_CITY',NULL),
('GundabadOrc','Gundabad Orcs','gundabad','SCATHA',NULL),
('GundabadUruk','Gundabad Uruks','gundabad','MOUNT_GUNDABAD',NULL),
('HalfTroll','Half-trolls','half_troll','gorrind',NULL),
('HaradDwarf','Harad Dwarves','harad_dwarf','MOUNT_SAND',NULL),
('HaradNomad','Harad Nomads','harad_nomad','dunesOfTheGreatDesert',NULL),
('HarlindonElf','Harlindon','harlindon','HARLOND',NULL),
('HarnennorMan','Harnennor','harnennor','HARNEN_SEA_TOWN',NULL),
('HarondorMan','Harondor','harondor','nallarin',NULL),
('IronfistsDwarf','Ironfists','ironfists','khagaldrim',NULL),
('IronHillsDwarf','Iron Hills','durin','EAST_PEAK',NULL),
('IsengardUruk','Isengard','isengard','ISENGARD',NULL),
('IthilienRanger','Ithilien','ithilien','HENNETH_ANNUN',NULL),
('JinzhunMan','Jinzhun','jinzhun','inzhuun',NULL),
('KaranolaMan','Karanola','karanola','rhunnaran',NULL),
('KaravaliMan','Karavali','karavali','khera',NULL),
('KhandMan','Khand','khand','bekElma',NULL),
('KhazadDumDwarf','Khazad-dum','khazad_dum','MOUNT_CARADHRAS',NULL),
('LamedonMan','Lamedon','lamedon','CALEMBEL',NULL),
('LebenninMan','Lebennin','lebennin','ostgondhir',NULL),
('LhugathMan','Lhugath','lhugath','minasseHatal',NULL),
('LimwaithMan','Limwaith','limwaith','ikkilAht',NULL),
('LindonElf','Lindon','high_elf','AMON_EREB',NULL),
('LogathMan','Logath','logath','cofFervain',NULL),
('LonelandsRanger','Lone-lands','lone_lands','WEATHERTOP',NULL),
('LossarnachMan','Lossarnach','lossarnach','IMLOTH_MELUI',NULL),
('LossothMan','Lossoth','lossoth','helcaMinasse',NULL),
('LothlorienElf','Lothlorien','lothlorien','CARAS_GALADHON',NULL),
('LuneValleyMan','Lune Valley','lune_valley','lhunPort',NULL),
('MahuduinMan','Mahuduin','mahuduin','haudhShivajine',NULL),
('MirkUruk','Mirk-uruks','mirk_uruk','anugMaudhol',NULL),
('MirkwoodHunter','Mirkwood Hunters','mirkwood_hunter','MIRKWOOD_MOUNTAINS',NULL),
('MistyMountainsGoblin','Misty Goblins','misty_goblins','GOBLIN_TOWN',NULL),
('MithlondElf','Mithlond','mithlond','MITHLOND_NORTH',NULL),
('MolraeenMan','Molraeen','molraeen','molrae',NULL),
('MordorOrc','Mordor','mordor','BARAD_DUR',NULL),
('MorgaiOrc','Morgai','morgai','DURTHANG',NULL),
('MorgulValeOrc','Morgul Vale','minas_morgul','MINAS_MORGUL',NULL),
('MortaurriElf','Mortaurri','mortauri','ivienu',NULL),
('MorthondMan','Morthond','morthond','galenhelm',NULL),
('MorwaithMan','Morwaith','morwaith','GREAT_PLAINS_EAST',NULL),
('NanUngolOrc','Nan Ungol','nan_ungol','VALLEY_OF_SPIDERS',NULL),
('NgoairuMan','N''goairu','ngoairu','ngoai',NULL),
('NuriagMan','Nuriag','nuriag','utotNuriag',NULL),
('NurnOrc','Nurn','nurn_orc','THAURBAND',NULL),
('OrocarniDwarf','Orocarni','orocarni','BARAZ_DUM',NULL),
('ParaliakosMan','Paraliakos','paraliakos','liakoIslands',NULL),
('PelargirMan','Pelargir','pelargir','PELARGIR',NULL),
('PinnathGelinMan','Pinnath Gelin','pinnath_gelin','GREEN_HILLS',NULL),
('ProshloyeMan','Proshyvil','proshyvil','grondyvil',NULL),
('QasinadrimMan','Qasinadrim','qasinadrim','hallasholm',NULL),
('RhovanionMan','Rhovanion','rhovanion','opeleRhovanion',NULL),
('RhudaurHillman','Rhudaur','rhudaur','rhudaurnor',NULL),
('RhudelMan','Rhudel','rhudel','RHUN_CAPITAL',NULL),
('RingloValeMan','Ringlo Vale','ringlo_vale','nendahil',NULL),
('RivendellElf','Rivendell','rivendell','RIVENDELL',NULL),
('RuboorMan','Ruboor','ruboor','theRubooryMansion',NULL),
('SargathMan','Sargath','sargath','theRedFord',NULL),
('ShireHobbit','Shire','hobbit','MICHEL_DELVING',NULL),
('SindarElf','Sindar','sindar','TOL_FUIN',NULL),
('StonefootDwarf','Stonefoots','stonefoots','regno',NULL),
('SyyranniMan','Syyranni','syyranni','arniOrTora',NULL),
('TaitaeMan','Ta''itae','taitae','myaotyk',NULL),
('TaitaeDwarf','Ta''itae Dwarves','taitae','cajjion',NULL),
('TaiyobuMan','Taiyobu','taiyobu','korotoyo',NULL),
('TaurethrimMan','Taurethrim','taurethrim','JUNGLE_CITY_CAPITAL',NULL),
('ThoronriMan','Thoronri','thoronri','JUNGLE_CITY_TRADE',NULL),
('TookHobbit','Took','took','TUCKBOROUGH',NULL),
('UddariMan','Uddari','uddari','saurrung',NULL),
('UmbarMan','Umbar','umbar','UMBAR_CITY',NULL),
('UsrakinMan','Usrakin','usrakin','tsama',NULL),
('VarillesraDwarf','Varillesra','varillesra','paramakudi',NULL),
('VsegoMan','Vsego','vsego','jinalOrn',NULL),
('WainriderMan','Wainriders','wainriders','BALCARAS',NULL),
('WestemnetMan','Westemnet','westemnet','flodgeheld',NULL),
('WestfoldMan','Westfold','westfold','HELMS_DEEP',NULL),
('WickedDwarf','Wicked Dwarves','wicked_dwarves','burnedMansion',NULL),
('WoldMan','Wold','wold','WOLD',NULL),
('WoodlandRealmElf','Woodland Realm','WOOD_ELF','THRANDUIL_HALLS',NULL),
('ZunimlothMan','Zunimloth','zunimloth','mupata',NULL)
ON CONFLICT (code) DO UPDATE SET
  display_name     = EXCLUDED.display_name,
  banner           = EXCLUDED.banner,
  capital_waypoint = EXCLUDED.capital_waypoint,
  lord_name        = EXCLUDED.lord_name;

-- Realm → Faction links
WITH pairs(faction_code, realm_code) AS (
  VALUES
   ('DUNLAND','AdornlandMan'),
   ('AENURIN','AenurinMan'),
   ('GONDOR','AndrastMan'),
   ('MEN_OF_ANDUIN','AnduinMan'),
   ('GONDOR','AnfalasMan'),
   ('ANGMAR','AngmarOrc'),
   ('GONDOR','AnorienMan'),
   ('AR_ADUNAIM','ArAdunaimMan'),
   ('AVARI','AvariElf'),
   ('HOBBIT','BagginsHobbit'),
   ('DOL_GULDUR','BalchothMan'),
   ('MEN_OF_ANDUIN','Beorning'),
   ('GONDOR','BlackrootValeMan'),
   ('MORDOR','BlackUruk'),
   ('BLUE_MOUNTAINS','BlueDwarf'),
   ('BREE','BreeHobbit'),
   ('BREE','BreeMan'),
   ('BLUE_MOUNTAINS','BroadbeamsDwarf'),
   ('HOBBIT','BucklandHobbit'),
   ('CARDOLAN','CardolanMan'),
   ('CERINRIM','CerinrimMan'),
   ('KHAND','ChelkarMan'),
   ('NEAR_HARAD','CoastSouthronMan'),
   ('NEAR_HARAD','CorsairOfUmbar'),
   ('AVARI','CuivienenElf'),
   ('DALE','DaleMan'),
   ('GONDOR','DolAmrothMan'),
   ('DOL_GULDUR','DolGuldurOrc'),
   ('DORWINION','DorwinionElf'),
   ('DORWINION','DorwinionMan'),
   ('DRUEDAIN','DruedainMan'),
   ('DRUEDAIN','DruethirrimMan'),
   ('DRUEDAIN','DruwaithIaurMan'),
   ('RANGER_NORTH','DunedainRanger'),
   ('DUNLAND','DunharrowMan'),
   ('DUNLAND','DunlandMan'),
   ('ROHAN','EastemnetMan'),
   ('MORDOR','EasternDesolationUruk'),
   ('ROHAN','EastfoldMan'),
   ('HIGH_ELF','ElvenWanderer'),
   ('DUNLAND','EnedwaithMan'),
   ('EREBOR','EreborDwarf'),
   ('EREGION','EregionElf'),
   ('FANGORN','FangornEnt'),
   ('FOROCHEL_ORC','ForochelOrc'),
   ('GONDOR','GondorMan'),
   ('WOOD_ELF','GreenwoodElf'),
   ('NEAR_HARAD','GulfSouthronMan'),
   ('GUNDABAD','GundabadOrc'),
   ('GUNDABAD','GundabadUruk'),
   ('HALF_TROLL','HalfTroll'),
   ('HARAD_DWARF','HaradDwarf'),
   ('NEAR_HARAD','HaradNomad'),
   ('HIGH_ELF','HarlindonElf'),
   ('NEAR_HARAD','HarnennorMan'),
   ('NEAR_HARAD','HarondorMan'),
   ('OROCARNI','IronfistsDwarf'),
   ('DURINS_FOLK','IronHillsDwarf'),
   ('ISENGARD','IsengardUruk'),
   ('GONDOR','IthilienRanger'),
   ('JINZHUN','JinzhunMan'),
   ('RHUDEL','KaranolaMan'),
   ('KARAVALI','KaravaliMan'),
   ('KHAND','KhandMan'),
   ('KHAZAD_DUM','KhazadDumDwarf'),
   ('GONDOR','LamedonMan'),
   ('GONDOR','LebenninMan'),
   ('LOGATHRIM','LhugathMan'),
   ('LIMWAITH','LimwaithMan'),
   ('HIGH_ELF','LindonElf'),
   ('LOGATHRIM','LogathMan'),
   ('RANGER_NORTH','LonelandsRanger'),
   ('GONDOR','LossarnachMan'),
   ('LOSSOTH','LossothMan'),
   ('LOTHLORIEN','LothlorienElf'),
   ('RANGER_NORTH','LuneValleyMan'),
   ('MAHUDUIN','MahuduinMan'),
   ('DOL_GULDUR','MirkUruk'),
   ('DOL_GULDUR','MirkwoodHunter'),
   ('GUNDABAD','MistyMountainsGoblin'),
   ('HIGH_ELF','MithlondElf'),
   ('MORWAITH','MolraeenMan'),
   ('MORDOR','MordorOrc'),
   ('MORDOR','MorgaiOrc'),
   ('MORDOR','MorgulValeOrc'),
   ('MORTAURRI','MortaurriElf'),
   ('GONDOR','MorthondMan'),
   ('MORWAITH','MorwaithMan'),
   ('MORDOR','NanUngolOrc'),
   ('NGOAIRU','NgoairuMan'),
   ('RHUDEL','NuriagMan'),
   ('MORDOR','NurnOrc'),
   ('OROCARNI','OrocarniDwarf'),
   ('PARALIAKOS','ParaliakosMan'),
   ('GONDOR','PelargirMan'),
   ('GONDOR','PinnathGelinMan'),
   ('PROSHYVIL','ProshloyeMan'),
   ('QASINADRIM','QasinadrimMan'),
   ('DALE','RhovanionMan'),
   ('ANGMAR','RhudaurHillman'),
   ('RHUDEL','RhudelMan'),
   ('GONDOR','RingloValeMan'),
   ('HIGH_ELF','RivendellElf'),
   ('PROSHYVIL','RuboorMan'),
   ('LOGATHRIM','SargathMan'),
   ('HOBBIT','ShireHobbit'),
   ('HIGH_ELF','SindarElf'),
   ('STONEFOOTS','StonefootDwarf'),
   ('MORWAITH','SyyranniMan'),
   ('TAITAE','TaitaeMan'),
   ('TAITAE','TaitaeDwarf'),
   ('TAIYOBU','TaiyobuMan'),
   ('TAURETHRIM','TaurethrimMan'),
   ('TAURETHRIM','ThoronriMan'),
   ('HOBBIT','TookHobbit'),
   ('UDDARI','UddariMan'),
   ('NEAR_HARAD','UmbarMan'),
   ('CERINRIM','UsrakinMan'),
   ('VARILLESRA','VarillesraDwarf'),
   ('VSEGO','VsegoMan'),
   ('RHUDEL','WainriderMan'),
   ('ROHAN','WestemnetMan'),
   ('ROHAN','WestfoldMan'),
   (normalize_faction_code('WICKED_DWARVES'),'WickedDwarf'),
   ('ROHAN','WoldMan'),
   ('WOOD_ELF','WoodlandRealmElf'),
   ('TAURETHRIM','ZunimlothMan')
)
INSERT INTO faction_realms (faction_code, realm_code)
SELECT normalize_faction_code(faction_code), realm_code
FROM pairs
ON CONFLICT (faction_code, realm_code) DO NOTHING;
