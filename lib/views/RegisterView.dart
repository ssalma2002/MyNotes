import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return
            Scaffold(
            appBar: AppBar(title: const Text('Register',style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,),
            body: Column(
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
                  try{final email=_email.text;
                  final password=_password.text;
                  final userCredential =await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                  print(userCredential);} catch(e)
                  {}
                },child: const Text('Register'),),
                TextButton(onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
                }, child: Text('Already registered ? click here'))
              ],
            ),
        );
  }
}
