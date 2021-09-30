import 'package:smart_beehive/composite/assets.dart';

import 'alert.dart';

class HiveProperties {
  double? temperature = 37.5;
  double? humidity = 85;
  double? weight = 5.5;
  int? population = 2000;
  List<Alert>? alerts = [
    Alert(t: AlertType.TEMPERATURE, lb: 35.1, ub: 39, sv: svgCelsius),
    Alert(t: AlertType.HUMIDITY, lb: 70, ub: 150, sv: svgHumidity),
  ];
}
