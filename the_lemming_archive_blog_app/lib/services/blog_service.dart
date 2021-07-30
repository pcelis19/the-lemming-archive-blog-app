import 'package:flutter/foundation.dart';
import 'package:the_lemming_archive_blog_app/blocs/blog_bloc.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class BlogService {
  BlogService(this.bloc) {
    _getData();
  }

  final BlogBloc bloc;

  Future<void> _getData() async {
    final nextEvent = await blog;
    bloc.sinkEvent(nextEvent);
  }

  Future<Blog> get blog async {
    final feed = await rssFeed;
    return Blog(feed: feed);
  }

  Future<void> refresh() async {
    bloc.sinkEvent(Blog());
    await _getData();
  }

  Future<RssFeed> get rssFeed =>
      http.get(Uri.parse(lemmingArchiveRssFeed)).then((value) {
        if (value.statusCode != 200) {
          throw 'Invalid status code${value.statusCode}';
        }
        return compute<String, RssFeed>(_parseRssFeed, value.body);
      });

  Future<AtomFeed> get atomFeed =>
      http.read(Uri.parse(lemmingArchiveRssFeed)).then(
          (xmlString) => compute<String, AtomFeed>(_parseAtomFeed, xmlString));

  Future<String> get _xmlData async {
    final response = await http.get(Uri.parse(lemmingArchiveRssFeed));
    if (response.statusCode != 200) {
      throw 'Error, status code: ${response.statusCode}';
    }
    return response.body;
  }

  static const String lemmingArchiveRssFeed =
      'https://lemmingarchive.blogspot.com/feeds/posts/default?alt=rss';
}

RssFeed _parseRssFeed(String xmlString) {
  return RssFeed.parse(xmlString);
}

AtomFeed _parseAtomFeed(String xmlString) => AtomFeed.parse(xmlString);

class Blog {
  final RssFeed atomFeed;

  Blog({RssFeed? feed}) : atomFeed = feed ?? RssFeed();
}
