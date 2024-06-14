import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Screen/Unlogin.dart';

class EditScreen extends StatefulWidget {
  final String username;

  const EditScreen({super.key, required this.username});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.username);
  }

  Future<void> _updateUsername(String newUsername) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', newUsername);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UnloginComponent()),
    );
  }

  void _cancelEdit() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Name')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: 250,
          alignment: Alignment.center,
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Enter new name'),
              ),
              ElevatedButton(
                onPressed: () {
                  _updateUsername(_controller.text);
                },
                child: const Text('Save'),
              ),
              ElevatedButton(
                onPressed: _cancelEdit,
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
