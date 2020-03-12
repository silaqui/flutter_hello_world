import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutterhelloworld/core/util/input_converter.dart';
import 'package:flutterhelloworld/features/number_trivia/domain/usecases/get_concreate_numbeer_trivia.dart';
import 'package:flutterhelloworld/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

import 'package:dartz/dartz.dart';

const String SERVER_FAILURE_MESSAGE = "Server Failure";
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String INVALID_INPUT_MESSAGE =
    "Invalid input - The number must be positive integer or zero";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required concrete,
    @required random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInt(event.numberString);

      yield* inputEither.fold((failure) async* {
        yield Error(message: INVALID_INPUT_MESSAGE);
      }, (integer) {
        throw UnimplementedError();
      });
    }
  }
}
