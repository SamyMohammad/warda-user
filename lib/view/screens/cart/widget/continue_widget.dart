import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../helper/route_helper.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_snackbar.dart';
import '../cubit/cart_cubit.dart';

class ContinueCartBtn extends StatelessWidget {
  ContinueCartBtn({Key? key, this.comeFromListItemCart = false})
      : super(key: key);
  bool comeFromListItemCart;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        var cubit = BlocProvider.of<CartCubit>(context);
        return Column(
          children: [
            SizedBox(
              height: context.height * 0.02,
            ),
            (!comeFromListItemCart && cubit.activeStep == 4)
                ? const SizedBox()
                : CustomButton(
                    buttonText: 'continue'.tr,
                    width: context.width * 0.9,
                    height: context.height * 0.07,
                    radius: 30,
                    onPressed: () {
                      if (comeFromListItemCart) {
                        print('deliveryTime ${cubit.deliveryTime}');

                        Get.toNamed(RouteHelper.getCheckoutScreenRoute());
                        cubit.changeActiveStep(1);
                      } else {
                        String? message = cubit
                                .validator(cubit.activeStep)
                                ?.entries
                                .first
                                .value ??
                            '';
                        if (message.isNotEmpty) {
                          print('deliveryTimeisNotEmpty ${cubit.deliveryTime}');

                          cubit.changeActiveStep(cubit
                                  .validator(cubit.activeStep)
                                  ?.entries
                                  .first
                                  .key ??
                              0);
                          showCustomSnackBar(message, isError: true);
                        } else {
                          print('deliveryTimechangeActiveStep ${cubit.deliveryTime}');

                          cubit.changeActiveStep(cubit.activeStep == 4
                              ? cubit.activeStep
                              : cubit.activeStep == 1
                                  ? cubit.activeStep + 2
                                  : cubit.activeStep + 1);
                        }
                      }
                    },
                  ),
            Platform.isIOS
                ? SizedBox(
                    height: context.height * 0.03,
                  )
                : SizedBox(
                    height: context.height * 0.03,
                  ),
          ],
        );
      },
    );
  }
}
