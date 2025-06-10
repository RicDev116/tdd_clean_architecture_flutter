import 'dart:isolate';

import 'package:dartz/dartz.dart';
import 'package:dtt_clean_architecture/core/error/exceptions.dart';

import 'package:dtt_clean_architecture/core/error/failure.dart';
import 'package:dtt_clean_architecture/core/platform/network_info.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';


typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

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
  Future<Either<Failure, NumberTrivia>?> getConcreteNumberTrivia(int number)async {
    return await _getTrivia(
      ()  =>  remoteDataSource.getConcreteNumberTrivia(number),
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async{
    return await _getTrivia(
      ()  =>  remoteDataSource.getRandomNumberTrivia(),
    );
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom ) async{
    if(await networkInfo.isConnected){
      try{
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      }on ServerException{
        return Left(ServerFailure());
      }
    }
    try {
      final localTrivia = await localDataSource.getLastNumberTrivia();
      return Right(localTrivia);
    } on CacheException {
      // If we can't get the last trivia from local, we return a CacheFailure
      return Left(CacheFailure());
    }
  }
  
}