import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:responsive_builder/responsive_builder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final delegate = BeamerRouterDelegate(
    listener: (state, location) {
      print(state.uri);
    },
    locationBuilder: SimpleLocationBuilder(routes: {
      '/': (context) {
        return ListWrapper();
      },
      '/detail/:index': (context) {
        final index = context.currentBeamLocation.state.pathParameters['index'];
        return DetailScreen(index: index!);
      },
      '/detail/:index/final': (context) {
        final index = context.currentBeamLocation.state.pathParameters['index'];
        return FinalScreen(index: index!);
      },
      '/final': (context) {
        final index =
            context.currentBeamLocation.state.queryParameters['index'];
        return FinalScreen(index: index!);
      }
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

class ListWrapper extends StatefulWidget {
  @override
  _ListWrapperState createState() => _ListWrapperState();
}

class _ListWrapperState extends State<ListWrapper> {
  String? _index;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => ListScreen(
        onSelected: (index) {
          context.beamToNamed(
            '/detail/$index',
            popBeamLocationOnPop: true,
          );
        },
      ),
      tablet: (_) {
        return Row(
          children: [
            Flexible(
                flex: 1,
                child: ListScreen(
                  onSelected: (index) {
                    setState(() {
                      _index = index;
                    });
                  },
                )),
            if (_index != null)
              Flexible(
                flex: 3,
                child: DetailScreen(index: _index!),
              )
          ],
        );
      },
    );
  }
}

typedef StringCallback = Function(String);

class ListScreen extends StatelessWidget {
  const ListScreen({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  final StringCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List')),
      body: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text('Item: $index'),
          onTap: () => this.onSelected('$index'),
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
                final nested = getValueForScreenType<bool>(
                  context: context,
                  mobile: true,
                  tablet: false,
                );
                if (nested) {
                  context.beamToNamed(
                    '/detail/$index/final',
                    popBeamLocationOnPop: true,
                    beamBackOnPop: true,
                  );
                } else {
                  context.beamToNamed(
                    '/final?index=$index',
                    popBeamLocationOnPop: true,
                  );
                }
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
  const FinalScreen({Key? key, required this.index}) : super(key: key);

  final String index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Final Screen')),
      body: Center(child: Text('Can only go back from here.')),
    );
  }
}
