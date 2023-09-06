import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:todo/widgets/todo.dart';
import 'dart:io';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData.dark(useMaterial3: true),
      home: const TodoList(title: 'Todo'),
    );
  }
}

class TodoList extends StatefulWidget {
  final String title;
  const TodoList({super.key, required this.title});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool boot = true;
  String todoText = "";
  String todoDescText = "";
  List<String> todos = [];
  Map todosMap = {};

  final TextEditingController _todoListTextController = TextEditingController();
    final TextEditingController _todoDescTextController = TextEditingController();
  // controlls the field used to input to do list items

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
// gives path to local documents directory used to store list items

  Future<File> get _localListFile async {
    final path = await _localPath;
    return File('$path/list.json').create();
  }

// gives a file in which the todo list is stored

  Future<String> get _listFileData async {
    // loads file data into list of strings for further proccessing
    try {
      final listFile = await _localListFile;
      final listFileData = listFile.readAsString();
      return listFileData;
    } catch (e) {
      return Future(() => "");
    }
  }

  void _loadTodoList() async {
    // loads todo listo items into their map
    final listFileData = await _listFileData;

    setState(() {
      // create instance of list file data to use

      if (listFileData.isNotEmpty) {
        todosMap = jsonDecode(listFileData);
      }
    });
  }
  // incase the list file isn't empty or unusable iterate
  // over it's list items in sets of 3 and use their
  // values to poplate the todosMap


  bool _addTodoItem() {
      if (todoText == "") {
        DoNothingAction();
        return false;
      } 
      else {
          setState(() {
          var time = DateTime.now().microsecondsSinceEpoch;
          Map todoItemMap = {"text": todoText, "checked": false, "ID": time,
                              "descText": todoDescText.isEmpty?
                                          "": todoDescText};
          todosMap[time.toString()] = todoItemMap;
          });
        return true;
      }
  }

  void _addTodoItemAndClearText() {
    setState(() {
      bool added = _addTodoItem();

      if (added) {
      _todoListTextController.clear();
      _todoDescTextController.clear();
      todoText = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (boot) {
      setState(() {
        _loadTodoList();
      });
// loads up todo list once
      boot = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: ListView(
              children: <Widget>[
                for (var value in todosMap.values)
                  TodoItem(
                    todoMap: value,
                    updateTodos: () => {setState((){})},
                    dataFile: _localListFile,
                    todosMap: todosMap,
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                    controller: _todoListTextController,
                    onChanged: (value) => todoText = value,
                    onSubmitted: (value) => {_addTodoItemAndClearText()},
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.inversePrimary,
                        hintText: "What do you want to do?"),
                  ),
                    TextField(
                    controller: _todoDescTextController,
                    onChanged: (value) => todoDescText = value,
                    onSubmitted: (value) => {_addTodoItemAndClearText()},
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.inversePrimary,
                        hintText: "Description"),
                  )
                ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_addTodoItemAndClearText()},
        tooltip: 'Increment',
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        child: const Icon(Icons.add)
      ),
    );
  }
}

