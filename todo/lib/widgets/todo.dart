import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.todoText});
  final String todoText;

  @override
  Widget build(BuildContext context) {
/*     return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Text(todoText),
    ); */
    return Card(
      color: Colors.amber,
    );
  }
}
