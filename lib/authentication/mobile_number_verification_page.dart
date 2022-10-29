import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nuox_project/authentication/moblie_number_otp_submission_page.dart';
import 'package:nuox_project/authentication/otp_verification_page.dart';
import 'package:nuox_project/authentication/signup.dart';
import 'package:nuox_project/constants/constants.dart';
import 'package:nuox_project/authentication/providers/auth_provider.dart';
import 'package:nuox_project/widgets/oulined_text_field_widget.dart';
import 'package:provider/provider.dart';

class MobileNumberverificationPage extends StatelessWidget {
  MobileNumberverificationPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mobile number verification"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15),
          children: [
            SizedBox(
              height: size * .4,
            ),
            TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly
              ],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: ((value) => value == null || value.length < 10
                  ? "Enter a valid mobile number"
                  : null),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              controller: _numberController,
              decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(top: 11, left: 1),
                    child: Text(
                      "  +91",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Mobile number",
                  hintStyle: TextStyle(color: Colors.black)),
            ),
            SizedBox(
              height: size * .1,
            ),
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
                  if (_formKey.currentState!.validate()) {
                    authProvider.numberVerification(
                        context: context,
                        number: _numberController.text.toString());
                  }
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            KHeight20,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "No account?",
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
                KWidth5,
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SignUpWidget()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
