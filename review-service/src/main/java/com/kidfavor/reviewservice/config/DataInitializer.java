package com.kidfavor.reviewservice.config;

import com.kidfavor.reviewservice.entity.Review;
import com.kidfavor.reviewservice.repository.ReviewRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final ReviewRepository reviewRepository;
    private final Random random = new Random();

    private final String[] positiveComments = {
            "Sản phẩm tuyệt vời, bé rất thích!",
            "Chất lượng rất tốt, đáng đồng tiền.",
            "Giao hàng nhanh, đóng gói cẩn thận.",
            "Màu sắc đẹp, chất liệu an toàn cho trẻ nhỏ.",
            "Sẽ tiếp tục ủng hộ shop lần sau.",
            "Thiết kế thông minh, bé nhà mình chơi không chán.",
            "Vượt ngoài mong đợi, 5 sao cho shop!",
            "Chất lượng ổn định, mẫu mã đa dạng.",
            "Dịch vụ khách hàng rất tốt.",
            "Sản phẩm y như hình, hài lòng tuyệt đối."
    };

    private final String[] neutralComments = {
            "Sản phẩm dùng được, tạm chấp nhận.",
            "Giao hàng hơi lâu một chút.",
            "Chất lượng ổn trong tầm giá.",
            "Bé chơi cũng được nhưng chưa thực sự hào hứng.",
            "Đóng gói bình thường, không quá đặc sắc."
    };

    private final String[] negativeComments = {
            "Chất lượng không như kỳ vọng.",
            "Giá hơi cao so với chất lượng thực tế.",
            "Màu sắc bên ngoài hơi khác so với trong ảnh.",
            "Cần cải thiện khâu đóng gói.",
            "Sản phẩm có vết xước khi nhận hàng."
    };

    @Override
    public void run(String... args) {
        if (reviewRepository.count() > 0) {
            log.info("Reviews already exist, skipping initialization. Total: {}", reviewRepository.count());
            return;
        }

        log.info("Initializing sample reviews for products...");

        List<Review> allReviews = new ArrayList<>();

        // Seed reviews for products 1 to 20
        for (long productId = 1; productId <= 20; productId++) {
            int reviewCount = 15 + random.nextInt(10); // 15-25 reviews per product

            for (int j = 0; j < reviewCount; j++) {
                int rating;
                String comment;

                // Distribting ratings: ~70% 4-5 stars, ~20% 3 stars, ~10% 1-2 stars
                double rand = random.nextDouble();
                if (rand < 0.7) {
                    rating = 4 + random.nextInt(2); // 4 or 5
                    comment = positiveComments[random.nextInt(positiveComments.length)];
                } else if (rand < 0.9) {
                    rating = 3;
                    comment = neutralComments[random.nextInt(neutralComments.length)];
                } else {
                    rating = 1 + random.nextInt(2); // 1 or 2
                    comment = negativeComments[random.nextInt(negativeComments.length)];
                }

                Review review = Review.builder()
                        .userId((long) (1 + random.nextInt(50))) // Random userId 1-50
                        .productId(productId)
                        .rating(rating)
                        .comment(comment)
                        .build();

                allReviews.add(review);
            }
        }

        reviewRepository.saveAll(allReviews);
        log.info("Successfully initialized {} sample reviews.", allReviews.size());
    }
}
