import 'dart:async';

import 'package:elotouch_flutter_plugin/models/text_column.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'models/enums.dart';
import 'models/font_size.dart';

export './models/enums.dart';
export './models/text_column.dart';

class ElotouchDevice {
  static const SetFontSize = "setFontSize";
  static const PrintText = "print";
  static const SetBold = "setBold";
  static const SetAlignment = "setAlignment";
  static const Feed = "feed";
  static const HasPaper = "hasPaper";

  static const MethodChannel _channel =
      const MethodChannel('elotouch_flutter_plugin');

  static Future<bool> _printText({
    @required String text,
  }) async {
    try {
      final bool _success = await _channel.invokeMethod(
        ElotouchDevice.PrintText,
        text,
      );
      return _success;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// set the font size for the printer. I recommend to set this values in the
  /// print text function instead of using this one. But, if you need another
  /// size, you can change it with this function, but it isn't as easy to use as
  /// it appears. you are warned :p
  ///
  static Future<bool> setFontSize({
    @required ElotouchFontSize fontSize,
  }) async {
    try {
      final customSizes = FontSize(fontSize);
      final bool _success = await _channel.invokeMethod(
        ElotouchDevice.SetFontSize,
        customSizes.getPrintSizes().toMap(),
      );
      return _success;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// enable/disable bold characters
  static Future<bool> setBold({
    @required bool boldOn,
  }) async {
    try {
      final bool _success = await _channel.invokeMethod(
        ElotouchDevice.SetBold,
        boldOn,
      );

      return _success;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// Set the text alignment.
  static Future<bool> setAlignment({
    @required EloAlignment alignment,
  }) async {
    try {
      final bool _success = await _channel.invokeMethod(
        ElotouchDevice.SetAlignment,
        alignment.index,
      );

      return _success;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// According with elo sdk, this function should print n blank lines;
  /// but for each value prints 4 blank lines. If you want to print only one
  /// empty line, use printEmptyLine()
  static Future<bool> feed({
    @required int lines,
  }) async {
    try {
      final bool _success = await _channel.invokeMethod(
        ElotouchDevice.Feed,
        lines,
      );

      return _success;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// Print a text with the desired configuration. If the text is longer than max
  /// width, it will continue in the following line keeping the Alignment.
  static Future<bool> printText({
    @required String text,
    bool isBold = false,
    EloAlignment alignment = EloAlignment.left,
    ElotouchFontSize fontSize = ElotouchFontSize.s,
  }) async {
    try {
      setBold(boldOn: isBold);
      setAlignment(alignment: alignment);
      setFontSize(fontSize: fontSize);
      _printText(text: text);
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// Print an empty line. Set the size attribute to change the height of the
  /// line
  static Future<bool> printEmptyLine({
    ElotouchFontSize size = ElotouchFontSize.s,
  }) async {
    try {
      setFontSize(fontSize: size);
      _printText(text: " ");
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// Print a row. The max width row depends on the font size and the
  /// width of the paper.
  /// There is no calculation for the paper width, so the max width was fixed
  /// making real proof on a device with a paper of 58mm. If it is not your case
  ///, you can set the maximum number of characters that fit on your paper using
  /// the forcedMaximunWidth attribute. Be careful that this value depends on
  /// the font size
  static Future<String> printRow({
    ElotouchFontSize size = ElotouchFontSize.s,
    List<TextColumn> cols,
    int forcedMaximunWidth,
  }) async {
    try {
      int _maxRowLength;
      if (forcedMaximunWidth == null) {
        _maxRowLength = FontSize(size).getMaxChars();
      } else {
        _maxRowLength = forcedMaximunWidth;
      }
      final isSumInvalid =
          cols.fold(0, (int sum, col) => sum + col.maxWidth) > _maxRowLength;

      if (isSumInvalid) {
        throw Exception(
          'Total columns width must be lower/equal than $_maxRowLength',
        );
      }
      String _rowText = "";
      cols.forEach((col) {
        if (col.text.length > col.maxWidth) {
          _rowText = _rowText + col.text.substring(0, col.maxWidth);
        } else {
          if (col.aligment == EloColumnAlignment.start) {
            _rowText = _rowText + col.text.padRight(col.maxWidth);
          } else {
            _rowText = _rowText + col.text.padLeft(col.maxWidth);
          }
          //the algorithm can be improve by adding a new line with the remaining text content
        }
      });
      setFontSize(fontSize: size);

      _printText(text: _rowText);
      return "Text printed";
    } on Exception catch (e) {
      print(e);
      return e.toString();
    }
  }

  /// This method will check if the printer has paper. If any error in the
  /// communication appears, It will consider that there is no paper on the
  /// printer.
  static Future<bool> hasPaper() async {
    try {
      final bool _success = await _channel.invokeMethod(
        ElotouchDevice.HasPaper,
      );
      return _success;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// this method check if the printer is connected. It uses the has paper sdk
  /// function and if an error in the connection is thrown, then the printer is
  /// not available.
  static Future<bool> isPrinterConnected() async {
    try {
      await _channel.invokeMethod(
        ElotouchDevice.HasPaper,
      );
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}
