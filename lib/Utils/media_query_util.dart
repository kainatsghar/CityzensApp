import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MediaQueryUtil {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late bool isTablet;
  static late bool isMobile;
  static late bool isWeb;
  static late Orientation orientation;

  // Initialize with BuildContext
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;

    // Calculate block sizes for responsive design
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    // Calculate safe area sizes
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;

    // Device type detection
    isTablet = _isTablet();
    isMobile = _isMobile();
    isWeb = kIsWeb;
  }

  // Check if device is tablet based on screen size
  static bool _isTablet() {
    final bool isTabletByWidth = screenWidth > 600;
    final bool isTabletByHeight = screenHeight > 600;
    return isTabletByWidth && isTabletByHeight;
  }

  // Check if device is mobile
  static bool _isMobile() {
    if (kIsWeb) return false;
    return Platform.isIOS || Platform.isAndroid;
  }

  // Get responsive font size
  static double getResponsiveFontSize(double fontSize) {
    double screenWidthFactor = screenWidth / 375.0; // Base width: iPhone X
    if (isTablet) {
      screenWidthFactor = screenWidth / 834.0; // Base width: iPad Air
    }
    return fontSize * screenWidthFactor;
  }

  // Get responsive padding
  static EdgeInsets getResponsivePadding({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: blockSizeHorizontal * horizontal,
      vertical: blockSizeVertical * vertical,
    );
  }

  // Get safe area padding
  static EdgeInsets getSafeAreaPadding() {
    return _mediaQueryData.padding;
  }

  // Check orientation
  static bool isLandscape() => orientation == Orientation.landscape;
  static bool isPortrait() => orientation == Orientation.portrait;

  // Get device pixel ratio
  static double get pixelRatio => _mediaQueryData.devicePixelRatio;

  // Get screen size category
  static String getScreenCategory() {
    if (screenWidth < 600) return 'phone';
    if (screenWidth < 840) return 'tablet';
    return 'desktop';
  }

  // Get responsive width based on percentage
  static double getWidthPercentage(double percentage) {
    return screenWidth * (percentage / 100);
  }

  // Get responsive height based on percentage
  static double getHeightPercentage(double percentage) {
    return screenHeight * (percentage / 100);
  }

  // Get responsive height based on percentage
  static double getResponsivePercentageSize(double percentage) {
    return (MediaQueryUtil.isLandscape()
        ? MediaQueryUtil.getWidthPercentage(percentage)
        : MediaQueryUtil.getHeightPercentage(percentage));
  }

  // Check if device has notch
  static bool hasNotch() {
    return _mediaQueryData.padding.top > 20;
  }

  // Get keyboard height
  static double getKeyboardHeight() {
    return _mediaQueryData.viewInsets.bottom;
  }

  // Check if keyboard is visible
  static bool isKeyboardVisible() {
    return _mediaQueryData.viewInsets.bottom > 0;
  }

  // Get status bar height
  static double getStatusBarHeight() {
    return _mediaQueryData.padding.top;
  }

  // Get bottom navigation bar height
  static double getBottomNavigationBarHeight() {
    return _mediaQueryData.padding.bottom;
  }

  // Get max width constraint based on screen category
  static double getMaxWidth() {
    switch (getScreenCategory()) {
      case 'phone':
        return 600;
      case 'tablet':
        return 840;
      default:
        return 1200;
    }
  }
}
