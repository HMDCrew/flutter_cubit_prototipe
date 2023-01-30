import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:products/products.dart';

import '../cache/local_store.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductsApi _api;
  final LocalStore localStore;

  ProductCubit(this._api, this.localStore) : super(const ProductLoading());

  void getProduct(String id) async {
    final product = await _api.getProduct(productId: id);

    product.isError || product.asValue == null || product.asValue!.value.isEmpty
        ? showError('no product found')
        : setPageData(product.asValue!.value);
  }

  void setPageData(Map<String, dynamic> result) {
    emit(ProductLoaded(result['id'], result));
  }

  void showError(String error) {
    emit(ErrorProduct(error));
  }
}
