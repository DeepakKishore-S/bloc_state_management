import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc_action.dart';
import 'bloc/person.dart';
import 'bloc/person_bloc.dart';
import 'bloc/person_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
          create: (_) => PersonsBloc(),
          child: const MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              // if (await checkInternetConnection()) {
              context.read<PersonsBloc>().add(
                    const LoadPersonAction(url: person1Url, loader: getPersons),
                  );
              // } else {
              //   context.read<PersonsBloc>().add(NetworkErrorAction());
              // }
            },
            child: const Text(
              "Load json #1",
            ),
          ),
          TextButton(
            onPressed: () async {
              // if (await checkInternetConnection()) {
                context
                    .read<PersonsBloc>()
                    .add(const LoadPersonAction(url: person2Url, loader: getPersons));
              // } else {
              //   context.read<PersonsBloc>().add(NetworkErrorAction());
              // }
            },
            child: const Text(
              "Load json #2",
            ),
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
            buildWhen: (previousResult, currentResult) {
              return previousResult?.persons != currentResult?.persons;
            },
            builder: (context, fetchResult) {
              final persons = fetchResult?.persons;
              if (persons == null) {
                return const SizedBox();
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${fetchResult!.isRetrievedFromCache}"),
                  fetchResult.isNetworkErr
                      ? const Text("Network Error")
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: persons.length,
                          itemBuilder: (context, index) {
                            final person = persons[index]!;

                            return ListTile(title: Text(person.name));
                          },
                        ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}



extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

Future<Iterable<Persons>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Persons.fromJson(e)));
