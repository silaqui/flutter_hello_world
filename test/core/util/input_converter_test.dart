import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterhelloworld/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("stringToUnsignedInt", () {
    test("should return int when String represents unsigned int", () async {
      //arrange
      final str = '123';
      //act
      final result = inputConverter.stringToUnsignedInt(str);
      //assert
      expect(result, Right(123));
    });

    test("should return a Failure when the string is not an integer", () async {
      //arrange
      final str = 'abc';
      //act
      final result = inputConverter.stringToUnsignedInt(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });

    test("should return a Failure when the string is a negative integer", () async {
      //arrange
      final str = '-123';
      //act
      final result = inputConverter.stringToUnsignedInt(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
