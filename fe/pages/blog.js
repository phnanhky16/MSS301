import { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import Link from 'next/link';
import {
  Input,
  Select,
  Button,
  Card,
  Row,
  Col,
  Spin,
  Empty,
  Pagination,
  Typography,
  Tag,
  Avatar,
  Statistic,
  Space
} from 'antd';
import {
  SearchOutlined,
  CalendarOutlined,
  UserOutlined,
  LikeOutlined,
  MessageOutlined,
  ClockCircleOutlined,
} from '@ant-design/icons';
import { getBlogArticles, getBlogCategories, getFeaturedArticles } from '../services/blog-api';
import { formatVnd } from '../utils/currency';

const { Title, Text, Paragraph } = Typography;

const BlogCard = ({ article }) => {
  const router = useRouter();
  return (
    <Card
      hoverable
      className="blog-card"
      cover={
        <div
          style={{
            height: 250,
            backgroundImage: `url(${article.image})`,
            backgroundSize: 'cover',
            backgroundPosition: 'center',
            cursor: 'pointer',
            position: 'relative',
            overflow: 'hidden'
          }}
          onClick={() => router.push(`/blog/${article.id}`)}
        >
          <Tag
            color="cyan"
            style={{
              position: 'absolute',
              top: 12,
              right: 12,
              zIndex: 10,
              borderRadius: 4
            }}
          >
            {article.category}
          </Tag>
          <div
            style={{
              position: 'absolute',
              bottom: 0,
              left: 0,
              right: 0,
              background: 'linear-gradient(to top, rgba(0,0,0,0.6), transparent)',
              padding: '20px 16px',
              color: 'white'
            }}
          >
            <div style={{ fontSize: 12, display: 'flex', gap: 12, alignItems: 'center' }}>
              <CalendarOutlined />
              {new Date(article.date).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'short',
                day: 'numeric'
              })}
            </div>
          </div>
        </div>
      }
      onClick={() => router.push(`/blog/${article.id}`)}
      style={{ cursor: 'pointer', height: '100%' }}
    >
      <Title level={4} style={{ marginTop: 0, marginBottom: 12, color: '#1a1a1a' }}>
        {article.title}
      </Title>
      <Paragraph
        ellipsis={{ rows: 2 }}
        style={{ color: '#666', marginBottom: 12, fontSize: 14 }}
      >
        {article.excerpt}
      </Paragraph>

      <div style={{ display: 'flex', gap: 16, marginBottom: 12, fontSize: 12, color: '#888' }}>
        <Space size={4}>
          <ClockCircleOutlined />
          <span>{article.readTime} min read</span>
        </Space>
        <Space size={4}>
          <LikeOutlined />
          <span>{article.likes}</span>
        </Space>
        <Space size={4}>
          <MessageOutlined />
          <span>{article.comments}</span>
        </Space>
      </div>

      <div style={{ borderTop: '1px solid #f0f0f0', paddingTop: 12 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <Space size={8}>
            <Avatar size={28} icon={<UserOutlined />} />
            <Text style={{ fontSize: 13 }}>{article.author}</Text>
          </Space>
          <Button
            type="link"
            size="small"
            onClick={(e) => {
              e.stopPropagation();
              router.push(`/blog/${article.id}`);
            }}
            style={{ color: '#1ca8c8' }}
          >
            Read More →
          </Button>
        </div>
      </div>
    </Card>
  );
};

export default function BlogPage() {
  const router = useRouter();
  const [articles, setArticles] = useState([]);
  const [featured, setFeatured] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalArticles, setTotalArticles] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [searchInput, setSearchInput] = useState('');

  const pageSize = 6;

  useEffect(() => {
    loadData();
  }, []);

  useEffect(() => {
    setCurrentPage(1);
    loadData(1);
  }, [selectedCategory, searchQuery]);

  const loadData = async (page = currentPage) => {
    setLoading(true);
    try {
      const [articlesRes, categoriesRes, featuredRes] = await Promise.all([
        getBlogArticles(page, pageSize, {
          category: selectedCategory,
          search: searchQuery
        }),
        getBlogCategories(),
        getFeaturedArticles(3)
      ]);

      setArticles(articlesRes.data);
      setTotalArticles(articlesRes.pagination.total);
      setTotalPages(articlesRes.pagination.totalPages);
      setCategories(categoriesRes);
      setFeatured(featuredRes);
    } catch (error) {
      console.error('Failed to load blog data:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = () => {
    setSearchQuery(searchInput);
  };

  return (
    <div style={{ background: '#f5f7fa', minHeight: '100vh', paddingTop: 40, paddingBottom: 60 }}>
      {/* Hero Section */}
      <div style={{ background: '#fff', marginBottom: 40, borderBottom: '2px solid #1ca8c8' }}>
        <div style={{ maxWidth: 1200, margin: '0 auto', padding: '60px 20px', textAlign: 'center' }}>
          <Title level={1} style={{ fontSize: 48, fontWeight: 800, color: '#1a1a1a', margin: 0 }}>
            🎈 Toy Blog & News
          </Title>
          <Paragraph style={{ fontSize: 18, color: '#666', marginTop: 12 }}>
            Explore expert reviews, parenting tips, and the latest trends in children's toys and educational products.
          </Paragraph>
        </div>
      </div>

      <div style={{ maxWidth: 1200, margin: '0 auto', padding: '0 20px' }}>
        {/* Featured Articles */}
        <div style={{ marginBottom: 60 }}>
          <Title level={2} style={{ fontSize: 32, fontWeight: 700, marginBottom: 24 }}>
            ⭐ Featured Articles
          </Title>
          <Row gutter={[24, 24]}>
            {featured.map(article => (
              <Col xs={24} sm={12} lg={8} key={article.id}>
                <BlogCard article={article} />
              </Col>
            ))}
          </Row>
        </div>

        {/* Search and Filter */}
        <div
          style={{
            background: '#fff',
            padding: '24px',
            borderRadius: 8,
            marginBottom: 32,
            boxShadow: '0 2px 8px rgba(0,0,0,0.06)'
          }}
        >
          <Row gutter={[16, 16]}>
            <Col xs={24} md={12}>
              <Input
                placeholder="Search articles..."
                prefix={<SearchOutlined />}
                size="large"
                value={searchInput}
                onChange={e => setSearchInput(e.target.value)}
                onPressEnter={handleSearch}
                style={{ borderRadius: 8 }}
              />
            </Col>
            <Col xs={24} md={12}>
              <Space style={{ width: '100%' }}>
                <Select
                  value={selectedCategory}
                  onChange={setSelectedCategory}
                  style={{ flex: 1, minWidth: 200 }}
                  size="large"
                >
                  <Select.Option value="all">All Categories</Select.Option>
                  {categories.map(cat => (
                    <Select.Option key={cat.name} value={cat.name}>
                      {cat.name} ({cat.count})
                    </Select.Option>
                  ))}
                </Select>
                <Button
                  type="primary"
                  icon={<SearchOutlined />}
                  size="large"
                  onClick={handleSearch}
                  style={{ background: '#1ca8c8', borderColor: '#1ca8c8' }}
                >
                  Search
                </Button>
              </Space>
            </Col>
          </Row>
        </div>

        {/* Articles List */}
        <div style={{ marginBottom: 32 }}>
          <Title level={2} style={{ fontSize: 32, fontWeight: 700, marginBottom: 24 }}>
            📚 All Articles
          </Title>
          {loading ? (
            <div style={{ textAlign: 'center', padding: '60px 20px' }}>
              <Spin size="large" />
            </div>
          ) : articles.length > 0 ? (
            <>
              <Row gutter={[24, 24]}>
                {articles.map(article => (
                  <Col xs={24} sm={12} lg={8} key={article.id}>
                    <BlogCard article={article} />
                  </Col>
                ))}
              </Row>

              {/* Pagination */}
              <div style={{ marginTop: 40, textAlign: 'center' }}>
                <Pagination
                  current={currentPage}
                  total={totalArticles}
                  pageSize={pageSize}
                  onChange={page => {
                    setCurrentPage(page);
                    loadData(page);
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                  }}
                  style={{ marginBottom: 20 }}
                />
              </div>
            </>
          ) : (
            <Empty description="No articles found" style={{ padding: '60px 20px' }} />
          )}
        </div>

        {/* Newsletter Section */}
        <Card
          style={{
            background: 'linear-gradient(135deg, #1ca8c8 0%, #1691b0 100%)',
            border: 'none',
            borderRadius: 12,
            padding: '40px',
            marginBottom: 40,
            textAlign: 'center'
          }}
        >
          <Title level={3} style={{ color: '#fff', marginBottom: 12 }}>
            📧 Subscribe to Our Newsletter
          </Title>
          <Paragraph style={{ color: '#e8f4f8', marginBottom: 20 }}>
            Get the latest toy reviews, parenting tips, and product updates delivered to your inbox.
          </Paragraph>
          <Space style={{ width: '100%', justifyContent: 'center' }}>
            <Input
              placeholder="Enter your email"
              type="email"
              style={{ width: 300, borderRadius: 8 }}
              size="large"
            />
            <Button
              type="primary"
              size="large"
              style={{ background: '#fff', color: '#1ca8c8', border: 'none' }}
            >
              Subscribe
            </Button>
          </Space>
        </Card>
      </div>

      <style jsx>{`
        :global(.blog-card) {
          transition: all 0.3s ease;
          border-radius: 12px;
          overflow: hidden;
          border: 1px solid #f0f0f0;
        }
        :global(.blog-card:hover) {
          box-shadow: 0 8px 24px rgba(28, 168, 200, 0.15);
          transform: translateY(-4px);
        }
        :global(.blog-card .ant-card-cover) {
          border-radius: 12px 12px 0 0;
        }
      `}</style>
    </div>
  );
}
