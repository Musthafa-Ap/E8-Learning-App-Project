import 'package:flutter/material.dart';
import 'package:nuox_project/authentication/providers/auth_provider.dart';
import 'package:nuox_project/pages/account/sections/profile/profile_edit_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/constants.dart';

class UserDetailesSection extends StatefulWidget {
  UserDetailesSection({super.key});

  @override
  State<UserDetailesSection> createState() => _UserDetailesSectionState();
}

class _UserDetailesSectionState extends State<UserDetailesSection> {
  @override
  void initState() {
    preffunc();
    super.initState();
  }

  String? name;
  String? email;
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(
      children: [
        Container(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileEditPage()));
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              )),
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 50,
          child: Text(
            "MA",
            style: const TextStyle(fontSize: 38, color: Colors.black),
          ),
        ),
        KHeight20,
        Center(
          child: Text(
            name == null ? "Username" : name.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 23),
          ),
        ),
        KHeight,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline,
              color: Colors.white,
            ),
            KWidth5,
            Text(
              email == null ? "E-mail" : email.toString(),
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ],
    );
  }

  void preffunc() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    setState(() {
      name = sharedPref.getString("name");
      email = sharedPref.getString('email');
    });
  }
}
