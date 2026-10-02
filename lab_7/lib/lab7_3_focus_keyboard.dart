import 'package:flutter/material.dart';

class Lab73FocusKeyboardScreen extends StatefulWidget {
  const Lab73FocusKeyboardScreen({super.key});

  @override
  State<Lab73FocusKeyboardScreen> createState() => _Lab73FocusKeyboardScreenState();
}

class _Lab73FocusKeyboardScreenState extends State<Lab73FocusKeyboardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  @override
  void dispose() {
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Validated with Focus Management!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Lab 7.3 - Focus & Keyboard')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  focusNode: _nameFocus,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  focusNode: _emailFocus,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val == null || !val.contains('@') ? 'Invalid Email' : null,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => (val?.length ?? 0) < 8 ? 'Min 8 chars' : null,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmFocus),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  focusNode: _confirmFocus,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val != _passwordController.text ? 'Mismatch' : null,
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}