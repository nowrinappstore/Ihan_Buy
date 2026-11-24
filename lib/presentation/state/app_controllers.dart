// lib/presentation/state/app_controllers.dart
// Composition root: wires services into controllers as global singletons,
// mirroring the previous manual-DI setup without a dedicated di/ folder.
import '../../data/service/auth_service.dart';
import '../../data/service/brand_service.dart';
import '../../data/service/cache/cache_service.dart';
import '../../data/service/cart_service.dart';
import '../../data/service/category_service.dart';
import '../../data/service/network/http_client.dart';
import '../../data/service/product_service.dart';
import '../../data/service/slide_service.dart';
import '../../data/service/wishlist_service.dart';
import 'auth_controller.dart';
import 'cart_controller.dart';
import 'products_controller.dart';
import 'reviews_controller.dart';

final HttpClient httpClient = HttpClient();
final CacheService cacheService = CacheService();

final AuthService authService = AuthService(httpClient, cacheService);
final CartService cartService = CartService(httpClient);
final CategoryService categoryService = CategoryService(httpClient);
final ProductService productService = ProductService(httpClient);
final WishlistService wishlistService = WishlistService();
final BrandService brandService = BrandService();
final SlideService slideService = SlideService();

final AuthController authController = AuthController(authService);
final CartController cartController = CartController(cartService, wishlistService);
final ProductsController productsController = ProductsController(productService, categoryService);
final ReviewsController reviewsController = ReviewsController(productService);
