import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final email = user?.email ?? 'Chưa xác định';
    final initial = email.isNotEmpty ? email[0].toUpperCase() : 'A';
    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text('Thông tin quản trị', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Quản lý thông tin phiên đăng nhập hiện tại.',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 22),
              Card(child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(children: [
                  CircleAvatar(radius: 42, backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(initial, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryContainer))),
                  const SizedBox(height: 14),
                  Text('Quản trị viên', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 5),
                  Text('ADMINISTRATOR', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.5, color: theme.colorScheme.primary)),
                  const SizedBox(height: 24),
                  _InfoRow(icon: Icons.email_outlined, label: 'Email đăng nhập', value: email),
                  const Divider(height: 26),
                  _InfoRow(icon: Icons.verified_user_outlined, label: 'Xác thực', value: user?.emailVerified == true ? 'Đã xác minh' : 'Tài khoản Firebase'),
                  const Divider(height: 26),
                  _InfoRow(icon: Icons.fingerprint_rounded, label: 'UID', value: user?.uid ?? '—'),
                ]),
              )),
              const SizedBox(height: 16),
              Card(child: SwitchListTile(
                value: theme.brightness == Brightness.dark,
                onChanged: (_) => AppTheme.toggle(),
                secondary: const Icon(Icons.dark_mode_outlined),
                title: const Text('Giao diện tối', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Điều chỉnh giao diện theo môi trường sử dụng'),
              )),
              const SizedBox(height: 16),
              Card(child: const Padding(
                padding: EdgeInsets.all(18),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.security_outlined),
                  SizedBox(width: 12),
                  Expanded(child: Text('Quyền truy cập dữ liệu cần được giới hạn bằng Firebase Security Rules. Việc xóa tài khoản Authentication của người dùng khác cần quyền Admin SDK hoặc Cloud Functions.')),
                ]),
              )),
            ]),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label, value;
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, color: Theme.of(context).colorScheme.primary),
    const SizedBox(width: 13),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      const SizedBox(height: 3),
      SelectableText(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    ])),
  ]);
}
