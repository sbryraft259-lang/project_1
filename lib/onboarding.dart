import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class OnboardingWrapper extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingWrapper({super.key, required this.onComplete});

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> sliderData = [
    {
      "image": "model/f10d6b2ee44ad989e5eed877cec1c2da1ab2ae1b.jpg",
      "title": "اكتشف الشواطئ الجميلة",
      "description": "احجز مكانك على الشاطئ بسهولة واستمتع بالبحر والاسترخاء."
    },
    {
      "image": "model/f527f91ec7432a0e10eace96077985dfa2f7f7a0.jpg",
      "title": "اخل بسهولة باستخدام الباركود",
      "description": "بعد الحجز، احصل على الباركود الشخصي الخاص بك واستخدمه للدخول المباشر."
    }
  ];

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showHome', true);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: sliderData.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return _buildPage(
                image: sliderData[index]["image"]!,
                title: sliderData[index]["title"]!,
                description: sliderData[index]["description"]!,
                isLastPage: index == sliderData.length - 1,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String image,
    required String title,
    required String description,
    required bool isLastPage,
  }) {
    return Stack(
      children: [
        Container(
          height: 500,
          width: 500,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF64C8EB))),
                const SizedBox(height: 15),
                Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.black54)),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    sliderData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 5),
                      height: 8,
                      width: _currentPage == index ? 40 : 12,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? const Color(0xFF64C8EB) : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                isLastPage
                    ? _buildGradientButton()
                    : _buildNextButton(),
                if (!isLastPage)
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: const Text("تخط", style: TextStyle(color: Color(0xFF64C8EB))),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease),
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF64C8EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        child: const Text("التالى", style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  Widget _buildGradientButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _finishOnboarding,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF64C8EB),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text("ابدأ الآن", style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
