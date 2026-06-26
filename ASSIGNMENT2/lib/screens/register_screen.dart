import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/sync_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'todo_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AuthService.instance.register(
        email: _emailController.text,
        password: _passwordController.text,
        displayName: _nameController.text,
      );
      SyncService.instance.syncInBackground();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TodoScreen()),
      );
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Đã xảy ra lỗi: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: AppTheme.backgroundDecoration(isDark),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Tạo tài khoản'),
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Bắt đầu sắp xếp công việc của bạn ✨',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFFEAF1FF) : const Color(0xFF0F1E31),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tạo tài khoản miễn phí để lưu trữ và đồng bộ dữ liệu.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Name (optional)
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    decoration: const InputDecoration(
                      labelText: 'Tên hiển thị (không bắt buộc)',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Icons.alternate_email_rounded),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu!';
                      if (v.length < 4) return 'Mật khẩu phải có ít nhất 4 ký tự!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm password
                  TextFormField(
                    controller: _confirmController,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _register(),
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    decoration: const InputDecoration(
                      labelText: 'Xác nhận mật khẩu',
                      prefixIcon: Icon(Icons.lock_reset_rounded),
                    ),
                    validator: (v) {
                      if (v != _passwordController.text) {
                        return 'Mật khẩu xác nhận không khớp!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  GradientButton(
                    isDark: isDark,
                    loading: _loading,
                    label: 'Đăng ký',
                    onPressed: _register,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đã có tài khoản?',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      TextButton(
                        onPressed: _loading ? null : () => Navigator.of(context).pop(),
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
