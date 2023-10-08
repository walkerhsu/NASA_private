import 'package:flutter/material.dart';
import 'package:water_app/Authentication/authenticate.dart';
import 'package:water_app/Components/login_widget.dart';
import 'package:water_app/Login/login_screen.dart';
import 'package:water_app/Login/signup_screen.dart';
import 'package:water_app/Pages/home_page.dart';
import 'package:water_app/components/small_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,

      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          Image.asset(
            'assets/images/hometitle.jpg',
            opacity: const AlwaysStoppedAnimation(0.55),
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TopScreenImage(
                    screenImageName: 'assets/images/Logo_noback1.png'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const ScreenTitle(title: 'Embrace the ocean!'),
                        const SmallText(
                          text: "Explorez les étendues d'eau.",
                          size: 20,
                        ),
                        const SizedBox(height: 1),
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
                            buttonText: 'Sign up',
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
                                        "test@nasa.com", "00000000")
                                    .then((value) => Navigator.pushNamed(
                                        context, CheckCurrentPosition.id));
                              },
                              child: Text(
                                'Sign in as guest',
                                style: TextStyle(
                                  color: Colors.grey[100],
                                  fontSize: 20,
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
        ]),
      ),
    );
  }
}
