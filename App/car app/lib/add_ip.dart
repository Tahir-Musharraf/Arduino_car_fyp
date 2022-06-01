import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddIP extends StatefulWidget {
  const AddIP({Key? key}) : super(key: key);

  @override
  State<AddIP> createState() => _AddIPState();
}

class _AddIPState extends State<AddIP> {
  String ip="";
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                keyboardType: TextInputType.number,
                textAlignVertical: TextAlignVertical.center,
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter a Valid IP Address";
                  }
                },
                onSaved: (newValue) => ip = newValue.toString().trim(),
                decoration: InputDecoration(
                  //  contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  hintText: "IP Address",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.black12)
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.black12)
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                onPressed: () async {
                  if(formKey.currentState!.validate()){
                    formKey.currentState!.save();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('ip', ip);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add")
            ),
          ],
        ),
      ),
    );
  }
}
