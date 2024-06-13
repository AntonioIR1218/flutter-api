import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/constants/constants.dart';

class Header extends StatelessWidget {
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AUTH_TOKEN) != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final isLoggedIn = snapshot.data ?? false;

        return AppBar(
          title: Text('Disney'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: Text('New', style: TextStyle(color: Colors.blue)),
            ),
            if (isLoggedIn) ...[
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create');
                },
                child: Text('Submit', style: TextStyle(color: Colors.blue)),
              ),
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove(AUTH_TOKEN);
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                child: Text('Logout', style: TextStyle(color: Colors.blue)),
              ),
            ] else ...[
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Login', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ],
        );
      },
    );
  }
}
