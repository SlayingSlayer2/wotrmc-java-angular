-- Fiefdoms (lightweight, no triggers)
CREATE TABLE IF NOT EXISTS fiefdoms (
  code            TEXT PRIMARY KEY,
  waypoint_code   TEXT NOT NULL REFERENCES waypoints(code) ON DELETE RESTRICT,
  display_name    TEXT,
  realm_code      TEXT NOT NULL REFERENCES realms(code) ON DELETE RESTRICT,
  lord_name       TEXT,
  banner          TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Seed fiefdoms
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('AndrathMan','andrathForests','Andrath','DunedainRanger','','andrath');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('AnnuminasMan','ANNUMINAS','Annuminas','DunedainRanger','','annuminas');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('ArakanunaiMan','arakanunai','Arakanunai','TaiyobuMan','','arakanunai');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('BaranduinMan','aranbad','Baranduin','CardolanMan','','baranduin');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('BardhavenMan','DALE_PORT','Bardhaven','DaleMan','','bardhaven');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('BightenMan','EAST_BIGHT','Bighten','DolGuldurOrc','','bighten_man');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('BlacklocksDwarf','xiao','Blacklocks','WickedDwarf','','blacklocks');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('BruinenElf','FORD_BRUINEN','Bruinen','RivendellElf','','rivendell');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('CairAndrosMan','CAIR_ANDROS','Cair Andros','AnorienMan','','cair_andros');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('CarnDumUruk','CARN_DUM','Carn Dum','AngmarOrc','','carn_dum');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('CelebrantElf','FIELD_OF_CELEBRANT','Celebrant','LothlorienElf','','celebrant');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('ColdfellsOrc','riverMitheithel','Coldfells','AngmarOrc','','coldfells');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('DainsHallsDwarf','DAINS_HALLS','Dain''s Halls','EreborDwarf','','dains_halls');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('DorEnErnilMan','brondost','Dor-En-Ernil','DolAmrothMan','','dor_en_ernil');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('EdhellondMan','EDHELLOND','Edhellond','DolAmrothMan','','edhellond');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('EmynWinionElf','DORWINION_HILLS','Emyn Winion','DorwinionElf','','emyn_winion');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('EngrinValeDwarf','engrinVale','Engrin Vale','IronHillsDwarf','','engrin_vale');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('EphelAngmarOrc','mountAngmar','Ephel Angmar','AngmarOrc','','ephel_angmar');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('ErynVornMan','ERYN_VORN','Eryn Vorn','CardolanMan','','eryn_vorn');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('EthringMan','ETHRING','Ethring','LamedonMan','','ethring');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('EttenmoorsOrc','ettenmoors','Ettenmoors','AngmarOrc','','ettenmoors');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('FalathrimElf','HIMLING','Falathrim','SindarElf','','falathrim');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('ForlondElf','FORLOND','Forlond','LindonElf','','forlond');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('FornostMan','FORNOST','Fornost','LonelandsRanger','','fornost');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('FramsburgMan','FRAMSBURG','Framsburg','AnduinMan','','framsburg');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('GlamhothMan','glamhold','Glamhoth','MordorOrc','','glamhoth');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('GreyCompanyRanger','lakeEvendim','Grey Company','DunedainRanger','','grey_company');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('HighlandsUruk','URUK_HIGHLANDS','Highlands Uruk','IsengardUruk','','highlands_uruk');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('ImladrisElf','highMoor','Imladris','RivendellElf','','rivendell');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('ImlothMeluiMan','IMLOTH_MELUI','Imloth Melui','LossarnachMan','','imloth_melui');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('IthilienWastelandsRanger','NORTH_ITHILIEN','Ithilien Wastelands','IthilienRanger','','ithilien_wastelands');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('Jinorocarn','jinorocarn','Jinorocarn','IronfistsDwarf','','jinorocarn');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('LaeglondElf','loeglond','Laeglond','WoodlandRealmElf','','laeglond');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('LaketownMan','LONG_LAKE','Lake-town','DaleMan','','laketown');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('LinhirMan','LINHIR','Linhir','LebenninMan','','linhir');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('MirulondElf','DORWINION_PORT','Mirulond','DorwinionElf','','mirulond');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('MountGramUruk','MOUNT_GRAM','Mount Gram','GundabadUruk','','mount_gram');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('NanCurunirUruk','ISENGARD','Nan Curunir','IsengardUruk','','nan_curunir');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('NimrodelElf','NIMRODEL','Nimrodel','LothlorienElf','','nimrodel');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('OssiriandElf','ossiriand','Ossiriand','LindonElf','','ossiriand');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('OstInEdhilElf','OST_IN_EDHIL','Ost-in-Edhil','EregionElf','','ost_in_edhil');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('SaralainnMan','liannHall','Saralainn','CardolanMan','','saralainn');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('TaurMorvithOrc','taurmorvith','Taur Morvith','DolGuldurOrc','','taur_morvith');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('TayorriMan','yahaban','Tayorri','TaiyobuMan','','tayorri');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('ThorogrimHalfTroll','OLD_JUNGLE_RUIN','Thorogrim','HalfTroll','','thorogrim');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('VintnerCourtMan','DORWINION_COURT','Vintner Court','DorwinionMan','','vintner_court');
INSERT INTO fiefdoms (code, waypoint_code, display_name, realm_code, lord_name, banner) VALUES ('WestmarchMan','westruin','Westmarch','WestfoldMan','','westmarch');
