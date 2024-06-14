import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Screen/Edit.dart';
import 'package:untitled1/main.dart';

class UnloginComponent extends StatefulWidget {
  const UnloginComponent({super.key});

  @override
  _UnloginComponentState createState() => _UnloginComponentState();
}

class _UnloginComponentState extends State<UnloginComponent> {
  late String username;
  late bool _isLogged;

  @override
  void initState() {
    super.initState();
    _loadState();


}

  Future<void> _deleteUsername(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.setBool('isLogged', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'login')
      )
        , (route) => false
    );
  }


  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      _isLogged = prefs.getBool('isLogged') ?? false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Welcome back, $username'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditScreen(username: username)),
                );
              },
              child: const Text('Edit Name'),
            ),
            ElevatedButton(
              onPressed: () => _deleteUsername(context),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

}
