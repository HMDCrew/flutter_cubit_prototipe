part of 'banners_cubit.dart';

abstract class BannersState extends Equatable {
  const BannersState();

  @override
  List<Object> get props => [];
}

class BannersLoading extends BannersState {

  const BannersLoading();

  @override
  List<Object> get props => [];
}

class BannersLoaded extends BannersState {
  final List _banners;
  List get banners => _banners;

  const BannersLoaded(this._banners);
  
  @override
  List<Object> get props => [_banners];
}

class ErrorBanners extends BannersState {
  final String message;

  const ErrorBanners(this.message);
  
  @override
  List<Object> get props => [message];
}