class AppConstants {
  //The free API was used in the released version =>
  static const String BASE_URL ="https://ghargrocer.com/api";

  // Using the search endpoint which is more reliable
  // static const String BASE_URL = "https://world.openfoodfacts.org/cgi/search.pl";
  static const String API_KEY = "YOUR_API_KEY"; //IF_EXIST
  static const String projectOwnerName = "Rami Omar";
  static const String baseUrl = 'https://ghargrocer.com/api/customer';
  static const String sendOtpEndpoint = '/send_otp';
  static const String authToken = 'Bearer HenilCode'; // Replace with your actual token if it changes
  static const String verifyOtpEndpoint = '/verify_otp';
  static const String fetchAllProdList = '/product';
  static const String fetchAllCategoryList = '/category';
}
