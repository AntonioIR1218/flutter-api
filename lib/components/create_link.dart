import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/constants/constants.dart';

const CREATE_LINK_MUTATION = """
  mutation CreateLink(\$url: String!, \$description: String!) {
    createLink(url: \$url, description: \$description) {
      id
      url
      description
    }
  }
""";

class CreateLink extends StatefulWidget {
  @override
  _CreateLinkState createState() => _CreateLinkState();
}

class _CreateLinkState extends State<CreateLink> {
  final _formKey = GlobalKey<FormState>();
  String _url = '';
  String _description = '';

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(CREATE_LINK_MUTATION),
        variables: {
          'url': _url,
          'description': _description,
        },
      ),
    );

    if (result.hasException) {
      print(result.exception.toString());
      return;
    }

    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Link'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _url = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Create Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
