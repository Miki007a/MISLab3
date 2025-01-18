import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/joke_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JokesByTypeScreen extends StatefulWidget {
  @override
  _JokesByTypeScreenState createState() => _JokesByTypeScreenState();
}

class _JokesByTypeScreenState extends State<JokesByTypeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> _isJokeFavorite(String setup, String punchline) async {
    final QuerySnapshot result = await _firestore
        .collection('favorite_jokes')
        .where('setup', isEqualTo: setup)
        .where('punchline', isEqualTo: punchline)
        .get();
    return result.docs.isNotEmpty;
  }

  Future<void> _toggleFavorite(JokeModel joke) async {
    final QuerySnapshot existingJokes = await _firestore
        .collection('favorite_jokes')
        .where('setup', isEqualTo: joke.setup)
        .where('punchline', isEqualTo: joke.punchline)
        .get();

    if (existingJokes.docs.isNotEmpty) {
      // Remove from favorites
      await existingJokes.docs.first.reference.delete();
      joke.isFavorite = false;
    } else {
      // Add to favorites
      await _firestore.collection('favorite_jokes').add({
        'setup': joke.setup,
        'punchline': joke.punchline,
        'timestamp': FieldValue.serverTimestamp(),
      });
      joke.isFavorite = true;
    }
  }

  Future<List<JokeModel>> _getJokesWithFavoriteStatus(String type) async {
    final jokes = await ApiService.fetchJokesByType(type);
    for (var joke in jokes) {
      joke.isFavorite = await _isJokeFavorite(joke.setup, joke.punchline);
    }
    return jokes;
  }

  @override
  Widget build(BuildContext context) {
    final type = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('$type Jokes')),
      body: FutureBuilder<List<JokeModel>>(
        future: _getJokesWithFavoriteStatus(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final jokes = snapshot.data!;
            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                final joke = jokes[index];
                return Card(
                  child: ListTile(
                    title: Text(joke.setup),
                    subtitle: Text(joke.punchline),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: joke.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () async {
                        await _toggleFavorite(joke);
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
