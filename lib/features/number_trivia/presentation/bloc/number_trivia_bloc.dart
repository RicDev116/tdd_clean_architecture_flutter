import 'package:bloc/bloc.dart';
import 'package:dtt_clean_architecture/core/presentation/util/input_converter.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';


const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid input - the number must be a positive number or zero.';


class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter converter;

  NumberTriviaBloc({
    required this.concrete,
    required this.random,
    required this.converter,
  }) : super(Empty()) {
    on<NumberTriviaEvent>(_mapEventToState);
  }

  Future<void> _mapEventToState(
    NumberTriviaEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither = converter.stringToUnsignedInteger(event.numberString);
      inputEither.fold(
        (failure) => emit(Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE)),
        (integer) {
          // emit()
        },
      );
    }
  }
}
