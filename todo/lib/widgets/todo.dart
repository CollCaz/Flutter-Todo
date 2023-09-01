import 'package:flutter/material.dart';

class TodoItem extends StatefulWidget {
  final Function removeTodoItem;
  final Map todoMap;
  const TodoItem(
      {super.key, required this.todoMap, required this.removeTodoItem});

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
                widget.removeTodoItem(widget.todoMap);
              });
            },
            icon: const Icon(Icons.delete)),
        controlAffinity: ListTileControlAffinity.platform,
        title: Text(widget.todoMap["text"]),
        onChanged: (bool? value) {
          setState(() {
            checked = value!;
          });
        },
      ),
    );
  }
}
