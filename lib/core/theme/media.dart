import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  double get availableHeight =>
      height - MediaQuery.of(this).padding.top - kToolbarHeight;

  double widthPct(double percent) => width * percent;
  double heightPct(double percent) => height * percent;

  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;
}
