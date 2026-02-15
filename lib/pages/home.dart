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

//  data saving structures
class Todo {
  String title;
  bool isCompleted;

  Todo({required this.title, this.isCompleted = false});

  Map<String, dynamic> toJson() {
    return {"title": title, "isCompleted": isCompleted};
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(title: json["title"], isCompleted: json["isCompleted"]);
  }
}

class TabData {
  String title;
  List<Todo> todoList;

  TabData({required this.title, List<Todo>? todoList})
    : todoList = todoList ?? [];

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "todoList": todoList.map((e) => e.toJson()).toList(),
    };
  }

  factory TabData.fromJson(Map<String, dynamic> json) {
    return TabData(
      title: json["title"],
      todoList: (json["todoList"] as List)
          .map((e) => Todo.fromJson(e))
          .toList(),
    );
  }
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  late List<TabData> tabs;
  int selectedTabIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    tabs = [
      TabData(title: "Personal"),
      TabData(title: "Work"),
      TabData(title: "Study"),
    ];

    loadData();
  }

  // shared prefrences savedata logic
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> jsonList = tabs.map((e) => e.toJson()).toList();

    await prefs.setString("ALL_TABS", jsonEncode(jsonList));
  }

  // shared prefrences loaddata logic
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("ALL_TABS");

    if (data != null) {
      List decoded = jsonDecode(data);
      tabs = decoded.map((e) => TabData.fromJson(e)).toList();
    }

    setState(() {
      isLoading = false;
    });
  }

  //  new tab add logic
  void addTab() {
    showDialog(
      context: context,
      builder: (context) => Addtile(
        controller: _controller,
        onSave: saveNewTab,
        onCancel: () => Navigator.pop(context),
        work: "Tab",
      ),
    );
  }

  // save a new Tile
  void saveNewTab() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      tabs.add(TabData(title: _controller.text.trim()));
      selectedTabIndex = tabs.length - 1;
    });
    Navigator.pop(context);
    _controller.clear();
    saveData();
  }

  // delets a tab using index logic
  void deleteTab(int index) {
    setState(() {
      tabs.removeAt(index);

      if (tabs.isEmpty) {
        tabs.add(TabData(title: "New Tab"));
        selectedTabIndex = 0;
      } else if (selectedTabIndex >= tabs.length) {
        selectedTabIndex = tabs.length - 1;
      }
    });

    saveData();
  }

  // save a new task
  void saveNewTask() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      tabs[selectedTabIndex].todoList.add(Todo(title: _controller.text.trim()));
    });

    Navigator.pop(context);
    _controller.clear();

    saveData();
  }

  // add a new tile
  void addTile() {
    showDialog(
      context: context,
      builder: (context) => Addtile(
        controller: _controller,
        onSave: saveNewTask,
        onCancel: () => Navigator.pop(context),
        work: "Task",
      ),
    );
  }

  // toggle a task
  void toggleTask(int index) {
    setState(() {
      tabs[selectedTabIndex].todoList[index].isCompleted =
          !tabs[selectedTabIndex].todoList[index].isCompleted;
    });

    saveData();
  }

  // delets a task
  void deleteTask(int index) {
    setState(() {
      tabs[selectedTabIndex].todoList.removeAt(index);
    });

    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 217, 210),

      // floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: addTile,
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),

      // appbar
      appBar: AppBar(
        title: const Text(
          "Todo Basic",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: tabs.length,
                          itemBuilder: (context, index) {
                            bool isSelected = selectedTabIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTabIndex = index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blueGrey
                                      : Colors.blueGrey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      tabs[index].title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => deleteTab(index),
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // add button in tabs list
                      IconButton(
                        onPressed: addTab,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),

                //  main task list
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: ListView.builder(
                      itemCount: tabs[selectedTabIndex].todoList.length,
                      itemBuilder: (context, index) => Todotile(
                        iconText: tabs[selectedTabIndex].todoList[index].title,
                        iconstatus:
                            tabs[selectedTabIndex].todoList[index].isCompleted,
                        onToggle: () => toggleTask(index),
                        deletetile: (context) => deleteTask(index),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
