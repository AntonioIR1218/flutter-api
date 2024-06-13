import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/constants/constants.dart';

const SIGNUP_MUTATION = """
  mutation SignupMutation(\$email: String!, \$username: String!, \$password: String!) {
    createUser(email: \$email, username: \$username, password: \$password) {
      user {
        id
        username
        email
      }
    }
  }
""";

const LOGIN_MUTATION = """
  mutation LoginMutation(\$username: String!, \$password: String!) {
    tokenAuth(username: \$username, password: \$password) {
      token
    }
  }
""";

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool login = true;
  String errorMessage = '';

  void _toggleForm() {
    setState(() {
      login = !login;
      errorMessage = '';
    });
  }

  void _submit() async {
    if (login) {
      await _login();
    } else {
      await _signup();
    }
  }

  Future<void> _login() async {
    final GraphQLClient client = GraphQLProvider.of(context).value;
    final QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(LOGIN_MUTATION),
        variables: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      ),
    );

    if (result.hasException) {
      setState(() {
        errorMessage = 'Please enter valid credentials';
      });
      print(result.exception.toString());
      return;
    }

    final token = result.data?['tokenAuth']?['token'];
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AUTH_TOKEN, token);
      Navigator.pushNamed(context, '/');
    }
  }

  Future<void> _signup() async {
    final GraphQLClient client = GraphQLProvider.of(context).value;
    final QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(SIGNUP_MUTATION),
        variables: {
          'email': _emailController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      ),
    );

    if (result.hasException) {
      setState(() {
        errorMessage = 'Error signing up. Please try again.';
      });
      print(result.exception.toString());
      return;
    }

    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(login ? 'Login' : 'Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            if (!login)
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submit,
              child: Text(login ? 'Login' : 'Create Account'),
            ),
            TextButton(
              onPressed: _toggleForm,
              child: Text(login ? 'Need to create an account?' : 'Already have an account?'),
            ),
          ],
        ),
      ),
    );
  }
}
