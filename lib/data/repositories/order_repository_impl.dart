import '../../domain/repositories/order_repository.dart';
import '../datasources/order_api_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderApiDataSource _dataSource;

  OrderRepositoryImpl(this._dataSource);

  @override
  Future<void> createOrder({
    required String paymentMethod,
    required Map<String, dynamic> shippingAddress,
  }) {
    return _dataSource.createOrder(paymentMethod: paymentMethod, shippingAddress: shippingAddress);
  }
}
