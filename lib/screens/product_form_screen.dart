import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../utils/image_storage.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key, this.product});
  final ProductModel? product;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _quantity;
  final _picker = ImagePicker();
  XFile? _selectedFile;
  Uint8List? _selectedBytes;
  String _image = '';
  bool _saving = false;
  bool get _editing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.product?.name ?? '');
    _price = TextEditingController(text: widget.product?.price.toString() ?? '');
    _quantity = TextEditingController(text: widget.product?.soluong.toString() ?? '');
    _image = widget.product?.image ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _quantity.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 55,
        maxWidth: 700,
        maxHeight: 700,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _selectedFile = file;
        _selectedBytes = bytes;
      });
    } catch (e) {
      _message('Không thể chọn hình ảnh: $e');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFile == null && _image.isEmpty) {
      _message('Vui lòng chọn hình ảnh sản phẩm.');
      return;
    }
    setState(() => _saving = true);
    try {
      var image = _image;
      if (_selectedFile != null && _selectedBytes != null) {
        image = await savePickedImage(file: _selectedFile!, bytes: _selectedBytes!);
      }
      final price = num.parse(_price.text.trim());
      final quantity = int.parse(_quantity.text.trim());
      if (_editing) {
        await ProductService.instance.updateProduct(
          id: widget.product!.id,
          name: _name.text,
          price: price,
          soluong: quantity,
          image: image,
        );
      } else {
        await ProductService.instance.addProduct(
          name: _name.text,
          price: price,
          soluong: quantity,
          image: image,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _message('Không thể lưu sản phẩm: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _message(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  ImageProvider<Object>? get _preview {
    if (_selectedBytes != null) return MemoryImage(_selectedBytes!);
    return imageProviderFor(_image);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preview = _preview;
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Sửa sản phẩm' : 'Thêm sản phẩm')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(_editing ? 'Cập nhật sản phẩm' : 'Thông tin sản phẩm',
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Center(
                        child: Column(children: [
                          Container(
                            width: 180,
                            height: 150,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                              image: preview == null ? null : DecorationImage(image: preview, fit: BoxFit.cover),
                            ),
                            child: preview == null
                                ? const Icon(Icons.image_outlined, size: 54)
                                : null,
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: _saving ? null : _pickImage,
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('Chọn hình ảnh'),
                          ),
                          Text('Ảnh được lưu đồng bộ trên Firebase', style: theme.textTheme.bodySmall),
                        ]),
                      ),
                      const SizedBox(height: 22),
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(labelText: 'Tên sản phẩm (name)', prefixIcon: Icon(Icons.inventory_2_outlined)),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Vui lòng nhập tên sản phẩm' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _price,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Giá sản phẩm (price)', prefixIcon: Icon(Icons.payments_outlined), suffixText: 'VNĐ'),
                        validator: (v) {
                          final n = num.tryParse((v ?? '').trim());
                          return n == null || n < 0 ? 'Giá phải là số không âm' : null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _quantity,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Số lượng (soluong)', prefixIcon: Icon(Icons.numbers_outlined)),
                        validator: (v) {
                          final n = int.tryParse((v ?? '').trim());
                          return n == null || n < 0 ? 'Số lượng phải là số nguyên không âm' : null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 50,
                        child: FilledButton.icon(
                          onPressed: _saving ? null : _save,
                          icon: _saving
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.save_outlined),
                          label: Text(_saving ? 'Đang lưu...' : (_editing ? 'Lưu thay đổi' : 'Thêm sản phẩm')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
