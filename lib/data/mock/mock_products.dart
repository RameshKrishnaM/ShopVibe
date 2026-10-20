import 'package:shopvibe/data/models/product_model.dart';

/// Static / local mock product catalog for e-commerce clothing assessment
class MockProducts {
  static const List<ProductModel> items = [
    ProductModel(
      id: 'prod_1',
      name: 'Urban Minimalist Bomber',
      description:
          'Water-resistant matte finish jacket with ribbed collar, brass hardware, and interior utility pocket.',
      price: 119.99,
      imageUrl:
          'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=700&auto=format&fit=crop&q=80',
      category: 'Jackets',
      rating: 4.9,
      reviewsCount: 248,
    ),
    ProductModel(
      id: 'prod_2',
      name: 'Organic Cotton Oxford Shirt',
      description:
          'Breathable 100% organic cotton button-down with tailored silhouette and Mother of Pearl buttons.',
      price: 1499.00,
      imageUrl:
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=700&auto=format&fit=crop&q=80',
      category: 'Shirts',
      rating: 4.8,
      reviewsCount: 512,
    ),
    ProductModel(
      id: 'prod_3',
      name: 'CloudWalk Leather Sneakers',
      description:
          'Full-grain Italian calfskin low-tops equipped with shock-absorbing memory foam footbeds.',
      price: 2999.00,
      imageUrl:
          'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=700&auto=format&fit=crop&q=80',
      category: 'Shoes',
      rating: 4.9,
      reviewsCount: 420,
    ),
    ProductModel(
      id: 'prod_4',
      name: 'Heavyweight Fleece Hoodie',
      description:
          'Ultra-plush 450 GSM French terry cotton hoodie featuring double-lined hood and kangaroo pouch.',
      price: 3499.00,
      imageUrl:
          'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=700&auto=format&fit=crop&q=80',
      category: 'Jackets',
      rating: 4.9,
      reviewsCount: 290,
    ),
    ProductModel(
      id: 'prod_5',
      name: 'Heritage Selvedge Denim',
      description:
          'Japanese raw denim woven on vintage shuttle looms. Classic tapered fit with copper rivets.',
      price: 1299.00,
      imageUrl:
          'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=700&auto=format&fit=crop&q=80',
      category: 'Shirts',
      rating: 4.7,
      reviewsCount: 198,
    ),
    ProductModel(
      id: 'prod_6',
      name: 'Nomad Waxed Canvas Backpack',
      description:
          'Durable 18oz weather-treated canvas bag with padded 16-inch laptop compartment and leather accents.',
      price: 89.95,
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=700&auto=format&fit=crop&q=80',
      category: 'Accessories',
      rating: 4.9,
      reviewsCount: 340,
    ),
    ProductModel(
      id: 'prod_7',
      name: 'Tailored Merino Wool Overcoat',
      description:
          'Refined double-breasted coat crafted from Australian merino wool blend with satin lining.',
      price: 189.99,
      imageUrl:
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=700&auto=format&fit=crop&q=80',
      category: 'Jackets',
      rating: 4.9,
      reviewsCount: 175,
    ),
    ProductModel(
      id: 'prod_8',
      name: 'Chronograph Minimalist Watch',
      description:
          'Surgical-grade 316L stainless steel timepiece with sapphire crystal glass and genuine leather strap.',
      price: 3999.00,
      imageUrl:
          'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=700&auto=format&fit=crop&q=80',
      category: 'Accessories',
      rating: 4.8,
      reviewsCount: 260,
    ),
  ];

  static const List<String> categories = [
    'All',
    'Jackets',
    'Shirts',
    'Shoes',
    'Accessories',
  ];
}
