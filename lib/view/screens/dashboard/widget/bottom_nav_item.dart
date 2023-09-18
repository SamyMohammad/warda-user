import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:warda/util/app_constants.dart';
import 'package:warda/util/styles.dart';

import '../../../../controller/cart_controller.dart';

class BottomNavItem extends StatelessWidget {
  final String title;
  final String unselectedImg;
  final String selectedImg;
  final Function? onTap;
  final bool isSelected;
  final bool isCategoryItem;
  final double size;
  const BottomNavItem(
      {Key? key,
      this.onTap,
      this.isSelected = false,
      this.size = 30,
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
            Stack(
              clipBehavior: Clip.none,
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
                if (title.toLowerCase() == 'cart')
                  GetBuilder<CartController>(builder: (cartController) {
                    return cartController.cartList.isNotEmpty
                        ? Positioned(
                            top: -5,
                            right: 3,
                            child: Container(
                              height: size < 20 ? 10 : size / 2,
                              width: size < 20 ? 10 : size / 2,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                                border: Border.all(
                                    width: size < 20 ? 0.7 : 1,
                                    color: Theme.of(context).cardColor),
                              ),
                              child: Text(
                                cartController.cartList.length.toString(),
                                style: robotoRegular.copyWith(
                                  fontSize: size < 20 ? size / 3 : size / 3.8,
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox();
                  }),
              ],
            ),
            isSelected
                ? Text(
                    title.toUpperCase(),
                    style: wardaItalic.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primaryColor),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
