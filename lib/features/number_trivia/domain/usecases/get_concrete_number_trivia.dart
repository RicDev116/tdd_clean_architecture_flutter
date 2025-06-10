import 'package:dartz/dartz.dart';
import 'package:dtt_clean_architecture/core/error/failure.dart';
import 'package:dtt_clean_architecture/core/usescases/usecase.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:equatable/equatable.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {

  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>?> call(Params params) {
    return repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {

  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];

}