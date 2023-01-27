import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:custom_posts/custom_posts.dart';

import '../cache/local_store.dart';

part 'banners_state.dart';

class BannersCubit extends Cubit<BannersState> {
  final PostsApi _api;
  final int pageSize;
  final LocalStore localStore;

  BannersCubit(this._api, this.localStore, {this.pageSize = 10})
      : super(const BannersLoading());

  void getBanners({required int page, String includeMetas = ''}) async {
    // Load cached information
    String cachedBanners = localStore.getData('banners');
    if (cachedBanners.isNotEmpty) {
      final List cacheResult = json.decode(cachedBanners);
      setPageData(cacheResult);
    }

    final pageResult = await _api.getAllPosts(
      page: page,
      pageSize: pageSize,
      includeMetas: includeMetas,
    );

    if (pageResult.isError ||
        pageResult.asValue == null ||
        pageResult.asValue!.value.isEmpty) {
      showError('banners not found');
    } else {
      // Update information on cache
      final List result = pageResult.asValue!.value;
      localStore.setData('banners', result);

      // information is emitted but widouth
      // changes context is not rebuilded
      setPageData(result);
    }
  }

  void setPageData(List result) {
    emit(BannersLoaded(result));
  }

  void showError(String error) {
    emit(ErrorBanners(error));
  }
}
