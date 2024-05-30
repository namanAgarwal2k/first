import 'package:first/models/paint_area.dart';
import 'package:first/controllers/paint_image_state_controller.dart';
import 'package:flutter/material.dart';
import '../models/icon_button.dart' as button;
import '../utils/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FullScreenPage extends HookConsumerWidget {
  const FullScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchState = ref.watch(paintImageStateProvider);
    final readNotifierState = ref.read(paintImageStateProvider.notifier);

    return watchState.imageInfo != null
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onPanDown: (details) => readNotifierState.startStroke(
                    details.localPosition.dx,
                    details.localPosition.dy,
                  ),
                  onPanUpdate: (details) => readNotifierState.moveStroke(
                    details.localPosition.dx,
                    details.localPosition.dy,
                    MediaQuery.of(context).size.width,
                  ),
                  child: PaintBox(
                    imageInfo: watchState.imageInfo,
                    strokes: watchState.strokes,
                    widgetWidth: constraints.maxWidth,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      button.IconButton(
                        onPressed: () {
                          readNotifierState.clearCanvas();
                        },
                        iconData: Icons.clear,
                        text: clearButtonText,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      button.IconButton(
                        onPressed: () {
                          readNotifierState.undoCanvas();
                        },
                        iconData: Icons.undo,
                        text: undoButtonText,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      button.IconButton(
                        onPressed: () {
                          readNotifierState.handleSavePressed(ref, context);
                        },
                        iconData: Icons.save_alt,
                        text: saveButtonText,
                      ),
                    ],
                  ),
                )
              ],
            );
          })
        : const Center(child: CircularProgressIndicator());
  }
}

//copy of old code
//import 'package:first/paint_area.dart';
// import 'package:flutter/material.dart';
// import 'dart:ui' as ui;
// import 'constants.dart';
//
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
//
// import 'drawing_painter.dart';
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     super.key,
//   });
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final _strokes = List<Path>.empty(growable: true);
//   ImageInfo? _imageInfo;
//   final GlobalKey _containerKey = GlobalKey();
//
//   @override
//   void initState() {
//     var img = NetworkImage(imgUrl);
//     img.resolve(const ImageConfiguration()).addListener(
//         ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
//       setState(() {
//         _imageInfo = imageInfo;
//       });
//     }));
//     super.initState();
//   }
//
//   _handleSavePressed() async {
//     ui.PictureRecorder recorder = ui.PictureRecorder();
//     Canvas canvas = Canvas(recorder);
//     var painter = DrawingPainter(_strokes, _imageInfo!);
//     var size = _containerKey.currentContext?.size;
//     painter.paint(canvas, size!);
//
//     ui.Image renderImage = await recorder
//         .endRecording()
//         .toImage(size.width.floor(), size.height.floor());
//
//     var pngBytes = await renderImage.toByteData(format: ui.ImageByteFormat.png);
//
//     Directory saveDir = await getApplicationDocumentsDirectory();
//     File saveFile = File('${saveDir.path}/$filename');
//
//     if (!saveFile.existsSync()) {
//       saveFile.createSync(recursive: true);
//     }
//     saveFile.writeAsBytesSync(pngBytes!.buffer.asUint8List(), flush: true);
//   }
//
//   void _startStroke(double x, double y) {
//     _strokes.add(Path()..moveTo(x, y));
//   }
//
//   void _moveStroke(double x, double y) {
//     if (_imageInfo != null) {
//       final maxHeight = _imageInfo!.image.height.toDouble() /
//           (_imageInfo!.image.width.toDouble() /
//               MediaQuery.of(context).size.width);
//       if (y > maxHeight) {
//         y = maxHeight;
//       } else if (y < 0) {
//         y = 0;
//       }
//     }
//     setState(() {
//       _strokes.last.lineTo(x, y);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _imageInfo != null
//         ? LayoutBuilder(builder: (context, constraints) {
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 GestureDetector(
//                   onPanDown: (details) => _startStroke(
//                     details.localPosition.dx,
//                     details.localPosition.dy,
//                   ),
//                   onPanUpdate: (details) => _moveStroke(
//                     details.localPosition.dx,
//                     details.localPosition.dy,
//                   ),
//                   child: PaintBox(
//                     imageInfo: _imageInfo!,
//                     strokes: _strokes,
//                     widgetWidth: constraints.maxWidth,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             _clearCanvas();
//                           },
//                           icon: const Icon(Icons.clear),
//                           label: const Text("Clear"),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 20,
//                       ),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             _undoCanvas();
//                           },
//                           icon: const Icon(Icons.undo),
//                           label: const Text("Undo"),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 20,
//                       ),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             _handleSavePressed();
//                           },
//                           icon: const Icon(Icons.save_alt),
//                           label: const Text("Save"),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             );
//           })
//         : const Center(child: CircularProgressIndicator());
//   }
//
//   void _clearCanvas() {
//     setState(() {
//       _strokes.clear();
//     });
//   }
//
//   void _undoCanvas() {
//     if (_strokes.isNotEmpty) {
//       setState(() {
//         _strokes.removeAt(_strokes.length - 1);
//       });
//     }
//   }
// }
