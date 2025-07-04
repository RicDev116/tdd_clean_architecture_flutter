import 'package:dartz/dartz.dart';
import 'package:dtt_clean_architecture/core/error/failure.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>?> call(Params params);
}

class NoParams extends Equatable{
  const NoParams();

  @override
  List<Object?> get props => [];
}