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
  final List prods;
  final int page;
  List get products => prods;

  const ShopLoaded({required this.prods, required this.page});

  @override
  List<Object> get props => [page, prods];
}

class ErrorShop extends ShopState {
  final String message;

  const ErrorShop(this.message);

  @override
  List<Object> get props => [message];
}
