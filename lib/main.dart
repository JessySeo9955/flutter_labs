import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum FoodCategory {
  meat,
  course,
  dessert,
}

class FoodItem {
  final String name;
  final String imageSrc;

  FoodItem({required this.name, required this.imageSrc});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller; // initialize later
  var imageName = 'images/beef.jpg';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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




  Widget buildMainTitle(String text) {
    return Text(text.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0));
  }

  Widget buildSubTitle(String text) {
    return Text(text.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0));
  }

  Widget buildBodyText(String text) {
    return Text(text, style: TextStyle(fontSize: 12.0));
  }

  Widget buildCustomTitle(String text, TextStyle style) {
    return Text(text, style: style);
  }

  Widget buildCategoryItemCard(FoodItem item, TextStyle style, {bool isStack = false}) {
    List<Widget> children = [
      CircleAvatar(
        backgroundImage: AssetImage(item.imageSrc),
        radius: 150,
      ),
      // ClipOval(
      //   child: Image.asset(
      //     item.imageSrc,
      //     width: 150,   // set width
      //     height: 150,  // set height
      //     fit: BoxFit.cover, // crop + scale
      //   )
      // ),
      buildCustomTitle(item.name, style),
    ];
    if (isStack) {
      return Stack(alignment: AlignmentDirectional.center, children: children, );
    }
    return Column(children: children);
  }

  Widget buildCategory(FoodCategory category) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: buildCategoryChildren(category),
    );
  }

  List<Widget> buildCategoryChildren(FoodCategory category) {
    bool isStack = false;
    TextStyle style = TextStyle(color: Colors.black, fontSize: 14.0);
    String categoryTitle = '';

    switch(category) {
      case FoodCategory.meat:
        categoryTitle = 'MY MEAT';
        isStack = true;
        style = TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold);
        break;
      case FoodCategory.course:
        categoryTitle = 'MY COURSE';
        break;
      case FoodCategory.dessert:
        categoryTitle = 'MY DESSERT';
        break;
    }

    Widget title = buildSubTitle(categoryTitle);
    List<Widget> items = categoryItems(category).map((item) => buildCategoryItemCard(item, style, isStack: isStack)).toList();

    return [Padding(padding: EdgeInsetsGeometry.all(16), child: title), Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: items)];
  }

  List<FoodItem> categoryItems(FoodCategory category) {
    List<FoodItem> items = [];

    switch(category) {
      case FoodCategory.meat:
        items.add(FoodItem(name: 'BEEF', imageSrc: 'images/beef.jpg'));
        items.add(FoodItem(name: 'CHICKEN', imageSrc: 'images/chicken.jpg'));
        items.add(FoodItem(name: 'PORK', imageSrc: 'images/pork.jpg'));
        items.add(FoodItem(name: 'SEAFOOD', imageSrc: 'images/seafood.jpg'));
        break;

      case FoodCategory.course:
        items.add(FoodItem(name: 'Main Dishes', imageSrc: 'images/maindish.jpg'));
        items.add(FoodItem(name: 'Salad Recipes', imageSrc: 'images/salad.jpg'));
        items.add(FoodItem(name: 'Side Dishes', imageSrc: 'images/side_dish.jpg'));
        items.add(FoodItem(name: 'Crockpot', imageSrc: 'images/crokpot.jpg'));
        break;

      case FoodCategory.dessert:
        items.add(FoodItem(name: 'Ice Cream', imageSrc: 'images/icecream.jpg'));
        items.add(FoodItem(name: 'Brownies', imageSrc: 'images/brownie.jpg'));
        items.add(FoodItem(name: 'Pies', imageSrc: 'images/pies.jpg'));
        items.add(FoodItem(name: 'Cookies', imageSrc: 'images/cookies.jpg'));
        break;
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: 
          Padding(padding: EdgeInsets.all(16.0), child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildMainTitle('Browse Categories'),
                buildBodyText('Not sure about exactly which recipe you\'re looking for? Do a search, or dive into our most popular categories'),
                buildCategory(FoodCategory.meat),
                buildCategory(FoodCategory.course),
                buildCategory(FoodCategory.dessert)
              ],
            ),
          )

      ),
    );
  }
}
