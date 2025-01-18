import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke Types'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          IconButton(
            icon: Icon(Icons.lightbulb),
            onPressed: () {
              Navigator.pushNamed(context, '/random');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: ApiService.fetchJokeTypes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final types = snapshot.data!;
            return ListView.builder(
              itemCount: types.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(types[index]),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/jokes_by_type',
                        arguments: types[index],
                      );
                    },
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
