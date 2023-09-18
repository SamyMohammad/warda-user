import 'package:warda/util/dimensions.dart';
import 'package:warda/util/styles.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? suffixIcon;
  final Function iconPressed;
  final Color? filledColor;
  final Color? suffixIconColor;
  final Function? onSubmit;
  final Function? onChanged;
  const SearchField(
      {Key? key,
      required this.controller,
      required this.hint,
      this.suffixIcon,
      required this.iconPressed,
      this.suffixIconColor,
      this.filledColor,
      this.onSubmit,
      this.onChanged})
      : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).disabledColor),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: widget.filledColor ?? Theme.of(context).cardColor,
        isDense: true,
        contentPadding: EdgeInsets.only(top: 12),
        suffixIcon: widget.suffixIcon.runtimeType != Null
            ? GestureDetector(
                onTap: widget.iconPressed as void Function()?,
                child: Icon(widget.suffixIcon,
                    size: 23,
                    color: widget.suffixIconColor.runtimeType == Null
                        ? Theme.of(context).primaryColor
                        : widget.suffixIconColor),
              )
            : null,
      ),
      onSubmitted: widget.onSubmit as void Function(String)?,
      onChanged: widget.onChanged as void Function(String)?,
    );
  }
}
