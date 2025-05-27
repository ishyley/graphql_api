import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphqloverlay/services/graphql_queries.dart';
import 'package:graphqloverlay/models/model.dart';
import 'package:graphqloverlay/services/values.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(title: 'GraphqlOverlay', home: CountryLookupScreen()),
    );
  }
}

class CountryLookupScreen extends StatefulWidget {
  const CountryLookupScreen({super.key});

  @override
  _CountryLookupScreenState createState() => _CountryLookupScreenState();
}

class _CountryLookupScreenState extends State<CountryLookupScreen> {
  final TextEditingController _controller = TextEditingController();
  Country? _country;
  // Languages? _languages;
  bool _loading = false;
  String? _error;

  Future<void> fetchCountry(String code, GraphQLClient client) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await client.query(
      QueryOptions(
        document: gql(GraphqlQueries.getCountryQuery),
        variables: {'code': code.toUpperCase()},
      ),
    );

    if (result.hasException) {
      setState(() {
        _loading = false;
        _error = result.exception.toString();
      });
      return;
    }

    final data = result.data?['country'];

    if (data == null) {
      setState(() {
        _loading = false;
        _error = 'Country not found';
      });
      return;
    }

    setState(() {
      _country = Country.fromJson(data);
      //   _languages = Languages.fromJson(datalang);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final client = GraphQLProvider.of(context).value;

    return Scaffold(
      appBar: AppBar(title: Text("Country Lookup")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter Country Code (e.g. US)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                fetchCountry(_controller.text.trim(), client);
              },
              child: Text("Continue"),
            ),
            SizedBox(height: 20),
            if (_loading) CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red)),
            if (_country != null) ...[
              Text(
                "Country: ${_country?.name ?? "Info not currently available"}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Capital: ${_country!.capital}",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Curency: ${_country!.currency}",
                style: TextStyle(fontSize: 16),
              ),
              Text("emoji: ${_country!.emoji}", style: TextStyle(fontSize: 16)),
              Text(
                "native: ${_country!.nativeName}",
                style: TextStyle(fontSize: 16),
              ),
              Text("Languages:", style: TextStyle(fontWeight: FontWeight.bold)),
              ..._country!.languages.map(
                (lang) => Text("${lang.name} (${lang.code})"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
