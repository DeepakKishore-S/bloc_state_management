
import 'package:bloc_statemanagement/bloc/person.dart';
import 'package:bloc_statemanagement/bloc/person_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_action.dart';

extension IsEqualToIgnoringOrdering<T> on Iterable {
  bool isEqualToIgnoringOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Persons>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonAction>((event, emit) async {
        final url = event.url;
        if (_cache.containsKey(url)) {
          final cachedPersons = _cache[url]!;
          final result =
              FetchResult(persons: cachedPersons, isRetrievedFromCache: true);
          emit(result);
        } else {
          final loader = event.loader;
          final persons = await loader(url);
          _cache[url] = persons;
          final result =
              FetchResult(persons: persons, isRetrievedFromCache: false);
          emit(result);
        }
    });

    on<NetworkErrorAction>(
      (event, emit) {
        emit(const FetchResult(
            persons: [], isRetrievedFromCache: false, isNetworkErr: true));
      },
    );
  }
}
