import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  // القيمة الابتدائية هي 0 (أي صفحة Home)
  NavigationCubit() : super(0);

  // ميثود لتغيير الصفحة
  void changePage(int index) => emit(index);
}
