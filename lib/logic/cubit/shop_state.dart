part of 'shop_cubit.dart';

abstract class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object> get props => [];
}

class ShopLoading extends ShopState {
  const ShopLoading();

  @override
  List<Object> get props => [];  
}

class ShopLoaded extends ShopState {
  List _products;
  List get products => _products;

  ShopLoaded(this._products);
  
  @override
  List<Object> get props => [_products];

  void update(List newProducts) => _products = newProducts;
}

class ProductLoaded extends ShopState {
  final Map<String, dynamic> _product;
  Map<String, dynamic> get product => _product;

  const ProductLoaded(this._product);
  
  @override
  List<Object> get props => [_product];
}

class ErrorShop extends ShopState {
  final String message;

  const ErrorShop(this.message);
  
  @override
  List<Object> get props => [message];
}