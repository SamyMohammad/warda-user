import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;

import '../../../../data/api/api_client.dart';
import '../../../../data/model/response/get_countries_cities_model.dart';
import '../../../../helper/cashe_helper.dart';
import '../../../../util/app_constants.dart';
part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({required this.apiClient}) : super(LocationInitial());
  GetCountriesCitiesModel? countriesCitiesModel;
  Country? countrySelected;
  City? citySelected;
  final ApiClient apiClient;
  String? countryName;
  String? cityName;

  Future<Either<String, GetCountriesCitiesModel>> getCountryData() async {
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.https(AppConstants.baseUrl.split('://')[1],
            'api/v1/auth/vendor/get-data'),
      );
      if (response.statusCode == 200) {
        var model = getCountriesCitiesModelFromJson(response.body);
        countriesCitiesModel = model;
        emit(CountiresLoaded(countriesCitiesModel: countriesCitiesModel!));
        return Right(model);
      } else {
        emit(LocationError('Error'));
        return Left('unexpacting error');
      }
    } finally {
      client.close();
    }
  }

  changeCountry(Country coutry) {
    countrySelected = coutry;
    citySelected = null;
    CasheHelper().store(AppConstants.countrySelectedKey, coutry.name);
    CasheHelper().store(AppConstants.countrySelectedId, coutry.id.toString());
    emit(CountiresLoaded(
        countriesCitiesModel: countriesCitiesModel!,
        countrySelected: coutry,
        citySelected: citySelected));
  }

  readCountryAndCity() async {
    countryName =
        await CasheHelper().read(AppConstants.countrySelectedKey) ?? '';
    cityName = await CasheHelper().read(AppConstants.citySelectedKey) ?? '';
    emit(LocationInitial());
  }

  updateHeaderWithCityId() {
    if (citySelected.runtimeType != Null) {
      apiClient.updateCityId(citySelected?.id.toString() ?? '');
    }
  }

  Future<bool> haveCityId() async {
    bool haveZoneId = false;
    String cityId = await CasheHelper().read(AppConstants.zoneId) ?? '';
    if (cityId != '') {
      haveZoneId = true;
    } else {
      haveZoneId = false;
    }

    return haveZoneId;
  }

  changeCity(City city) {
    citySelected = city;
    CasheHelper().store(AppConstants.citySelectedKey, city.name);
    CasheHelper().store(AppConstants.zoneId, city.id.toString());
    emit(CountiresLoaded(
        countriesCitiesModel: countriesCitiesModel,
        countrySelected: countrySelected,
        citySelected: city));
  }
}
