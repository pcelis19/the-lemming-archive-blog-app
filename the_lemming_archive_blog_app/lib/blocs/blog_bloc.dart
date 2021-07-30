import 'package:rxdart/subjects.dart';
import 'package:the_lemming_archive_blog_app/services/blog_service.dart';
import 'package:webfeed/domain/rss_feed.dart';

class BlogBloc {
  final BehaviorSubject<Blog> _controller = BehaviorSubject<Blog>();
  Stream<Blog> get stream => _controller.stream;
  Blog? get initialData => _controller.valueOrNull;
  void sinkEvent(Blog event) => _controller.sink.add(event);
  dispose() => _controller.close();
}
