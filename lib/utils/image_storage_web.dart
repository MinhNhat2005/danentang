
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

Future<String> savePickedImage({
  required XFile file,
  required Uint8List bytes,
}) async {
  // Giới hạn ảnh để tránh vượt giới hạn Firestore.
  if (bytes.lengthInBytes > 600 * 1024) {
    throw Exception(
      'Ảnh quá lớn. Vui lòng chọn ảnh nhỏ hơn.',
    );
  }

  return 'base64:${base64Encode(bytes)}';
}

ImageProvider<Object>? imageProviderFor(String value) {
  if (value.isEmpty) return null;

  if (value.startsWith('http://') ||
      value.startsWith('https://')) {
    return NetworkImage(value);
  }

  if (value.startsWith('base64:')) {
    try {
      return MemoryImage(
        base64Decode(value.substring(7)),
      );
    } catch (_) {
      return null;
    }
  }

  return null;
}
