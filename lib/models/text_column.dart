import 'package:flutter/foundation.dart';

import 'enums.dart';

class TextColumn {
  String text;
  int maxWidth;
  EloColumnAlignment aligment;
  TextColumn({
    @required this.text,
    this.maxWidth = 16,
    this.aligment = EloColumnAlignment.start,
  });
}
