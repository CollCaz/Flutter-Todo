import 'package:flutter/material.dart';

class TodoItem extends StatefulWidget {
  const TodoItem(
      {super.key,
      required this.todoMap,
      required this.removeTodoItem,
      required this.addItem});

  final Function removeTodoItem;
  final Function addItem;
  final Map todoMap;
  final bool checked = false;

  void saveTodoItem(s) {
    print(s);
  }

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
                widget.removeTodoItem(widget.todoMap["ID"].toString());
              });
            },
            icon: const Icon(Icons.delete)),
        controlAffinity: ListTileControlAffinity.platform,
        title: Text(
          widget.todoMap["text"],
          style: TextStyle(
              decoration: widget.todoMap["checked"] == true
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        onChanged: (bool? value) {
          setState(() {
            widget.todoMap["checked"] = value!;
            widget.addItem;
          });
        },
      ),
    );
  }
}
