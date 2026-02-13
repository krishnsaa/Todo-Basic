import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Todotile extends StatefulWidget {
  final String iconText;
  final Function(BuildContext)? deletetile;
  const Todotile({super.key, required this.iconText, required this.deletetile});

  @override
  State<Todotile> createState() => _TodotileState();
}

class _TodotileState extends State<Todotile> {
  static const iconBlank = Icons.check_box_outline_blank_outlined;
  static const iconFull = Icons.check_box;

  IconData icon = iconBlank;

  void changeIcon() {
    setState(() {
      icon = icon == iconFull ? iconBlank : iconFull;
    });
  }

  TextDecoration? textDecor(IconData data) {
    return data == iconFull ? TextDecoration.lineThrough : null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: widget.deletetile,
              icon: Icons.delete_forever,
              backgroundColor: Colors.redAccent,
              borderRadius: BorderRadius.circular(30),
            ),
          ],
        ),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 210, 166, 153),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              IconButton(onPressed: changeIcon, icon: Icon(icon)),
              Text(
                widget.iconText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  decoration: textDecor(icon),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
