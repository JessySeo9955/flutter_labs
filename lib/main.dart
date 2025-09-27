import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String PREFERENCE_PASSWORD_KEY = "password";
  final String PREFERENCE_USERNAME_KEY = "username";
  late TextEditingController usernameController; //late means promise to initialize it later
  late TextEditingController passwordController; //late means promise to initialize it later

  //you're visible
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    Future.delayed(Duration.zero,  () => loadUserInfoToEncryptPreferences());
  }

  @override
  void dispose() {
   super.dispose();
   usernameController.dispose();
   passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            wrapPadding(TextField(
                controller: usernameController,
                decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText:"Put your name here",
                labelText: "First Name")
            )),
            wrapPadding(TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                border: OutlineInputBorder())
            )),
            ElevatedButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (context) => buildUserInfoSaveDialog(),
              ),
              child: Text("Login"),
            ),
          ],
        ),
      )
    );
  }

  Widget wrapPadding(Widget child) {
    return   Padding(
        child: child,
        padding: EdgeInsets.fromLTRB(50, 10, 50, 10)
    );
  }

  Widget buildUserInfoSaveDialog() {
    return AlertDialog(
        title: Text("Alert!!"),
        content:Text("Do you really want to save your text?"),
        actions:[
          OutlinedButton(
              child:Text("Yes"),
              onPressed: () => alertButtonHandler(saveUserInfoToEncryptPreferences)
          ),
          OutlinedButton(
              child:Text("No"),
              onPressed: () => alertButtonHandler(clearUserInfoToEncryptPreferences)
          ),
        ] );
  }

  Future<void> alertButtonHandler(Future<void> Function() handler) async {
    Navigator.pop(context);
    await handler();
  }

  Future<void> saveUserInfoToEncryptPreferences() async {
    var prefs = EncryptedSharedPreferences();
    await prefs.setString(PREFERENCE_USERNAME_KEY, usernameController.value.text);
    await prefs.setString(PREFERENCE_PASSWORD_KEY, passwordController.value.text);
   }

  Future<void> clearUserInfoToEncryptPreferences() async {
    var prefs = EncryptedSharedPreferences();
    prefs.clear();
  }

  void loadUserInfoToEncryptPreferences() {
    var prefs = EncryptedSharedPreferences();
    Future.wait([
      prefs.getString(PREFERENCE_USERNAME_KEY),
      prefs.getString(PREFERENCE_PASSWORD_KEY),
    ]).then((results) {
      final username = results[0];
      final password = results[1];
      if (username != '' || password != '') {
          usernameController.text = username;
          passwordController.text =  password;
          displaySandbox();
      }
    });
  }

  void displaySandbox() {
    var snackBar = SnackBar(
        content: Text('Username and Password loaded')
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
