import 'package:warda/controller/search_controller.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/view/base/footer_view.dart';
import 'package:warda/view/base/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemView extends StatelessWidget {
  final bool isItem;
  const ItemView({Key? key, required this.isItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SearchingController>(builder: (searchController) {
        return SingleChildScrollView(
          child: FooterView(
            child: SizedBox(width: Dimensions.webMaxWidth, child: ItemsView(
              isStore: isItem, items: searchController.searchItemList, stores: searchController.searchStoreList,
            )),
          ),
        );
      }),
    );
  }
}
