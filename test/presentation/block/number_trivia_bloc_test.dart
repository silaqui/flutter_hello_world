import 'package:dartz/dartz.dart';
import 'package:flutterhelloworld/core/util/input_converter.dart';
import 'package:flutterhelloworld/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutterhelloworld/features/number_trivia/domain/usecases/get_concreate_numbeer_trivia.dart';
import 'package:flutterhelloworld/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutterhelloworld/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('Initail state should be Empty', () {
    //assert
    expect(bloc.initialState, Empty());
  });

  group('Get trivia for concreate number', () {
    final testNumberString = '1';
    final testNumberParsed = 1;
    final testNumberTrivia = NumberTrivia(number: 1, text: "Test trivia");

    test(
        "should call InputConverter to validate and convert string to unsigned int",
        () async {
      //arrange
      when(mockInputConverter.stringToUnsignedInt(any))
          .thenReturn(Right(testNumberParsed));
      //act
      bloc.dispatch(GetTriviaForConcreteNumber(testNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInt(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInt(testNumberString));
    });

    test("should emit [Error] when input is invelid", () async {
      //arrange
      when(mockInputConverter.stringToUnsignedInt(any))
          .thenReturn(Left(InvalidInputFailure()));
      // assert
      final expected = [Empty(), Error(message: INVALID_INPUT_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.dispatch(GetTriviaForConcreteNumber(testNumberString));
    });
  });
}
