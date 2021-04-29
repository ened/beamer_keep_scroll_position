import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final delegate = BeamerRouterDelegate(
    locationBuilder: SimpleLocationBuilder(routes: {
      '/': (context) => ListScreen(),
      '/detail/:index': (context) {
        final index = context.currentBeamLocation.state.pathParameters['index'];
        return DetailScreen(index: index!);
      },
      '/query': (context) {
        final index =
            context.currentBeamLocation.state.queryParameters['index'];
        return DetailScreen(index: index!);
      },
      '/final': (context) => FinalScreen()
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
          onTap: () => context.beamToNamed(
            '/detail/$index',
            popBeamLocationOnPop: true,
          ),
          onLongPress: () => context.beamToNamed(
            '/query?index=$index',
            popBeamLocationOnPop: true,
          ),
        ),
        itemCount: 1000,
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.index}) : super(key: key);

  final String index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail for $index')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('INDEX: $index'),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.beamToNamed(
                  '/final',
                  popBeamLocationOnPop: true,
                  beamBackOnPop: true,
                );
              },
              child: Text('to final page'),
            )
          ],
        ),
      ),
    );
  }
}

class FinalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Final Screen')),
      body: Center(child: Text('Can only go back from here.')),
    );
  }
}
