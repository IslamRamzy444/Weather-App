import 'package:flutter/material.dart';
import 'package:flutter_application_25/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen(),));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan,Colors.white60],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight
          )
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/cloudy.png"),
                    Text("Weather Application",style: TextStyle(color: Colors.blue[800],fontSize: 16),)
                  ],
                )
              ),
              Text("Flutter App",style: TextStyle(color: Colors.blue[800]),)
            ],
          ),
        ),
      ),
    );
  }
}