import 'package:solardata/solar_data/solar_prototype.dart';

class VHFModel {
  SolarPrototype solarPrototype;
  static List<VHFConditionsPrototype> listVHFConditions;
  String _auroraLatVal;
  String _auroraVal;
  String _europeVal;
  String _northAmericaVal;
  String _europee6mVal;
  String _europe4mVal;

  VHFModel(SolarPrototype solarPrototype) {
    this.solarPrototype = solarPrototype;
    listVHFConditions = solarPrototype.listVHFConditions;
    print('16 ');
    print(listVHFConditions.length);
    for (int i = 0; i < listVHFConditions.length; i++) {
      print(listVHFConditions[i].name +
          "  location: " +
          listVHFConditions[i].location +
          " value: " +
          listVHFConditions[i].value);
      if (listVHFConditions[i].name.contains("latdegree")) {
        _auroraLatVal = listVHFConditions[i].value;
      } else if (listVHFConditions[i].name.contains("vhf-aurora")) {
        _auroraVal = listVHFConditions[i].value;
      } else if (listVHFConditions[i].location.contains("6m")) {
        _europee6mVal = listVHFConditions[i].value;
      } else if (listVHFConditions[i].location.contains("4m")) {
        _europe4mVal = listVHFConditions[i].value;
      } else if (listVHFConditions[i].location.contains("europe")) {
        _europeVal = listVHFConditions[i].value;
      } else if (listVHFConditions[i].location.contains("north_america")) {
        _northAmericaVal = listVHFConditions[i].value;
      }
    }
  }

  String get europe4mVal => _europe4mVal;

  set europe4mVal(String value) {
    _europe4mVal = value;
  }

  String get europee6mVal => _europee6mVal;

  set europee6mVal(String value) {
    _europee6mVal = value;
  }

  String get northAmericaVal => _northAmericaVal;

  set northAmericaVal(String value) {
    _northAmericaVal = value;
  }

  String get europeVal => _europeVal;

  set europeVal(String value) {
    _europeVal = value;
  }

  String get auroraVal => _auroraVal;

  set auroraVal(String value) {
    _auroraVal = value;
  }

  String get auroraLatVal => _auroraLatVal;

  set auroraLatVal(String value) {
    _auroraLatVal = value;
  }
}
