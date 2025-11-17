import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<TodoItem> _todos = [
    TodoItem(title: "Estudar para a prova", completed: false),
    TodoItem(title: "Fazer a feira", completed: false),
  ];

  void _addTodo() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _todos.add(TodoItem(title: _controller.text.trim(), completed: false));
        _controller.clear();
      });
    }
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].completed = !_todos[index].completed;
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _clearAll() {
    setState(() {
      _todos.clear();
    });
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Lista de Tarefas',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.check_circle_outline, size: 50),
      children: const [
        Text('App simples de lista de tarefas criado com Flutter.'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Tarefas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 132, 39, 160),
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black45,
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'clear') _clearAll();
              if (value == 'about') _showAbout();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Color.fromARGB(255, 55, 54, 56)),
                    SizedBox(width: 12),
                    Text('Limpar Todas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Color.fromARGB(255, 55, 54, 56)),
                    SizedBox(width: 12),
                    Text('Sobre'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // nova tarefa
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Nova Tarefa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Digite sua tarefa...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addTodo(),
                    ),
                    const SizedBox(height: 12),
                    Center(    
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton.icon(
                          onPressed: _addTodo,
                          label: const Text(
                            'Adicionar Tarefa',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), 
                            ),
                            elevation: 6,
                            shadowColor: const Color.fromARGB(255, 227, 218, 252),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Suas Tarefas:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Lista de tarefas
          Expanded(
            child: _todos.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma tarefa ainda.\nAdicione uma acima!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.completed,
                            onChanged: (_) => _toggleTodo(index),
                            activeColor: Colors.deepPurple,
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: todo.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                              color:
                                  todo.completed ? Colors.grey : Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTodo(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class TodoItem {
  String title;
  bool completed;

  TodoItem({required this.title, required this.completed});
}
