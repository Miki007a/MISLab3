import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/joke_model.dart';

class FavoriteJokesScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print('Building FavoriteJokesScreen');
    return Scaffold(
      appBar: AppBar(
        title: Text('Омилени шеги'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('favorite_jokes').snapshots(),
        builder: (context, snapshot) {
          print('StreamBuilder state: ${snapshot.connectionState}');
          if (snapshot.hasError) {
            print('StreamBuilder error: ${snapshot.error}');
          }
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Грешка: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Немате омилени шеги'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              
              return Card(
                child: ListTile(
                  title: Text(data['setup']),
                  subtitle: Text(data['punchline']),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () async {
                      await doc.reference.delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 