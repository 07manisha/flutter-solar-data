import 'package:solardata/solar_data/solar_calculated_condition_model.dart';

class SolarPrototype {
  List<SolarCalculatedConditionModel> _solarCalculatedConditionModels;

  String _updated;
  String _solarflux;
  String _xray;
  String _sunspots;
  String _solarwind;

  List<VHFConditionsPrototype> _listVHFConditions;

  SolarPrototype(
    this._solarCalculatedConditionModels,
    this._updated,
    this._solarflux,
    this._xray,
    this._sunspots, this._listVHFConditions
  );

  String get solarwind => _solarwind;

  set solarwind(String value) {
    _solarwind = value;
  }

  String get sunspots => _sunspots;

  set sunspots(String value) {
    _sunspots = value;
  }

  String get xray => _xray;

  set xray(String value) {
    _xray = value;
  }

  String get solarflux => _solarflux;

  set solarflux(String value) {
    _solarflux = value;
  }

  String get updated => _updated;

  set updated(String value) {
    _updated = value;
  }

  List<SolarCalculatedConditionModel> get solarCalculatedConditionModels =>
      _solarCalculatedConditionModels;

  set solarCalculatedConditionModels(
      List<SolarCalculatedConditionModel> value) {
    _solarCalculatedConditionModels = value;
  }

  List<VHFConditionsPrototype> get listVHFConditions => _listVHFConditions;

  set listVHFConditions(List<VHFConditionsPrototype> value) {
    _listVHFConditions = value;
  }
}


class VHFConditionsPrototype{
  String _name, _location, _value;


  VHFConditionsPrototype(this._name, this._location, this._value);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  get location => _location;

  set location(value) {
    _location = value;
  }

  get value => _value;

  set value(value) {
    _value = value;
  }



}