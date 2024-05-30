import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/drawing_painter.dart';
import '../utils/constants.dart';

final paintImageStateProvider = StateNotifierProvider.autoDispose<
    PaintImageStateController, PaintImageState>((ref) {
  return PaintImageStateController(PaintImageState.initial());
});

class PaintImageState {
  final List<Path>? strokes;
  ImageInfo? imageInfo;

  PaintImageState({this.strokes, this.imageInfo});

  factory PaintImageState.initial() {
    return PaintImageState(
      strokes: List<Path>.empty(growable: true),
    );
  }

  PaintImageState copyWith({
    List<Path>? strokes,
    ImageInfo? imageInfo,
  }) {
    return PaintImageState(
        strokes: strokes ?? this.strokes,
        imageInfo: imageInfo ?? this.imageInfo);
  }
}

class PaintImageStateController extends StateNotifier<PaintImageState> {
  PaintImageStateController(super.state);

  void setImageInfo(ImageInfo? imageInfo) {
    state = state.copyWith(imageInfo: imageInfo);
  }

  void startStroke(double x, double y) {
    state = state.copyWith(strokes: state.strokes?..add(Path()..moveTo(x, y)));
  }

  void moveStroke(double x, double y, double width) {
    if (state.imageInfo != null) {
      final maxHeight = state.imageInfo!.image.height.toDouble() /
          (state.imageInfo!.image.width.toDouble() / width);
      if (y > maxHeight) {
        y = maxHeight;
      } else if (y < 0) {
        y = 0;
      }
    }

    state = state.copyWith(strokes: state.strokes?..last.lineTo(x, y));
  }

  void clearCanvas() {
    state = state.copyWith(strokes: state.strokes?..clear());
  }

  void undoCanvas() {
    if (state.strokes != null) {
      state = state.copyWith(
          strokes: state.strokes?..removeAt(state.strokes!.length - 1));
    }
  }

  void handleSavePressed(WidgetRef ref, BuildContext context) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    var painter = DrawingPainter(
        ref.read(paintImageStateProvider).strokes,
        ref.read(paintImageStateProvider).imageInfo,
        MediaQuery.of(context).size.width);
    var size = MediaQuery.of(context).size;

    painter.paint(canvas, size);

    ui.Image renderImage = await recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());

    var pngBytes = await renderImage.toByteData(format: ui.ImageByteFormat.png);

    Directory saveDir = await getApplicationDocumentsDirectory();
    File saveFile = File('${saveDir.path}/$filename');
    if (!saveFile.existsSync()) {
      saveFile.createSync(recursive: true);
    }
    saveFile.writeAsBytesSync(pngBytes!.buffer.asUint8List(), flush: true);
  }
}
