import 'package:get/get.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double radius;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  const CustomButton(
      {Key? key,
      this.onPressed,
      required this.buttonText,
      this.transparent = false,
      this.margin,
      this.width,
      this.height,
      this.fontSize,
      this.radius = 30,
      this.icon,
      this.color,
      this.textColor,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null
          ? Theme.of(context).disabledColor
          : transparent
              ? Colors.transparent
              : color ?? Theme.of(context).primaryColor,
      minimumSize: Size(width != null ? width! : Dimensions.webMaxWidth,
          height != null ? height! : 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(
              color: color ?? Theme.of(context).primaryColor, width: 0.6)),
    );

    return Center(
        child: Container(
            width: width ?? Dimensions.webMaxWidth,
            padding: margin == null ? const EdgeInsets.all(0) : margin!,
            child: TextButton(
              
              onPressed: isLoading ? null : onPressed as void Function()?,
              style: flatButtonStyle,
              child: isLoading
                  ? Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    textColor ?? Theme.of(context).cardColor),
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(
                                width: Dimensions.paddingSizeSmall),
                            Text('loading'.tr,
                                style: robotoMedium.copyWith(
                                    color: textColor ??
                                        Theme.of(context).cardColor)),
                          ]),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          icon != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      right:
                                          Dimensions.paddingSizeExtraSmall),
                                  child: Icon(icon,
                                      color: transparent
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).cardColor),
                                )
                              : const SizedBox(),
                          FittedBox(
                            fit: BoxFit.cover,
                            child: Text(buttonText,
                                textAlign: TextAlign.center,
                                style: robotoRegular.copyWith(
                                  color: textColor ??
                                      (transparent
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).cardColor),
                                  fontSize:
                                      fontSize ?? Dimensions.fontSizeLarge,
                                )),
                          ),
                        ]),
            )));
  }
}
