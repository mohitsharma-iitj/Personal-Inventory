import 'package:flutter/material.dart';

class cash extends StatefulWidget {
  @override
  _cashState createState() => _cashState();
}

class _cashState extends State<cash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Cash'),
      ),
      body: Column(children: [
        Card(
          child: ListTile(
            leading: Icon(Icons.money),
            title: Text('Cash'),
            subtitle: Text('Cash'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ]),
      //floatting button to add more items
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          fixedColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Cash",
              icon: Icon(Icons.savings),
            ),
          ],
          onTap: (int indexOfItem) {
            if (indexOfItem == 0) {
              Navigator.pop(context);
            }
          }),
    );
  }
}
