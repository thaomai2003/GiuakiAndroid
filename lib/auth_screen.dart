import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:giuaki/pages/Home.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isSignUp = true;

  Future<void> _submit() async {
    try {
      if (isSignUp) {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công! Vui lòng đăng nhập.')),
        );
        setState(() {
          isSignUp = false;
        });
      } else {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thành công!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignUp ? 'Đăng Ký' : 'Đăng Nhập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(isSignUp ? 'Đăng Ký' : 'Đăng Nhập'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isSignUp = !isSignUp;
                });
              },
              child: Text(isSignUp
                  ? 'Đã có tài khoản? Đăng nhập'
                  : 'Chưa có tài khoản? Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }
}
