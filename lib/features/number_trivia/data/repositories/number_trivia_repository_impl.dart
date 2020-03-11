import 'package:dartz/dartz.dart';
import 'package:flutterhelloworld/core/error/exception.dart';
import 'package:flutterhelloworld/core/error/failure.dart';
import 'package:flutterhelloworld/core/platform/network_info.dart';
import 'package:flutterhelloworld/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutterhelloworld/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutterhelloworld/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutterhelloworld/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

typedef Future<NumberTrivia> _TriviaFunction();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.localDataSource,
    @required this.remoteDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _TriviaFunction getTriviaFunction,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = (await getTriviaFunction());
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final result = await localDataSource.getLastNumberTrivia();
        return Right(result);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
