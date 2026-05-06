import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/search_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository repository;
  SearchCubit(this.repository) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final results = await repository.searchProducts(query);
      if (results.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchSuccess(products: results));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
