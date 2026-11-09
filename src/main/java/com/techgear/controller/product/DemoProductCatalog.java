package com.techgear.controller.product;

import com.techgear.model.Product;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/** Sample products used only when the database has no active catalog data. */
public final class DemoProductCatalog {
    private DemoProductCatalog() { }

    public static List<Product> getProducts() {
        List<Product> products = new ArrayList<>();
        products.add(create(-101, "Tai nghe HyperSound X7", "Tai nghe", "HyperSound",
                "690000", "890000", 50,
                "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"));
        products.add(create(-102, "Bàn phím KeyPro K68", "Bàn phím", "KeyPro",
                "990000", "1250000", 30,
                "https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=800&q=80"));
        products.add(create(-103, "Chuột Aero M5", "Chuột", "AeroTech",
                "459000", "599000", 40,
                "https://images.unsplash.com/photo-1527814050087-3793815479db?auto=format&fit=crop&w=800&q=80"));
        products.add(create(-104, "Loa Mini Boom S2", "Loa", "SoundPulse",
                "590000", "750000", 25,
                "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=800&q=80"));
        products.add(create(-105, "Giá treo tai nghe TechStand Pro", "Phụ kiện", "TechGear",
                "290000", "350000", 60,
                "https://images.unsplash.com/photo-1584679109597-c656b19974c9?auto=format&fit=crop&w=800&q=80"));
        products.add(create(-106, "Lót chuột DeskMat Gaming", "Phụ kiện", "TechGear",
                "199000", "250000", 100,
                "https://images.unsplash.com/photo-1616440347437-b1c73416efc2?auto=format&fit=crop&w=800&q=80"));
        return products;
    }

    public static Product find(int productId) {
        for (Product product : getProducts()) {
            if (product.getProductId() == productId) {
                return product;
            }
        }
        return null;
    }

    public static List<Product> getRelatedProducts(int productId, int limit) {
        List<Product> related = new ArrayList<>();
        for (Product product : getProducts()) {
            if (product.getProductId() != productId) {
                related.add(product);
                if (related.size() >= limit) {
                    break;
                }
            }
        }
        return related;
    }

    private static Product create(int id, String name, String category, String brand,
            String price, String compareAtPrice, int stock, String imageUrl) {
        Product product = new Product();
        product.setProductId(id);
        product.setProductName(name);
        product.setCategoryName(category);
        product.setBrandName(brand);
        product.setPrice(new BigDecimal(price));
        product.setCompareAtPrice(new BigDecimal(compareAtPrice));
        product.setStockQuantity(stock);
        product.setActive(true);
        product.setImageUrl(imageUrl);
        product.setAverageRating(new BigDecimal("4.8"));
        product.setReviewCount(0);
        product.setShortDescription(name + " — sản phẩm minh họa khi chưa có dữ liệu từ database.");
        product.setDescription(product.getShortDescription());
        product.setSpecifications("Thương hiệu: " + brand + "\nDanh mục: " + category);
        product.setFeatured(true);
        product.setBestSeller(id == -103);
        product.setNewArrival(id == -104);
        return product;
    }
}
