import 'package:flutter/material.dart';
import 'package:warda/data/api/api_checker.dart';
import 'package:warda/data/model/response/item_model.dart';
import 'package:warda/data/model/response/store_model.dart';
import 'package:warda/data/repository/search_repo.dart';
import 'package:warda/helper/date_converter.dart';
import 'package:get/get.dart';

import '../data/model/response/faq_model.dart';
import '../data/model/response/flower_colors_model.dart';
import '../data/model/response/flower_types_model.dart';
import '../data/model/response/occasion_model.dart';
import '../data/model/response/sizes_model.dart';

class SearchingController extends GetxController implements GetxService {
  final SearchRepo searchRepo;
  SearchingController({required this.searchRepo});

  List<Item>? _searchItemList;
  List<Item>? _allItemList;
  List<Item>? _suggestedItemList;
  List<FaqItem>? _faqList;
  List<Occasion>? _occasionList;
  List<FlowerColor>? _flowerColorList;
  List<FlowerType>? _flowerTypeList;
  List<SizeItem>? _sizeList;
  List<Store>? _searchStoreList;
  List<Store>? _allStoreList;
  String? _searchText = '';
  String? _storeResultText = '';
  String? _itemResultText = '';
  double _lowerValue = 0;
  double _upperValue = 0;
  List<String> _historyList = [];
  bool _isSearchMode = true;
  final List<String> _sortList = ['ascending'.tr, 'descending'.tr];
  int _sortIndex = -1;
  int _rating = -1;
  bool _isAvailableItems = false;
  bool _isDiscountedItems = false;
  bool _veg = false;
  bool _nonVeg = false;
  String? _searchHomeText = '';

  List<Item>? get searchItemList => _searchItemList;
  List<Item>? get allItemList => _allItemList;
  List<Item>? get suggestedItemList => _suggestedItemList;
  List<FaqItem>? get faqList => _faqList;

  List<Occasion>? get occasionList => _occasionList;
  List<SizeItem>? get sizeList => _sizeList;
  List<FlowerType>? get flowerTypeList => _flowerTypeList;
  List<FlowerColor>? get flowerColorList => _flowerColorList;
  List<Store>? get searchStoreList => _searchStoreList;
  String? get searchText => _searchText;
  double get lowerValue => _lowerValue;
  double get upperValue => _upperValue;
  bool get isSearchMode => _isSearchMode;
  List<String?> get historyList => _historyList;
  List<String> get sortList => _sortList;
  int get sortIndex => _sortIndex;
  int get rating => _rating;
  bool get isAvailableItems => _isAvailableItems;
  bool get isDiscountedItems => _isDiscountedItems;
  bool get veg => _veg;
  bool get nonVeg => _nonVeg;
  String? get searchHomeText => _searchHomeText;

  void toggleVeg() {
    _veg = !_veg;
    update();
  }

  void toggleNonVeg() {
    _nonVeg = !_nonVeg;
    update();
  }

  void toggleAvailableItems() {
    _isAvailableItems = !_isAvailableItems;
    update();
  }

  void toggleDiscountedItems() {
    _isDiscountedItems = !_isDiscountedItems;
    update();
  }

  void setSearchMode(bool isSearchMode) {
    _isSearchMode = isSearchMode;
    if (isSearchMode) {
      _searchText = '';
      _itemResultText = '';
      _storeResultText = '';
      _allStoreList = null;
      _allItemList = null;
      _searchItemList = null;
      _searchStoreList = null;
      _sortIndex = -1;
      _isDiscountedItems = false;
      _isAvailableItems = false;
      _veg = false;
      _nonVeg = false;
      _rating = -1;
      _upperValue = 0;
      _lowerValue = 0;
    }
    update();
  }

  void setLowerAndUpperValue(double lower, double upper) {
    _lowerValue = lower;
    _upperValue = upper;
    update();
  }

  void sortItemSearchList() {
    _searchItemList = [];
    _searchItemList!.addAll(_allItemList!);
    if (_upperValue > 0) {
      _searchItemList!.removeWhere((product) =>
          product.price! <= _lowerValue || product.price! > _upperValue);
    }
    if (_rating != -1) {
      _searchItemList!.removeWhere((product) => product.avgRating! < _rating);
    }
    if (!_veg && _nonVeg) {
      _searchItemList!.removeWhere((product) => product.veg == 1);
    }
    if (!_nonVeg && _veg) {
      _searchItemList!.removeWhere((product) => product.veg == 0);
    }
    if (_isAvailableItems || _isDiscountedItems) {
      if (_isAvailableItems) {
        _searchItemList!.removeWhere((product) => !DateConverter.isAvailable(
            product.availableTimeStarts, product.availableTimeEnds));
      }
      if (_isDiscountedItems) {
        _searchItemList!.removeWhere((product) => product.discount == 0);
      }
    }
    if (_sortIndex != -1) {
      if (_sortIndex == 0) {
        _searchItemList!.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      } else {
        _searchItemList!.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        Iterable iterable = _searchItemList!.reversed;
        _searchItemList = iterable.toList() as List<Item>?;
      }
    }
    update();
  }

  void sortStoreSearchList() {
    _searchStoreList = [];
    _searchStoreList!.addAll(_allStoreList!);
    if (_rating != -1) {
      _searchStoreList!.removeWhere((store) => store.avgRating! < _rating);
    }
    if (!_veg && _nonVeg) {
      _searchStoreList!.removeWhere((product) => product.nonVeg == 0);
    }
    if (!_nonVeg && _veg) {
      _searchStoreList!.removeWhere((product) => product.veg == 0);
    }
    if (_isAvailableItems || _isDiscountedItems) {
      if (_isAvailableItems) {
        _searchStoreList!.removeWhere((store) => store.open == 0);
      }
      if (_isDiscountedItems) {
        _searchStoreList!.removeWhere((store) => store.discount == null);
      }
    }
    if (_sortIndex != -1) {
      if (_sortIndex == 0) {
        _searchStoreList!.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      } else {
        _searchStoreList!.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        Iterable iterable = _searchStoreList!.reversed;
        _searchStoreList = iterable.toList() as List<Store>?;
      }
    }
    update();
  }

  void setSearchText(String text) {
    _searchText = text;
    update();
  }

  void getSuggestedItems() async {
    Response response = await searchRepo.getSuggestedItems();
    if (response.statusCode == 200) {
      _suggestedItemList = [];
      response.body.forEach((suggestedItem) =>
          _suggestedItemList!.add(Item.fromJson(suggestedItem)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void getFAQ() async {
    Response response = await searchRepo.getFAQ();
    if (response.statusCode == 200) {
      _faqList = [];
      response.body['data']
          .forEach((faqItem) => _faqList!.add(FaqItem.fromJson(faqItem)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void getSizesFilter() async {
    Response response = await searchRepo.getSizesFilter();
    if (response.statusCode == 200) {
      _sizeList = [];
      response.body['data'].forEach(
          (suggestedItem) => _sizeList!.add(SizeItem.fromJson(suggestedItem)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void getOccasionFilter() async {
    Response response = await searchRepo.getOccasionsFilter();
    if (response.statusCode == 200) {
      _occasionList = [];
      response.body['data'].forEach((suggestedItem) =>
          _occasionList!.add(Occasion.fromJson(suggestedItem)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void getFlowerTypesFilter() async {
    Response response = await searchRepo.getFlowerTypesFilter();
    if (response.statusCode == 200) {
      _flowerTypeList = [];
      response.body['data'].forEach((suggestedItem) =>
          _flowerTypeList!.add(FlowerType.fromJson(suggestedItem)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void getFlowerColorsFilter() async {
    Response response = await searchRepo.getFlowerColorsFilter();
    if (response.statusCode == 200) {
      _flowerColorList = [];

      response.body['data'].forEach((suggestedItem) {
        _flowerColorList!.add(FlowerColor.fromJson(suggestedItem));
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void searchData(
    String? query,
    bool fromHome, {
    List<int>? occationIds,
    List<int>? sizeIds,
    List<int>? categoryIds,
    List<int>? flowerTypeIds,
    List<int>? flowerColorIds,
  }) async {
    _searchHomeText = query;
    _searchText = query;
    _rating = -1;
    _upperValue = 0;
    _lowerValue = 0;

    _searchItemList = null;
    _allItemList = null;

    if (query.runtimeType != Null) {
      if (!_historyList.contains(query)) {
        _historyList.insert(0, query ?? '');
      }
      searchRepo.saveSearchHistory(_historyList);
    }
    _isSearchMode = false;
    if (!fromHome) {
      WidgetsBinding.instance.addPostFrameCallback((_) => update());
    }

    Response response = await searchRepo.getSearchData(query,
        categoryIds: categoryIds,
        sizeIds: sizeIds,
        occationIds: occationIds,
        flowerColorIds: flowerColorIds,
        flowerTypeIds: flowerTypeIds);
        print('helllllllllOOO ${response.statusCode}');
    if (response.statusCode == 200) {
      if (query.runtimeType == Null) {
        _searchItemList = [];
        _searchItemList!.addAll(ItemModel.fromJson(response.body).items!);
      } else {
        _itemResultText = query;
        _searchItemList = [];
        _allItemList = [];
        _searchItemList!.addAll(ItemModel.fromJson(response.body).items!);
        _allItemList!.addAll(ItemModel.fromJson(response.body).items!);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void getHistoryList() {
    _isSearchMode = true;
    _searchText = '';
    _historyList = [];
    _historyList.addAll(searchRepo.getSearchAddress());
  }

  void removeHistory(int index) {
    _historyList.removeAt(index);
    searchRepo.saveSearchHistory(_historyList);
    update();
  }

  void clearSearchAddress() async {
    searchRepo.clearSearchHistory();
    _historyList = [];
    update();
  }

  void setRating(int rate) {
    _rating = rate;
    update();
  }

  void setSortIndex(int index) {
    _sortIndex = index;
    update();
  }

  void resetFilter() {
    _rating = -1;
    _upperValue = 0;
    _lowerValue = 0;
    _isAvailableItems = false;
    _isDiscountedItems = false;
    _veg = false;
    _nonVeg = false;
    _sortIndex = -1;
    update();
  }

  void clearSearchHomeText() {
    _searchHomeText = '';
    update();
  }
}
