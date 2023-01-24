import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:custom_posts/custom_posts.dart';

part 'banners_state.dart';

class BannersCubit extends Cubit<BannersState> {
  final PostsApi _api;
  final int pageSize;

  BannersCubit(this._api, {this.pageSize = 10})
      : super(const BannersLoading());

  void getBanners({required int page, String includeMetas = ''}) async {
    final pageResult = await _api.getAllPosts(
      page: page,
      pageSize: pageSize,
      includeMetas: includeMetas,
    );

    pageResult.isError ||
            pageResult.asValue == null ||
            pageResult.asValue!.value.isEmpty
        ? showError('banners not found')
        : setPageData(pageResult.asValue!.value);
  }

  void setPageData(List result) {
    emit(BannersLoaded(result));
  }

  void showError(String error) {
    emit(ErrorBanners(error));
  }
}
