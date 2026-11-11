
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String> savePickedImage({
  required XFile file,
  required Uint8List bytes,
}) async {
  // Giới hạn kích thước để không vượt giới hạn Firestore.
  if (bytes.lengthInBytes > 600 * 1024) {
    throw Exception(
      'Ảnh quá lớn. Vui lòng chọn ảnh nhỏ hơn.',
    );
  }

  // Vẫn lưu bản ảnh cục bộ trên điện thoại.
  final appDir = await getApplicationDocumentsDirectory();
  final imageDir = Directory('${appDir.path}/user_images');

  if (!await imageDir.exists()) {
    await imageDir.create(recursive: true);
  }

  final extension = file.name.contains('.')
      ? file.name.split('.').last.toLowerCase()
      : 'jpg';

  final safeExtension =
      RegExp(r'^[a-z0-9]{1,8}$').hasMatch(extension)
          ? extension
          : 'jpg';

  final fileName =
      '${DateTime.now().microsecondsSinceEpoch}.$safeExtension';

  final destination = File('${imageDir.path}/$fileName');

  await File(file.path).copy(destination.path);

  // Lưu nội dung ảnh vào Firestore để đồng bộ Web và Android.
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

  final file = File(value);
  return file.existsSync() ? FileImage(file) : null;
}
