import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/sync_service.dart';
import '../theme/app_theme.dart';
import 'register_screen.dart';
import 'todo_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AuthService.instance.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Save login + push local data to the server in the background.
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
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(isDark: isDark),
                    const SizedBox(height: 40),

                    // Email field
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
                        if (v == null || v.trim().isEmpty) {
                          return 'Vui lòng nhập email!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(),
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
                        if (v == null || v.isEmpty) {
                          return 'Vui lòng nhập mật khẩu!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    // Login button
                    GradientButton(
                      isDark: isDark,
                      loading: _loading,
                      label: 'Đăng nhập',
                      onPressed: _login,
                    ),
                    const SizedBox(height: 20),

                    // Go to register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chưa có tài khoản?',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                        TextButton(
                          onPressed: _loading
                              ? null
                              : () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => const RegisterScreen()),
                                  ),
                          child: const Text(
                            'Đăng ký ngay',
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
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isDark;
  const _Header({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFFADC6FF), const Color(0xFF8B5CF6)]
                  : [const Color(0xFF0058BE), const Color(0xFF6366F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: (isDark ? const Color(0xFFADC6FF) : const Color(0xFF0058BE))
                    .withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.checklist_rounded, size: 44, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          'Chào mừng trở lại!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFFEAF1FF) : const Color(0xFF0F1E31),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Đăng nhập để tiếp tục với TaskFlow Pro',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
      ],
    );
  }
}

/// Reusable gradient primary button shared by Login & Register.
class GradientButton extends StatelessWidget {
  final bool isDark;
  final bool loading;
  final String label;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.isDark,
    required this.loading,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFFADC6FF), const Color(0xFF8B5CF6)]
              : [const Color(0xFF0058BE), const Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: (isDark ? const Color(0xFFADC6FF) : const Color(0xFF0058BE))
                .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
