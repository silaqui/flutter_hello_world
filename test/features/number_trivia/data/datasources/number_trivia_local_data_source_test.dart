import 'dart:convert';

import 'package:flutterhelloworld/core/error/exception.dart';
import 'package:flutterhelloworld/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutterhelloworld/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group("getLastNumberTrivia", () {
    final testTriviaNumberModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
        "should return NumberTrivia from SharedPreferences when there is one in the cache",
        () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));
      //act
      final result = await dataSource.getLastNumberTrivia();
      //assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, testTriviaNumberModel);
    });

    test(
        "should return CacheException from SharedPreferences when there is no trivia in cache",
        () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = dataSource.getLastNumberTrivia;
      //assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("cacheNumberTrivia", () {
    final testNumberTriviaModel =
        NumberTriviaModel(number: 1, text: "Test test");

    test("should call SharedPreferences to cache the data", () async {
      //arrange
      final expectedJsonString = json.encode(testNumberTriviaModel);
      //act
      dataSource.cacheNumberTrivia(testNumberTriviaModel);
      //assert
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
