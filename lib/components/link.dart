import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final String id;
  final String url;
  final String description;
  final String? postedBy;
  final int votesCount;

  Link({
    required this.id,
    required this.url,
    required this.description,
    this.postedBy,
    required this.votesCount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(description),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(url),
          if (postedBy != null) Text('Posted by $postedBy'),
          Text('Votes: $votesCount'),
        ],
      ),
    );
  }
}
