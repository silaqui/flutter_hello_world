import 'package:dartz/dartz.dart';
import 'package:flutterhelloworld/core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String str) {
    try {
      final value = int.parse(str);
      if (value < 0) {
        throw FormatException();
      } else {
        return Right(int.parse(str));
      }
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
