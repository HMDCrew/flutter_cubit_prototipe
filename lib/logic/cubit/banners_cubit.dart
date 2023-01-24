import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'banners_state.dart';

class BannersCubit extends Cubit<BannersState> {
  BannersCubit() : super(BannersInitial());
}
