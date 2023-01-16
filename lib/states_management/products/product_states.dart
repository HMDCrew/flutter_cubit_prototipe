import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();
}

class Initial extends ProductState {

  const Initial();

  @override
  List<Object> get props => [];
}

class Loading extends ProductState {

  const Loading();

  @override
  List<Object> get props => [];
}

class PageLoaded extends ProductState {
  final List _page;
  List get products => _page;

  const PageLoaded(this._page);
  
  @override
  List<Object> get props => [_page];
}

class ProductLoaded extends ProductState {
  final Map<String, dynamic> product;

  const ProductLoaded(this.product);

  @override
  List<Object> get props => [product];
}

// class MenuLoaded extends ProductState {
//   final List<Menu> menu;

//   const MenuLoaded(this.menu);
  
//   @override
//   List<Object> get props => [menu];
// }

class ErrorState extends ProductState {
  final String message;

  const ErrorState(this.message);
  
  @override
  List<Object> get props => [message];
}
