import 'package:flutter/material.dart';
import 'package:sample_api_v1/pages/index.dart';
import 'package:sample_api_v1/theme/theme_colors.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(
      primaryColor: primary
    ),
    debugShowCheckedModeBanner: false,
    home: IndexPage(),
  )
);


