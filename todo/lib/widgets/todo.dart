import 'package:flutter/material.dart';

class TodoItem extends StatefulWidget {
  const TodoItem({super.key, required this.todoText});
  final String todoText;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
/*     return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Text(todoText),
    ); */
    bool checked = false;
    return Card(
      child: CheckboxListTile(
        value: checked,
        onChanged: (value) {
          setState(() {
            _checked = value;
            print(value);
          });
        },
        onFocusChange: (value) => print(value),
        title: Text(widget.todoText),
      ),
    );
  }
}
