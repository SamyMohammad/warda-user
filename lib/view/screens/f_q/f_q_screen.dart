import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:warda/util/app_constants.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/custom_app_bar.dart';

import 'cubit/fq_cubit.dart';

class FQScreen extends StatefulWidget {
  const FQScreen({Key? key}) : super(key: key);

  @override
  State<FQScreen> createState() => _FQScreenState();
}

class _FQScreenState extends State<FQScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FqCubit>(context).getFAQ();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FqCubit, FqState>(
        builder: (context, state) {
          var cubit = BlocProvider.of<FqCubit>(context);
          print('hello::: ${cubit.faqlist?.length}');
          return SafeArea(
            child: Center(
              child: SizedBox(
                width: context.width,
                child: Column(
                  children: [
                    CustomAppBar(
                      title: 'FAQ',
                      backButton: true,
                    ),
                    Expanded(
                      // height: context.height * 0.7,
                      child: SizedBox(
                        width: context.width * 0.9,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cubit.faqlist?.length,
                            itemBuilder: (context, index) {
                              var faq = cubit.faqlist?[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: AnimatedContainer(
                                  alignment: Alignment.centerRight,
                                  duration: Duration(milliseconds: 1500),
                                  constraints: BoxConstraints(
                                      minHeight:
                                          cubit.currentQuestionOpen == index
                                              ? context.height * 0.1
                                              : context.height * 0.05),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  // clipBehavior: Clip.antiAlias,
                                  // constraints:
                                  // height: context.height * 0.05,
                                  // width: context.width * 0.8,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: context.width * 0.7,
                                            child: Text(
                                              faq?.question ?? '',
                                              style: robotoRegular.copyWith(
                                                  color:
                                                      AppConstants.greenColor),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              cubit.openQuestion(index);
                                            },
                                            child: Icon(
                                              cubit.currentQuestionOpen == index
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: AppConstants.greenColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: context.width * 0.02,
                                      ),
                                      cubit.currentQuestionOpen == index
                                          ? SizedBox(
                                              width: context.width * 0.86,
                                              child: Text(
                                                '${faq?.answer ?? ''} ',
                                                style: robotoRegular,
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
