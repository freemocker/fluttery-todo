import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:todo/model/todo_list_model.dart';

import 'package:todo/gradient_background.dart';
import 'package:todo/shadow_image.dart';
import 'package:todo/task_progress_indicator.dart';
import 'package:todo/page/detail_screen.dart';
import 'package:todo/model/hero_id_model.dart';
import 'package:todo/route/scale_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var app = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400),
          title: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500),
          body1: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Hind',
          ),
        ),
      ),
      home: MyHomePage(title: 'TODO'),
    );

    return ScopedModel<TodoListModel>(
      model: TodoListModel(),
      child: app,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  final todos = [
    {
      "id": 923,
      "code_point": 0xe878,
      "progress": 60.0,
      "color": Colors.blue,
    },
    {
      "id": 933,
      "code_point": 0xe7fd,
      "progress": 40.0,
      "color": Colors.green,
    },
    {
      "id": 943,
      "code_point": 0xe854,
      "progress": 90.0,
      "color": Colors.red,
    },
  ];

  HeroId _generateHeroIds(int position) {
    var todo = todos[position];
    return HeroId(
      codePointId: 'code_point_id_${todo['id']}',
      progressId: 'progress_id_${todo['id']}',
      titleId: 'title_id_${todo['id']}',
      remainingTaskId: 'remaining_task_id_${todo['id']}',
    );
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController;
  int _counter = 0;
  MaterialColor color = Colors.purple;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
    super.initState();
  }

  void _onHandleTap() {
    var currentPageIndex = _pageController.page.toInt();
    var todo = widget.todos[currentPageIndex];
    var heroIds = widget._generateHeroIds(currentPageIndex);

    Navigator.push(
      context,
      ScaleRoute(
        widget: DetailScreen(
          color: todo['color'],
          codePoint: todo['code_point'],
          progress: todo['progress'],
          id: todo['id'],
          heroIds: heroIds,
        ),
      ),
      // MaterialPageRoute(
      //   builder: (context) => DetailScreen(
      //         color: todo['color'],
      //         codePoint: todo['code_point'],
      //         progress: todo['progress'],
      //         id: todo['id'],
      //         heroIds: heroIds,
      //       ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      color: color,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 36.0, left: 56.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ShadowImage(),
                  Container(
                    margin: EdgeInsets.only(top: 22.0, bottom: 12.0),
                    child: Text(
                      'Hello, Jane.',
                      style: Theme.of(context)
                          .textTheme
                          .headline
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  Text(
                    'Looks like feel good.',
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: Colors.white.withOpacity(0.7)),
                  ),
                  Container(height: 4.0),
                  Text(
                    'You have 3 tasks to do today.',
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: Colors.white.withOpacity(0.7)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 42.0),
                    child: Text(
                      'TODAY : FEBURARY 13, 2019',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: Colors.white.withOpacity(0.8)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification) {
                    var currentPage = _pageController.page;
                    print("ScrollNotification = ${_pageController.page}");
                    setState(() {
                      color = widget.todos[currentPage.toInt()]["color"];
                    });
                  }
                },
                child: PageView.builder(
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    var heroIds = widget._generateHeroIds(index);
                    return GestureDetector(
                      onTap: _onHandleTap,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 4.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Hero(
                                tag: heroIds.codePointId,
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  margin: EdgeInsets.only(
                                    bottom: 6.0,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey.shade100,
                                    ),
                                  ),
                                  child: Icon(
                                    IconData(
                                      widget.todos[index]["code_point"],
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    color: widget.todos[index]["color"],
                                  ),
                                ),
                              ),
                              Spacer(
                                flex: 8,
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 4.0),
                                child: Hero(
                                  tag: heroIds.remainingTaskId,
                                  child: Text(
                                    '12 Tasks',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .copyWith(color: Colors.grey[500]),
                                  ),
                                ),
                              ),
                              Container(
                                child: Hero(
                                  tag: heroIds.titleId,
                                  child: Text('Work',
                                      style: Theme.of(context)
                                          .textTheme
                                          .title
                                          .copyWith(color: Colors.black54)),
                                ),
                              ),
                              Spacer(),
                              Hero(
                                tag: heroIds.progressId,
                                child: TaskProgressIndicator(
                                  color: widget.todos[index]["color"],
                                  progress: widget.todos[index]["progress"],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: widget.todos.length,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 68.0),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'New Todo',
          backgroundColor: Colors.white,
          foregroundColor: color,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
