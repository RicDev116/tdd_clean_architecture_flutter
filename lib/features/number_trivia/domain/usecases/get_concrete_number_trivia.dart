import 'package:dartz/dartz.dart';
import 'package:dtt_clean_architecture/core/error/failure.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia{

  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> execute(int number) {
    return repository.getConcreteNumberTrivia(number);
  }

  
}