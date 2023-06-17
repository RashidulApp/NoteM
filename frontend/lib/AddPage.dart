import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserName {
  final String name;

  UserName({required this.name});

  Map<String, dynamic> toJson() => {"name": name};
}

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final nameController = TextEditingController();

  Future<void> sendData(UserName userName) async {
    final response = await http.post(Uri.parse("http://localhost:3000/name"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userName.toJson()));

    if (response.statusCode == 201) {
      print("Data send succesfully");
    } else {
      throw Exception("Data send to server fail");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final createUser = UserName(name: nameController.text);
                sendData(createUser);
                print(createUser.name);
                Navigator.pop(context);
              },
              child: const Text("Add Text"),
            )
          ],
        ),
      ),
    );
  }
}
