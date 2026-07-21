import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/gen/assets.gen.dart';

class ShowMessageOnImage extends StatelessWidget {
  final String message;
  final String? imagePath;

  const ShowMessageOnImage({super.key, required this.message, this.imagePath});

  @override
  Widget build(BuildContext context) {
    // Get screen size and orientation
    final Size size = MediaQuery.sizeOf(context);
    final bool isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final bool isTablet = size.shortestSide >= 600;

    // Calculate dimensions based on orientation and device type
    final double containerSize = isLandscape
        ? (isTablet ? size.height * 0.7 : size.height * 0.8)
        : (isTablet ? size.width * 0.6 : size.width * 0.8);

    // Calculate text size based on container size and device type
    final double fontSize = isTablet ? 32.0 : 24.0;
    final double padding = containerSize * 0.2;
    return SafeArea(
      // Maintain aspect ratio in landscape
      maintainBottomViewPadding: true,
      child: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 600 : 400,
                  maxHeight: isTablet ? 600 : 400,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      imagePath ?? Assets.images.bgCircularColored.path,
                      height: containerSize,
                      width: containerSize,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      height: containerSize,
                      width: containerSize,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                                color: AppColors.primaryDarkBlue,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
