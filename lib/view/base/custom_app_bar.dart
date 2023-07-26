import 'package:warda/controller/category_controller.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/app_constants.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/cart_widget.dart';
import 'package:warda/view/base/veg_filter_widget.dart';
import 'package:warda/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Function? onBackPressed;
  final bool showCart;
  final bool showLogo;
  final Function(String value)? onVegFilterTap;
  final String? type;
  final String? leadingIcon;
  final Color? foregroundColor;
  final List<Widget>? actions;
  const CustomAppBar(
      {Key? key,
      required this.title,
      this.backButton = true,
      this.onBackPressed,
      this.showCart = false,
      this.showLogo = false,
      this.foregroundColor = AppConstants.primaryColor,
      this.leadingIcon,
      this.actions,
      this.onVegFilterTap,
      this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? const WebMenuBar()
        : PreferredSize(
            preferredSize: Size(context.width, context.height * 0.32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: showCart || showLogo || onVegFilterTap != null
                      ? [
                          showLogo
                              ? Image.asset(
                                  Images.logoColor,
                                  color: foregroundColor,
                                  width: context.width * 0.25,
                                  height: context.height * 0.03,
                                  fit: BoxFit.fitHeight,
                                )
                              : SizedBox(),
                          showCart
                              ? IconButton(
                                  onPressed: () =>
                                      Get.toNamed(RouteHelper.getCartRoute()),
                                  icon: CartWidget(
                                      color: foregroundColor, size: 25),
                                )
                              : const SizedBox(),
                          onVegFilterTap != null
                              ? VegFilterWidget(
                                  type: type,
                                  onSelected: onVegFilterTap,
                                  fromAppBar: true,
                                )
                              : const SizedBox(),
                        ]
                      : [const SizedBox()],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    backButton
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: IconButton(
                                icon: Center(
                                  child: leadingIcon != null
                                      ? Image.asset(leadingIcon!,
                                          height: 22, width: 22)
                                      : const Icon(Icons.arrow_back_ios),
                                ),
                                color: foregroundColor,
                                onPressed: () => onBackPressed != null
                                    ? onBackPressed!()
                                    : Navigator.pop(context),
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Container(
                                width: 22,
                                height: 22,
                              ),
                            ),
                          ),
                    Container(
                        width: context.width * 0.6,
                        alignment: Alignment.center,
                        child: Text(title,
                            style: wardaRegular.copyWith(
                              fontSize: Dimensions.fontSizeOverLarge,
                              color: foregroundColor,
                            ))),
                    actions.runtimeType != Null
                        ? Container(
                            alignment: Alignment.centerRight,
                            height: context.height * 0.02,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            width: context.width,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: actions!.length,
                                itemBuilder: (context, index) => Container(
                                      alignment: Alignment.centerRight,
                                      child: actions?[index],
                                    )),
                          )
                        : const SizedBox(),
                  ],
                )
              ],
            ),
          );
  }

  @override
  Size get preferredSize => Size(Get.width, GetPlatform.isDesktop ? 70 : 50);
}
