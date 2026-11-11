
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'image_storage_stub.dart'
    if (dart.library.io) 'image_storage_io.dart'
    if (dart.library.html) 'image_storage_web.dart' as platform;

Future<String> savePickedImage({
  required XFile file,
  required Uint8List bytes,
}) {
  return platform.savePickedImage(file: file, bytes: bytes);
}

ImageProvider<Object>? imageProviderFor(String value) {
  return platform.imageProviderFor(value);
}
