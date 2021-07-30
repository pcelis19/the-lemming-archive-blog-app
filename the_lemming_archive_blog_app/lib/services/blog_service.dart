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
    final xmlString = await _xmlData;
    final feed = await compute<String, RssFeed>(_parseRssFeed, xmlString);
    return Blog(rssFeed: feed);
  }

  Future<void> refresh() async {
    bloc.sinkEvent(Blog());
    await _getData();
  }

   Future<AtomFeed> getFeed() =>
      http.read(_targetUrl).then((xmlString) => AtomFeed.parse(xmlString))

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

class Blog {
  final RssFeed rssFeed;

  Blog({RssFeed? rssFeed}) : rssFeed = rssFeed ?? RssFeed();
}
