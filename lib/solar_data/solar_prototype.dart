import 'package:solardata/solar_data/solar_calculated_condition_model.dart';

class SolarPrototype {
  List<SolarCalculatedConditionModel> _solarCalculatedConditionModels;

  String _updated;
  String _solarflux;
  String _xray;
  String _sunspots;
  String _solarwind;

  List<VHFConditionsPrototype> _listVHFConditions;

  //calculated conditions data
  CalculatedConditionsFields _calculatedConditionsFields;


  SolarPrototype(
    this._solarCalculatedConditionModels,
    this._updated,
    this._solarflux,
    this._xray,
    this._sunspots, this._listVHFConditions, this._calculatedConditionsFields
  );

  CalculatedConditionsFields get calculatedConditionsFields =>
      _calculatedConditionsFields;

  set calculatedConditionsFields(CalculatedConditionsFields value) {
    _calculatedConditionsFields = value;
  }

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


class CalculatedConditionsFields{
  //calculated conditions data
  String _geomagneticField;
  String _signalNoiseField;
  String _muffactorFieldValue;
  String _fof2Value;
  String _mufValue;

  CalculatedConditionsFields(this._geomagneticField, this._signalNoiseField,
      this._muffactorFieldValue, this._fof2Value, this._mufValue);

  String get mufValue => _mufValue;

  set mufValue(String value) {
    _mufValue = value;
  }

  String get fof2Value => _fof2Value;

  set fof2Value(String value) {
    _fof2Value = value;
  }

  String get muffactorFieldValue => _muffactorFieldValue;

  set muffactorFieldValue(String value) {
    _muffactorFieldValue = value;
  }

  String get signalNoiseField => _signalNoiseField;

  set signalNoiseField(String value) {
    _signalNoiseField = value;
  }

  String get geomagneticField => _geomagneticField;

  set geomagneticField(String value) {
    _geomagneticField = value;
  }
}

