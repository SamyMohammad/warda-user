part of 'location_cubit.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationError extends LocationState {
  final String error;

  LocationError(this.error);
}

class CountiresLoaded extends LocationState {
  final GetCountriesCitiesModel? countriesCitiesModel;
  Country? countrySelected;
  City? citySelected;

  CountiresLoaded(
      {this.countriesCitiesModel, this.citySelected, this.countrySelected});
}
