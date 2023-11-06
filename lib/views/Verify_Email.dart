import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/constants/routes.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email',),),
      body: Column(
        children: [
          const Text("We've already sent an email verification, please check your Email"),
          const Text("In case you didn't receive the email verification, press click on the button"),
          TextButton(onPressed: ()async{
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          }, child: const Text('Send email verification'),),
          TextButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(registerRoute,
                  (route) => false,
            );
          }, child: const Text("Restart"))
        ],
      ),
    );

  }
}