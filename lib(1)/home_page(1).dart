import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).loadUsers().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showUserForm(BuildContext context, {User? user}) {
    final titleController = TextEditingController(text: user?.title ?? '');
    final isEditing = user != null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit User' : 'Add User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final provider =
                  Provider.of<UserProvider>(context, listen: false);

              if (isEditing) {
                provider.updateUser(
                  user!.id,
                  User(id: user.id, title: titleController.text.trim()),
                );
              } else {
                provider
                    .addUser(User(id: '', title: titleController.text.trim()));
              }

              Navigator.of(ctx).pop();
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Posts")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.users.isEmpty
              ? const Center(child: Text("No users found."))
              : ListView.builder(
                  itemCount: provider.users.length,
                  itemBuilder: (ctx, i) {
                    final user = provider.users[i];
                    return ListTile(
                      title: Text(user.id),
                      subtitle: Text(user.title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showUserForm(context, user: user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              provider.deleteUser(user.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
