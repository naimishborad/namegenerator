import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: Center(
            // Drop the const, and
            //child: Text('Hello World'),        // Replace this text...
            child: randomwords() // With this text.
            ),
      ),
    );
  }
}

class randomwords extends StatefulWidget {
  randomwords({Key? key}) : super(key: key);

  @override
  State<randomwords> createState() => _randomwordsState();
}

class _randomwordsState extends State<randomwords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  void _pushsaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  tileColor: Colors.white,
                  title: Text(
                    pair.asPascalCase,
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Vx.indigo500),
                  ),
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            backgroundColor: Vx.gray800,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text('Saved Suggestions',style: TextStyle(color: Vx.indigo400),),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView(children: divided),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget _buildsuggetions() {
    return ListView.builder(
      itemBuilder: (context, i) {
        if (i.isOdd)
          return Divider(
            color: Vx.gray800,
            height: 5,
          );
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          // ...then generate 10 more and add them to the
          // suggestions list.
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random(); // Delete these...
    //return Text(wordPair.asPascalCase); // ... two lines.

    return Scaffold(
      backgroundColor: Vx.gray800, // Add from here...
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: const Text(
            '''Unlimited Startup Name Generator
By Naimish Borad''',
            style: TextStyle(color: Vx.indigo400, fontSize: 20),
          ),
        ),
        actions: [
          IconButton(onPressed: _pushsaved, icon: Icon(Icons.list))
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: _buildsuggetions(),
      ),
    ); // ... to here.
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    // ignore: prefer_const_constructors
    return Card(
      child: Row(
        children: [
          Container(
            width: 20,
            color: Vx.indigo400,
          ),
          Container(
            color: Vx.indigo200,
            width: 10,
          ),
          SizedBox(
            width: 5,
          ),
          ButtonBar(
            children: [
              IconButton(
                iconSize: 23,
                icon: Icon(
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null,
                  semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                ),
                onPressed: () {
                  setState(() {
                    if (alreadySaved) {
                      _saved.remove(pair);
                    } else {
                      _saved.add(pair);
                    }
                  });
                },
              ),
            ],
          ),
          Text(
            pair.asPascalCase,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
          ),
          // ignore: prefer_const_constructors
        ],
      ),
    ).h(55);
  }
} 
