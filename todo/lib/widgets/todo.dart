

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

import 'package:flutter_animate/flutter_animate.dart';

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

    void save() async {
    // saves the current state of the todosMap to a JSON file

    final file = await dataFile;
    file.writeAsString(jsonEncode(todosMap));
  }

  void removeSelf(bool pending) {
    if (pending) {
      todosMap.remove(todoMap["ID"].toString());
    save();
    }

  }

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  bool fresh = true;
  bool pendingRemoval = false;

  @override
  Widget build(BuildContext context) {
    if (fresh) {
      widget.save();
      fresh = false;
    }
    // updates JSON file containing todosMap to include the newly created item

    return Animate(
      autoPlay: false,
      target: pendingRemoval? 1: 0,
      onComplete: (controller) => {
          widget.removeSelf(pendingRemoval),
          widget.updateTodos()
      },
      effects: [
        SlideEffect(delay: 850.ms, duration: 850.ms, begin: const Offset(0.0, 0.0), end: const Offset(1.0, 0.0)),
        FadeEffect(delay: 1.seconds, duration: 300.ms, begin: 1.0, end: 0.0)
      ],
      child: Card(
        child: Column(
          children: [
            CheckboxListTile(
              visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
              value: widget.todoMap["checked"],
              secondary: IconButton(
                  onPressed: () => {
                    setState(() {
                      pendingRemoval = !pendingRemoval;
                    }),
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
            ExpansionTile(
              title: Text("Description",
                style: TextStyle(fontSize: 10.0,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
                maxLines: 1
                ),
              children: [Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: TextField(autofocus: false,
                  decoration: const InputDecoration(hintText: "add description") ,
                  onChanged: (value) => 
                      widget.todoMap["descText"] = value,
              
                  onSubmitted: (value) => setState(() {
                    widget.save();
                  }),
                  onTapOutside: (event) => setState(() {
                    widget.save();
                  }),
                  controller: TextEditingController(text: widget.todoMap["descText"]),
                  minLines: 2, maxLines: null,
                  style: TextStyle(fontSize: 12,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
                                    ),
              ),
              ]
            )
          ],
        ),
      ),
    );
  }
}
