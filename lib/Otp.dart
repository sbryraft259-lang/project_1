import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtpPage extends StatefulWidget {
  final String email;
  final String name;
  final String password;

  const OtpPage({
    super.key,
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final int otpLength = 6;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  int secondsRemaining = 30;
  bool isButtonDisabled = true;
  Timer? timer;

  String otpCode = "";

  @override
  void initState() {
    super.initState();
    controllers = List.generate(otpLength, (_) => TextEditingController());
    focusNodes = List.generate(otpLength, (_) => FocusNode());
    startTimer();
  }

  void startTimer() {
    secondsRemaining = 30;
    isButtonDisabled = true;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        setState(() {
          timer.cancel();
          isButtonDisabled = false;
        });
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < otpLength - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
      }
    }

    otpCode = controllers.map((c) => c.text).join();
  }

  // ✅ Verify OTP
  Future<void> verifyOtp() async {
    if (otpCode.length != otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ادخل الكود كامل")),
      );
      return;
    }

    final url = Uri.parse(
        "https://beachflow-app-production-7bce.up.railway.app/api/auth/verify");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "otp": otpCode,
        }),
      );

      final data = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? "")),
      );

      if (response.statusCode == 200) {
        // نجاح → روح لصفحة اللوجين
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("خطأ في الاتصال")),
      );
    }
  }

  // ✅ Resend OTP (باستخدام register)
  Future<void> resendOtp() async {
    final url = Uri.parse(
        "https://beachflow-app-production-7bce.up.railway.app/api/auth/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": widget.name,
          "email": widget.email,
          "password": widget.password,
        }),
      );

      final data = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? "تم إرسال الكود")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("خطأ في الاتصال")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تأكيد الكود"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "ادخل كود التحقق المرسل إلى بريدك",style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(otpLength, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => onOtpChanged(value, index),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: verifyOtp,
                  child: const Text(
                    "التحقق من الرمز",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: isButtonDisabled
                    ? null
                    : () async {
                        await resendOtp();
                        startTimer();
                      },
                child: Text(
                  isButtonDisabled
                      ? "إعادة الإرسال بعد $secondsRemaining ثانية"
                      : "لم يصلك الكود؟ إعادة إرسال",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}