import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nuox_project/authentication/login_page.dart';
import 'package:nuox_project/authentication/mobile_number_verification_page.dart';
import 'package:nuox_project/authentication/providers/widgets/top_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../my_home_page.dart';
import 'providers/auth_provider.dart';
import '../constants/constants.dart';
import 'package:provider/provider.dart';

ValueNotifier<bool> isdocumentUploadedNotifier = ValueNotifier(false);
ValueNotifier<bool> instructorOptionNotifier = ValueNotifier(false);
final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _nameController = TextEditingController();

  final _numberController = TextEditingController();

  GoogleSignInAccount? _currentUser;
  File? documentFile;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);
    Future<void> signIn() async {
      try {
        await _googleSignIn.signOut();
        _currentUser = await _googleSignIn.signIn();
        if (_currentUser != null) {
          authProvider.socialLogin(
              name: _currentUser!.displayName.toString(),
              context: context,
              id: _currentUser!.id.toString(),
              email: _currentUser!.email.toString(),
              image: _currentUser?.photoUrl.toString());
        }
      } catch (e) {
        print("Error signing in $e");
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              SizedBox(
                height: size * .05,
              ),
              const TopImage(),
              SizedBox(
                height: size * .1,
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                ],
                keyboardType: TextInputType.name,
                controller: _nameController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  errorText: authProvider.name_error,
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: ((value) => value == null || value.isEmpty
                    ? "Please enter your name"
                    : null),
              ),
              kHeight,

              kWidth5,
              TextFormField(
                style: const TextStyle(color: Colors.black),
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                keyboardType: TextInputType.number,
                controller: _numberController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding:
                        const EdgeInsets.only(right: 2, left: 8, bottom: 3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: 30,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://upload.wikimedia.org/wikipedia/en/thumb/4/41/Flag_of_India.svg/1200px-Flag_of_India.svg.png"))),
                        ),
                        const Text(
                          "  +91",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  errorText: authProvider.mobile_error,
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Mobile Number",
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: ((value) => value == null || value.length < 10
                    ? "Enter a valid mobile number"
                    : null),
              ),
              kHeight,
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      errorText: authProvider.email_error,
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "Email"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? "Enter a valid email"
                          : null),
              kHeight,
              TextFormField(
                obscureText: _obscureText,
                controller: _passwordController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: _obscureText ? Colors.grey : Colors.black,
                        )),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Password"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) => password != null && password.length < 8
                    ? "Enter min. 8 characters"
                    : null,
              ),
              kHeight,
              FlutterPwValidator(
                controller: _passwordController,
                minLength: 8,
                uppercaseCharCount: 1,
                numericCharCount: 1,
                specialCharCount: 1,
                width: 400,
                height: 150,
                onSuccess: () {},
                // onFail: yourCallbackFunction),
              ),
              kHeight,
              ValueListenableBuilder(
                valueListenable: instructorOptionNotifier,
                builder: (context, newvValue, child) {
                  return Row(
                    children: [
                      const Text(
                        "Are you an instructor ?",
                        style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      kWidth10,
                      const Text(
                        "Yes",
                        style: TextStyle(color: Colors.white),
                      ),
                      Radio(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                          value: true,
                          groupValue: newvValue,
                          onChanged: (value) {
                            instructorOptionNotifier.value = value!;
                          }),
                      const Text(
                        "No",
                        style: TextStyle(color: Colors.white),
                      ),
                      Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                        value: false,
                        groupValue: newvValue,
                        onChanged: (value) {
                          instructorOptionNotifier.value = value!;
                        },
                      )
                    ],
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: instructorOptionNotifier,
                builder: (context, value, child) {
                  return value == true
                      ? GestureDetector(
                          onTap: () async {
                            FilePickerResult? resultFile =
                                await FilePicker.platform.pickFiles();
                            if (resultFile != null) {
                              PlatformFile file = resultFile.files.first;
                              setState(() {
                                documentFile = File(file.path.toString());
                              });

                              isdocumentUploadedNotifier.value = true;
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                          'Document updoaded successfully')));
                            } else {
                              isdocumentUploadedNotifier.value = false;
                              // if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.red,
                                      content:
                                          Text('Please upload a document')));
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 45),
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Center(
                                child: ValueListenableBuilder(
                              valueListenable: isdocumentUploadedNotifier,
                              builder: (context, value, child) {
                                return value == false
                                    ? const Text(
                                        "Upload a document",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )
                                    : const Text(
                                        "Document uploaded",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      );
                              },
                            )),
                          ),
                        )
                      : const SizedBox();
                },
              ),
              kHeight,
              ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 15)),
                      backgroundColor: const MaterialStatePropertyAll(
                        Colors.purple,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )),
                  onPressed: () {
                    final istrue = _formKey.currentState!.validate();
                    if (istrue) {
                      if (instructorOptionNotifier.value == false) {
                        authProvider.registration(
                            context: context,
                            email:
                                _emailController.text.toString().toLowerCase(),
                            number: _numberController.text.toString(),
                            name: _nameController.text.toString(),
                            password: _passwordController.text.toString());
                      } else {
                        if (isdocumentUploadedNotifier.value == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Please upload a document')));
                        } else {
                          if (documentFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('Please upload a document')));
                          } else {
                            authProvider.instructorRegistration(
                                isInstructor: true,
                                document: documentFile,
                                context: context,
                                email: _emailController.text
                                    .toString()
                                    .toLowerCase(),
                                number: _numberController.text.toString(),
                                name: _nameController.text.toString(),
                                password: _passwordController.text.toString());
                          }
                        }
                      }
                    }
                  },
                  child: authProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : const Text("Sign up",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),

              kHeight,
              Row(
                children: const [
                  Expanded(
                      child: Divider(
                    thickness: 1,
                    color: Colors.white,
                  )),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("OR",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: Divider(
                    color: Colors.white,
                    thickness: 1,
                  ))
                ],
              ),
              kHeight,

              SizedBox(
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MobileNumberverificationPage()));
                  },
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.white))),
                  child: Row(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: 45,
                        child: Image.network(
                            "https://cdn5.vectorstock.com/i/1000x1000/93/64/telephone-receiver-line-icon-on-black-background-vector-26849364.jpg"),
                      ),
                      const Text(
                        "Log in with Mobile number",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
              ),
              kheight20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      signIn();
                    },
                    child: SizedBox(
                      width: 25,
                      child: Image.network(
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/2048px-Google_%22G%22_Logo.svg.png"),
                    ),
                  ),
                ],
              ),
              kHeight15,
              kheight20,
              //////////
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already Registered?",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  kWidth5,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  )
                ],
              ),
              kheight20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Join as a ",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences sharedPref =
                          await SharedPreferences.getInstance();
                      sharedPref.setBool("isLogged", true);
                      sharedPref.setBool("guest", true);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Joined as a guest')));
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage()),
                          (route) => false);
                    },
                    child: const Text(
                      "Guest",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
