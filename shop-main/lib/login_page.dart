import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'stylesheet.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
      case 'wrong-password':
      case 'user-not-found':
      case 'invalid-credential':
        return 'Incorrect email or password';
      default:
        return e.message ?? 'Authentication failed';
    }
  }

  Future<void> _handleSignInEmail() async {
    setState(() { _error = null; _busy = true; });
    try {
      await _auth.signInWithEmail(_email.text.trim(), _password.text);
      if (!mounted) return;
      // Go to Home using named route
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _mapAuthError(e));
    } catch (e) {
      setState(() => _error = 'Authentication failed');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _handleRegisterEmail() async {
    setState(() { _error = null; _busy = true; });
    try {
      await _auth.registerWithEmail(_email.text.trim(), _password.text);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } on FirebaseAuthException catch (e) {
      // For register, show specific messages except invalid-email
      if (e.code == 'invalid-email') {
        setState(() => _error = 'Incorrect email or password');
      } else {
        setState(() => _error = e.message ?? 'Could not create account');
      }
    } catch (e) {
      setState(() => _error = 'Could not create account');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _handleGoogle() async {
    setState(() { _error = null; _busy = true; });
    try {
      await _auth.signInWithGoogle();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'Google sign-in failed');
    } catch (e) {
      setState(() => _error = 'Google sign-in failed');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Sign in', style: Styles.sectionTitle),
                const SizedBox(height: 16),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 12),
                if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _busy ? null : _handleSignInEmail,
                    child: _busy
                        ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Sign in'),
                  ),
                ),
                TextButton(
                  onPressed: _busy ? null : _handleRegisterEmail,
                  child: const Text('Create account'),
                ),
                const SizedBox(height: 8),
                Divider(color: theme.dividerColor),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in with Google'),
                    onPressed: _busy ? null : _handleGoogle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}