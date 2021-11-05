// app texts
const textSmart = 'Smart';
const textHive = 'hive';
const textTrackHint = 'Track down your bees wherever you are';
const textRegisterLogin = 'Register/Login';
const textStepOne = 'Step 1';
const textStepOneHint = 'Create a hive to start listening to your bees';
const textStepTwo = 'Step 2';
const textStepTwoHint = 'Generate the QR code' /*as an identifier of the hive*/
/* '\n- Scan the code from within the app'
    "\nYou're all set"*/
    ;

const textAbout = 'About';
const textSaveHarvest = 'Save Harvest';
const textHarvestHistory = 'Harvest History';
const textApply = 'Apply';
const textFilters = 'Filters';
const textYear = 'Year';
const textMonth = 'Month';
const textDay = 'Day';
const textAllTime = 'All Time';
const textAll = 'All';
const textCreate = 'Create';
const textGenerateQr = 'Generate QR';
const textClear = 'Clear';
const textAddHiveHint = 'Please scan the Qr code to add a beehive ';
const textScan = 'Scan';
const textScanQr = 'Scan Qr Code';
const textShare = 'Share';
const textHiveNotAdded =
    'This hive is not yet added into our system.\nPlease scan the qr code to start the service';
const textNoAlertsHint =
    'No alerts!\n\nAdd the first alert by pressing + button';
const textDetails = 'Details';
const textProperties = 'Properties';
const textOverview = 'Overview';
const textLogs = 'Logs';

const textAlert = 'ALERT';
const textCreateAlert = 'Create Alert';
const textSaveAlert = 'Save Alert';
const textEditAlert = 'Edit Alert';
const textType = 'Type';
const textHighest = 'Highest';
const textLowest = 'Lowest';
const textEditHive = 'Edit Hive';
const textNA = 'N/A';
const textSave = 'Save';
const textOk = 'Ok';
const textCancel = 'Cancel';
const textLocationSettings = 'Location Settings';
const textAppSettings = 'App Settings';
const textAddBees = "Add Bees";
const textAdd  = "Add";
const textRemove  = "Remove";
const textStop  = "Stop";

// chart titles
const textTemperature = 'Temperature (°C)';
const textWeight = 'Weight (g)';
const textPopulation = 'Population';

// app texts - overview
const textName = 'Name';
const textHiveType = 'Hive Type';
const textInstallationDate = 'Installation Date';
const textColonyAge = 'Colony Age';
const textSpecies = 'Species';
const textLocation = 'Location';
const textOther = 'Other';

// textFields  hints
const hintUsername = 'username';
const hintPassword = 'password';

// page settings
const settingHome = 'Home';
const settingRegistration = 'Registration';
const settingSplash = 'Splash';

// page names
const farm = 'My Farm';
const analysis = 'Analysis';
const alerts = 'Alerts';
const profile = 'Profile';
const navigation = 'Navigation';
const settings = 'Settings';
const notifications = 'Notifications';

// data type
const typeTemperature = 'Temperature';
const typeHumidity = 'Humidity';
const typePopulation = 'Population';
const typeSwarming = 'Swarming';
const typeWeight = 'Weight';

// alerts message
const alertWeight = 'Beehive weight has decreased by 4000g.'
    '\nWe highly recommend you to check your hive location.'
    '\nThis might be a robbery!!';
const alertTempHigh = 'Beehive temperature is very High.'
    '\nPlease check your hive location.';
const alertTempLow = 'Beehive temperature is too low.'
    '\nPlease check your hive location.';

// buttons texts
const btTurnOff = 'Turn Off';
const btRemove = 'remove';
const btChange = 'change';
const btClear = 'Clear';

/// hive logs
const logGeneral = 'General';
const logTreatment = 'Treatment';

/// hive logs - queen
//<editor-fold desc='queen'>
const logQueen = 'Queen';
// queen marking
const logQueenMarking = 'Marking';
const logQueenMarkingTip = 'Marking';
const logOneSix = '1 or 6';
const logTwoSeven = '2 or 7';
const logThreeEight = '3 or 8';
const logFourNine = '4 or 9';
const logFiveZero = '5 or 0';
const logQueenMarkingInfo =
    'Queen marking involves placing a contrasting spot of'
    ' colored paint on the top of her torax.';

// queen status
const logQueenStatus = 'Queen Status';
const logQueenRight = 'Queenright';
const logQueenLess = 'Queenless';
const logTimeToReQueen = 'Time To Requeen';
const logQueenReplaced = 'Queen Replaced';
const logQueenStatusInfo = 'Your colony\'s queen status.';

// queen wings
const logQueenWings = 'Wings';
const logQueenWingsClipped = 'Wings Clipped';
const logQueenWingsNotClipped = 'Wings Not Clipped';
const logQueenWingsInfo =
    'Clipping the queen bee\'s wings involves snipping 1/4th of'
    ' an inch pr 6 mm of one or both wings using specialized'
    ' clippers or small scissors, such as fingernail scissors.';

// queen cells
const logCells = 'Cells';
const logCellEmergency = 'Emergency';
const logCellSupersedure = 'Supersedure';
const logCellSwarm = 'Swarm';
const logCellLayingWorker = 'Laying Worker';
const logCellDrone = 'Drone';
const logCellYoungestBrood = 'Youngest Brood';
const logCellSupersedureInfo =
    'Supersedure cells are queen cells usually found in the'
    ' center of brood frames. Worker bees create supersedure'
    ' cells when the queen pheromone weakens due to age or'
    ' illness. The first queen to emerge from the cells will usually'
    ' become the new queen.';
const logCellSwarmInfo =
    'Swarm cells are queen cells formed in strong colonies as a '
    ' natural wat of reproduction at rhe colony level. When these'
    ' cells are capped, the current queen leaves the hive with half'
    ' the workers to establish a new colony.';
const logCellLayingWorkerInfo =
    'The humber of laying worker cells you found during'
    ' inspection.';
const logCellDroneInfo =
    'The humber of drone cells you found during inspection.';
const logCellYoungestBroodInfo =
    'The youngest type of brood you found during inspection.';

// queen swarm status
const logSwarmStatus = 'Swarm Status';
const logNotSwarming = 'Not Swarming';
const logPreSwarming = 'Pre Swarming';
const logSwarming = 'Swarming';
const logSwarmStatusInfo =
    'Whether your colony is swarming, preparing to swarm, or none.';

// queen excluder
const logQueenExcluder = 'Queen Excluder';
const logExcluder = 'Excluder';
const logNoExcluder = 'No $logExcluder';
const logQueenExcluderInfo =
    'A queen excluder is a perforated barrier placed between'
    ' the brood chamber and the honey super that prevents'
    ' the queen from entering the honey super and laying eggs.'
    '\nBrood in honey supers means extra care is required when'
    ' harvesting honey, particularly in commercial operations.'
    '\nExcluders assist with colony management by confining the'
    ' queen to a specific part of the hive.';
//</editor-fold>

/// hive logs - harvests
//<editor-fold des='harvests'>
const logHarvests = 'Harvests';
const logBeeswax = 'Beeswax';
const logHoneycomb = 'Honeycomb';
const logHoney = 'Honey';
const logPollen = 'Pollen';
const logPropolis = 'Propolis';
const logRoyalJelly = 'Royal Jelly';
const logG = 'g';
const logKg = 'kg';
const logOz = 'oz';
const logLbs = 'lbs';
const logFrames = 'frames';

//</editor-fold>

/// hive logs - feeds
//<editor-fold des='feeds'>
const logFeeds = 'Feeds';
const logSyrup = 'Syrup';
const logSyrupHeavy = 'Heavy';
const logSyrupLight = 'Light';
const logPatty = 'Patty';
const logProtein = 'Protein';
const logProbiotics = 'Probiotics';
const logSyrupHeavyInfo =
    'Heavy syrup or fall syrup is made from 2 parts sugar to'
    ' one part water. Heavy syrup is used when bees don\'t have'
    ' sufficient access to natural food sources.';
const logSyrupLightInfo =
    'Light syrup or spring syrup is 1 part sugar to 1 part water'
    ' by either weight or volume. Light syrup is used when bees'
    ' don\'t have sufficient access to natural food sources.';
const logPattyPollenInfo =
    'Pollen patties are a food source for bees made from pollen.'
    ' Patties provide a supplement to natural sources when'
    ' needed tha can help your colony grow and thrive in the'
    ' long term.';
const logPattyProteinInfo =
    'Protein patties are a food source for bees made from'
    ' various formulas. Protein patties provide an early Spring'
    ' supplement to help stimulate the queen to produce brood.';
const logProbioticsInfo =
    'Probiotic bee supplements are beneficial microorganisms'
    ' known for promoting intestinal and immune support.'
    '\nProbiotics are used to stave off common bacterial'
    ' hive infestations.';
//</editor-fold>

//<editor-fold des='treatment'>
const logFoulBrood = 'Foulbrood';
const logTerraPatties = 'Terra-Patties';
const logTerraPro = 'Terra-Pro';
const logTerramycin = 'Terramycin';
const logTetraBeeMix = 'Tetra Bee Mix';
const logTylan = 'Tylan';

const logHiveBeetles = 'Hive Beetles';
const logDiatomacsiousEarth = 'Diatomacsious Earth';
const logGardStar = 'GardStar';
const logPermethrinSFR = 'Permethrin SFR';
const logNosema = 'Nosema';
const logFumidilB = 'Fumidil-B';
const logTrachealMites = 'Tracheal Mites';
const logMiteAThol = 'Mite-A-Thol';
const logVarroaMites = 'Varroa Mites';
const logAmitraz = 'Amitraz';
const logApiBioxal = 'Api-Bioxal';
const logApiGuard = 'Apiguard';
const logApiStan = 'Apistan';
const logApiVarStrips = 'Apivar Strips';
const logCheckMite = 'Check Mite';
const logDroneComb = 'Drone Comb';
const logFormicPro = 'Formic Pro';
const logHopGuard = 'HopGuard';
const logMiteAway = 'Mite Away';
const logMiteStrips = 'Mite Strips';
const logOxalicAcidFumigate = 'Oxalic Acid - Fumigate';
const logOxalicAcidDrip = 'Oxalic Acid - Drip';
const logOxalicAcidGlycerine = 'Oxalic Acid - Glycerine';
const logOxyBee = 'Oxybee';
const logTactic = 'Tactic';
const logWaxMoths = 'Wax Moths';
const logB401 = 'B401';
const logParaMoth = 'Para-Moth';

const logFoulBroodInfo =
    'American foulbrood (AFB) is a bacterial brood disease that results'
    ' from the infection of honey bee larvae with Paenibacillus larvae.'
    ' While it only attacks larvae, AFB weakens the colony and can quickly'
    ' lead to its death in only three weeks.'
    ' AFB is most commonly transmitted through spores of the bacteria,'
    ' which can be dormant in the colonies or used equipment for 70 or more years.'
    ' When nurse bees feed larvae with food contaminated with spores,'
    ' the spores turn into a vegetative stage that replicates in the larval'
    ' tissue leading to its death.'
    ' Larvae killed by these bacteria have a unique "foul" odor that gives'
    ' this brood disease its name.';
const logHiveBeetlesInfo =
    'The small hive beetle is a beekeeping pest. It is endemic to'
    ' sub-Saharan Africa, but has spread to many other locations,'
    ' including North America, Australia, and the Philippines.'
    ' The small hive beetle can be a destructive pest of honey'
    ' bee colonies, causing damage to comb, stored honey, and'
    ' pollen. If a beetle infestation is sufficiently heavy, they may'
    ' cause bees to abandon their hive. Its presence can also'
    ' be a marker in the diagnosis of colony collapse disorder'
    ' for honey bees. The beetles can also be a pest of stored'
    ' combs, and honey (in the comb) awaiting extraction. Beetle'
    ' Larvae may tunnel through combs of honey, feeding and'
    ' defecating, causing discoloration and fermentation of the'
    ' honey.';
const logNosemaInfo = '';
const logTrachealMitesInfo =
    'Russian stocks also have been shown to resist infection by'
    ' tracheal mites (Acarapls woodi). This heritable trait is due to'
    ' hygienic grooming behaviors.';
const logVarroaMitesInfo =
    'Varroa destructor (Varroa mite) is an external parasitic mite'
    ' that attack and feeds on honey bees, The disease caused'
    ' by the mites is called varroosis, The Varroa mite can only'
    ' reproduce in a honey bee colory. It attaches to the body'
    ' of the bee and weakens the bee by sucking fat bodies. The'
    ' species is a vector for at least five debilitating bee viruses,'
    ' including RNA viruses such as the deformed wing virus'
    ' (DWV). A significant mite infestation leads to the death of'
    ' a honey bee colony, usually in the late autumn through'
    ' early spring. The Varroa mite is the parasite with possibly'
    ' the most pronounced economic impact on the beekeeping'
    ' industry. Varroa is considered to be one of multiple stress'
    ' factors contributing to the higher levels of bee losses'
    ' around the world.';
const logWaxMothsInfo = 'Waxworms are the caterpillar are of mex mecs'
    ' which belong to the family Pyralisas (smout moths). TWO'
    ' closely related species are commercially brad - the lesser'
    ' wax moth (Achroia grisella) and the greater wa math'
    ' (Galleria mellonella). They belong to the unibe Galleriini'
    ' in the snout moth subfamily Gallerinae. Another species'
    ' whose larvae share that name is the lindiam mealmoth'
    ' (Plodia interpunctella), though this species is not available'
    ' commercially.';
//</editor-fold>

// Species
const spMelifera = 'Apis Melifera';
const spCaucasia = '$spMelifera caucasia';
const spCamica = '$spMelifera camica';
const spIgustica = '$spMelifera igustica';
const spMeliferaMelifera = '$spMelifera melifera';
const spScutellata = '$spMelifera scutellata';

// hive types
const htLangstroth = 'Langstroth';
const htWarre = 'Warre';
const htTopBar = 'Top Bar';

// months
const textJan = 'January';
const textFeb = 'February';
const textMar = 'March';
const textApr = 'April';
const textMay = 'May';
const textJun = 'June';
const textJul = 'July';
const textAug = 'August';
const textSep = 'September';
const textOct = 'October';
const textNov = 'November';
const textDec = 'December';

// location
const textGetLocation = "Get Location";
const textUseMyLocation = "Use My Location";
const serviceDisabled = 'Location Service Disabled';
const permissionDenied = 'Permission Denied';

// swarming tips
const textHiveNotSwarming = 'Hive is not swarming. All good';
const textHiveSwarming = 'Hive is swarming!!';
const textBeekeeperTips = 'Beekeeper Tips';
const textReasons = 'Primary reasons for swarming';
const textReasons1 = 'Reproduction.';
const textReasons2 = 'Space problems.';
const textReasons3 = 'Poor performing queen.';
const textReasonsExplanation =
    'A poor performing queen might contribute to the urge of swarming, '
    'but the most pressing reasons are space issues and overcrowding leading '
    'to congestion and poor ventilation.';
const textAvoidCongestion = 'How to avoid congestion?';
const textAvoidCongestion1 =
    'Anticipate the needs of the colony and provide them with more room before the need it.';
const textAvoidCongestion2 =
    'Add honey supers before the first nectar flow in early spring.';
const textGoodVentilation = 'How to help bees to have a good ventilation?';
const textGoodVentilation1 =
    'Keep the ventilation hole in the front of the inner cover open.';
const textGoodVentilation2 =
    'Drill some holes in the upper deep and in the honey supers.';
const textGoodVentilation3 = 'In case of hot weather:';
const textHotWeather1 =
    'Make sure to have a nearby water source, where bees can easily access water. '
    'Bees need water to monitor the temperature in the hive.';
const textHotWeather2 =
    'If the hive is completely exposed to sunlight, help bees to get some shadow on hot days by providing a shield.';
const textRecommendations = 'Additional recommendations to prevent swarming';
const textDo = 'Do';
const textDoNot = 'Do Not';
const textDo1 =
    'If you don’t rely on local bees and want to choose a particular bee race, '
    'then you can choose a race that is less inclined to swarming. '
    'Keep in mind the downsides of these races, though. Read also our Guide to bee races.';
const textDo2 =
    'Create new appealing homes close to the original hive by placing for example '
    'empty hives in the surrounding environment. In this way, swarming colonies might just move '
    'to another hive and you don’t lose them.';
const textDo3 =
    'Make a split yourself. Leave the queen cells in the original hive and put '
    'the old queen and half of the colony in a new hive5.';
const textDoNot1 = 'Do not cut the internal wings of the queen bee. '
    'The queen, when walking out of the hive to start the swarm, '
    'falls on the ground and dies as she is unable to fly. '
    'Some beekeepers do this to keep the colony in the hive. '
    'We don’t consider it an ethical solution for queen bees.';
const textDoNot2 = 'If possible try to avoid crush barriers. '
    'These are grids made of metal or plastic with holes that allow '
    'only the smaller worker bees to pass through. Drones and queens '
    'cannot pass these grids. This significantly restricts the queen’s '
    'movements and leads to unnatural behaviour that can be harmful to the whole colony.';
const textDoNot3 = 'If possible due to local and personal conditions, '
    'try not to destroy the queen cells. We know that this sounds like '
    'a simple way to prevent swarming, but it does not reduce the urge '
    'to swarm in general. Bees just build more queen cells and sooner '
    'or later you might miss one and the bees swarm out.';
const textRaces =
    'Are there bee races that are more inclined to swarming than others?';
const textRaces1 =
    'Races with low inclination to swarming: Caucasian and Buckfast';
const textRaces2 =
    'Races with medium inclination to swarming: Italian, German, Cordovan and Russian';
const textRaces3 =
    'Races with excessive inclination to swarming: Carniolan, African and Africanized.';
const textLess = 'Less';
const textMore = 'More';