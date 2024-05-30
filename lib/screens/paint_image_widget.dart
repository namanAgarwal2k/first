import 'package:first/screens/fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../controllers/paint_image_state_controller.dart';
import '../models/paint_area.dart';
import '../utils/constants.dart';

class PaintImageWidget extends ConsumerStatefulWidget {
  const PaintImageWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<PaintImageWidget> createState() => _PaintImageWidgetState();
}

class _PaintImageWidgetState extends ConsumerState<PaintImageWidget> {
  @override
  void initState() {
    var img = NetworkImage(imgUrl);
    img.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
      ref.read(paintImageStateProvider.notifier).setImageInfo(imageInfo);
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paintImageStateProvider);
    return state.imageInfo != null
        ? LayoutBuilder(builder: (context, constraints) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FullScreenPage()));
              },
              child: PaintBox(
                imageInfo: state.imageInfo,
                strokes: state.strokes,
                widgetWidth: constraints.maxWidth,
              ),
            );
          })
        : const CircularProgressIndicator();
  }
}
