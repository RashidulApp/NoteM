import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Name {
  String id;
  String name;

  Name({required this.id, required this.name});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {"name": name};
}

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<Name> nameList = [];
  String name = "";
  @override
  void initState() {
    super.initState();
    fatchName();
  }

  Future<void> fatchName() async {
    final response = await http.get(Uri.parse("http://localhost:3000/names"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      print(data);
      setState(() {
        nameList = data.map((item) => Name.fromJson(item)).toList();
      });
    } else {
      throw Exception("Fail to data load");
    }
  }

  Future<void> updateData(String id, String newName) async {
    final response = await http.put(
        Uri.parse("http://localhost:3000/name/${id}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": newName}));
    if (response.statusCode == 200) {
      setState(() {
        nameList.firstWhere((name) => name.id == id).name = newName;
      });
      print("Data Updated successfully");
    } else {
      throw Exception("Fail to updated");
    }
  }

  Future<void> deleteData(String id) async {
    final response =
        await http.delete(Uri.parse("http://localhost:3000/name/${id}"));

    if (response.statusCode == 200) {
      setState(() {
        nameList.removeWhere((name) => name.id == id);
      });
      print("Data delete successfully");
    } else {
      throw Exception("Fail to data delete");
    }
  }

  @override
  Widget build(BuildContext context) {
    return nameList.isEmpty
        ? const Text("Bangladesh")
        : ListView.builder(
            itemCount: nameList.length,
            itemBuilder: (context, index) => ListTile(
                  leading: IconButton(
                    onPressed: () {
                      deleteData(nameList[index].id);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  title: Text(nameList[index].name),
                  trailing: IconButton(
                    onPressed: () {
                      TextEditingController nameController =
                          TextEditingController(text: nameList[index].name);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Update Data"),
                          content: TextField(
                            controller: nameController,
                            onChanged: (value) => name = value,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  updateData(nameList[index].id, name);
                                  Navigator.pop(context);
                                },
                                child: const Text("Updated"))
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ));
  }
}
