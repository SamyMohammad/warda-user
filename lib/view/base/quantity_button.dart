import 'package:warda/util/app_constants.dart';
import 'package:warda/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:warda/util/styles.dart';

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final Function onTap;
  final bool fromSheet;
  final bool showRemoveIcon;
  const QuantityButton(
      {Key? key,
      required this.isIncrement,
      required this.onTap,
      this.fromSheet = false,
      this.showRemoveIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        height: fromSheet ? 30 : 20,
        width: fromSheet ? 30 : 30,
        margin:
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          shape: BoxShape.rectangle,
          color: isIncrement
              ? AppConstants.primaryColor
              : AppConstants.lightPinkColor,
          // border: Border.all(
          //     width: 1,
          //     color: showRemoveIcon
          //         ? Theme.of(context).colorScheme.error
          //         : isIncrement
          //             ? Theme.of(context).primaryColor
          //             : Theme.of(context).cardColor),
          // color: showRemoveIcon
          //     ? Theme.of(context).cardColor
          //     : isIncrement
          //         ? Theme.of(context).primaryColor
          //         : Theme.of(context).disabledColor.withOpacity(0.0),
        ),
        alignment: Alignment.center,
        child: Center(
          child: Icon(
            showRemoveIcon
                ? Icons.delete_outline_outlined
                : isIncrement
                    ? Icons.add
                    : Icons.remove,
            size: 15,
            color: showRemoveIcon
                ? Theme.of(context).colorScheme.error
                : isIncrement
                    ? Theme.of(context).cardColor
                    : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}
