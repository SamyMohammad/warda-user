import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/styles.dart';

import '../../../../controller/search_controller.dart';
import '../../../../data/model/response/flower_colors_model.dart';
import '../../../../data/model/response/flower_types_model.dart';
import '../../../../data/model/response/occasion_model.dart';
import '../../../../data/model/response/sizes_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
}
