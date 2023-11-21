import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba/Model/team.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Team> teams = [];
  late Future<List<Team>> futureTeams;

  // get teams
  Future getTeams() async {
    var response = await http.get(
      Uri.https('balldontlie.io', 'api/v1/teams'),
    );

    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData['data']) {
      final team = Team(
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
      );

      teams.add(team);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NBA'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.separated(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: ListTile(
                    leading: const Icon(Icons.group),
                    title: Text(teams[index].abbreviation),
                    subtitle: Text(teams[index].city),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    //contentPadding: const EdgeInsets.all(8),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.white,
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
