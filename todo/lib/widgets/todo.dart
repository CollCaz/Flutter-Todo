import 'package:flutter/material.dart';

class TodoItem extends StatefulWidget {
  final Function removeTodoItem;
  final Map todoMap;
  bool checked = false;
  TodoItem({super.key, required this.todoMap, required this.removeTodoItem});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        value: widget.todoMap["checked"],
        secondary: IconButton(
            onPressed: () {
              setState(() {
                widget.removeTodoItem(widget.todoMap);
              });
            },
            icon: const Icon(Icons.delete)),
        controlAffinity: ListTileControlAffinity.platform,
        title: Text(widget.todoMap["id"].toString()),
        onChanged: (bool? value) {
          setState(() {
            widget.todoMap["checked"] = value!;
          });
        },
      ),
    );
  }
}
