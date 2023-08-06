import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warda/util/app_constants.dart';

import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_snackbar.dart';
import '../../../base/custom_text_field.dart';
import '../cubit/cart_cubit.dart';

class CartMessageWidget extends StatefulWidget {
  const CartMessageWidget({Key? key}) : super(key: key);

  @override
  State<CartMessageWidget> createState() => _CartMessageWidgetState();
}

class _CartMessageWidgetState extends State<CartMessageWidget> {
  @override
  void initState() {
    // TODO: implement initState

    BlocProvider.of<CartCubit>(context).getQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * 0.9,
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          var cubit = BlocProvider.of<CartCubit>(context);
          return SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: context.height * 0.02,
                ),
                Text('card_message'.tr + 'optional'.tr,
                    textAlign: TextAlign.start,
                    style: robotoBlack.copyWith(
                        fontSize: 16, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: context.height * 0.03,
                ),
                getMessageWidget(cubit),
                SizedBox(
                  height: context.height * 0.02,
                ),
                const Divider(
                  thickness: 3,
                ),
                qrWidget(cubit),
                // CustomButton(
                //   onPressed: () {
                //     String? message = cubit.validator(2);
                //     if (message.runtimeType != Null) {
                //       showCustomSnackBar(message, isError: true);
                //     } else {
                //       cubit.changeActiveStep(2);
                //     }
                //   },
                //   buttonText: 'continue'.tr,
                //   radius: 30,
                // ),
                SizedBox(
                  height: context.height * 0.03,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget qrWidget(CartCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('share_your_feelings'.tr,
            textAlign: TextAlign.start,
            style: robotoBlack.copyWith(
                fontSize: 16, fontWeight: FontWeight.w400)),
        SizedBox(
          height: context.height * 0.01,
        ),
        Text('choose_way_share_feelings'.tr,
            textAlign: TextAlign.start,
            style: robotoRegular.copyWith(
              fontWeight: FontWeight.w300,
              fontSize: 12,
            )),
        SizedBox(
          height: context.height * 0.02,
        ),
        Container(
          // margin: const EdgeInsets.symmetric(horizontal: 12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text('link_optional'.tr,
                  textAlign: TextAlign.start,
                  style: robotoRegular.copyWith(fontSize: 13)),
            ),
            cubit.showGeneratedQrCode
                ? Container(
                    width: context.width,
                    alignment: Alignment.center,
                    child: QrImage(
                      data: cubit.linkSongController.text,
                      version: QrVersions.auto,
                      size: context.height * 0.24,
                      eyeStyle: const QrEyeStyle(
                          //eyeShape: QrEyeShape.square,
                          color: Colors.black),
                      dataModuleStyle:
                          const QrDataModuleStyle(color: Colors.black),
                      // Colors.black),
                      gapless: false,
                      embeddedImage: const AssetImage(Images.logoCircle),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size((context.height * 0.22) / 4,
                            (context.height * 0.22) / 4),
                      ),
                    ),
                  )
                : CustomTextField(
                    controller: cubit.linkSongController,
                    titleText: 'paste_link_for_song_video'.tr,
                    showBorder: true,
                  ),
          ]),
        ),
        SizedBox(
          height: context.height * 0.04,
        ),
        CustomButton(
          onPressed: () {
            !cubit.showGeneratedQrCode
                ? cubit.generateQrCode()
                : cubit.changeAudioLink();
          },
          buttonText: cubit.showGeneratedQrCode
              ? 'change_media_link'.tr
              : 'generate_qrCode'.tr,
          radius: 30,
          color: Theme.of(context).cardColor,
          textColor: Theme.of(context).primaryColor,
        ),
        SizedBox(
          height: context.height * 0.02,
        ),
      ],
    );
  }

  Widget getMessageWidget(CartCubit cubit) {
    return cubit.showGeneratedMessage
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cubit.generatedMessage ?? '',
                style: robotoRegular.copyWith(fontSize: 14),
              ),
              SizedBox(
                height: context.height * 0.02,
              ),
              CustomButton(
                buttonText: 'write_your_message'.tr,
                onPressed: () {
                  cubit.showMessageController();
                },
              )
            ],
          )
        : cubit.generateMessageWithAI
            ? Column(
                children: [
                  questionForAiMessage(context, cubit),
                  SizedBox(
                    height: context.height * 0.01,
                  ),
                  CustomButton(
                    buttonText: 'generate_message'.tr,
                    isLoading: cubit.state is CartLoading,
                  
                    color: Theme.of(context).cardColor,
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      cubit.generateMessage();
                    },
                  ),
                  SizedBox(
                    height: context.height * 0.02,
                  ),
                  CustomButton(
                    buttonText: 'write_your_message'.tr,
                    onPressed: () {
                      cubit.showMessageController();
                    },
                  )
                ],
              )
            : Column(
                children: [
                  CustomTextField(
                    controller: cubit.messageController,
                    maxLines: 3,
                    titleText: 'write_your_message_here'.tr,
                  ),
                  SizedBox(
                    height: context.height * 0.02,
                  ),
                  CustomButton(
                    buttonText: 'create_message_with_chatgpt'.tr,
                    color: Theme.of(context).cardColor,
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      cubit.showQuestion();
                    },
                  )
                ],
              );
  }

  Widget questionForAiMessage(BuildContext context, CartCubit cubit) {
    return ListView.builder(
        itemCount: cubit.questions.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var question = cubit.questions[index];
          bool haveChoice = question.choices.isNotEmpty;
          bool textType = question.type == 'text';
          var choiceValue;
          var questionController;
          var questionBool;
          if (!textType) {
            questionBool = cubit.messageQuestionsBool?.entries
                .firstWhere((element) => element.key == question.q);
          } else {
            if (haveChoice) {
              choiceValue = cubit.questionChoises?.entries
                  .firstWhere((element) => element.key == question.q);
            } else {
              questionController = cubit.messageQuestionsControllers?.entries
                  .firstWhere((element) => element.key == question.q);
            }
          }
          return SizedBox(
            height: context.height * 0.09,
            child: textType
                ? haveChoice
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.q,
                            style: robotoRegular.copyWith(fontSize: 14),
                          ),
                          SizedBox(
                            height: context.height * 0.06,
                            width: context.width,
                            child: ListView.builder(
                                itemCount: question.choices.length,
                                //itemCount: 5,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var choice = question.choices[index];
                                  var choiceOption = choiceValue?.value.entries
                                      .firstWhere((element) =>
                                          element.key == choice.name);
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right: context.width * 0.05),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                            value: choiceOption?.value,
                                            onChanged: (value) {
                                              cubit.changeQuestionBoolValue(
                                                  question, value ?? false,
                                                  isChoice: true,
                                                  choiceName: choice.name);
                                            }),
                                        Text(
                                          choice.name,
                                          style: robotoRegular.copyWith(
                                              fontSize: 13),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      )
                    : CustomTextField(
                        controller: questionController?.value,
                        titleText: questionController?.key ?? '',
                        showBorder: true,
                      )
                : SizedBox(
                    height: context.height * 0.06,
                    width: context.width,
                    child: Padding(
                      padding: EdgeInsets.only(right: context.width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: questionBool?.value,
                              onChanged: (value) {
                                cubit.changeQuestionBoolValue(
                                    question, value ?? false);
                              }),
                          Text(
                            questionBool.key,
                            style: robotoRegular.copyWith(fontSize: 13),
                          )
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
