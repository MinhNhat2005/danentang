import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';
import '../utils/image_storage.dart';
import 'product_form_screen.dart';
import 'profile_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductFormScreen()));
  }

  Future<void> _edit(ProductModel product) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => ProductFormScreen(product: product)));
  }

  Future<void> _delete(ProductModel product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa sản phẩm?'),
        content: Text('Bạn có chắc muốn xóa "${product.name}" không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Hủy')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await ProductService.instance.deleteProduct(product.id);
      if (mounted) _message('Đã xóa sản phẩm.');
    } catch (e) {
      if (mounted) _message('Không thể xóa sản phẩm: $e');
    }
  }

  void _message(String value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));

  String _money(num value) => '${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')} đ';

  Widget _productImage(String value, {double width = 76, double height = 76}) {
    final provider = imageProviderFor(value);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: provider == null
            ? const Icon(Icons.image_not_supported_outlined, size: 30)
            : Image(image: provider, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined)),
      ),
    );
  }

  Widget _productCard(ProductModel product, {bool compact = false}) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _productImage(product.image, width: compact ? 82 : 96, height: compact ? 82 : 96),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(_money(product.price), style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text('Số lượng: ${product.soluong}', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Thao tác',
              onSelected: (value) => value == 'edit' ? _edit(product) : _delete(product),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined), SizedBox(width: 10), Text('Sửa')])),
                PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, color: Colors.red), SizedBox(width: 10), Text('Xóa')])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty(String title, String detail, IconData icon) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 54, color: Theme.of(context).colorScheme.primary.withValues(alpha: .65)),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(detail, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
      ]),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 850;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !wide,
        title: Row(children: [
          if (wide) ...[
            Container(width: 38, height: 38, decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.storefront_outlined, color: Colors.white)),
            const SizedBox(width: 12),
          ],
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Product Admin', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            Text('Quản lý sản phẩm', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
          ]),
        ]),
        actions: [
          IconButton(tooltip: theme.brightness == Brightness.dark ? 'Chế độ sáng' : 'Chế độ tối',
            onPressed: AppTheme.toggle, icon: Icon(theme.brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode_outlined)),
          IconButton(tooltip: 'Tài khoản Admin', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            icon: const Icon(Icons.account_circle_outlined)),
          Padding(padding: const EdgeInsets.only(right: 12), child: IconButton.filledTonal(
            tooltip: 'Đăng xuất', onPressed: () => AuthService.instance.signOut(), icon: const Icon(Icons.logout_rounded))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text('Thêm sản phẩm'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 90),
            child: StreamBuilder<List<ProductModel>>(
              stream: ProductService.instance.watchProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return _empty('Không tải được sản phẩm', '${snapshot.error}', Icons.cloud_off_outlined);
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final all = snapshot.data!;
                final products = all.where((p) => p.name.toLowerCase().contains(_query)).toList();
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text('Danh sách sản phẩm', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 5),
                  Text('Thêm, xem, chỉnh sửa và xóa thông tin sản phẩm trên Firebase Firestore.',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 18),
                  Row(children: [
                    Expanded(child: TextField(
                      controller: _search,
                      onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm theo tên sản phẩm...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _query.isEmpty ? null : IconButton(onPressed: () { _search.clear(); setState(() => _query = ''); }, icon: const Icon(Icons.close)),
                      ),
                    )),
                    const SizedBox(width: 12),
                    Chip(avatar: const Icon(Icons.inventory_2_outlined, size: 18), label: Text('${products.length} sản phẩm')),
                  ]),
                  const SizedBox(height: 12),
                  Expanded(
                    child: products.isEmpty
                        ? _empty(all.isEmpty ? 'Chưa có sản phẩm' : 'Không tìm thấy sản phẩm',
                            all.isEmpty ? 'Nhấn “Thêm sản phẩm” để tạo sản phẩm đầu tiên.' : 'Thử tìm bằng tên khác.', Icons.inventory_2_outlined)
                        : wide
                            ? LayoutBuilder(builder: (context, constraints) {
                                final columns = constraints.maxWidth > 1000 ? 3 : 2;
                                return GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns, mainAxisExtent: 132, crossAxisSpacing: 12, mainAxisSpacing: 4),
                                  itemCount: products.length,
                                  itemBuilder: (_, i) => _productCard(products[i]),
                                );
                              })
                            : ListView.builder(
                                itemCount: products.length,
                                itemBuilder: (_, i) => _productCard(products[i], compact: true),
                              ),
                  ),
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
