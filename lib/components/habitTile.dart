import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitTile(
      {super.key,
      required this.habitName,
      required this.habitCompleted,
      required this.onChanged,
      required this.settingsTapped,
      required this.deleteTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Checkbox(
          value: habitCompleted,
          onChanged: onChanged,
        ),
        Text(habitName),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
             settingsTapped?.call(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            deleteTapped?.call(context);
          },
        ),
      ]),
    );
  }
}
