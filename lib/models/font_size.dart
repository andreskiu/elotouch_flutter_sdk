import 'enums.dart';

class FontSize {
  ElotouchFontSize size;
  FontSize(
    this.size,
  );

  _PrintSizes getPrintSizes() {
    switch (size) {
      case ElotouchFontSize.s:
        return _PrintSizes(5, 8);

      case ElotouchFontSize.m:
        return _PrintSizes(12, 20);

      case ElotouchFontSize.l:
        return _PrintSizes(16, 17);

      case ElotouchFontSize.xl:
        return _PrintSizes(16, 18);
      default:
        return _PrintSizes(5, 8);
    }
  }

  /// maximum number of characters that fit in a line for a 52mm? printer
  int getMaxChars() {
    switch (size) {
      case ElotouchFontSize.s:
        return 32;
      default:
        return 16;
    }
  }
}

class _PrintSizes {
  final int height;
  final int width;

  _PrintSizes(
    this.height,
    this.width,
  );

  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'width': width,
    };
  }

  factory _PrintSizes.fromMap(Map<String, dynamic> map) {
    return _PrintSizes(
      map['height'],
      map['width'],
    );
  }
}
