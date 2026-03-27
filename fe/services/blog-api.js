/**
 * Blog Service - Fetch articles from public APIs about toys and children products
 */

// Mock blog data - will be used as fallback or primary data source
const MOCK_BLOG_DATA = [
  {
    id: 1,
    title: "Top 10 Educational Toys for Toddlers in 2024",
    excerpt: "Discover the best educational toys that help develop your toddler's cognitive and motor skills while keeping them entertained for hours.",
    content: "Educational toys are essential for your child's development. In 2024, the focus is on toys that combine fun with learning. From building blocks to interactive puzzles, we've curated the top 10 toys that experts recommend for toddlers aged 2-4.",
    author: "Sarah Johnson",
    date: new Date(2024, 0, 15),
    image: "https://images.unsplash.com/photo-1601095888161-e66eeff1c6de?w=800&h=400&fit=crop",
    category: "Educational",
    readTime: 5,
    likes: 234,
    comments: 12
  },
  {
    id: 2,
    title: "Best Toys for Developing Fine Motor Skills",
    excerpt: "Fine motor skills are crucial for your child's development. Learn which toys are most effective for strengthening hand-eye coordination.",
    content: "Fine motor skills involve the use of small muscles in the hands and fingers. Activities that develop these skills are important for writing, drawing, and self-care tasks. We explore the most effective toys for developing these essential skills.",
    author: "Dr. Michael Chen",
    date: new Date(2024, 1, 20),
    image: "https://images.unsplash.com/photo-1563789879-e18d2b44a6e1?w=800&h=400&fit=crop",
    category: "Development",
    readTime: 7,
    likes: 189,
    comments: 8
  },
  {
    id: 3,
    title: "Eco-Friendly Toys: Safe for Kids and Planet",
    excerpt: "Sustainable and non-toxic toys that are better for your child and the environment. A comprehensive guide to eco-conscious toy shopping.",
    content: "As parents become more environmentally conscious, the demand for eco-friendly toys continues to grow. These toys are made from sustainable materials, are free from harmful chemicals, and often come in recyclable or compostable packaging.",
    author: "Emma Green",
    date: new Date(2024, 2, 10),
    image: "https://images.unsplash.com/photo-1595777707802-51b5019a2bdc?w=800&h=400&fit=crop",
    category: "Eco-Friendly",
    readTime: 6,
    likes: 312,
    comments: 25
  },
  {
    id: 4,
    title: "STEM Toys That Make Learning Fun",
    excerpt: "Science, Technology, Engineering, and Math toys that spark curiosity and help kids develop problem-solving skills.",
    content: "STEM education is more important than ever. These toys introduce children to scientific concepts through play. From coding robots to chemistry kits, we showcases the most engaging STEM toys available today.",
    author: "Prof. David Russell",
    date: new Date(2024, 2, 25),
    image: "https://images.unsplash.com/photo-1588345643519-c0c5adbc73d0?w=800&h=400&fit=crop",
    category: "STEM",
    readTime: 8,
    likes: 456,
    comments: 34
  },
  {
    id: 5,
    title: "Toys for Babies 0-12 Months: Development Guide",
    excerpt: "The best toys for infant development month by month. What to look for to support your baby's growth during the critical first year.",
    content: "The first year of life is crucial for development. Different toys support different developmental milestones. We break down which toys are best for each month, from newborn to 12 months.",
    author: "Dr. Lisa Anderson",
    date: new Date(2024, 3, 5),
    image: "https://images.unsplash.com/photo-1595777707802-51b5019a2bdc?w=800&h=400&fit=crop",
    category: "Babies",
    readTime: 9,
    likes: 278,
    comments: 16
  },
  {
    id: 6,
    title: "Outdoor Toys and Physical Activity for Kids",
    excerpt: "Get kids off the screen with these engaging outdoor toys that encourage physical activity and outdoor exploration.",
    content: "Physical activity is essential for children's health. Outdoor toys not only keep kids entertained but also help them develop strength, coordination, and confidence. From tricycles to sports equipment, we present outdoor toys for different age groups.",
    author: "Coach Mark Wilson",
    date: new Date(2024, 3, 18),
    image: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800&h=400&fit=crop",
    category: "Outdoor",
    readTime: 6,
    likes: 201,
    comments: 11
  },
  {
    id: 7,
    title: "Toy Safety Standards Every Parent Should Know",
    excerpt: "Understanding toy safety certifications and standards to ensure you're buying safe toys for your children.",
    content: "Not all toys are created equal when it comes to safety. We explain the important certifications and safety standards you should look for when shopping for toys, including ASTM, CE, and other important marks.",
    author: "Safety Expert James Bolton",
    date: new Date(2024, 4, 1),
    image: "https://images.unsplash.com/photo-1566481994642-939e1662a028?w=800&h=400&fit=crop",
    category: "Safety",
    readTime: 7,
    likes: 167,
    comments: 9
  },
  {
    id: 8,
    title: "Building Sets for Every Age Group",
    excerpt: "From simple blocks for toddlers to complex construction sets for older kids, find the perfect building toy for your child.",
    content: "Building toys develop spatial reasoning, creativity, and problem-solving skills. We've categorized the best building sets by age group, from soft blocks for babies to advanced LEGO sets for older children.",
    author: "Creativity Coach Linda Martinez",
    date: new Date(2024, 4, 12),
    image: "https://images.unsplash.com/photo-1605090465677-a3f9e50d0c63?w=800&h=400&fit=crop",
    category: "Building",
    readTime: 8,
    likes: 334,
    comments: 28
  }
];

/**
 * Get all blog articles
 * @param {number} page - Page number (1-indexed)
 * @param {number} pageSize - Articles per page
 * @param {Object} filters - Filter options (category, search, etc.)
 * @returns {Promise<Object>} Articles with pagination
 */
export async function getBlogArticles(page = 1, pageSize = 6, filters = {}) {
  try {
    // Simulate API delay
    await new Promise(resolve => setTimeout(resolve, 300));

    let articles = [...MOCK_BLOG_DATA];

    // Apply search filter
    if (filters.search) {
      const search = filters.search.toLowerCase();
      articles = articles.filter(a => 
        a.title.toLowerCase().includes(search) || 
        a.excerpt.toLowerCase().includes(search) ||
        a.content.toLowerCase().includes(search)
      );
    }

    // Apply category filter
    if (filters.category && filters.category !== 'all') {
      articles = articles.filter(a => a.category.toLowerCase() === filters.category.toLowerCase());
    }

    // Sort by date (newest first)
    articles.sort((a, b) => new Date(b.date) - new Date(a.date));

    // Pagination
    const total = articles.length;
    const startIndex = (page - 1) * pageSize;
    const paginatedArticles = articles.slice(startIndex, startIndex + pageSize);

    return {
      data: paginatedArticles,
      pagination: {
        current: page,
        pageSize,
        total,
        totalPages: Math.ceil(total / pageSize)
      }
    };
  } catch (error) {
    console.error('Failed to fetch blog articles:', error);
    throw error;
  }
}

/**
 * Get single blog article by ID
 * @param {number} id - Article ID
 * @returns {Promise<Object>} Article details
 */
export async function getBlogArticle(id) {
  try {
    await new Promise(resolve => setTimeout(resolve, 200));

    const article = MOCK_BLOG_DATA.find(a => a.id === parseInt(id));
    if (!article) {
      throw new Error('Article not found');
    }

    // Get related articles (same category, max 3)
    const related = MOCK_BLOG_DATA
      .filter(a => a.category === article.category && a.id !== article.id)
      .slice(0, 3);

    return {
      ...article,
      related
    };
  } catch (error) {
    console.error('Failed to fetch blog article:', error);
    throw error;
  }
}

/**
 * Get blog categories
 * @returns {Promise<Array>} Categories with count
 */
export async function getBlogCategories() {
  try {
    await new Promise(resolve => setTimeout(resolve, 100));

    const categories = {};
    MOCK_BLOG_DATA.forEach(article => {
      if (!categories[article.category]) {
        categories[article.category] = 0;
      }
      categories[article.category]++;
    });

    return Object.entries(categories).map(([name, count]) => ({
      name,
      count
    }));
  } catch (error) {
    console.error('Failed to fetch blog categories:', error);
    throw error;
  }
}

/**
 * Get featured articles (most liked or recent)
 * @returns {Promise<Array>} Featured articles
 */
export async function getFeaturedArticles(limit = 3) {
  try {
    await new Promise(resolve => setTimeout(resolve, 200));

    return MOCK_BLOG_DATA
      .sort((a, b) => b.likes - a.likes)
      .slice(0, limit);
  } catch (error) {
    console.error('Failed to fetch featured articles:', error);
    throw error;
  }
}

/**
 * Post a comment on an article
 * @param {number} articleId - Article ID
 * @param {string} content - Comment content
 * @param {string} author - Comment author name
 * @returns {Promise<Object>} Comment details
 */
export async function postComment(articleId, content, author) {
  try {
    await new Promise(resolve => setTimeout(resolve, 500));

    return {
      id: Date.now(),
      articleId,
      content,
      author,
      date: new Date(),
      likes: 0
    };
  } catch (error) {
    console.error('Failed to post comment:', error);
    throw error;
  }
}

export default {
  getBlogArticles,
  getBlogArticle,
  getBlogCategories,
  getFeaturedArticles,
  postComment
};
