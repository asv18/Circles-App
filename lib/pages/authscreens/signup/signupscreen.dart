import 'package:circlesapp/components/UI/form_field.dart';
import 'package:circlesapp/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _nameController;

  final _formKey = GlobalKey<FormState>();

  bool _passNotVisibile = true;
  bool _invalidUser = false;

  final _emailRegex =
      r"""(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""";

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nameController = TextEditingController();
  }

  void _toggleVisibility() {
    setState(() {
      _passNotVisibile = !_passNotVisibile;
    });
  }

  Future<void> createEmailPassUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService().emailAndPasswordRegister(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
        );
      } on FirebaseAuthException catch (e) {
        print(e);
        setState(() {
          _invalidUser = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                (_invalidUser)
                    ? Container(
                        height: 30,
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Invalid email or password",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 30,
                      ),
                FormTextField(
                  visibility: false,
                  controller: _nameController,
                  hintText: "Name",
                  validator: (value) {
                    value = value as String;
                    if (value == "" || !value.contains(" ")) {
                      return "Please put your first and last name!";
                    }
                  },
                  onChanged: () {
                    setState(() {
                      _invalidUser = false;
                    });
                  },
                ),
                FormTextField(
                  visibility: false,
                  controller: _emailController,
                  hintText: "Email",
                  validator: (value) {
                    if (!RegExp(_emailRegex).hasMatch(value) || value == "") {
                      return "Invalid email!";
                    }
                  },
                  onChanged: () {
                    setState(() {
                      _invalidUser = false;
                    });
                  },
                ),
                FormTextField(
                  visibility: _passNotVisibile,
                  controller: _passwordController,
                  hintText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () => _toggleVisibility(),
                    icon: Icon(
                      (_passNotVisibile)
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  validator: (value) {
                    if (value == "") {
                      return "Invalid password!";
                    }
                  },
                  onChanged: () {
                    setState(() {
                      _invalidUser = false;
                    });
                  },
                ),
                FormTextField(
                  visibility: true,
                  controller: _confirmPasswordController,
                  hintText: "Confirm Password",
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return "Passwords do not match!";
                    }
                  },
                  onChanged: () {
                    setState(() {
                      _invalidUser = false;
                    });
                  },
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: createEmailPassUser,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "REGISTER",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
