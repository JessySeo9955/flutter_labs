import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  @override
  ListPageState createState() {
    return ListPageState();
  }
}

class ListPageState extends State<ListPage> {
  List<String> lists1 = [];
  late TextEditingController _itemController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController();
    _quantityController = TextEditingController();
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
                    onPressed: () {
                      setState(() {
                        lists1.add(_itemController.text + ':' + _quantityController.text);
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
                  child: Text("${rowNum + 1}: ${lists1[rowNum]}"),
                  onLongPress: () {

                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete this?'),
                          content: const Text('are you sure?'),
                          actions: <Widget>[
                            FilledButton(child:Text("Yes"), onPressed:() {
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
