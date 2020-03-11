import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutterhelloworld/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutterhelloworld/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/reader.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaModel(
      number: 1, text: "1e+40 is ...");

  test(
    'should be a subclass of NumberTrivia entity',
        () async {
      //assert
      expect(testNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
          () async {
        //arrange
        final Map<String, dynamic> jsonMap =
        json.decode(fixture("trivia.json"));
        //act
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        expect(result, testNumberTriviaModel);
      },
    );

    test(
      'should return a valid model when the JSON number is regarded as a double',
          () async {
        //arrange
        final Map<String, dynamic> jsonMap =
        json.decode(fixture("trivia_double.json"));
        //act
        final result = NumberTriviaModel.fromJson(jsonMap);
        //assert
        expect(result, testNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should retrun a JSON map with proper data',
          () async {
        //arrange
        final expectedMap = {
          "text": "1e+40 is ...",
          "number": 1
        };
        //act
        final result = testNumberTriviaModel.toJson();
        //assert
        expect(result, expectedMap);
      },
    );
  });
}
