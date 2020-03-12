import 'package:dartz/dartz.dart';
import 'package:flutterhelloworld/core/error/failure.dart';
import 'package:flutterhelloworld/core/usecases/usecase.dart';
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

    setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInt(any))
            .thenReturn(Right(testNumberParsed));

    test(
        "should call InputConverter to validate and convert string to unsigned int",
        () async {
      //arrange
      setUpMockInputConverterSuccess();
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

    test("should get data from the concrete use case", () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(testNumberTrivia));
      //act
      bloc.dispatch(GetTriviaForConcreteNumber(testNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: testNumberParsed)));
    });

    test("should emit [Loading, Loaded] when data is gather successfuly", () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(testNumberTrivia));
      // assert
      final expected = [Empty(), Loading(), Loaded(trivia: testNumberTrivia)];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.dispatch(GetTriviaForConcreteNumber(testNumberString));
    });

    test("should emit [Loading, Error] when data is gather failed", () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert
      final expected = [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.dispatch(GetTriviaForConcreteNumber(testNumberString));
    });

    test('''should emit [Loading, Error] with proper message
         for the error when gettijg data fial''', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert
      final expected = [Empty(), Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.dispatch(GetTriviaForConcreteNumber(testNumberString));
    });
  });

  group('Get trivia for random number', () {
    final testNumberTrivia = NumberTrivia(number: 1, text: "Test trivia");

    test("should get data from the random use case", () async {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(testNumberTrivia));
      //act
      bloc.dispatch(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test("should emit [Loading, Loaded] when data is gather successfuly", () async {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(testNumberTrivia));
      // assert
      final expected = [Empty(), Loading(), Loaded(trivia: testNumberTrivia)];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test("should emit [Loading, Error] when data is gather failed", () async {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert
      final expected = [Empty(), Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test('''should emit [Loading, Error] with proper message
         for the error when gettijg data fial''', () async {
      //arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert
      final expected = [Empty(), Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.dispatch(GetTriviaForRandomNumber());
    });
  });
}
