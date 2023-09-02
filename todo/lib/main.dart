import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:todo/widgets/todo.dart';

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

  void _removeTodo(Map value) {
    setState(() {
      todosMap.remove(value);
    });
  }

  void _addTodoItem() {
    setState(() {
      todoText == ""
          ? DoNothingAction()
          : todosMap.add({
              "text": todoText,
              "checked": false,
              "id": DateTime.now().millisecondsSinceEpoch,
            });
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
                onSubmitted: (value) => {
                  _addTodoItemAndClearText(),
                },
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
