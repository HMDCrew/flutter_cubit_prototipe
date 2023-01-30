part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductLoading extends ProductState {
  const ProductLoading();

  @override
  List<Object> get props => [];
}

class ProductLoaded extends ProductState {
  final Map<String, dynamic> prod;
  final int id;
  Map<String, dynamic> get product => prod;

  const ProductLoaded(this.id, this.prod);

  @override
  List<Object> get props => [id, prod];
}

class ErrorProduct extends ProductState {
  final String message;

  const ErrorProduct(this.message);

  @override
  List<Object> get props => [message];
}
