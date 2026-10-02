import 'package:flutter/material.dart';

class Lab74AsyncValidationScreen extends StatefulWidget {
  const Lab74AsyncValidationScreen({super.key});

  @override
  State<Lab74AsyncValidationScreen> createState() => _Lab74AsyncValidationScreenState();
}

class _Lab74AsyncValidationScreenState extends State<Lab74AsyncValidationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isCheckingEmail = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCheckingEmail = true);

    // Mô phỏng gọi API mất 2 giây
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final email = _emailController.text.trim().toLowerCase();
    if (email.startsWith('taken')) {
      setState(() => _isCheckingEmail = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This email is already taken!'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      setState(() => _isCheckingEmail = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup Successful!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 7.4 - Async Email Check')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Type "taken@gmail.com" to test error',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || !val.contains('@') ? 'Invalid Email' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => (val?.length ?? 0) < 8 ? 'Min 8 chars' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val != _passwordController.text ? 'Mismatch' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isCheckingEmail ? null : _submit,
                child: _isCheckingEmail
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 10),
                    Text('Checking Email...'),
                  ],
                )
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}