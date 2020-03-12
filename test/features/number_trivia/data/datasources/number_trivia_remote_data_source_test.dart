import 'dart:convert';

import 'package:flutterhelloworld/core/error/exception.dart';
import 'package:flutterhelloworld/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutterhelloworld/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/reader.dart';

import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(mockHttpClient);
  });

  void setUpMockHttpSuccess200(){
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));
  }

  void setUpMockHttpError404(){
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response("Something went wrong", 404));
  }

  group("getConcreteNumberTrivia", () {
    final testNumber = 1;
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));

    test('''should get preforme GET request at URL with number 
            being the endpoint and with application/json header''', () async {
      //arrange
      setUpMockHttpSuccess200();
      //act
      dataSource.getConcreteNumberTrivia(testNumber);
      //assert
      verify(mockHttpClient.get(
        'http://numbersapi.com/$testNumber',
        headers: {'Content-type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when return code is 200', () async {
      //arrange
      setUpMockHttpSuccess200();
      //act
      final result = await dataSource.getConcreteNumberTrivia(testNumber);
      //assert
      expect(result, equals(testNumberTriviaModel));
    });

    test('should throw ServerException when return code is not 200', () async {
      //arrange
      setUpMockHttpError404();
      //act
      final call = dataSource.getConcreteNumberTrivia;
      //assert
      expect(()=>call(testNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group("getRandomNumberTrivia", () {
    final testNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));

    test('''should get preforme GET request at URL with number 
            being the endpoint and with application/json header''', () async {
      //arrange
      setUpMockHttpSuccess200();
      //act
      dataSource.getRandomNumberTrivia();
      //assert
      verify(mockHttpClient.get(
        'http://numbersapi.com/random',
        headers: {'Content-type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when return code is 200', () async {
      //arrange
      setUpMockHttpSuccess200();
      //act
      final result = await dataSource.getRandomNumberTrivia();
      //assert
      expect(result, equals(testNumberTriviaModel));
    });

    test('should throw ServerException when return code is not 200', () async {
      //arrange
      setUpMockHttpError404();
      //act
      final call = dataSource.getRandomNumberTrivia;
      //assert
      expect(()=>call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
