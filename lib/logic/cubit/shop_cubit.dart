import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:products/products.dart';

part 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  final ProductsApi _api;
  final int pageSize;
  ShopCubit(this._api, {this.pageSize = 10}) : super(const ShopLoading());

  void getProducts({required int page}) async {
    final pageResult = await _api.getAllProducts(
      page: page,
      pageSize: pageSize,
    );

    pageResult.isError ||
            pageResult.asValue == null ||
            pageResult.asValue!.value.isEmpty
        ? showError('no products found')
        : setPageData(pageResult.asValue!.value);
  }

  void search(int page, String query) async {
    final searchResults = await _api.findProducts(
      page: page,
      pageSize: pageSize,
      searchTerm: query,
    );

    searchResults.isError ||
            searchResults.asValue == null ||
            searchResults.asValue!.value.isEmpty
        ? showError('no products found')
        : setPageData(searchResults.asValue!.value);
  }

  void getProduct(String id) async {
    final product = await _api.getProduct(productId: id);

    product.isError || product.asValue == null || product.asValue!.value.isEmpty
        ? showError('no product found')
        : emit(ProductLoaded(product.asValue!.value));
  }

  void setPageData(List result) {
    emit(ShopLoaded(result));
  }

  void showError(String error) {
    emit(ErrorShop(error));
  }
}
