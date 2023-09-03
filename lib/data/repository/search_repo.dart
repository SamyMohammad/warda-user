import 'package:warda/data/api/api_client.dart';
import 'package:warda/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SearchRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getSearchData(
    String? query, {
    int? occationId,
    int? sizeId,
    int? categoryId,
  }) async {
    String searchQuery = '?';
    if (query.runtimeType != Null) {
      searchQuery = '${searchQuery}name=$query';
    }
    if (occationId.runtimeType != Null) {
      searchQuery = '$searchQuery&occasion_id=$occationId';
    }
    if (sizeId.runtimeType != Null) {
      searchQuery = '$searchQuery&size_id=$sizeId';
    }
    if (categoryId.runtimeType != Null) {
      searchQuery = '$searchQuery&category_id=$categoryId';
    }
    if (searchQuery.length >= 2) {
    } else {
      searchQuery = '';
    }

    print('search_query ${searchQuery}');
    return await apiClient.getData(
        '${AppConstants.searchUri}items/search$searchQuery&offset=1&limit=50');
  }

  Future<Response> getSuggestedItems() async {
    return await apiClient.getData(AppConstants.suggestedItemUri);
  }

  Future<Response> getFAQ() async {
    return await apiClient.getData(AppConstants.faqUri);
  }

  Future<Response> getSizesFilter() async {
    return await apiClient.getData(AppConstants.getSizesUri);
  }

  Future<Response> getOccasionsFilter() async {
    return await apiClient.getData(AppConstants.getOccasionsUri);
  }

  Future<Response> getFlowerTypesFilter() async {
    return await apiClient.getData(AppConstants.getOccasionsUri);
  }

  Future<Response> getFlowerColorsFilter() async {
    return await apiClient.getData(AppConstants.getOccasionsUri);
  }

  Future<bool> saveSearchHistory(List<String?> searchHistories) async {
    return await sharedPreferences.setStringList(
        AppConstants.searchHistory, searchHistories as List<String>);
  }

  List<String> getSearchAddress() {
    return sharedPreferences.getStringList(AppConstants.searchHistory) ?? [];
  }

  Future<bool> clearSearchHistory() async {
    return sharedPreferences.setStringList(AppConstants.searchHistory, []);
  }
}
