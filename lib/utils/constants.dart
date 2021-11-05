const errorLocationServiceDisabled = 'Location services are disabled.';
const errorLocationPermissionDenied = 'Location permissions are denied';
const errorLocationPermissionDeniedForEver =
    'Location permissions are permanently denied, we cannot request permissions.';

// firestore collections
const collectionBeekeeper = 'Beekeeper';
const collectionHives = 'Hives';
const collectionOverview = 'Overview';
const collectionProperties = 'Properties';
const collectionLogs = 'Logs';

// firestore - Beekeeper
const fieldDeviceToken = 'deviceToken';
const fieldId = 'ID';
const fieldHiveId = 'HiveID';
const fieldOverviewId = 'OverviewID';
const fieldPropertiesId = 'PropertiesID';
const fieldLogsId = 'LogsID';
const fieldKeeperId = 'KeeperID';
const fieldUsername = 'username';
const fieldPassword = 'password';
const fieldImage = 'image';
const fieldHives = 'hives';

// firestore - Beehive
const fieldOverview = 'overview';
const fieldProperties = 'properties';
const fieldLogs = 'logs';
const fieldSwarming = 'swarming';

// firestore - overview
const fieldName = 'name';
const fieldType = 'type';
const fieldSpecies = 'species';
const fieldLocation = 'location';
const fieldDate = 'date';
const fieldPosition = 'position';

// firestore - properties
const fieldTemperature = 'temperature';
const fieldHumidity = 'humidity';
const fieldWeight = 'weight';
const fieldPopulation = 'population';
const fieldAlerts = 'alerts';
const fieldLastFiveTemperature = 'temperature_5';
const fieldLastFiveWeight = 'weight_5';
const fieldLastFiveHumidity = 'humidity_5';
const fieldLastFivePopulation = 'population_5';
const fieldDailyFiveTemperature = 'temperature_day';
const fieldDailyFiveWeight = 'weight_day';
const fieldDailyFiveHumidity = 'humidity_day';
const fieldDailyFivePopulation = 'population_day';


// firestore - logs
const fieldQueen = 'queen';
const fieldHarvest = 'harvests';
const fieldFeeds = 'feeds';
const fieldTreatment = 'treatment';

// firestore - logs - queen
const fieldStatus = 'status';
const fieldWingsClipped = 'wingsClipped';
const fieldMarking = 'marking';
const fieldSwarmStatus = 'swarmStatus';
const fieldQueenExcluder = 'excluder';

// firestore - harvests
const fieldHistory = 'history';
const fieldValue = 'value';
const fieldUnit = 'unit';
const fieldBeeswax = 'beeswax';
const fieldHoneyComb = 'honeyComb';
const fieldHoney = 'honey';
const fieldPollen = 'pollen';
const fieldPropolis = 'propolis';
const fieldRoyalJelly = 'royalJelly';

// firestore - feeds
const fieldSyrup = 'syrup';
const fieldPatty = 'patty';
const fieldProbiotics = 'probiotics';

//firestore - treatment
const fieldTreatments = 'treatments';
const fieldFoulBrood = 'foulBrood';
const fieldHiveBeetles = 'hiveBeetles';
const fieldNosema = 'nosema';
const fieldTrachealMites = 'trachealMites';
const fieldVarroaMites = 'varroaMites';
const fieldWaxMoths = 'waxMoths';
const fieldDescription = 'description';
const fieldChecked = 'isChecked';

// firestore - alert
const fieldLowerBound = 'lowerBound';
const fieldUpperBound = 'upperBound';


// errors
const errorUsernameNotAvailable = 'Username not available!';
const errorSomethingWrong = 'Something went wrong!';
const errorWrongCredentials = 'Wrong Credentials!';
const errorNoAuthToken = 'Auth Token Error';
