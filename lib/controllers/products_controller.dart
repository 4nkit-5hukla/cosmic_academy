import 'package:get/get.dart';
import 'package:cosmic_assessments/models/products/product.dart';

class ProductsController extends GetxController {
  List<Product> productsData = [];
  List<Product> cartData = List<Product>.empty().obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  addToCart(Product item) {
    cartData.add(item);
  }

  removeFromCart(Product item) {
    cartData.remove(item);
  }

  double get totalPrice => cartData.fold(0, (sum, item) => sum + item.price);
  int get cartCount => cartData.length;

  fetchProducts() async {
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
    );

    List<Product> serverRes = [
      Product(
        id: 1,
        title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        price: 109.95,
        description:
            "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
        image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
        favorite: false,
      ),
      Product(
        id: 2,
        title: "Mens Casual Premium Slim Fit T-Shirts",
        price: 22.3,
        description:
            "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.",
        image:
            "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
        favorite: true,
      ),
    ];

    productsData.assignAll(serverRes);
    update();
  }

  addToFavorites(id) {
    int index = productsData.indexWhere((element) => element.id == id);
    productsData[index].favorite = !productsData[index].favorite;
    update();
  }
}
