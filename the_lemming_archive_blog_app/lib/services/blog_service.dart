import 'package:webfeed/webfeed.dart';


class BlogService {
  static const String lemmingArchiveRssFeed =
      'https://lemmingarchive.blogspot.com/feeds/posts/default?alt=rss';
  Future<Blog> get blog{
    RssFeed rssFeed = Rss
  }
}

class Blog {
  final RssFeed rssFeed;
}
