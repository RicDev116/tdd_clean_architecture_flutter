import 'package:dartz/dartz.dart';

import 'package:dtt_clean_architecture/core/error/failure.dart';
import 'package:dtt_clean_architecture/core/platform/network_info.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {

  final NumberTriviaRemoteDatasource remoteDataSource;
  final NumberTriviaLocalDatasource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    // TODO: implement getConcreteNumberTrivia
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }

  


}