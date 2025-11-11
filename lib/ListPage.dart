import 'package:flutter/material.dart';
import 'package:in_class_examples/database/PersonDatabase.dart';

import 'dao/PersonDAO.dart';
import 'entity/Person.dart';





class ListPage extends StatefulWidget {
  @override
  ListPageState createState() {
    return ListPageState();
  }
}

class ListPageState extends State<ListPage> {
  List<Person> lists1 = [];
  late TextEditingController _itemController;
  late TextEditingController _quantityController;
  int selectedItem = -1; // nothing is selected

  late PersonDAO personDAO;

  @override
  void initState() {
    super.initState();

    _itemController = TextEditingController();
    _quantityController = TextEditingController();

    $FloorPersonDatabase
        .databaseBuilder('PersonFile.db')
        .build()
        .then((database) {
      personDAO = database.personDAO;
      return personDAO.getAllPersons();
    }).then((persons) {
      setState(() {
        lists1.addAll(persons);
      });
    });
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Widget reactiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;


    if ((width > height) && (width > 720)) {
      // tablet
      return Row(children: [
        Expanded(child: listPage(), flex: 1), // left side 33%
        Expanded(child: detailsPage(), flex: 2)  // right side 66%
      ]);
    } else {
      // portrait mode / phone
      if (selectedItem == -1) {
        return listPage();       // show list first
      } else {
        return detailsPage();    // show details after selection
      }
    }
  }

  Widget detailsPage() {
    if (selectedItem != -1) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${lists1[selectedItem].name}'),
            Text('Quantity: ${lists1[selectedItem].quantity}'),
            ElevatedButton(onPressed: () {
              deletePersonFromDatabase(selectedItem);
              selectedItem = -1;
            }, child: Text('Delete')),
            ElevatedButton(onPressed: () {
              setState(() {
                selectedItem = -1;
              });
            }, child: Text('Close'))
          ],
        ),
      );
    } else {
      return Text('Please select an Person from the list', style: TextStyle(fontSize: 30.0));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(flex: 1, child: TextField(
                    controller: _itemController,
                  decoration: InputDecoration(
                    hintText: 'Type the item here',
                    border: OutlineInputBorder(), // 👈 adds the outline
                  ),
                )),
                Flexible(flex: 1, child: TextField(
                    controller: _quantityController,
                  decoration: InputDecoration(
                      hintText: 'Type the quantity here',
                    border: OutlineInputBorder(), // 👈 adds the outline
                  ),
                )),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        Person person = new Person(Person.ID++, int.parse(_quantityController.text), _itemController.text);

                        personDAO.insertPerson(person);
                        setState(() {
                          lists1.add(person);
                        });
                        // lists1.add(_itemController.text + ':' + _quantityController.text);
                        _itemController.text = '';
                        _quantityController.text = '';
                      });
                    },
                    child: Text("Click Here"),
                  ),
                ),
              ],
            ),
            Expanded(child:  reactiveLayout(),)
          ],
        ),
      ),
    );
  }

  Widget listPage() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: lists1.length == 0
          ? Text("There are no items")
          : ListView.builder(
              itemCount: lists1.length,
              itemBuilder: (context, rowNum) {
                return GestureDetector(
                  child: Text("${rowNum + 1}: ${lists1[rowNum].name}"),
                  onTap: () {
                    setState(() {
                      selectedItem = rowNum;
                    });
                  },
                  onLongPress: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete this?'),
                          content: const Text('are you sure?'),
                          actions: <Widget>[
                            FilledButton(child:Text("Yes"), onPressed:() {
                              deletePersonFromDatabase(rowNum);
                              Navigator.pop(context);
                            }),
                            FilledButton(child:Text("Cancel"), onPressed:() {
                              Navigator.pop(context);

                            }),
                          ],
                        )
                    );
                  },
                );
              },
            ),
    );
  }

  void deletePersonFromDatabase(int rowNum) {
  Person person = lists1[rowNum];
  personDAO.deletePerson(person);
  setState(() {
  lists1.removeAt(rowNum);
  });
  }
}
