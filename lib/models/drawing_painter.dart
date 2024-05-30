import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<Path>? strokes;
  ImageInfo? imageInfo;
  final double screenWidth;

  DrawingPainter(this.strokes, this.imageInfo, this.screenWidth);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      imageInfo!.image,
      Rect.fromLTWH(0, 0, imageInfo!.image.width.toDouble(),
          imageInfo!.image.height.toDouble()),
      Rect.fromLTWH(
          0,
          0,
          size.width,
          imageInfo!.image.height.toDouble() /
              (imageInfo!.image.width.toDouble() / size.width)),
      Paint(),
    );

    for (final stroke in strokes!) {
      final paint = Paint()
        ..strokeWidth = 3
        ..color = Colors.red
        ..style = PaintingStyle.stroke;

      final Matrix4 matrix4 = Matrix4.identity();
      matrix4.scale(size.width / screenWidth);
      var path = stroke.transform(matrix4.storage);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
