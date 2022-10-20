class Api {
  static String productApi = 'http://127.0.0.1:8000/api/v1/latest-products/';
  // We need to append it with category and product slugs
  static String productDetailApi = 'http://127.0.0.1:8000/api/v1/products/';

  static String categoryApi = 'http://127.0.0.1:8000/api/v1/categories/';
  // We need to append it with category slugs
  static String categoryDetails = 'http://127.0.0.1:8000/api/v1/products/';

  // Search product category
  static String searchProduct = 'http://127.0.0.1:8000/api/v1/products/search/';
}
