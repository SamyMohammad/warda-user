import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/styles.dart';

class CartMessageWidget extends StatelessWidget {
  const CartMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('card_message'.tr,
              textAlign: TextAlign.start,
              style: robotoBlack.copyWith(
                  fontSize: 20, fontWeight: FontWeight.w400)),
                
        ],
      ),
    );
  }
}
