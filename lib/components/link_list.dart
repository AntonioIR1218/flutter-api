import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'header.dart';  // Importa header.dart
import 'link.dart' as custom_link;

const FEED_QUERY = """
  query {
    links {
      id
      url
      description
      postedBy {
        username
      }
      votes {
        id
      }
    }
  }
""";

class LinkList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Header(),  // Usa el Header
      ),
      body: Query(
        options: QueryOptions(
          document: gql(FEED_QUERY),
        ),
        builder: (QueryResult result, {FetchMore? fetchMore, VoidCallback? refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List links = result.data?['links'] ?? [];

          return ListView.builder(
            itemCount: links.length,
            itemBuilder: (context, index) {
              final link = links[index];
              return custom_link.Link(
                id: link['id'],
                url: link['url'],
                description: link['description'],
                postedBy: link['postedBy']?['username'],
                votesCount: link['votes']?.length ?? 0,
              );
            },
          );
        },
      ),
    );
  }
}
