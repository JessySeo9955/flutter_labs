import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
  late TextEditingController _controller; // initialize later
  var imageName = 'images/question-mark.png';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    Future.delayed(Duration(seconds: 1), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var snackBar = SnackBar(
          content: Text("dddd"),
          action: SnackBarAction(
            label: "Hide",
            onPressed: () {
              loadPreference2();
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeImageSource(String name) {
    setState(() {
      imageName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(obscureText: true, decoration: InputDecoration(hintText: 'Login', labelText: 'login',  border: OutlineInputBorder())),
            TextField(controller: _controller, obscureText: false, decoration: InputDecoration(hintText: 'Password', labelText: 'password',  border: OutlineInputBorder())),
            ElevatedButton(onPressed: () {
              showDialog<String>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title:  Text("Alert!!"),
                      content: Text("Do you really want to do this"),
                      actions: [
                        OutlinedButton(child: Text("Yes"), onPressed: () async {

                          await loadPreference();
                          loadEncyptedPreference();
                          // close dialog
                          Navigator.pop(context);
                        }),
                        OutlinedButton(child: Text("No"), onPressed: () {
                          Navigator.pop(context);
                        }),
                        ElevatedButton(child: Image.asset("images/cookies.jpg",    width: 40,
                          height: 40,), onPressed: () {})
                      ],
                    );
                  }
              );


            }, child: Text('Login')
            ),
            Semantics(label: 'image', child: Image.asset(imageName, height: 200, width: 200)),
            // const Text('You have pushed the button this many times:'),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Increment2',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
      //
    );
  }


  Future<void> loadPreference() async {
    // load in background, but wait before moving on
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("MySavedString", _controller.value.text);
  }

  void loadEncyptedPreference() {
    // load in background, but wait before moving on
    var prefs = EncryptedSharedPreferences();
    prefs.setString("MySavedEncrypted", _controller.value.text);
  }

  void loadPreference2() {
    // load in background, but wait before moving on
    SharedPreferences.getInstance().then((pref) {
      // pref are all loaded
      var str = pref.getString("MySavedString");
      if (str != null) {
        _controller.text = str;
      }

    });
  }
}