import 'package:bloc_statemanagement/bloc/bloc_action.dart';
import 'package:bloc_statemanagement/bloc/person.dart';
import 'package:bloc_statemanagement/bloc/person_bloc.dart';
import 'package:bloc_statemanagement/bloc/person_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPerson1 = [Persons("Foo", 12), Persons("nye", 23)];
const mockedPerson2 = [Persons("Foo", 12), Persons("nye", 23)];

Future<Iterable<Persons>> getPerson1MockData(String _) =>
    Future.value(mockedPerson1);

Future<Iterable<Persons>> getPerson2MockData(String _) =>
    Future.value(mockedPerson2);

void main() {
  group("Person Bloc Testing", () {
    late PersonsBloc bloc;

    setUp(() => bloc = PersonsBloc());

    blocTest<PersonsBloc, FetchResult?>("testing init state",
        build: () => bloc,
        verify: (bloc) => expect(
              bloc.state,
              null,
            ));
    blocTest(
      "Mock Retrieve person from mockingperson 1",
      build: () => bloc,
      act: (bloc) {
        bloc.add(
            const LoadPersonAction(loader: getPerson1MockData, url: "url_1"));
        bloc.add(
            const LoadPersonAction(loader: getPerson1MockData, url: "url_1"));
      },
      expect: () =>
          [
            const FetchResult(persons: mockedPerson1, isRetrievedFromCache: false),
            const FetchResult(persons: mockedPerson1, isRetrievedFromCache: true),
          ],
    );
  });
}
