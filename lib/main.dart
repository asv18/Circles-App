import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:circlesapp/routes.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
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

  final primaryColor = const Color.fromARGB(255, 59, 55, 142);
  final primaryColorLight = const Color.fromARGB(255, 245, 248, 255);
  final primaryColorDark = const Color.fromARGB(255, 90, 86, 180);
  final borderColor = const Color.fromARGB(255, 218, 229, 255);
  final canvasColor = Colors.white;
  final indicatorColor = const Color.fromARGB(255, 78, 177, 88);

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
              fontFamily: "Hind",
              textTheme: TextTheme(
                headlineLarge: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                headlineMedium: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                headlineSmall: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                displayMedium: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                displaySmall: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                labelLarge: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 108, 117, 125),
                ),
                labelMedium: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromARGB(255, 108, 117, 125),
                ),
                titleLarge: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                titleSmall: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                bodyMedium: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                bodySmall: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 108, 117, 125),
                ),
              ),
              primaryColor: primaryColor,
              primaryColorLight: primaryColorLight,
              primaryColorDark: primaryColorDark,
              canvasColor: canvasColor,
              indicatorColor: indicatorColor,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    primaryColor,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              dividerColor: const Color.fromARGB(255, 215, 227, 255),
            ),
          );
        }

        /*
        ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
          ),
          primaryColorDark: Colors.blue[800],
          primaryColorLight: const Color.fromARGB(255, 145, 220, 255),
          fontFamily: "Hind",
        ),
        */

        return const Text(
          'loading',
          textDirection: TextDirection.ltr,
        );
      },
    );
  }
}
