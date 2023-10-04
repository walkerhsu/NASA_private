import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:camerawesome/camerawesome_plugin.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

/// CameraApp is the Main Application.

// class streamCameraPage extends StatelessWidget {
//   const streamCameraPage({
//     super.key,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(stream: stream, builder: builder)
//   }
// }

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
  });
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CameraAwesomeBuilder.awesome(
          saveConfig: SaveConfig.photo(
            pathBuilder: (sensors) async {
              final Directory extDir = await getTemporaryDirectory();
              final testDir = await Directory(
                '${extDir.path}/camerawesome',
              ).create(recursive: true);
              if (sensors.length == 1) {
                final String filePath =
                    '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
                SingleCaptureRequest singleCaptureRequest =
                    SingleCaptureRequest(filePath, sensors.first);
                return singleCaptureRequest;
              } else {
                return MultipleCaptureRequest(
                  {
                    for (final sensor in sensors)
                      sensor:
                          '${testDir.path}/${sensor.position == SensorPosition.front ? 'front_' : "back_"}${DateTime.now().millisecondsSinceEpoch}.jpg',
                  },
                );
              }
            },
          ),
          bottomActionsBuilder: (state) => AwesomeBottomActions(
            state: state,
            captureButton: MyCaptureButton(state: state as PhotoCameraState),
            right: StreamBuilder(
              stream: state.captureState$,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  return AwesomeMediaPreview(
                    mediaCapture: snapshot.requireData,
                    onMediaTap: (mediaCapture) => OpenFile.open(mediaCapture
                        .captureRequest
                        .when(single: (single) => single.file!.path)),
                  );
                }
              },
            ),
          ),
          enablePhysicalButton: true,
          filter: AwesomeFilter.AddictiveRed,
          // flashMode: FlashMode.auto,
          sensorConfig: SensorConfig.single(
            sensor: Sensor.position(SensorPosition.back),
            // flashMode: FlashMode.auto,
            aspectRatio: CameraAspectRatios.ratio_4_3,
            zoom: 0.0,
          ),
          // filter: AwesomeFilter.AddictiveRed,
          previewFit: CameraPreviewFit.fitWidth,
          onMediaTap: (mediaCapture) {
            OpenFile.open(
              mediaCapture.captureRequest
                  .when(single: (single) => single.file?.path),
            );
          },
        ),
      ),
    );
  }
}

class MyCaptureButton extends StatelessWidget {
  const MyCaptureButton({
    super.key,
    required this.state,
  });

  final PhotoCameraState state;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final filePath = await state.takePhoto().then(
            (result) => result.when(single: (single) => single.file?.path));
        await ImageGallerySaver.saveFile(filePath!);
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 5,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.camera,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
