import 'package:flutter/material.dart';

class TodoItem extends StatefulWidget {
  final String todoText;
  final Function pls;
  const TodoItem({super.key, required this.todoText, required this.pls});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        value: checked,
        secondary: IconButton(
            onPressed: () {
              setState(() {
                widget.pls(widget.todoText);
              });
            },
            icon: Icon(Icons.delete)),
        controlAffinity: ListTileControlAffinity.platform,
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
