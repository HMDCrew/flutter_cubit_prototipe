import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products/products.dart';

import 'product_states.dart' as product_states;

class ProductCubit extends Cubit<product_states.ProductState> {
  final ProductsApi _api;
  final int _pageSize;

  ProductCubit(this._api, {int defaultPageSize = 10})
      : _pageSize = defaultPageSize,
        super(const product_states.Initial());

  void getProducts({required int page}) async {
    _startLoading();
    final pageResult = await _api.getAllProducts(
      page: page,
      pageSize: _pageSize,
    );

    pageResult.isError || pageResult.asValue == null || pageResult.asValue!.value.isEmpty
         ? _showError('no products found')
         : _setPageData(pageResult.asValue!.value);
  }

  void search(int page, String query) async {
    _startLoading();

    final searchResults = await _api.findProducts(
      page: page,
      pageSize: _pageSize,
      searchTerm: query,
    );

    searchResults.isError || searchResults.asValue == null || searchResults.asValue!.value.isEmpty
         ? _showError('no products found')
         : _setPageData(searchResults.asValue!.value);
  }

  void getProduct(String id) async {
    _startLoading();

    final product = await _api.getProduct(productId: id);

    product.isError || product.asValue == null || product.asValue!.value.isEmpty
        ? _showError('no product found')
        : emit(product_states.ProductLoaded(product.asValue!.value));
  }

  void _startLoading() {
    try {
      emit(const product_states.Loading());
    } catch (error) {
      print(error);
      print('_startLoading');
    }
  }

  void _setPageData(List result) {
    try {
      emit(product_states.PageLoaded(result));
    } catch (error) {
      print(error);
      print('_setPageData');
    }
  }

  void _showError(String error) {
    try {
      emit(product_states.ErrorState(error));
    } catch (error) {
      print(error);
      print('_showError');
    }
  }
}
