import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'database_helper.dart';
import 'item_model.dart';

// Define a custom Form widget.
class AddItemForm extends StatefulWidget {
  const AddItemForm({super.key});

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _AddItemFormState extends State<AddItemForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  String? _directoryPath;
  _directory() async {
    Directory? directory = await getExternalStorageDirectory();
    _directoryPath = (directory == null ? "" : directory.path);
  }

  void savedata(String name, category, image) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // GallerySaver.saveImage(image!.path);
      final splitted = image.path.split('/');
      print(splitted.last);
      print(_directoryPath! + '/' + splitted.last);

      // File fimage = await image.copy(_directoryPath! + image.path);
      void imagecopy() async {
        File tocopy = File(image.path);
        File fimage = await tocopy.copy(_directoryPath! + '/' + splitted.last);
        print(fimage.path);
      }

      imagecopy();
      DatabaseHelper.insert(InventoryItem(
          name: name,
          // description: "Macbook Pro 2019",
          category: category,
          image: _directoryPath! + '/' + splitted.last,
          givenAway: 0));
    });
  }

  final item = TextEditingController();
  final category = TextEditingController(text: "Laundry");

  List<CameraDescription>? cameras; //list out the camera available
  CameraController? cameraController; //controller for camera
  XFile? image; //for captured image

  @override
  void initState() {
    loadCamera();
    _directory();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      cameraController = CameraController(cameras![0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      cameraController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    item.dispose();
    category.dispose();
    // cameraController!.dispose();
    image = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter product name',
                label: Text("Name"),
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              controller: item,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter product category',
                label: Text("Category"),
              ),
              onChanged: (String? newValue) {
                category.text = newValue!;
                setState(() {});
              },
              items: <String>[
                'Laundry',
                'Documents',
                'Stationary',
                'Miscellaneous'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                  onTap: () {
                    setState(() {});
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(children: [
              Container(
                  height: 200,
                  width: 200,
                  child: cameraController == null
                      ? Center(child: Text("Loading Camera..."))
                      : !cameraController!.value.isInitialized
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : image == null
                              ? CameraPreview(cameraController!)
                              : Image.file(File(image!.path),
                                  fit: BoxFit.cover)),
              ElevatedButton.icon(
                //image capture button
                onPressed: () async {
                  if (image == null) {
                    try {
                      //reset image
                      if (cameraController != null) {
                        //check if contrller is not null
                        if (cameraController!.value.isInitialized) {
                          //check if controller is initialized
                          image = await cameraController!
                              .takePicture(); //capture image
                          setState(() {
                            //update UI
                          });
                        }
                      }
                    } catch (e) {
                      print(e); //show error
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Recapture Image"),
                          content:
                              const Text("Do you want to recapture image?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  image = null;
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                child: const Text("Yes")),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("No"))
                          ],
                        );
                      },
                    );
                  } //reset image
                },
                icon: Icon(Icons.camera),
                label: Text("Capture"),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        // Retrieve the text the that user has entered by using the
                        // TextEditingController.
                        content: Column(
                      // crossAxisAlignment: CrossAxisAlignment.min,A
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          (item.text == "")
                              ? 'Please enter the name'
                              : 'Name: ${item.text.toString()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          (category.text == "")
                              ? 'Please enter the name'
                              : 'Category: ${category.text.toString()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        image == null
                            ? const Text("please capture image",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ))
                            : Image.file(File(image!.path), fit: BoxFit.cover),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // SizedBox(width: 10),
                            (item.text != "" && image != null)
                                ? ElevatedButton(
                                    onPressed: () {
                                      savedata(item.text, category.text, image);
                                      dispose();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Save"))
                                : SizedBox(),
                            // SizedBox(width: 10),
                            ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Edit")),
                            // SizedBox(width: 10),

                            // SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ));
                  },
                );
              },
              icon: Icon(Icons.add),
              label: Text("Add Item"),
            ),
          )
        ],
      ),
    );
  }
}
