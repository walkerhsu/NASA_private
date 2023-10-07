import 'package:firebase_auth/firebase_auth.dart';
import 'package:water_app/Storage/cloud_storage.dart';
import 'package:water_app/globals.dart';

class Authentication {
  // get current user email
  static String getCurrentUserEmail() {
    return FirebaseAuth.instance.currentUser!.email!;
  }

  // sign out
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<Map<String, String>> signIn(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      CloudStorage.loadUserData(email);
      return {
        'title': 'You are Login!',
        'desc': '',
        'btnText': 'Home page',
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return {
          'title': 'Wrong password',
          'desc': 'Please try again',
          'btnText': 'Try Now',
        };
      } else if (e.code == 'user-not-found') {
        return {
          'title': 'No user found for that email',
          'desc': 'Please sign up first',
          'btnText': 'Sign up',
        };
      } else if (e.code == 'invalid-email') {
        return {
          'title': 'The email address is badly formatted',
          'desc': 'Please try again',
          'btnText': 'Try Now',
        };
      } else {
        return {
          'title': e.toString(),
          'desc': 'Please try again later',
          'btnText': 'Try Now',
        };
      }
    }
  }

  static Future<Map<String, String>> signUp(
      String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      currentUser.email = email;
      CloudStorage.uploadUserData(email);
      return {
        'title': 'Good, you are signed up!',
        'desc': 'Please check your email to verify your account.',
        'btnText': 'Login Now',
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return {
          'title': 'The password provided is too weak.',
          'desc': 'Please create a new password',
          'btnText': 'Change it',
        };
      } else if (e.code == 'email-already-in-use') {
        return {
          'title': 'The account already exists for that email.',
          'desc': 'Please create another email or login',
          'btnText': 'Change it',
        };
      } else if (e.code == 'invalid-email.') {
        return {
          'title': 'The email address is badly formatted.',
          'desc': 'Please create the correct email',
          'btnText': 'Change it',
        };
      } else {
        return {
          'title': e.toString(),
          'desc': 'Please try again later',
          'btnText': 'Try Now',
        };
      }
    } catch (e) {
      return {
        'title': e.toString(),
        'desc': 'Please try again later',
        'btnText': 'Try Now',
      };
    }
  }
}
