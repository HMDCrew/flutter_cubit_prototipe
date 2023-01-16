import 'package:bloc/bloc.dart';

import '../../modules/Header.dart';

class HeaderCubit extends Cubit<Header> {
  HeaderCubit() : super(Header('', ''));

  update(String title, String? imageUrl) => emit(Header(title, imageUrl));
}
