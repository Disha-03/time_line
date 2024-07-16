import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_demo/config/text_style.dart';
import 'package:timeline_demo/view/home/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => const HomePage());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Timeline App",
          style: AppTextStyle.regular600.copyWith(fontSize: 20),
        ),
      ),
    );
  }
}
