import 'package:flutter/material.dart';
import 'package:todo/pages/button.dart';

class Addtile extends StatefulWidget {
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
  State<Addtile> createState() => _AddtileState();
}

class _AddtileState extends State<Addtile> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Request focus after dialog builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add New ${widget.work}"),
      backgroundColor: const Color.fromARGB(255, 181, 200, 210),
      content: SizedBox(
        height: 200,
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Type Here..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(text: "Save", onPressed: widget.onSave),
                MyButton(text: "Close", onPressed: widget.onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
