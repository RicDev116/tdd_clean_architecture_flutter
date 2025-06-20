import 'package:dtt_clean_architecture/core/network/network_info.dart';
import 'package:dtt_clean_architecture/core/presentation/util/input_converter.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dtt_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final serviceLocator =GetIt.instance;

Future<void> init()async{

  //! Features  - Number Trivia 
  serviceLocator.registerFactory(() => NumberTriviaBloc(
    getConcreteNumberTrivia: serviceLocator(), 
    getRandomNumberTrivia: serviceLocator(), 
    converter: serviceLocator(), 
  ));

  //USE CASES
  serviceLocator.registerLazySingleton(
    () => GetConcreteNumberTrivia( serviceLocator() )
  );
  serviceLocator.registerLazySingleton(
    () => GetRandomNumberTrivia( serviceLocator() )
  );

  //Repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: serviceLocator(), 
      localDataSource: serviceLocator(), 
      networkInfo: serviceLocator()
    )
  );

  // Data sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDatasource>(
    () => NumberTriviaRemoteDataSourceImpl(client: serviceLocator())
  );

  serviceLocator.registerLazySingleton<NumberTriviaLocalDatasource>(
    () => NumberTriviaLocalDatasourceImpl(sharedPreferences: serviceLocator())
  );



  //! Core
  serviceLocator.registerLazySingleton(
    () => InputConverter()
  );

  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: serviceLocator())
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton( ()=> sharedPreferences );
  serviceLocator.registerLazySingleton( ()=> http.Client() );
  serviceLocator.registerLazySingleton( ()=> InternetConnectionChecker);
  
}