import 'package:custom_posts/custom_posts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'banners_state.dart' as banner_state;

class BannerCubit extends Cubit<banner_state.BannerState> {
  final PostsApi _api;
  final int _pageSize;

  BannerCubit(this._api, {int defaultPageSize = 10})
      : _pageSize = defaultPageSize,
        super(const banner_state.Initial());

  void getBanners({required int page, String includeMetas = 'banner_text, color_title, click_through_url'}) async {
    _startLoading();
    final pageResult = await _api.getAllPosts(
      page: page,
      pageSize: _pageSize,
      includeMetas: includeMetas,
    );

    pageResult.isError || pageResult.asValue == null || pageResult.asValue!.value.isEmpty
         ? _showError('banners not found')
         : _setPageData(pageResult.asValue!.value);
  }

  void search(int page, String query, {String includeMetas = 'banner_text, color_title, click_through_url'}) async {
    _startLoading();

    final searchResults = await _api.findPosts(
      page: page,
      pageSize: _pageSize,
      searchTerm: query,
      includeMetas: includeMetas
    );

    searchResults.isError || searchResults.asValue == null || searchResults.asValue!.value.isEmpty
         ? _showError('banners not found')
         : _setPageData(searchResults.asValue!.value);
  }

  void getBanner(String id) async {
    _startLoading();

    final banner = await _api.getPost(postId: id);

    banner.isError || banner.asValue == null || banner.asValue!.value.isEmpty
        ? _showError('banner not found')
        : emit(banner_state.BannerLoaded(banner.asValue!.value));
  }

  void _startLoading() {
    try {
      emit(const banner_state.Loading());
    } catch (error) {
      print(error);
      print('_startLoading');
    }
  }

  void _setPageData(List result) {
    try {
      emit(banner_state.PageLoaded(result));
    } catch (error) {
      print(error);
      print('_setPageData');
    }
  }

  void _showError(String error) {
    try {
      emit(banner_state.ErrorState(error));
    } catch (error) {
      print(error);
      print('_showError');
    }
  }
}
