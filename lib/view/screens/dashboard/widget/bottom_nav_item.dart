import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:warda/util/app_constants.dart';
import 'package:warda/util/styles.dart';

class BottomNavItem extends StatelessWidget {
  final String title;
  final String unselectedImg;
  final String selectedImg;
  final Function? onTap;
  final bool isSelected;
  final bool isCategoryItem;
  const BottomNavItem(
      {Key? key,
      this.onTap,
      this.isSelected = false,
      this.isCategoryItem = false,
      required this.title,
      required this.selectedImg,
      required this.unselectedImg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        width: isCategoryItem ? context.width * 0.215 : context.width * 0.188,
        // color: Colors.red,
        // margin: isCategoryItem
        //     ? EdgeInsets.symmetric(horizontal: context.width * 0.02)
        //     : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSelected
                ? Image.asset(
                    selectedImg,
                    width: 30,
                    height: 30,
                  )
                : Image.asset(
                    unselectedImg,
                    width: 25,
                    height: 25,
                  ),
            isSelected
                ? Text(
                    title.toUpperCase(),
                    style: wardaRegular.copyWith(
                        fontSize: 12, color: AppConstants.primaryColor),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
