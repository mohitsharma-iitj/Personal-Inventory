import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'item_model.dart';
import 'form_to_add_item.dart';
import 'dart:io';
import 'cash.dart';

Future<void> main() async {
  runApp(const MyApp());
}

String state = "Laundry";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 28, 90, 213)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Personal Inventory'),
    );
  }
}

//Home apge stateful widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//Home page state
class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      DatabaseHelper.insert(InventoryItem(
          name: "jeans",
          // description: "Macbook Pro 2019",
          category: "Miscellaneous",
          image: "assets/Sign_B21EE035.jpg",
          givenAway: 1));
    });
  }

  //reload widget function called when we want to change the state of the widget
  void setstate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          ScrollBar(
              sstate:
                  setstate), //it contains the buttons to show the categories of the items
          Expanded(
            child: mainbody(
                sstate:
                    setstate), // This is the main body where item description cards are displayed
          ),
        ],
      ),
      //floatting button to add more items
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddItemForm(),
                maintainState: false),
          );
          setstate();
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
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
            if (indexOfItem == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => cash(), maintainState: false),
              );
            }
          }),
    );
  }
}

// Below class is the card that contains the information about the inventory item
// like image,name,description,etc. and category of the item
class Itemdescriptioncard extends StatefulWidget {
  Itemdescriptioncard({
    super.key,
    required this.item,
    required this.sstate,
    required this.refresh,
  });

  final VoidCallback sstate;
  final VoidCallback refresh;
  InventoryItem item;

  @override
  State<Itemdescriptioncard> createState() => _ItemdescriptioncardState();
}

class _ItemdescriptioncardState extends State<Itemdescriptioncard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          // IT is th widget to show image of the item
          Padding(
            padding: EdgeInsets.all(10),
            child: InkWell(
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(widget.item.name),
                        content: Image.file(File(widget.item.image)),
                      );
                    });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: SizedBox.fromSize(
                    size: Size.fromRadius(48), // Image radius
                    child: Image.file(File(widget.item.image),
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) =>
                            const Text(
                              'Some errors occurred!',
                              style: TextStyle(fontSize: 20),
                            ))),
              ),
            ),
          ),

          Column(
            children: [
              Text(widget.item.name),
              // Text(item.description),

              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                                "Are you sure you want to delete this item?"),
                            content: Text(widget.item.name),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    DatabaseHelper.delete(widget.item);
                                    widget.sstate();
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Yes")),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("No"))
                            ],
                          );
                        });
                  },
                  child: const Text("Delete")),

              widget.item.category == "Laundry"
                  ? (ElevatedButton(
                      onPressed: () {
                        InventoryItem toupdate = InventoryItem(
                            id: widget.item.id,
                            name: widget.item.name,
                            // description: "Macbook Pro 2019",
                            category: widget.item.category,
                            image: widget.item.image,
                            givenAway: widget.item.givenAway == 0 ? 1 : 0);
                        DatabaseHelper.update(toupdate);
                        setState(() {
                          widget.item = toupdate;
                        });
                        widget.refresh();
                      },
                      child: widget.item.givenAway == 0
                          ? const Text("Give")
                          : const Text("Recieved"),
                      style: ButtonStyle(
                        backgroundColor: widget.item.givenAway == 0
                            ? MaterialStateProperty.all<Color>(
                                const Color.fromARGB(150, 240, 118, 12),
                              )
                            : MaterialStateProperty.all<Color>(
                                const Color.fromARGB(148, 106, 255, 0),
                              ),
                      ),
                    ))
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}

// below code is for the main body which contains the cards of the items
class mainbody extends StatefulWidget {
  const mainbody({super.key, required this.sstate});
  final VoidCallback sstate;
  @override
  State<mainbody> createState() => _mainbodyState();
}

class _mainbodyState extends State<mainbody> {
  List<InventoryItem> items_retrived = [];
  Future refresh() async {
    var result = await DatabaseHelper.retrieveItems();
    items_retrived = result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.retrieveItems(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          items_retrived = snapshot.data as List<InventoryItem>;
          return ListView.builder(
              itemBuilder: (context, index) {
                dynamic x = Itemdescriptioncard(
                    item: items_retrived[index],
                    sstate: widget.sstate,
                    refresh: refresh);
                // Create an instance of the ScrollBar class
                // Use the instance to access the 'v' variable

                if (items_retrived[index].category == state) {
                  return x;
                }
                return SizedBox();
              },
              itemCount: items_retrived.length);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}

// it is a horizontal bar that contains the categories of the items which are to be displayed
class ScrollBar extends StatelessWidget {
  const ScrollBar({super.key, required this.sstate});
  final VoidCallback sstate;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: MediaQuery.of(context).size.width > 500
              ? MediaQuery.of(context).size.width
              : 500,
          height: 50,
          color: Color.fromARGB(255, 161, 170, 206),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    sstate();
                    state = "Laundry";
                  },
                  child: Text("Laundry")),
              // SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    sstate();
                    state = "Documents";
                  },
                  child: Text("Documents")),
              // SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    sstate();
                    state = "Stationary";
                  },
                  child: Text("Stationary")),
              // SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    sstate();
                    state = "Miscellaneous";
                  },
                  child: Text("Miscellaneous")),
              // SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
