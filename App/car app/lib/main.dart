import 'dart:io';

import 'package:esp32_test/connect_to_car.dart';
import 'package:esp32_test/detect_object.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_ip.dart';


void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Esp32',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Esp32 App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String? ip;
  @override
  void initState() {
    super.initState();
    initSharedPref();
  }


  Future<void> initSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    ip = prefs.getString("ip");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Esp32 App"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (){
                    showPicker(context);
                  },
                  child: const Text("Detect object")
              ),
              ElevatedButton(
                  onPressed: (){
                    if(ip!=null) {
                      var route = MaterialPageRoute(builder: (context){
                        return ConnectToCar(ip:ip!);
                      });
                      Navigator.push(context, route);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("add ip address")));
                    }

                  },
                  child: const Text("Connect to car")
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var route = MaterialPageRoute(builder: (context){
            return const AddIP();
          });
          await Navigator.push(context, route);
          initSharedPref();
        },
      ),
    );
  }


  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      pickImage(ImageSource.gallery,context);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    pickImage(ImageSource.camera,context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  Future<void> pickImage(source,context) async {
    final picker=ImagePicker();
    XFile? xfile = await  picker.pickImage(source: source);
    if(xfile!=null){
      File image = File(xfile.path);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Processing...")));
      var route = MaterialPageRoute(builder: (context){
        return DetectObject(file: image,);
      });
      Navigator.push(context, route);

    }
  }


}
