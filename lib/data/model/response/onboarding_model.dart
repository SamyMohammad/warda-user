import 'package:flutter/material.dart';

class OnBoardingModel {
  final String _imageUrl;
  final String _title;
  final String _description;
  final List<Color> _backgroundColor;
  final Color _textColor;

  get imageUrl => _imageUrl;
  get title => _title;
  get description => _description;
  get backgroundColor => _backgroundColor;
  get textColor => _textColor;

  OnBoardingModel(this._imageUrl, this._title, this._description,
      this._backgroundColor, this._textColor);
}
