import 'package:flutter/material.dart';
import 'package:water_app/Authentication/authenticate.dart';
import 'package:water_app/Components/login_widget.dart';
import 'package:water_app/Login/home_screen.dart';
import 'package:water_app/Login/login_screen.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = 'signup_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _email = "";
  String _password = "";
  String _confirmPass = "";
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TopScreenImage(
                      screenImageName: 'assets/images/Logo.png'),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const ScreenTitle(title: 'Sign Up'),
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
                              ).copyWith(
                                hintText: 'Email',
                              ),
                            ),
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
                              ).copyWith(
                                hintText: 'Password',
                              ),
                            ),
                          ),
                          MyTextField(
                            textField: TextField(
                              obscureText: true,
                              onChanged: (value) {
                                _confirmPass = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '',
                                // ),
                              ).copyWith(
                                hintText: 'Confirm Password',
                              ),
                            ),
                          ),
                          MyBottomScreen(
                            textButton: 'SignUp',
                            heroTag: 'signup_button',
                            question: 'Have an account?',
                            buttonPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                _saving = true;
                              });
                              if (_confirmPass == _password) {
                                Map<String, String> message =
                                    await Authentication.signUp(
                                        _email, _password);
                                if (context.mounted) {
                                  signUpAlert(
                                    context: context,
                                    title: message['title']!,
                                    desc: message['desc']!,
                                    btnText: message['btnText']!,
                                    onPressed: () {
                                      if (message['title'] ==
                                          'Good, you are signed up!') {
                                        setState(() {
                                          _saving = false;
                                        });
                                        Navigator.pushNamed(
                                            context, LoginScreen.id);
                                      } else {
                                        Navigator.pop(context);
                                        setState(() {
                                          _saving = false;
                                        });
                                      }
                                    },
                                  ).show();
                                }
                              } else {
                                showAlert(
                                    context: context,
                                    title: 'WRONG PASSWORD',
                                    desc:
                                        'Make sure that you write the same password twice',
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        _saving = false;
                                      });
                                    }).show();
                              }
                            },
                            questionPressed: () async {
                              Navigator.pushNamed(context, LoginScreen.id);
                            },
                            iconButton: Icons.login_outlined,
                          ),
                        ],
                      ),
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
