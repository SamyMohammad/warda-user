import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../../../controller/search_controller.dart';
import '../../../../data/model/response/faq_model.dart';

part 'fq_state.dart';

class FqCubit extends Cubit<FqState> {
  FqCubit() : super(FqInitial());

  List<FaqItem>? faqlist = [];
  int? currentQuestionOpen;

  getFAQ() {
    emit(FqLoading());
    faqlist = Get.find<SearchingController>().faqList;

    emit(FqInitial());
  }

  openQuestion(int index) {
    emit(FqLoading());
    if (currentQuestionOpen == index) {
      currentQuestionOpen = null;
    } else {
      currentQuestionOpen = index;
    }
    emit(FqInitial());
  }
}
