import '../../data/datasources/auth_api_data_source.dart';
import '../../data/datasources/cart_api_data_source.dart';
import '../../data/datasources/order_api_data_source.dart';
import '../../data/datasources/product_api_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/checkout.dart';
import '../../domain/usecases/create_review.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/signup.dart';
import '../../domain/usecases/toggle_wishlist.dart';
import '../../domain/usecases/update_cart_quantity.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../presentation/state/auth_controller.dart';
import '../../presentation/state/cart_controller.dart';
import '../../presentation/state/products_controller.dart';
import '../../presentation/state/reviews_controller.dart';
import '../network/api_client.dart';
import '../storage/auth_local_storage.dart';

final ApiClient apiClient = ApiClient();
final AuthLocalStorage authLocalStorage = AuthLocalStorage();

final ProductRepository productRepository = ProductRepositoryImpl(ProductApiDataSource(apiClient));
final CartRepository cartRepository = CartRepositoryImpl(CartApiDataSource(apiClient));
final OrderRepository orderRepository = OrderRepositoryImpl(OrderApiDataSource(apiClient));
final AuthRepository authRepository = AuthRepositoryImpl(
  AuthApiDataSource(apiClient),
  apiClient,
  authLocalStorage,
);

final CartController cartController = CartController(
  repository: cartRepository,
  addToCart: AddToCart(cartRepository),
  removeFromCart: RemoveFromCart(cartRepository),
  updateCartQuantity: UpdateCartQuantity(cartRepository),
  toggleWishlist: ToggleWishlist(cartRepository),
  checkout: Checkout(cartRepository, orderRepository),
);

final AuthController authController = AuthController(
  repository: authRepository,
  login: Login(authRepository),
  signup: Signup(authRepository),
  sendOtp: SendOtp(authRepository),
  verifyOtp: VerifyOtp(authRepository),
);

final ProductsController productsController = ProductsController(repository: productRepository);

final ReviewsController reviewsController = ReviewsController(
  repository: productRepository,
  createReview: CreateReview(productRepository),
);
