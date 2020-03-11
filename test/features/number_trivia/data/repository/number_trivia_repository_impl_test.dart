import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterhelloworld/core/error/exception.dart';
import 'package:flutterhelloworld/core/error/failure.dart';
import 'package:flutterhelloworld/core/network/network_info.dart';
import 'package:flutterhelloworld/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutterhelloworld/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutterhelloworld/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutterhelloworld/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutterhelloworld/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body){
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body){
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group("Tests for getConcreteNumberTrivia", () {
    final testNumber = 1;
    final testNumberTriviaModel =
        NumberTriviaModel(number: testNumber, text: "test triva");
    final NumberTrivia testNumberTrivia = testNumberTriviaModel;

    test(
      "should check if device is online",
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        repository.getConcreteNumberTrivia(testNumber);
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline((){
      test(
        "should return remote data when call to remote data sourse is successful",
        () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => testNumberTriviaModel);
          //act
          final result = await repository.getConcreteNumberTrivia(testNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
          expect(result, equals(Right(testNumberTrivia)));
        },
      );

      test(
        "should cache data when call to remote data source is successful",
        () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => testNumberTriviaModel);
          //act
          await repository.getConcreteNumberTrivia(testNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));
        },
      );

      test(
        "should return server failure when call to remote data source is unsucessful",
        () async {
          //arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());
          //act
          final result = await repository.getConcreteNumberTrivia(testNumber);
          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(testNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestOffline((){
      test(
        "should return last localy cached data when cache data is present",
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => testNumberTriviaModel);
          //act
          final result = await repository.getConcreteNumberTrivia(testNumber);
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(testNumberTrivia)));
        },
      );

      test(
        "should return CacheFailure when cache data is not present",
        () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          //act
          final result = await repository.getConcreteNumberTrivia(testNumber);
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group("Tests for getRandomNumberTrivia", () {
    final testNumberTriviaModel =
    NumberTriviaModel(number: 123, text: "test triva");
    final NumberTrivia testNumberTrivia = testNumberTriviaModel;

    test(
      "should check if device is online",
          () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        //act
        repository.getRandomNumberTrivia();
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestOnline((){
      test(
        "should return remote data when call to remote data sourse is successful",
            () async {
          //arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => testNumberTriviaModel);
          //act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(testNumberTrivia)));
        },
      );

      test(
        "should cache data when call to remote data source is successful",
            () async {
          //arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => testNumberTriviaModel);
          //act
          await repository.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));
        },
      );

      test(
        "should return server failure when call to remote data source is unsucessful",
            () async {
          //arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          //act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestOffline((){
      test(
        "should return last localy cached data when cache data is present",
            () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => testNumberTriviaModel);
          //act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(testNumberTrivia)));
        },
      );

      test(
        "should return CacheFailure when cache data is not present",
            () async {
          //arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          //act
          final result = await repository.getRandomNumberTrivia();
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

}
