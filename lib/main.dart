import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/app.dart';
import 'constants/constants.dart';

Future<ValueNotifier<GraphQLClient>> getClient() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(AUTH_TOKEN) ?? '';

  final HttpLink httpLink = HttpLink('http://35.203.173.173:8080/graphql/');

  Link link = httpLink;
  if (token.isNotEmpty) {
    link = AuthLink(getToken: () async => 'JWT $token').concat(httpLink);
  }

  return ValueNotifier<GraphQLClient>(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path); // Use a directory not synchronized by OneDrive
  await initHiveForFlutter();

  final client = await getClient();

  runApp(
    GraphQLProvider(
      client: client,
      child: App(),
    ),
  );
}
