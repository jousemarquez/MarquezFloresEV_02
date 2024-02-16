import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:clothing_shop/pages/product_details_page.dart';
import 'package:clothing_shop/widgets/CustomImageWidget.dart';
import 'package:clothing_shop/widgets/ProductCard.dart';
import 'package:http/http.dart' as http;
import 'package:clothing_shop/pages/products_page.dart';

class ProductsManComponent extends StatefulWidget {
  const ProductsManComponent({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductsManComponent> {
  List<Product> _productsElectronic = [];
  List<Product> _productsMensClothing = [];
  final List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchProducts('electronics').then((products) => {
          setState(() {
            _productsElectronic = products;
            _allProducts.addAll(products);
          })
        });
    fetchProducts("men's clothing").then((products) {
      setState(() {
        _productsMensClothing = products;
        _allProducts.addAll(products);
        _filteredProducts = _allProducts;
      });
    });
  }

  Future<List<Product>> fetchProducts(String category) async {
    final response = await http
        .get(Uri.parse('https://fakestoreapi.com/products/category/$category'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Product> products =
          data.map((item) => Product.fromJson(item)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToBottom() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(maxScroll,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _allProducts
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageWidget(
              imageUrl: 'assets/images/modelHombre.png',
              description: 'name_user',
              onPressedHome: _scrollToTop,
              onPressedShop: _scrollToBottom,
              imagenUrlFrase: 'assets/images/Letras/MIRTOHOMBRE.png',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      'assets/images/clothing_store_logo.png',
                      width: 245,
                      height: 137,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _filterProducts,
                              decoration: InputDecoration(
                                hintText: 'Search products',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildProductGrid(_filteredProducts),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    final limitedProducts = products.take(8).toList();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: limitedProducts.length,
      itemBuilder: (BuildContext context, int index) {
        final product = products[index];
        //   return ProductCard(
        //     image: product.image,
        //     title: product.title,
        //     price: product.price.toStringAsFixed(2),
        //   );
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
          },
          child: ProductCard(
            image: product.image,
            title: product.title,
            price: product.price.toStringAsFixed(2),
          ),
        );
      },
    );
  }
}
