
import 'package:bloc_statemanagement/bloc/person.dart';
import 'package:bloc_statemanagement/bloc/person_bloc.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class FetchResult {
  final Iterable<Persons> persons;
  final bool isRetrievedFromCache;
  final bool isNetworkErr;
  const FetchResult(
      {this.isNetworkErr = false,
      required this.persons,
      required this.isRetrievedFromCache});
  @override
  String toString() =>
      'FetchResult(isRetrievedFromCache = $isRetrievedFromCache, persons = $persons)';

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualToIgnoringOrdering(other.persons) &&
      isRetrievedFromCache == other.isRetrievedFromCache;
      
        @override
        // TODO: implement hashCode
        int get hashCode => Object.hash(persons, isRetrievedFromCache);
      
}
