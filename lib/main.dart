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
  int _counter = 0;
  var isChecked = false;
  var myFontSize = 0.0;
  late TextEditingController _controller; //late means promise to initialize it later

  //you're visible
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(); //doing your promise to initialize

    Future.delayed(Duration.zero,  () {


      //this is the snackbar:
      var snackBar = SnackBar(
          content: Text('Do you want to reload your string?'),
          action: SnackBarAction( label:"Yes please",
              onPressed: () {
                //load from disk:
                loadPreferences();

              } )
      );

      //this line shows it: context is the page
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    });
  }

  //you are being removed
  @override
  void dispose() {
   super.dispose();
   //free memory:
    _controller.dispose();
  }


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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

            Padding(padding:EdgeInsets.fromLTRB(0, 50, 0, 0),
               child:  Text("You have typed:  ${_controller.value.text}" )),
            Semantics(child: Image.asset("images/algonquin.jpg", height:100, width:100) ,
                label: 'Algonquin College Logo',),
            ElevatedButton(onPressed: () { //paste the text written
                                        //passed in to Build(context)
              showDialog<String>( context:context ,
                builder: (context){

                  return AlertDialog(
                      title: Text("Alert!!"),
                    content:Text("Do you really want to save your text?"),
                    actions:[
                      OutlinedButton(child:Text("Yes"), onPressed:
                          () async
                      {
                       var prefs = EncryptedSharedPreferences();//await SharedPreferences.getInstance(); //async, we must wait
                                        //Key is the variable name ,     //what the user typed:
                        await prefs.setString("MySavedString", _controller.value.text);
                        Navigator.pop(context);//hide the dialog
                      }),
                      OutlinedButton(child:Text("No"), onPressed: (){ Navigator.pop(context); }),
                      OutlinedButton(child:Text("Clear data"), onPressed: (){
                        var prefs = EncryptedSharedPreferences();
                        prefs.clear();//deletes all data
                        Navigator.pop(context); }),

                    ] );

              });

            } //<-- Lambda, or anonymous function
              , child: Image.asset("images/algonquin.jpg", height:50, width:50),),
            Checkbox( value: isChecked, onChanged:  (newChecked) {
            setState(() {
              isChecked = newChecked !; // ! is non-null assertion. If it null, get red screen
            });
          } ),
            Switch(value: isChecked, onChanged: (newChecked) {
              setState(() {
                isChecked = newChecked !; // ! is non-null assertion. If it null, get red screen
              });
            }),
            Padding(child:
                TextField(controller: _controller, decoration:
                InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:"Put your name here",
                labelText: "First Name"

                ) ),
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0)
            )

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void buttonClicked()
  {

  }
  //load this in a background thread
  void loadPreferences( ) async //background thread
   {
    //start loading from disk, not async:
    var prefs = EncryptedSharedPreferences();//await SharedPreferences.getInstance();


    //Encrypted, this is async:
    var str = await prefs.getString("MySavedString"); //Use the same variable as in setString()

    //put back onto page:
    if(str != null)
      _controller.text = str; // see your string on the page
   }

  void loadPreferences2() //not async:
  {
    var prefs = EncryptedSharedPreferences();
    prefs.getString("MySavedString").then((savedString){
      if(savedString != null)
        _controller.text = savedString; // see your string on the page
    });
  }

}
