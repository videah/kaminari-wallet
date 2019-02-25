import 'package:flutter/material.dart';

double getLargestScreenSize(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;
  return width > height ? width : height;
}