import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:water_app/components/big_text.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key,
      required this.buttonText,
      this.isOutlined = false,
      required this.onPressed,
      this.width = 280,
      required this.icon});

  final String buttonText;
  final bool isOutlined;
  final Function onPressed;
  final double width;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Material(
        borderRadius: BorderRadius.circular(30),
        elevation: 4,
        child: Container(
            width: width,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: isOutlined ? Colors.grey[200] : const Color(0xFF4879C5),
              border: Border.all(color: const Color(0xFF4879C5), width: 2.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isOutlined ? const Color(0xFF4879C5) : Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  buttonText,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: isOutlined ? const Color(0xFF4879C5) : Colors.white,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class TopScreenImage extends StatelessWidget {
  const TopScreenImage({super.key, required this.screenImageName});
  final String screenImageName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(screenImageName),
          ),
        ),
      ),
    );
  }
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return BigText(
      text: title,
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({super.key, required this.textField});
  final TextField textField;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          width: 2.5,
          color: const Color(0xFF4879C5),
        ),
      ),
      child: textField,
    );
  }
}

class MyBottomScreen extends StatelessWidget {
  const MyBottomScreen({
    super.key,
    required this.textButton,
    required this.question,
    this.heroTag = '',
    required this.buttonPressed,
    required this.questionPressed,
    required this.iconButton,
  });
  final String textButton;
  final String question;
  final String heroTag;
  final Function buttonPressed;
  final Function questionPressed;
  final IconData iconButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: GestureDetector(
              onTap: () {
                questionPressed();
              },
              child: Text(question,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                  )),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Hero(
              tag: heroTag,
              child: MyButton(
                buttonText: textButton,
                width: 140,
                onPressed: () {
                  buttonPressed();
                },
                icon: iconButton,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Alert signUpAlert({
  required Function onPressed,
  required String title,
  required String desc,
  required String btnText,
  required BuildContext context,
}) {
  return Alert(
    context: context,
    title: title,
    desc: desc,
    buttons: [
      DialogButton(
        onPressed: () {
          onPressed();
        },
        width: 130,
        child: Text(
          btnText,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ],
  );
}

Alert showAlert({
  required Function onPressed,
  required String title,
  required String desc,
  required BuildContext context,
}) {
  return Alert(
    context: context,
    type: AlertType.error,
    title: title,
    desc: desc,
    buttons: [
      DialogButton(
        onPressed: () {
          onPressed();
        },
        width: 150,
        child: const Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      )
    ],
  );
}
