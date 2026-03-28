import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:por2/login.dart';
import 'dart:convert';
import 'Otp.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('كلمة المرور غير متطابقة')));
      return;
    }

    setState(() => isLoading = true);

    try {
      final url = Uri.parse(
        'https://beachflow-app-production-7bce.up.railway.app/api/auth/register',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name':
              "${_firstNameController.text} ${_lastNameController.text}", // دمج الاسم
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      setState(() => isLoading = false);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpPage(
              email: _emailController.text.trim(),
              name: "${_firstNameController.text} ${_lastNameController.text}",
              password: _passwordController.text,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'] ?? "حدث خطا")));
      }
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('إنشاء حساب')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // البريد
                TextFormField(
                  controller: _emailController,
                  decoration: inputStyle('البريد الإلكتروني الخاص بك'),
                  validator: (v) => v!.isEmpty ? 'ادخل البريد' : null,
                ),

                const SizedBox(height: 15),

                // الاسم الأول + اسم العائلة
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: inputStyle('الاسم الأول'),
                        validator: (v) =>
                            v!.isEmpty ? 'ادخل الاسم الأول' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: inputStyle('اسم العائلة'),
                        validator: (v) =>
                            v!.isEmpty ? 'ادخل اسم العائلة' : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // الباسورد
                TextFormField(
                  controller: _passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: inputStyle('كلمة المرور').copyWith(
                    suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      child: Icon(isPasswordVisible?Icons.visibility:Icons.visibility_off,size: 20,),
                    ),
                  ),
                  validator: (v) => v!.length < 6 ? '6 أحرف على الأقل' : null,
                ),

                const SizedBox(height: 15),

                // تأكيد الباسورد
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !isConfirmPasswordVisible,
                  decoration: inputStyle('تأكيد كلمة المرور').copyWith(
                    suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                      child: Icon(isConfirmPasswordVisible?Icons.visibility:Icons.visibility_off,size: 20,),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'أكد كلمة المرور' : null,
                ),

                const SizedBox(height: 25),

                // زر إنشاء حساب
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'إنشاء حساب',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),

                const SizedBox(height: 15),

                // تسجيل الدخول
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("هل لديك حساب بالفعل؟ "),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text("تسجيل الدخول"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
