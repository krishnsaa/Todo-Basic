import 'package:flutter/material.dart';
import 'package:todo/pages/add_tile.dart';
import 'package:todo/pages/todo_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  List<List<String>> todoList = [];

  // load data on init
  @override
  void initState() {
    super.initState();
    loadData();
  }

  // to save data to local
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    String encoded = jsonEncode(todoList);
    await prefs.setString("TODOLIST", encoded);
  }

  bool isLoading = true;

  // retrieve local's data
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("TODOLIST");

    if (data != null) {
      todoList = List<List<String>>.from(
        jsonDecode(data).map((x) => List<String>.from(x)),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  String iconText = "Hello work";

  void savenewtask() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      todoList.add([_controller.text.trim()]);
      Navigator.of(context).pop();
      _controller.clear();
    });

    saveData();
  }

  void addTile() {
    showDialog(
      context: context,
      builder: (context) {
        return Addtile(
          controller: _controller,
          onSave: savenewtask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deletetask(int ind) {
    setState(() {
      todoList.removeAt(ind);
    });
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 186, 138, 121),

      // floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: addTile,
        backgroundColor: Colors.blueGrey,
        child: Icon(
          Icons.add_box_outlined,
          size: 50,
          color: const Color.fromARGB(255, 186, 138, 121),
        ),
      ),
      // AppBar
      appBar: AppBar(
        title: Text(
          "Todo Basic",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        // shadowColor: Colors.black,
        backgroundColor: Colors.blueGrey,
      ),
      // Drawer
      drawer: Drawer(
        backgroundColor: Colors.blueGrey,
        width: 200,
        child: Column(
          children: [
            DrawerHeader(
              child: Text(
                "Lets Schedule EveryThing....",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(onPressed: null, child: Text("LogOut")),
          ],
        ),
      ),
      // Body
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 18),
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) => Todotile(
                  iconText: todoList[index][0],
                  deletetile: (context) => deletetask(index),
                ),
              ),
            ),
    );
  }
}
