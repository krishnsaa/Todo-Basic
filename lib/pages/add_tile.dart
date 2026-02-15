import 'package:flutter/material.dart';
import 'package:todo/pages/button.dart';

class Addtile extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final String work;
  const Addtile({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    required this.work,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add New $work"),
      backgroundColor: const Color.fromARGB(255, 181, 200, 210),
      content: SizedBox(
        height: 200,
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hint: Text("Type Here..", style: TextStyle(fontSize: 20)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(text: "Save", onPressed: onSave),
                MyButton(text: "Close", onPressed: onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
