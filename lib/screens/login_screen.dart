import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _hidePassword = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      await AuthService.instance.signIn(_email.text, _password.text);
    } catch (e) {
      if (mounted) setState(() => _error = _friendlyError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(Object e) {
    final text = e.toString();
    if (text.contains('invalid-credential') || text.contains('wrong-password') ||
        text.contains('user-not-found')) return 'Email hoặc mật khẩu không chính xác.';
    if (text.contains('network-request-failed')) return 'Không có kết nối mạng. Vui lòng thử lại.';
    return 'Đăng nhập thất bại: $text';
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: dark
                      ? const [Color(0xFF211A32), Color(0xFF17141F), Color(0xFF211D2D)]
                      : const [Color(0xFFEDE7FF), Color(0xFFF8F7FC), Color(0xFFE8E1FF)],
                ),
              ),
            ),
          ),
          Positioned(top: -90, right: -50, child: _GlowCircle(size: 260)),
          Positioned(bottom: -120, left: -70, child: _GlowCircle(size: 300)),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton.filledTonal(
                  tooltip: dark ? 'Chế độ sáng' : 'Chế độ tối',
                  onPressed: AppTheme.toggle,
                  icon: Icon(dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width > 700 ? 940 : 460),
                child: width > 700
                    ? Row(
                        children: [
                          Expanded(child: _BrandPanel()),
                          const SizedBox(width: 24),
                          Expanded(child: _LoginCard(
                            formKey: _formKey, email: _email, password: _password,
                            loading: _loading, hidePassword: _hidePassword,
                            error: _error, onLogin: _login,
                            onTogglePassword: () => setState(() => _hidePassword = !_hidePassword),
                          )),
                        ],
                      )
                    : _LoginCard(
                        formKey: _formKey, email: _email, password: _password,
                        loading: _loading, hidePassword: _hidePassword,
                        error: _error, onLogin: _login,
                        onTogglePassword: () => setState(() => _hidePassword = !_hidePassword),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 68, height: 68,
            decoration: BoxDecoration(color: color.primary, borderRadius: BorderRadius.circular(22)),
            child: const Icon(Icons.hub_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 28),
          Text('Quản lý tinh gọn.\nVận hành thông minh.',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, height: 1.18)),
          const SizedBox(height: 16),
          Text('Không gian quản trị người dùng tập trung, đồng bộ dữ liệu linh hoạt trên Web và Android.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color.onSurfaceVariant, height: 1.6)),
          const SizedBox(height: 28),
          const _Feature(icon: Icons.cloud_sync_rounded, text: 'Đồng bộ dữ liệu với Firebase'),
          const _Feature(icon: Icons.devices_rounded, text: 'Trải nghiệm đa nền tảng'),
          const _Feature(icon: Icons.shield_outlined, text: 'Đăng nhập bảo mật'),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 13),
    child: Row(children: [
      Icon(icon, color: Theme.of(context).colorScheme.primary),
      const SizedBox(width: 12),
      Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    ]),
  );
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.formKey, required this.email, required this.password,
    required this.loading, required this.hidePassword, required this.error,
    required this.onLogin, required this.onTogglePassword,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController email, password;
  final bool loading, hidePassword;
  final String? error;
  final VoidCallback onLogin, onTogglePassword;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('Chào mừng trở lại', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 7),
            Text('Đăng nhập để tiếp tục vào hệ thống quản trị.', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 28),
            Text('EMAIL', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 8),
            TextFormField(
              controller: email, keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'admin@example.com', prefixIcon: Icon(Icons.mail_outline_rounded)),
              validator: (v) => v == null || !v.contains('@') ? 'Email không hợp lệ' : null,
            ),
            const SizedBox(height: 18),
            Text('MẬT KHẨU', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 8),
            TextFormField(
              controller: password, obscureText: hidePassword,
              decoration: InputDecoration(
                hintText: 'Nhập mật khẩu', prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(onPressed: onTogglePassword,
                  icon: Icon(hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
              onFieldSubmitted: (_) => onLogin(),
            ),
            if (error != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(12)),
                child: Text(error!, style: TextStyle(color: theme.colorScheme.onErrorContainer)),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(height: 52, child: FilledButton(
              onPressed: loading ? null : onLogin,
              child: loading
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('ĐĂNG NHẬP', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: .6)),
                      SizedBox(width: 8), Icon(Icons.arrow_forward_rounded, size: 18),
                    ]),
            )),
            const SizedBox(height: 18),
            Text('Tài khoản quản trị được tạo trong Firebase Authentication.',
                textAlign: TextAlign.center, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ]),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size});
  final double size;
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.purple.withValues(alpha: .08)),
    ),
  );
}
