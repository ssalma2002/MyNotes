import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/constants/routes.dart';
import '../utilities/show_error_dialog.dart';


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
    _password = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          Container(
            height: 130,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: TextField(
              controller: _email,
              decoration: InputDecoration(border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
                  hintText: 'Enter email', prefixIcon: const Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
            child: TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
                hintText: 'Enter password', prefixIcon: const Icon(Icons.key),),
            ),
          ),
          TextButton(onPressed: () async {
            try {
              final email = _email.text;
              final password = _password.text;
              await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: password);
              final user = FirebaseAuth.instance.currentUser;
              if(user?.emailVerified ?? false)
                {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute, (route) => false);
                } else{
                Navigator.of(context).pushNamedAndRemoveUntil(
                    emailVerifyRoute, (route) => false);
              }

            } on FirebaseAuthException catch (e) {

              if (e.code == 'too-many-requests') {
                await showErrorDialog( context,  'Wrong password',);
              }
              else if(e.code == 'INVALID_LOGIN_CREDENTIALS')
                {await showErrorDialog( context,  'User not found',);}
              else {
                await showErrorDialog( context,  e.code);
              }
            } catch(e) {
              await showErrorDialog( context,  e.toString());
            }
          }, child: const Text('Login'),),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute, (route) => false);
              }, child: const Text('Not registered yet ? click here'))
        ],
      ),
    );
  }
}


