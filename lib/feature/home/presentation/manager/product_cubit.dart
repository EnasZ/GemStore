import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/common/entities/product_entity.dart';
import '../../domain/repositories/home_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final HomeRepository repository;

  ProductCubit(this.repository) : super(ProductInitial());

  /// دالة جلب المنتجات مع دعم الفلترة (مثلاً حسب التصنيف أو المنتجات المميزة)
  Future<void> getProducts({Map<String, dynamic>? filters}) async {
    emit(ProductLoading());
    try {
      // نمرر الفلاتر للـ repository إذا كانت موجودة
      final products = await repository.getAllProducts(filters: filters);

      if (products.isEmpty) {
        emit(ProductEmpty()); // حالة إضافية إذا لم توجد نتائج
      } else {
        emit(ProductLoaded(products: products));
      }
    } catch (e) {
      emit(
        ProductError(message: "حدث خطأ أثناء تحميل البيانات: ${e.toString()}"),
      );
    }
  }

  // أضيفي هذه الدالة في ProductCubit
  void resetState() {
    emit(ProductInitial());
  }
}
