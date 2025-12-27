import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    final error = await _authService.login(_emailController.text.trim(), _passwordController.text.trim());
    if (error != null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      // Clear navigation stack and go to the first screen (handled by StreamBuilder in main.dart)
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _handleReset() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter email first")));
      return;
    }
    await _authService.resetPassword(_emailController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reset email sent!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _handleReset, child: const Text("Forgot Password?"))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                onPressed: _isLoading ? null : _handleLogin, 
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Login"),
              ),
            ),
            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen())), child: const Text("New here? Sign Up")),
          ],
        ),
      ),
    );
  }
}