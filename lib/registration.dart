// api key https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCEoZ91sMRSXsTAHq-l9dDkI41eJnXinP8

//sign in key https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCEoZ91sMRSXsTAHq-l9dDkI41eJnXinP8

import 'dart:io';

import 'package:dojo/log_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                Text(
                  "Register to Dojo",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LogIn()),
                      (route) => route.isFirst,
                    );
                  },
                  child: Text('Already a user? Login'),
                ),
                (_isLoading)
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                        }
                        Map dataToSend = {
                          'email': _emailController.text,
                          'password': _passwordController.text,
                          'returnSecureToken': true,
                        };
                        final response = await http.post(
                          Uri.parse(
                            'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCEoZ91sMRSXsTAHq-l9dDkI41eJnXinP8',
                          ),
                          body: jsonEncode(dataToSend),
                          headers: {'ContentType': 'application/json'},
                        );
                        print(response.body);
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Text('Register'),
                    ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
