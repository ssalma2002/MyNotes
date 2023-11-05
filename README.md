# MyNotes

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
## Register view
A simple form in which the user have to enter an email and password.
Connected with firebase.
Email Verification
Textbutton to login if already have an account

## Login view 
A simple form in which the user have to enter your email and password , that he has already registered in the system. 
Connected with firebase.
Textbutton to register if no account
Textbutton to Main UI if you have an account

## Main UI view
Contain PopMenuButton that contain PopMenuItem in actions in appbar that displays logout
Upon tapping on logout an alert dialog will show asking if you are sure. if canceled than will remain in Main UI view. if you are sure then return to login view