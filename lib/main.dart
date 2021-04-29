import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final delegate = BeamerRouterDelegate(
    locationBuilder: SimpleLocationBuilder(routes: {
      '/': (context) => ListScreen(),
      '/detail/:index': (context) => DetailScreen(),
    }),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerDelegate: delegate,
      routeInformationParser: BeamerRouteInformationParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: delegate),
    );
  }
}

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List')),
      body: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text('Item: $index'),
          onTap: () =>
              context.beamToNamed('/detail/$index', popBeamLocationOnPop: true),
        ),
        itemCount: 1000,
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final index = context.currentBeamLocation.state.pathParameters['index'];
    return Scaffold(
      appBar: AppBar(title: Text('Detail for $index')),
      body: Center(child: Text('INDEX: $index')),
    );
  }
}
