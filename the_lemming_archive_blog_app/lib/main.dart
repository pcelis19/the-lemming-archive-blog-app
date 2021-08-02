import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_lemming_archive_blog_app/blocs/blog_bloc.dart';
import 'package:the_lemming_archive_blog_app/services/blog_service.dart';
import 'package:webfeed/domain/atom_item.dart';
import 'package:webfeed/domain/rss_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final BlogService blogService = BlogService(BlogBloc());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme(),
        primarySwatch: Colors.blue,
        // The line below forces the theme to iOS.
        platform: TargetPlatform.iOS,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Unofficial Blog App'),
          ),
          body: RefreshIndicator(
            onRefresh: blogService.refresh,
            child: StreamBuilder<Blog>(
              stream: blogService.bloc.stream,
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                } else {
                  final list = snapshot.data!.atomFeed.items ?? <RssItem>[];

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      RssItem rssItem = list[index];
                      return ListTile(
                        title: Text(
                          rssItem.title ?? 'No Title',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        isThreeLine: false,
                        subtitle: Text(rssItem.pubDate?.toLocal().toString() ??
                            'no date specified'),
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (BuildContext context) => BlogPost(
                            rssItem: rssItem,
                            blog: snapshot.data!,
                          ),
                        )),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class BlogPost extends StatelessWidget {
  final Blog blog;
  final RssItem rssItem;
  const BlogPost({Key? key, required this.rssItem, required this.blog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rssItem.title ?? 'No Title'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                text ?? 'No Content',
              ),
            ),
          )
        ],
      ),
    );
  }

  String? get text => Blog.stripHtmlIfNeeded(rssItem.description ?? '');
}
