import 'package:flutter/material.dart';

class TodoItem extends StatefulWidget {
  const TodoItem({super.key, required this.todoText});
  final String todoText;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
/*     return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Text(todoText),
    ); */
    return Card(
      child: CheckboxListTile(
        value: checked,
        onFocusChange: (value) => print(value),
        title: Text(widget.todoText),
        onChanged: (bool? value) {
          setState(() {
            checked = value!;
          });
        },
      ),
    );
  }
}
