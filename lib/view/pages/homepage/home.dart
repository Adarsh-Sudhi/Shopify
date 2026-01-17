import 'dart:async';
import 'dart:developer';
import 'package:avodha_interview_test/model/category.dart';
import 'package:avodha_interview_test/model/product.dart';
import 'package:avodha_interview_test/view/customWidget/CachedNetWorkImage.dart';
import 'package:avodha_interview_test/view/pages/cart/cart_page.dart';
import 'package:avodha_interview_test/view/pages/categories/get_categories.dart';
import 'package:avodha_interview_test/view/pages/homepage/search_page.dart';
import 'package:avodha_interview_test/view/pages/productspage/productPageView.dart';
import 'package:avodha_interview_test/view/profile/profile_page.dart';
import 'package:avodha_interview_test/viewmodel/product_home_bloc/product_home_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> banners = [
    'assets/banner/banner0.jpg',
    'assets/banner/banner1.jpg',
    'assets/banner/banner2.jpg',
    'assets/banner/banner3.jpg',
  ];

  final List<String> categoryUris = [
    "https://dummyjson.com/products/category/beauty",
    'https://dummyjson.com/products/category/smartphones',
    'https://dummyjson.com/products/category/furniture',
    'https://dummyjson.com/products/category/groceries',
  ];

  final Map<String, IconData> categoryIcons = {
    "Beauty": Icons.brush,
    "Fragrances": Icons.spa,
    "Furniture": Icons.chair,
    "Groceries": Icons.shopping_basket,
    "Home Decoration": Icons.home,
    "Kitchen Accessories": Icons.kitchen,
    "Laptops": Icons.laptop,
    "Mens Shirts": Icons.checkroom,
    "Mens Shoes": Icons.directions_run,
    "Mens Watches": Icons.watch,
    "Mobile Accessories": Icons.headset,
    "Motorcycle": Icons.motorcycle,
    "Skin Care": Icons.face,
    "Smartphones": Icons.smartphone,
    "Sports Accessories": Icons.sports_soccer,
    "Sunglasses": Icons.wb_sunny,
    "Tablets": Icons.tablet,
    "Tops": Icons.emoji_people,
    "Vehicle": Icons.directions_car,
    "Womens Bags": Icons.shopping_bag,
    "Womens Dresses": Icons.style,
    "Womens Jewellery": Icons.diamond,
    "Womens Shoes": Icons.hiking,
    "Womens Watches": Icons.watch_later,
  };

  final TextEditingController _searchQueryController = TextEditingController();

  late Timer _timer;
  Duration _timeLeft = Duration(hours: 5, minutes: 30, seconds: 0);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductHomeBloc>(context).add(GetHomeDataEvent());
    startCountdown();
  }

  Widget categoryItem(String title, IconData icon) {
    return Container(
      width: 70,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.deepPurple.shade50,
            child: Icon(icon, size: 28, color: Colors.deepPurple),
          ),
          SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  final ValueNotifier<Duration> timeLeftNotifier = ValueNotifier(
    Duration(days: 1),
  );

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeftNotifier.value.inSeconds > 0) {
        timeLeftNotifier.value =
            timeLeftNotifier.value - const Duration(seconds: 1);
      } else {
        _timer.cancel();
      }
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(230),
        child: BlocBuilder<ProductHomeBloc, ProductHomeState>(
          builder: (context, state) {
            if (state is HomeProductDetails) {
              List<Categories> categories = state.categoriesMap;
              return _buildAppBar(size, categories);
            } else {
              return _buildAppBar(size, null);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10),
              _buildBannerCarousel(size),
              SizedBox(height: 20),
              _buildLimitedOfferCard(),
              SizedBox(height: 20),
              _buildSectionTitle('Featured Products'),
              SizedBox(height: 10),
              _buildFeaturedProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(Size size, List<Categories>? categories) {
    return Container(
      height: 230,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchQueryController,
                              onSubmitted: (value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SearchProductsPage(
                                      search: _searchQueryController.text
                                          .trim(),
                                    ),
                                  ),
                                );
                              },
                              decoration: InputDecoration(
                                hintText: 'Search products...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      final session = Hive.box("sessionBox");
                      final email = session.get("email");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CartPage(email: email),
                        ),
                      );
                    },
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.shopping_cart, color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AccountPage()),
                      );
                    },
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.person, color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Expanded(
                child: categories != null
                    ? ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(categories.length, (i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewProductsPage(
                                    name: categories[i].name,
                                    apiUrl: categories[i].url,
                                  ),
                                ),
                              );
                            },
                            child: categoryItem(
                              categories[i].name,
                              categoryIcons[categories[i].name] ??
                                  Icons.no_luggage_outlined,
                            ),
                          );
                        }),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 70,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    height: 12,
                                    width: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(Size size) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.95,
      ),
      items: List.generate(
        banners.length,
        (e) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewProductsPage(
                  name: e == 0
                      ? "MakeUp"
                      : e == 1
                      ? "SmartPhones"
                      : e == 2
                      ? "Furniture"
                      : "Groceries",
                  apiUrl: categoryUris[e],
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              banners[e],
              fit: BoxFit.cover,
              width: size.width,
            ),
          ),
        ),
      ).toList(),
    );
  }

  Widget _buildLimitedOfferCard() {
    final dummyOffers = [
      {
        "title": "Dell Aspire v8",
        "price": 999,
        "discount": 28,
        "image": "assets/products/laptop.png",
      },
      {
        "title": "Redmi Note 14",
        "price": 1299,
        "discount": 32,
        "image": "assets/products/mobile.png",
      },
      {
        "title": "Hugo Boss",
        "price": 120,
        "discount": 40,
        "image": "assets/products/perfumes.png",
      },
    ];

    return BlocBuilder<ProductHomeBloc, ProductHomeState>(
      builder: (context, state) {
        if (state is HomeProductDetails) {
          List<ProductElement> _productElement = List.from(state.products);
          _productElement.shuffle();
          List<ProductElement> _random = _productElement.take(5).toList();
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.deepPurple.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flash_on, color: Colors.orange),
                        SizedBox(width: 6),
                        Text(
                          'Limited-Time Offer!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: timeLeftNotifier,
                        builder: (context, value, child) {
                          return Text(
                            formatDuration(value),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade400,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14),

                /// OFFER PRODUCTS
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _random.length,
                    itemBuilder: (context, index) {
                      final item = _random[index];
                      log(item.images.last);
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(14),
                                  ),
                                  child: Image.network(
                                    item.images.last,
                                    height: 70,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  left: 6,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "${item.discountPercentage}% OFF",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "\$${item.price}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.deepPurple.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flash_on, color: Colors.orange),
                      SizedBox(width: 6),
                      Text(
                        'Limited-Time Offer!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      formatDuration(_timeLeft),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dummyOffers.length,
                  itemBuilder: (context, index) {
                    final item = dummyOffers[index];
                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(14),
                                ),
                                child: Image.asset(
                                  item["image"].toString(),
                                  height: 70,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 6,
                                left: 6,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "${item["discount"]}% OFF",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"].toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "\$${item["price"]}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    return BlocBuilder<ProductHomeBloc, ProductHomeState>(
      builder: (context, state) {
        if (state is HomeProductDetails) {
          List<ProductElement> products = state.products;
          return SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductViewPage(product: product),
                      ),
                    );
                  },
                  child: Container(
                    width: 170,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Hero(
                            tag: product.id,
                            child: AppCachedImage(
                              imageUrl: product.thumbnail,
                              height: 140,
                              width: 170,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.rating.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.local_offer,
                                    size: 14,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
