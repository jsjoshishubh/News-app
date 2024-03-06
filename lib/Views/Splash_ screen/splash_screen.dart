import 'package:flutter/material.dart';
import 'package:newsapp/Styles/app_colors.dart';
import 'package:newsapp/Views/Login_SIgnup/social_login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigate to the main screen or any desired screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SocialMediaLoginScreen(), // Replace with your main app screen
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('Assets/Images/news_logo.png'),
              const Text(
                'News App',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 32.0,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
