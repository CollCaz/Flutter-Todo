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
  List<String> todos = [];
  List<Map> todosMap = [];

  final TextEditingController _todoListTextController = TextEditingController();
  // controlls the field used to input to do list items

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
// gives path to local documents directory used to store list items

  Future<File> get _localListFile async {
    final path = await _localPath;
    return File('$path/list.txt');
  }

// gives a file in which the todo list is stored

  Future<List<String>> get _listFileData async {
    // loads file data into list of strings for further proccessing
    try {
      final listFile = await _localListFile;
      final listFileData = await listFile.readAsLines();
      return listFileData;
    } catch (e) {
      return [];
    }
  }

  void _loadTodoList() async {
    // loads todo list items into their map

    final listFileData = await _listFileData;
    // create instance of list file data to use

    if (listFileData.isNotEmpty) {
      for (var i = 0; i < listFileData.length; i += 3) {
        setState(() {
          todosMap.add({
            "id": int.parse(listFileData[i]),
            "text": (listFileData[i + 1]),
            "checked": bool.parse(listFileData[i + 2])
          });
        });
      }
    }
    // incase the list file isn't empty or unusable iterate
    // over it's list items in sets of 3 and use their
    // values to poplate the todosMap
  }

  void _appendTodoFile(Map todoMap) async {
    // used to append the file with new todo list items
    //  should be called each time a new item is added

    final listFile = await _localListFile;
    // create instance of list file to use
    final todoID = todoMap["id"];
    final todoText = todoMap["text"];
    final todoChecked = todoMap["checked"];

    listFile.writeAsString('$todoID\n$todoText\n$todoChecked\n',
        mode: FileMode.append);
  }

  void _removeTodo(Map value) {
    setState(() {
      todosMap.remove(value);
    });
  }

  void _addTodoItem() {
    setState(() {
      if (todoText == "") {
        DoNothingAction();
      } else {
        var time = DateTime.now().microsecondsSinceEpoch;
        todosMap.add({"text": todoText, "checked": false, "id": time});
        _appendTodoFile(todoText, time);
      }
    });
  }

  void _addTodoItemAndClearText() {
    setState(() {
      _addTodoItem();
      _todoListTextController.clear();
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
                for (var i = 0; i < todosMap.length; i++)
                  TodoItem(
                    todoMap: todosMap[i],
                    removeTodoItem: _removeTodo,
                  ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: TextField(
                controller: _todoListTextController,
                onChanged: (value) => todoText = value,
                onSubmitted: (value) => {_addTodoItemAndClearText()},
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.inversePrimary,
                    hintText: "What do you want to do?"),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_addTodoItemAndClearText()},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
