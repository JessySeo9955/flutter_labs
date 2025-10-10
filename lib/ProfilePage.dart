import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DataRepository.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {

  late TextEditingController _firstNameController; //late means promise to initialize it later
  late TextEditingController _lastNameController; //late means promise to initialize it later
  late TextEditingController _phoneNumberController; //late means promise to initialize it later
  late TextEditingController _emailController; //late means promise to initialize it later

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();

    Future.delayed(Duration.zero,  () async {
      List<String> userInfo = await DataRepository.loadData();
      String userName = userInfo[0];
      _firstNameController.text = userName.split(" ")[0];
      _lastNameController.text = userName.split(" ")[1];
      _phoneNumberController.text = userInfo[1];
      _emailController.text = userInfo[2];
      displaySandbox(userName);

      updateUserInfo();

    });
  }

  void updateUserInfo() {
    final controllers = [
      _firstNameController,
      _lastNameController,
      _phoneNumberController,
      _emailController,
    ];

    for (final controller in controllers) {
      controller.addListener(() {
        final firstName = _firstNameController.text;
        final lastName = _lastNameController.text;
        final phone = _phoneNumberController.text;
        final email = _emailController.text;
        final fullName = "$firstName $lastName";

        DataRepository.saveData(
          fullName,
          phone: phone,
          email: email,
        );
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to Profile Page"),
            wrapPadding(
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Put your firstname here",
                  labelText: "First Name",
                ),
              ),
            ),
            wrapPadding(
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Put your lastname here",
                  labelText: "Last Name",
                ),
              ),
            ),
            wrapPadding(
              Row(
                children: [
                  Flexible(child: TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Put your phone number here",
                      labelText: "Phone Number",
                    ),
                  )),
                  ElevatedButton(onPressed: (){
                    openApplication(Uri(scheme: 'tel', path: _phoneNumberController.value.text));
                  },  child: const Icon(Icons.phone)),
                  ElevatedButton(onPressed: (){
                    openApplication(Uri(scheme: 'sms', path: _phoneNumberController.value.text));
                  },  child: const Icon(Icons.sms))
                ],
              ),

            ),
            wrapPadding(
              Row(children: [
                Flexible(child:  TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Put your email address here",
                    labelText: "Email Address",
                  )
                )),
                ElevatedButton(onPressed: (){
                  openApplication(Uri(scheme: 'mailto', path: _emailController.value.text));
                },  child: const Icon(Icons.email))
              ],),

            ),

          ],
        ),
      ),
    );
  }

  Widget wrapPadding(Widget child) {
    return Padding(child: child, padding: EdgeInsets.fromLTRB(50, 10, 50, 10));
  }

  void displaySandbox(String userName) {
    var snackBar = SnackBar(
      content: Text("Welcome back $userName")
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void openApplication(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Cannot launch application for URI: $uri');
    }
  }
}
