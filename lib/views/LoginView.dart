import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password =TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 130,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: TextField( controller: _email,decoration: InputDecoration(border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
                hintText: 'Enter email',prefixIcon: const Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: TextField(controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
                hintText: 'Enter password',prefixIcon: const Icon(Icons.key),),
            ),
          ),
          TextButton(onPressed: ()async{
            try {final email=_email.text;
            final password=_password.text;
            final userCredential =await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
            print(userCredential);
            }on FirebaseAuthException catch(e)
            {
              if(e.code=='INVALID_LOGIN_CREDENTIALS')
              {
                print('User not found');
                print(e.code);
              }

            }
          },child: const Text('Login'),),
        ],
      ),
    );
  }
}
