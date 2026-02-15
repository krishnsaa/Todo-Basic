import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Todotile extends StatelessWidget {
  final String iconText;
  final bool iconstatus;
  final VoidCallback onToggle;
  final Function(BuildContext)? deletetile;

  const Todotile({
    super.key,
    required this.iconText,
    required this.iconstatus,
    required this.onToggle,
    required this.deletetile,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon = iconstatus
        ? Icons.check_box
        : Icons.check_box_outline_blank_outlined;

    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deletetile,
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
              IconButton(onPressed: onToggle, icon: Icon(icon)),
              Text(
                iconText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  decoration: iconstatus ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
