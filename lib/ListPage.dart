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
            listPage(),
          ],
        ),
      ),
    );
  }

  Widget listPage() {
    return Expanded(
      child: lists1.length == 0
          ? Text("There are no items")
          : ListView.builder(
              itemCount: lists1.length,
              itemBuilder: (context, rowNum) {
                return GestureDetector(
                  child: Text("${rowNum + 1}: ${lists1[rowNum].name}"),
                  onLongPress: () {

                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete this?'),
                          content: const Text('are you sure?'),
                          actions: <Widget>[
                            FilledButton(child:Text("Yes"), onPressed:() {
                              Person person = lists1[rowNum];
                              personDAO.deletePerson(person);
                              setState(() {
                                lists1.removeAt(rowNum);
                              });
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
}
