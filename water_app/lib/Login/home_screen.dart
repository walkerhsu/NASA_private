import 'package:flutter/material.dart';
import 'package:water_app/Authentication/authenticate.dart';
import 'package:water_app/Login/components.dart';
import 'package:water_app/Login/login_screen.dart';
import 'package:water_app/Login/signup_screen.dart';
import 'package:water_app/Pages/home_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopScreenImage(screenImageName: 'assets/images/Logo.png'),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 15.0, left: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const ScreenTitle(title: 'Hello'),
                      Hero(
                        tag: 'login_button',
                        child: MyButton(
                          icon: Icons.login_outlined,
                          buttonText: 'Login',
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Hero(
                        tag: 'signup_button',
                        child: MyButton(
                          icon: Icons.app_registration_outlined,
                          buttonText: 'Signup',
                          isOutlined: true,
                          onPressed: () {
                            Navigator.pushNamed(context, SignUpScreen.id);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              await Authentication.signIn(
                                  "test@nasa.com", "00000000");

                              Navigator.pushNamed(context, MyHomePage.id);
                            },
                            child: const Text(
                              'Sign up as guest',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
