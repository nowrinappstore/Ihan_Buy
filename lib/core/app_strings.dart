// lib/core/app_strings.dart
class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'IhanBuy';
  static const String appLogoPart1 = 'Ihan';
  static const String appLogoPart2 = 'Buy';
  static const String versionLabel = 'Version 1.0';

  // Common
  static const String cancel = 'Cancel';
  static const String retry = 'Retry';
  static const String search = 'Search';
  static const String next = 'Next';
  static const String submit = 'Submit';
  static const String notAvailable = 'N/A';
  static const String currencySymbol = '\$';

  // Bottom navigation
  static const String navHome = 'Home';
  static const String navCategories = 'Categories';
  static const String navCart = 'Cart';
  static const String navWish = 'Wish';

  // Splash
  // (uses versionLabel)

  // Login
  static const String loginWelcomeBack = 'Welcome Back';
  static const String loginCreateAccount = 'Create Account';
  static const String loginEmailHint = 'Email Address';
  static const String loginPasswordHint = 'Password';
  static const String loginButton = 'Log In';
  static const String loginNoAccount = "Don't have an account? Sign Up";
  static const String loginHaveAccount = 'Already have an account? Log In';
  static const String errorEnterEmailAndPassword = 'Please enter your email and password';
  static const String errorEnterEmailAndPasswordLogin = 'Please Enter Your Email And Password';
  static const String errorEnterEmailAndChoosePassword =
      'Please Enter Your Email And Choose A Password';

  // Complete profile
  static const String completeProfileTitle = 'Complete Profile';
  static const String completeProfileSubtitle = 'Get started with us with your details';
  static const String firstNameHint = 'First Name';
  static const String lastNameHint = 'Last Name';
  static const String mobileHint = 'Mobile';
  static const String cityHint = 'City';
  static const String shippingAddressHint = 'Shipping Address';
  static const String completeButton = 'Complete';
  static const String errorEnterFirstLastName = 'Please enter your first and last name';

  // OTP
  static const String otpTitle = 'Enter OTP Code';
  static const String otpSubtitle = 'A 4 Digit OTP Code has been Sent';
  static const String otpResend = 'Resend Code';
  static const String errorEnterFullOtpCode = 'Please enter the full 4-digit code';
  static String otpExpiresIn(int seconds) => 'This code will expire in $seconds s';

  // Home
  static const String logOut = 'Log Out';
  static const String logOutConfirm = 'Are you sure you want to log out?';
  static const String promoBannerText = 'Happy New Year\nSpecial Deal\nSave 30%';
  static const String buyNow = 'Buy Now';
  static const String allCategories = 'All Categories';
  static const String seeAll = 'See All';
  static const String popularSection = 'Popular';
  static const String specialSection = 'Special';
  static const String newSection = 'New';

  // Categories
  static const String categoriesTitle = 'Categories';
  static const String allProductsTitle = 'All Products';

  // Cart
  static const String cartTitle = 'Cart';
  static const String cartEmpty = 'Your cart is empty';
  static String cartItemColorSize(String color, String size) => 'Color: $color, Size: $size';
  static const String orderPlacedSuccessfully = 'Order placed successfully';
  static const String checkout = 'Checkout';
  static const String errorFillShippingDetails = 'Please fill in all shipping details';
  static const String shippingDetailsTitle = 'Shipping Details';
  static const String fullNameHint = 'Full Name';
  static const String phoneHint = 'Phone';
  static const String addressHint = 'Address';
  static const String postalCodeHint = 'Postal Code';
  static const String placeOrderCod = 'Place Order (COD)';

  // Wishlist
  static const String wishlistTitle = 'Wish List';
  static const String wishlistEmpty = 'No items in your wish list';

  // Product details
  static const String productDetailsTitle = 'Product Details';
  static const String colorLabel = 'Color';
  static const String sizeLabel = 'Size';
  static const String descriptionLabel = 'Description';
  static const String addedToCart = 'Added to cart';
  static const String addToCart = 'Add To Cart';

  // Reviews
  static const String reviewsTitle = 'Reviews';
  static String reviewsCount(int count) => 'Reviews ($count)';
  static const String writeReviewHint = 'Write Review';
  static const String createReviewTitle = 'Create Review';
  static const String errorFillNameAndReview = 'Please fill in your name and review';
  static const String reviewSubmitted = 'Review submitted';

  // Controller error messages
  static const String errorCouldNotLogIn = 'Could not log in. Please try again.';
  static const String errorCouldNotSignUp = 'Could not sign up. Please try again.';
  static const String errorCouldNotSendCode = 'Could not send the code. Please try again.';
  static const String errorIncorrectCode = 'Incorrect code. Please try again.';
  static const String errorCouldNotVerifyCode = 'Could not verify the code. Please try again.';
  static const String errorCouldNotAddToCart =
      'Could not add this item to your cart. Please try again.';
  static const String errorCouldNotRemoveItem = 'Could not remove this item. Please try again.';
  static const String errorCouldNotUpdateQuantity =
      'Could not update the quantity. Please try again.';
  static const String errorCouldNotPlaceOrder = 'Could not place your order. Please try again.';
  static const String errorCouldNotLoadProducts = 'Could not load products. Please try again.';
}
