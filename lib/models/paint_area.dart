import 'package:flutter/material.dart';
import 'drawing_painter.dart';

class PaintBox extends StatelessWidget {
  final ImageInfo? imageInfo;
  final List<Path>? strokes;
  late final double width;
  late final double height;

  PaintBox({
    super.key,
    required this.imageInfo,
    required this.strokes,
    required double widgetWidth,
  }) {
    final imageWidth = imageInfo!.image.width.toDouble();
    final imageHeight = imageInfo!.image.height.toDouble();
    width = widgetWidth;
    height = imageHeight / (imageWidth / widgetWidth);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        width,
        height,
      ),
      painter:
          DrawingPainter(strokes, imageInfo, MediaQuery.of(context).size.width),
    );
  }
}
