import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/Screen/Unlogin.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'login',
      home: MyHomePage(title: 'Shared preferences demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color themeColor = Colors.blue;
  String username = '';
  bool _isLogged = false;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      themeColor = Color(prefs.getInt('themeColor') ?? Colors.blue.value);
      username = prefs.getString('username') ?? '';
      _isLogged = prefs.getBool('isLogged') ?? false;
    });
    if (_isLogged) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UnloginComponent()),
        (route) => false,
      );
    }
  }

  void _resetState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    setState(() {
      themeColor = Colors.blue;
      username = '';
      _isLogged = false;
    });
  }

  void _login(String user, int pass, bool saveSession) async {
    if (user == 'admin' && pass == 1234) {
      if (saveSession) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLogged', true);
        prefs.setString('username', user);
      }
      setState(() {
        _isLogged = true;
        username = user;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged in'),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UnloginComponent()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isLogged ? themeColor : Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isLogged)
              LoginComponente(
                onLogin: _login,
                clear: _resetState,
              )
          ],
        ),
      ),
    );
  }
}

class LoginComponente extends StatefulWidget {
  final Function(String, int, bool) onLogin;
  final Function() clear;

  const LoginComponente({super.key, required this.onLogin, required this.clear});

  @override
  State<LoginComponente> createState() => _LoginComponenteState();
}

class _LoginComponenteState extends State<LoginComponente> {
  String username = '';
  int password = 0;
  bool saveSession = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Column(
        children: [
          TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Username',
            ),
            onChanged: (value) {
              setState(() {
                username = value;
              });
            },
          ),
          TextField(
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
            onChanged: (value) {
              setState(() {
                password = int.tryParse(value) ?? 0;
              });
            },
          ),
          Row(
            children: [
              Checkbox(
                value: saveSession,
                onChanged: (value) {
                  setState(() {
                    saveSession = value ?? false;
                  });
                },
              ),
              const Text('Guardar sesión'),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              widget.onLogin(username, password, saveSession);
            },
            child: const Text('Login'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                username = '';
                password = 0;
                saveSession = false;
              });
            },
            child: const Text('Borrar'),
          )
        ],
      ),
    );
  }
}
