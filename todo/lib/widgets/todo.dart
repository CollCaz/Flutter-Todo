import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class TodoItem extends StatefulWidget {
  const TodoItem(
      {super.key,
      required this.todoMap,
      required this.addItem,
      required this.todosMap,
      required this.dataFile});

  final Function addItem;
  final Map todoMap;
  final Map todosMap;
  final Future<File> dataFile;
  final bool checked = false;

  void save() async {
    final file = await dataFile;
    file.writeAsString(jsonEncode(todosMap));
  }
  void remove() {
    todosMap.remove(todoMap["ID"].toString());
    save();
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
            onPressed: () => {
              setState(() {
                widget.remove();
              })
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
            widget.save();
          });
        },
      ),
    );
  }
}
