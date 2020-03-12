import 'dart:convert';

import 'package:flutterhelloworld/core/error/exception.dart';
import 'package:flutterhelloworld/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutterhelloworld/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl(this.client);

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) async {
    return _getTriviaFromUrl("http://numbersapi.com/$number");
  }

  @override
  Future<NumberTrivia> getRandomNumberTrivia() async {
    return _getTriviaFromUrl("http://numbersapi.com/random");
  }

  Future<NumberTrivia> _getTriviaFromUrl(String URL) async {
    final response = await client.get(
      URL,
      headers: {'Content-type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
