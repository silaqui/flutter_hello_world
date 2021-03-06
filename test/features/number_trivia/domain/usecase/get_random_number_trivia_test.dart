import 'package:dartz/dartz.dart';
import 'package:flutterhelloworld/core/usecases/usecase.dart';
import 'package:flutterhelloworld/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutterhelloworld/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutterhelloworld/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final testNumberTrivia = NumberTrivia(number: 1, text: "test");

  test(
    'should get trivia from the repository',
    () async {
      //arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(testNumberTrivia));
      //act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(testNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
