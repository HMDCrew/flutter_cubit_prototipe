import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxonomy/taxonomy.dart';

import 'taxonomy_states.dart' as taxonomy_state;

class TaxonomyCubit extends Cubit<taxonomy_state.TaxonomyState> {
  final TaxonomyApi _api;

  TaxonomyCubit(this._api) : super(const taxonomy_state.Initial());

  void getTaxonomyMenu({required String taxonomySlug, int hideEmpty = 1 }) async {
    _startLoading();
    final pageResult = await _api.getTaxonomy(taxonomy_slug: taxonomySlug, hide_empty: hideEmpty);

    pageResult.isError || pageResult.asValue == null || pageResult.asValue!.value.isEmpty
         ? _showError('taxonomy not found')
         : _setPageData(pageResult.asValue!.value);
  }

  void _startLoading() {
    try {
      emit(const taxonomy_state.Loading());
    } catch (error) {
      print(error);
      print('_startLoading');
    }
  }

  void _setPageData(List result) {
    try {
      emit(taxonomy_state.PageLoaded(result));
    } catch (error) {
      print(error);
      print('_setPageData');
    }
  }

  void _showError(String error) {
    try {
      emit(taxonomy_state.ErrorState(error));
    } catch (error) {
      print(error);
      print('_showError');
    }
  }
}
