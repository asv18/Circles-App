import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:circlesapp/routes.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

void main() async {
  await Hive.initFlutter();

  const secureStorage = FlutterSecureStorage();

  dynamic encryptionKey = await secureStorage.read(key: 'hive_key');

  if (encryptionKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(
      key: 'hive_key',
      value: base64Url.encode(key),
    );
  }

  final key = await secureStorage.read(key: 'hive_key');
  encryptionKey = base64Url.decode(key!);

  await Hive.openBox(
    'userBox',
    encryptionCipher: HiveAesCipher(encryptionKey),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            'error',
            textDirection: TextDirection.ltr,
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            routes: appRoutes,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
              ),
              primaryColorDark: Colors.blue[800],
              primaryColorLight: const Color.fromARGB(255, 145, 220, 255),
              fontFamily: "Hind",
            ),
          );
        }

        return const Text(
          'loading',
          textDirection: TextDirection.ltr,
        );
      },
    );
  }
}
