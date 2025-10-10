import 'package:flutter/material.dart';
import 'DataRepository.dart';
import 'ProfilePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //   ),
    //   home: Scaffold(
    //     appBar: AppBar(title: const Text("Test Page")),
    //     body: const Center(child: Text("App launched successfully ✅")),
    //   ),
    // );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/profile': (context) => ProfilePage()
      }
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
  // final String PREFERENCE_PASSWORD_KEY = "password";
  // final String PREFERENCE_USERNAME_KEY = "username";
  late TextEditingController _usernameController; //late means promise to initialize it later
  late TextEditingController _passwordController; //late means promise to initialize it later

  //you're visible
  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    // Future.delayed(Duration.zero,  () => loadUserInfoToEncryptPreferences());
  }

  @override
  void dispose() {
   super.dispose();
   _usernameController.dispose();
   _passwordController.dispose();
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
                controller: _usernameController,
                decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText:"Put your name here",
                labelText: "User Name")
            )),
            wrapPadding(TextField(
                controller: _passwordController,
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
              onPressed: () => alertButtonHandler(() async {
                await DataRepository.saveData(_usernameController.value.text);
                Navigator.pushNamed(context, '/profile');
              })
          ),
          OutlinedButton(
              child:Text("No"),
              onPressed: () => alertButtonHandler(() async {})
          ),
        ] );
  }

  Future<void> alertButtonHandler(Future<void> Function() handler) async {
    Navigator.pop(context);
    await handler();
  }

  // Future<void> saveUserInfoToEncryptPreferences() async {
  //   var prefs = EncryptedSharedPreferences();
  //   await prefs.setString(PREFERENCE_USERNAME_KEY, _usernameController.value.text);
  //   await prefs.setString(PREFERENCE_PASSWORD_KEY, _passwordController.value.text);
  //  }

  // Future<void> clearUserInfoToEncryptPreferences() async {
  //   var prefs = EncryptedSharedPreferences();
  //   prefs.clear();
  // }

  // void loadUserInfoToEncryptPreferences() {
  //   var prefs = EncryptedSharedPreferences();
  //   Future.wait([
  //     prefs.getString(PREFERENCE_USERNAME_KEY),
  //     prefs.getString(PREFERENCE_PASSWORD_KEY),
  //   ]).then((results) {
  //     final username = results[0];
  //     final password = results[1];
  //     if (username != '' || password != '') {
  //         _usernameController.text = username;
  //         _passwordController.text =  password;
  //         displaySandbox();
  //     }
  //   });
  // }

  // void displaySandbox() {
  //   var snackBar = SnackBar(
  //       content: Text('Username and Password loaded')
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }
}
