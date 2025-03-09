import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import '../../widgets/app_button.dart';
import '../auth/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0;

  final List<AssetImage> _carouselImages = const [
    AssetImage('images/image1.png'),
    AssetImage('images/image2.png'),
    AssetImage('images/image3.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image carousel
                  slider.CarouselSlider(
                    items: _carouselImages
                        .map((item) => Image(image: item))
                        .toList(),
                    options: slider.CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tagline text
                  const Text(
                    'Start working out to reach your creative peak.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Carousel indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _carouselImages.length; i++)
                  Icon(
                    _currentIndex == i ? Icons.circle : Icons.circle_outlined,
                    size: 12,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            // Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppButton(
                text: 'Get Started',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Terms and Privacy text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  // Show terms and privacy policy
                },
                child: const Text(
                  'By continuing you agree to the apps Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}