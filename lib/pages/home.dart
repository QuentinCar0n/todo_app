import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _supabase = Supabase.instance.client;
  final _todoController = TextEditingController();

  Future<List<Map<String, dynamic>>> _fetchTodos() async {
    final response = await _supabase
        .from('todos')
        .select('id, task, is_complete')
        .order('created_at');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> _addTodo() async {
    if (_todoController.text.isEmpty) return;
    
    await _supabase.from('todos').insert({
      'task': _todoController.text,
      'user_id': _supabase.auth.currentUser!.id,
    });
    _todoController.clear();
  }

  Future<void> _toggleComplete(Map<String, dynamic> todo) async {
    await _supabase
        .from('todos')
        .update({'is_complete': !todo['is_complete']})
        .eq('id', todo['id']);
  }

  Future<void> _deleteTodo(String id) async {
    await _supabase.from('todos').delete().eq('id', id);
  }

  Future<void> _logout() async {
    await _supabase.auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: StreamBuilder(
        stream: _supabase.from('todos').stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final todos = snapshot.data!;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(todo['task']),
                leading: Checkbox(
                  value: todo['is_complete'] ?? false,
                  onChanged: (_) => _toggleComplete(todo),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteTodo(todo['id']),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTodoPage(todo: todo),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('New Todo'),
            content: TextField(
              controller: _todoController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Enter todo task',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _addTodo();
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EditTodoPage extends StatelessWidget {
  final Map<String, dynamic> todo;
  final _controller = TextEditingController();

  EditTodoPage({super.key, required this.todo}) {
    _controller.text = todo['task'];
  }

  Future<void> _updateTodo(BuildContext context) async {
    await Supabase.instance.client
        .from('todos')
        .update({'task': _controller.text})
        .eq('id', todo['id']);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Todo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _updateTodo(context),
                child: const Text('Update Todo'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
