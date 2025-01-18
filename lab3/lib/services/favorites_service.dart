import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/joke_model.dart';

class FavoritesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'favorite_jokes';

  static Future<List<JokeModel>> getFavoriteJokes() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return JokeModel(
          setup: data['setup'],
          punchline: data['punchline'],
          isFavorite: true,
        );
      }).toList();
    } catch (e) {
      print('Error getting favorite jokes: $e');
      return [];
    }
  }

  static Future<void> toggleFavorite(JokeModel joke) async {
    try {
      final QuerySnapshot existingJokes = await _firestore
          .collection(_collection)
          .where('setup', isEqualTo: joke.setup)
          .where('punchline', isEqualTo: joke.punchline)
          .get();

      if (existingJokes.docs.isNotEmpty) {
        // Remove from favorites
        await _firestore.collection(_collection).doc(existingJokes.docs.first.id).delete();
        joke.isFavorite = false;
      } else {
        // Add to favorites
        await _firestore.collection(_collection).add({
          'setup': joke.setup,
          'punchline': joke.punchline,
          'timestamp': FieldValue.serverTimestamp(),
        });
        joke.isFavorite = true;
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  static Future<bool> isJokeFavorite(String setup, String punchline) async {
    try {
      final QuerySnapshot existingJokes = await _firestore
          .collection(_collection)
          .where('setup', isEqualTo: setup)
          .where('punchline', isEqualTo: punchline)
          .get();
      return existingJokes.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if joke is favorite: $e');
      return false;
    }
  }
} 