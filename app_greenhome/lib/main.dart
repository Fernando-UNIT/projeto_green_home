import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.signInWithEmailAndPassword( //Autenticacao provisoria, ate as telas de login e cadastro estarem prontas
    email: 'testeuser@souunit.com.br',
    password: 'abcdef', 
  );

  runApp(const GreenHomeApp());
}