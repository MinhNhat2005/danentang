
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

Future<String> savePickedImage({
  required XFile file,
  required Uint8List bytes,
}) async {
  throw UnsupportedError('Nền tảng không hỗ trợ lưu ảnh.');
}

ImageProvider<Object>? imageProviderFor(String value) => null;
