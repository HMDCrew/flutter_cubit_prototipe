import 'package:equatable/equatable.dart';

abstract class BannerState extends Equatable {
  const BannerState();
}

class Initial extends BannerState {

  const Initial();

  @override
  List<Object> get props => [];
}

class Loading extends BannerState {

  const Loading();

  @override
  List<Object> get props => [];
}

class PageLoaded extends BannerState {
  final List _banners;
  List get banners => _banners;

  const PageLoaded(this._banners);
  
  @override
  List<Object> get props => [_banners];
}

class BannerLoaded extends BannerState {
  final Map<String, dynamic> banner;

  const BannerLoaded(this.banner);

  @override
  List<Object> get props => [banner];
}

class ErrorState extends BannerState {
  final String message;

  const ErrorState(this.message);
  
  @override
  List<Object> get props => [message];
}
