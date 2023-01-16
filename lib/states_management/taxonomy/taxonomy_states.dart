import 'package:equatable/equatable.dart';

abstract class TaxonomyState extends Equatable {
  const TaxonomyState();
}

class Initial extends TaxonomyState {

  const Initial();

  @override
  List<Object> get props => [];
}

class Loading extends TaxonomyState {

  const Loading();

  @override
  List<Object> get props => [];
}

class PageLoaded extends TaxonomyState {
  final List _page;
  List get products => _page;

  const PageLoaded(this._page);
  
  @override
  List<Object> get props => [_page];
}

class TaxonomyLoaded extends TaxonomyState {
  final Map<String, dynamic> taxonomy;

  const TaxonomyLoaded(this.taxonomy);

  @override
  List<Object> get props => [taxonomy];
}

class ErrorState extends TaxonomyState {
  final String message;

  const ErrorState(this.message);
  
  @override
  List<Object> get props => [message];
}
