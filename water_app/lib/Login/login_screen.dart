import 'package:flutter/material.dart';
import 'package:water_app/Authentication/authenticate.dart';
import 'package:water_app/Components/login_widget.dart';
import 'package:water_app/Login/home_screen.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:water_app/Login/signup_screen.dart';
import 'package:water_app/Pages/home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email;
  late String _password;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const TopScreenImage(
                      screenImageName: 'assets/images/象山.jpeg'),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ScreenTitle(title: 'Login'),
                        MyTextField(
                          textField: TextField(
                              onChanged: (value) {
                                _email = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '',
                                // ),
                              ).copyWith(hintText: 'Email')),
                        ),
                        MyTextField(
                          textField: TextField(
                            obscureText: true,
                            onChanged: (value) {
                              _password = value;
                            },
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '',
                              // ),
                            ).copyWith(hintText: 'Password'),
                          ),
                        ),
                        MyBottomScreen(
                          textButton: 'Login',
                          heroTag: 'login_button',
                          question: 'No account?',
                          buttonPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              _saving = true;
                            });
                            Map<String, String> message =
                                await Authentication.signIn(_email, _password);
                            if (!mounted) return;
                            signUpAlert(
                              context: context,
                              onPressed: () {
                                if (message['title'] == "You are Login!") {
                                  setState(() {
                                    _saving = false;
                                  });
                                  Navigator.pushNamed(context, CheckCurrentPosition.id);
                                } else {
                                  Navigator.pop(context);
                                  setState(() {
                                    _saving = false;
                                  });
                                }
                              },
                              title: message['title']!,
                              desc: message['desc']!,
                              btnText: message['btnText']!,
                            ).show();
                          },
                          questionPressed: () {
                            Navigator.pushNamed(context, SignUpScreen.id);
                          },
                          iconButton: Icons.login_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
