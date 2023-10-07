import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

/// CameraPage is the Main Application.

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
  /// Default Constructor
  const CameraPage({super.key, required this.camera});
  final CameraDescription camera;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  late CameraDescription camera;
  ScreenshotController screenshotController = ScreenshotController();
  double _scaleFactor = 1.0;
  double zoom = 1.0;

  Future<dynamic> showCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Captured widget screenshot"),
          ),
          body: Center(child: Image.memory(capturedImage)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            FloatingActionButton(
                onPressed: () async {
                  try {
                    Navigator.of(context).pop();
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print(e);
                  }
                },
                child: const Icon(Icons.close)),
            FloatingActionButton(
                onPressed: () async {
                  try {
                    ImageGallerySaver.saveImage(
                      capturedImage,
                      quality: 100,
                    );
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print(e);
                  }
                },
                child: const Icon(Icons.check)),
          ])),
    );
  }

  @override
  void initState() {
    super.initState();
    camera = widget.camera;
    controller = CameraController(camera, ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: const Text('Take a picture')),
        body: Screenshot(
          controller: screenshotController,
          child: Stack(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                        width: 100, // the actual width is not important here
                        child: CameraPreview(
                          controller,
                        )),
                  )),
              // CameraPreview(controller),
              Center(
                child: Image.asset(
                  'assets/images/山椒魚.jpg',
                  width: 50,
                  height: 50,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onScaleStart: (details) {
                  zoom = _scaleFactor;
                },
                onScaleUpdate: (details) {
                  _scaleFactor = zoom * details.scale;
                  controller.setZoomLevel(_scaleFactor);
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              try {
                if (!kIsWeb) {
                  screenshotController
                      .capture(delay: const Duration(milliseconds: 5))
                      .then((capturedImage) async {
                    print("in");
                    showCapturedWidget(context, capturedImage!);
                  }).catchError((onError) {
                    print(onError);
                  });
                } else {
                  final filepath = await controller.takePicture();
                  screenshotController
                      .captureFromWidget(
                          Stack(
                            children: [
                              SizedBox(
                                width: w, // Width of the cropping box
                                height: h, // Height of the cropping box
                                child: ClipRect(
                                  child: Image.network(
                                    fit: BoxFit.fitHeight,
                                    filepath.path,
                                    height: h,
                                  ),
                                ),
                              ),
                              Center(
                                child: Image.asset(
                                  'assets/images/山椒魚.jpg',
                                  width: 50,
                                  height: 50,
                                ),
                              )
                            ],
                          ),
                          delay: const Duration(milliseconds: 50))
                      .then((capturedImage) async {
                    print("in");
                    showCapturedWidget(context, capturedImage);
                  }).catchError((onError) {
                    print(onError);
                  });
                }
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
            child: const Icon(Icons.camera_alt)));
  }
}
