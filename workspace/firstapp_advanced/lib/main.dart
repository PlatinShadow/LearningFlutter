import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];
  var history = <WordPair>[];
  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState;
    animatedList.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite(pair) {
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }

    notifyListeners();
  }

  bool isFaved() {
    return favorites.contains(current);
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch(selectedIndex) {
      case 0: 
        page = GeneratorPage(); 
        break;
      case 1:
       page = FavoritesPage(); 
       break;
      default: 
        throw UnimplementedError("no widget for $selectedIndex"); 
    }

    var mainArea = Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return LayoutBuilder(
      builder: (contex, constraints) {
        return Scaffold(
          body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: const [
                  NavigationRailDestination(
                      icon: Icon(Icons.home), label: Text('Home')),
                  NavigationRailDestination(
                      icon: Icon(Icons.favorite), label: Text('Favorites')),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;     
                  });
                },
              ),
            ),
            Expanded(child: mainArea)
          ],
        ));
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    var icon = appState.isFaved() ? Icons.favorite : Icons.favorite_outline;

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Expanded(flex: 2, child: HistoryListView()),
        BigCard(pair: pair),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                appState.toggleFavorite(pair);
                appState.getNext();
              },
              icon: Icon(icon),
              label: const Text('Like'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: const Text('Next')),
          ],
        ),
        const Spacer(flex: 2)
      ]),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(children: [
          Text(pair.first, style: style.copyWith(fontWeight: FontWeight.w200)),
          Text(pair.second, style: style.copyWith(fontWeight: FontWeight.w400))
          ]),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if(appState.favorites.isEmpty) {
      return const Center(child: Text('No favorites yet :/'));
    }

    return ListView(
      children: [
        Padding(padding: const EdgeInsets.all(20),
        child: Text('You have ${appState.favorites.length} favorites: ')),

        for (var pair in appState.favorites)
          ListTile(leading: Icon(Icons.favorite), title: Text(pair.asLowerCase))

      ],
    );

  }

} 

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
    final _key = GlobalKey();

    static const Gradient _maskingGradient = LinearGradient(
      colors: [Colors.transparent, Colors.black],
      stops: [0.0, 0.5],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(child: 
            TextButton.icon(onPressed: () => appState.toggleFavorite(pair), icon: appState.favorites.contains(pair) ? Icon(Icons.favorite, size:12) : SizedBox(), label: Text(pair.asLowerCase))));
        },
        
      ));
  }
}