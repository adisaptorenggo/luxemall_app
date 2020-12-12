import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DevLog{
  static const String ADI = "ADI Log";

  static void d(String tag, String value){
    if (!kReleaseMode) {
      debugPrint('$tag: $value');
    }
  }

  static void e(String tag, String value){
    if (!kReleaseMode) {
      debugPrint('$tag: $value');
    }
  }
}