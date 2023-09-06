

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class TodoItem extends StatefulWidget {
  const TodoItem(
      {super.key,
      required this.todoMap,
      required this.todosMap,
      required this.dataFile,
      required this.updateTodos});


  final Function updateTodos;
  final Map todoMap;
  final Map todosMap;
  final Future<File> dataFile;
  final bool checked = false;
  final bool fresh = true;

  void save() async {
    // saves the current state of the todosMap to a JSON file

    final file = await dataFile;
    file.writeAsString(jsonEncode(todosMap));
  }

  void removeSelf() {
    todosMap.remove(todoMap["ID"].toString());
    save();
  }

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    if (widget.fresh) {
      widget.save();
    }
    // updates JSON file containing todosMap to include the newly created item

    return Card(
      child: Column(
        children: [
          CheckboxListTile(
            visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
            value: widget.todoMap["checked"],
            secondary: IconButton(
                onPressed: () => {
                  widget.removeSelf(),
                  widget.updateTodos()
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
                widget.save();
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 2.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container( alignment: FractionalOffset.centerLeft,
                child: Text(widget.todoMap["descText"].toString(),
                            style: TextStyle(fontSize: widget.todoMap["descText"] == ""?
                                                        0.0: 14.0,
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
                        ),
              ),
            )
          )
        ],
      ),
    );
  }
}
