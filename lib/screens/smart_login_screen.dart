import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:protea_metering/screens/old_password_screen.dart';
import 'package:protea_metering/screens/reset_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'dart:convert';
import '../widgets/app_scaffold.dart';
import '../config/api_config.dart';
import '../services/smart_login_service.dart';
import '../models/smart_login_response.dart';
import 'smart_complex_screen.dart';

class SmartLoginScreen extends StatefulWidget {
  const SmartLoginScreen({super.key});

  @override
  State<SmartLoginScreen> createState() => _SmartLoginScreenState();
}

class _SmartLoginScreenState extends State<SmartLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('saved_username');
    final savedPassword = prefs.getString('saved_password');
    if (savedUsername != null) {
      setState(() {
        _usernameController.text = savedUsername;
        if (savedPassword != null) {
          _passwordController.text = savedPassword;
        }
        _rememberMe = true;
      });
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_username', _usernameController.text);
      await prefs.setString('saved_password', _passwordController.text);
    } else {
      await prefs.remove('saved_username');
      await prefs.remove('saved_password');
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse(ApiConfig.smartLogin()),
          body: {
            'username': _usernameController.text,
            'password': _passwordController.text,
          },
        );

        if (!mounted) return;

        if (response.statusCode == 200) {
          await _saveCredentials();
          final loginData = SmartLoginResponse.fromJson(jsonDecode(response.body));
          await SmartLoginService.saveLoginData(loginData);
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SmartComplexScreen(loginData: loginData),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid credentials. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Smart Login',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.account_circle,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text('Remember Username'),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OldPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text('Get Old Password'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text('Reset Password'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}