import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'taxonomy_state.dart';

class TaxonomyCubit extends Cubit<TaxonomyState> {
  TaxonomyCubit() : super(TaxonomyInitial());
}
