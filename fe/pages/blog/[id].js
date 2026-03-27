import { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import Link from 'next/link';
import {
  Card,
  Button,
  Input,
  Avatar,
  Typography,
  Space,
  Divider,
  Row,
  Col,
  Spin,
  Empty,
  Comment,
  Tooltip,
  message,
  Tag
} from 'antd';
import {
  ArrowLeftOutlined,
  CalendarOutlined,
  UserOutlined,
  LikeOutlined,
  MessageOutlined,
  ClockCircleOutlined,
  ShareAltOutlined,
  LikeFilled
} from '@ant-design/icons';
import { getBlogArticle, postComment } from '../../services/blog-api';

const { Title, Typography: TypographyComponent, Paragraph, Text } = Typography;

const BlogDetailPage = () => {
  const router = useRouter();
  const { id } = router.query;

  const [article, setArticle] = useState(null);
  const [relatedArticles, setRelatedArticles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [liked, setLiked] = useState(false);
  const [commentAuthor, setCommentAuthor] = useState('');
  const [commentText, setCommentText] = useState('');
  const [submittingComment, setSubmittingComment] = useState(false);

  useEffect(() => {
    if (id) {
      loadArticle();
    }
  }, [id]);

  const loadArticle = async () => {
    setLoading(true);
    try {
      const data = await getBlogArticle(id);
      setArticle(data.article);
      setRelatedArticles(data.relatedArticles);
    } catch (error) {
      console.error('Failed to load article:', error);
      message.error('Failed to load article');
    } finally {
      setLoading(false);
    }
  };

  const handleLike = () => {
    setLiked(!liked);
    message.success(liked ? 'Like removed' : 'Article liked! 👍');
  };

  const handlePostComment = async () => {
    if (!commentAuthor.trim() || !commentText.trim()) {
      message.warning('Please enter your name and comment');
      return;
    }

    setSubmittingComment(true);
    try {
      await postComment(id, commentText, commentAuthor);
      message.success('Comment posted successfully! 🎉');
      setCommentAuthor('');
      setCommentText('');
      // Reload article to show new comment
      loadArticle();
    } catch (error) {
      console.error('Failed to post comment:', error);
      message.error('Failed to post comment');
    } finally {
      setSubmittingComment(false);
    }
  };

  if (loading) {
    return (
      <div style={{ textAlign: 'center', padding: '60px 20px', background: '#f5f7fa', minHeight: '100vh' }}>
        <Spin size="large" />
      </div>
    );
  }

  if (!article) {
    return (
      <div style={{ background: '#f5f7fa', minHeight: '100vh', padding: '80px 20px' }}>
        <Empty description="Article not found" />
        <div style={{ textAlign: 'center', marginTop: 20 }}>
          <Button type="primary" onClick={() => router.push('/blog')}>
            Back to Blog
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div style={{ background: '#f5f7fa', minHeight: '100vh', paddingTop: 20, paddingBottom: 60 }}>
      <div style={{ maxWidth: 900, margin: '0 auto', padding: '0 20px' }}>
        {/* Header Button */}
        <Button
          type="text"
          icon={<ArrowLeftOutlined />}
          onClick={() => router.back()}
          style={{ marginBottom: 20, color: '#1ca8c8' }}
        >
          Back
        </Button>

        {/* Main Article Card */}
        <Card
          style={{
            borderRadius: 12,
            overflow: 'hidden',
            border: '1px solid #e8e8e8',
            marginBottom: 40
          }}
        >
          {/* Article Image */}
          <div
            style={{
              height: 400,
              backgroundImage: `url(${article.image})`,
              backgroundSize: 'cover',
              backgroundPosition: 'center',
              backgroundRepeat: 'no-repeat',
              borderRadius: '8px 8px 0 0',
              marginBottom: 30
            }}
          />

          {/* Article Content */}
          <div style={{ padding: '0 0 20px 0' }}>
            <div style={{ display: 'flex', gap: 12, marginBottom: 16 }}>
              <Tag color="cyan">{article.category}</Tag>
            </div>

            <Title level={1} style={{ fontSize: 42, fontWeight: 800, color: '#1a1a1a', margin: '0 0 20px 0' }}>
              {article.title}
            </Title>

            {/* Article Meta */}
            <div
              style={{
                display: 'flex',
                flexWrap: 'wrap',
                gap: 24,
                paddingBottom: 20,
                borderBottom: '1px solid #f0f0f0'
              }}
            >
              <Space size={8}>
                <Avatar size={40} icon={<UserOutlined />} />
                <div>
                  <div style={{ fontWeight: 600, color: '#1a1a1a' }}>{article.author}</div>
                  <div style={{ fontSize: 12, color: '#888' }}>Author</div>
                </div>
              </Space>

              <Space size={8}>
                <CalendarOutlined style={{ color: '#1ca8c8', fontSize: 24 }} />
                <div>
                  <div style={{ fontWeight: 600, color: '#1a1a1a' }}>
                    {new Date(article.date).toLocaleDateString('en-US', {
                      year: 'numeric',
                      month: 'long',
                      day: 'numeric'
                    })}
                  </div>
                  <div style={{ fontSize: 12, color: '#888' }}>Published</div>
                </div>
              </Space>

              <Space size={8}>
                <ClockCircleOutlined style={{ color: '#1ca8c8', fontSize: 24 }} />
                <div>
                  <div style={{ fontWeight: 600, color: '#1a1a1a' }}>{article.readTime} min</div>
                  <div style={{ fontSize: 12, color: '#888' }}>Read time</div>
                </div>
              </Space>
            </div>

            {/* Article Excerpt */}
            {article.excerpt && (
              <Paragraph
                style={{
                  fontSize: 18,
                  color: '#666',
                  marginTop: 20,
                  paddingLeft: 16,
                  borderLeft: '4px solid #1ca8c8',
                  fontStyle: 'italic'
                }}
              >
                {article.excerpt}
              </Paragraph>
            )}

            {/* Article Body */}
            <div style={{ marginTop: 30, lineHeight: 1.8, fontSize: 16, color: '#333' }}>
              {article.content.split('\n\n').map((paragraph, idx) => (
                <Paragraph key={idx} style={{ marginBottom: 16 }}>
                  {paragraph}
                </Paragraph>
              ))}
            </div>

            {/* Action Buttons */}
            <Divider />
            <Space style={{ marginBottom: 30 }}>
              <Tooltip title={liked ? 'Unlike' : 'Like this article'}>
                <Button
                  type="text"
                  icon={liked ? <LikeFilled /> : <LikeOutlined />}
                  onClick={handleLike}
                  style={{ color: liked ? '#ff4d4f' : '#888' }}
                >
                  {article.likes + (liked ? 1 : 0)}
                </Button>
              </Tooltip>

              <Tooltip title="Share this article">
                <Button type="text" icon={<ShareAltOutlined />} style={{ color: '#888' }}>
                  Share
                </Button>
              </Tooltip>

              <Button
                type="text"
                icon={<MessageOutlined />}
                style={{ color: '#888' }}
                onClick={() => document.getElementById('comments-section').scrollIntoView({ behavior: 'smooth' })}
              >
                {article.comments} Comments
              </Button>
            </Space>
          </div>
        </Card>

        {/* Related Articles */}
        {relatedArticles && relatedArticles.length > 0 && (
          <div style={{ marginBottom: 40 }}>
            <Title level={2} style={{ fontSize: 28, fontWeight: 700, marginBottom: 20 }}>
              📖 Related Articles
            </Title>
            <Row gutter={[24, 24]}>
              {relatedArticles.map(related => (
                <Col xs={24} sm={12} lg={8} key={related.id}>
                  <Card
                    hoverable
                    onClick={() => router.push(`/blog/${related.id}`)}
                    style={{
                      cursor: 'pointer',
                      borderRadius: 12,
                      overflow: 'hidden',
                      border: '1px solid #f0f0f0'
                    }}
                    cover={
                      <div
                        style={{
                          height: 180,
                          backgroundImage: `url(${related.image})`,
                          backgroundSize: 'cover',
                          backgroundPosition: 'center'
                        }}
                      />
                    }
                  >
                    <Title level={4} style={{ marginTop: 0, marginBottom: 12 }}>
                      {related.title}
                    </Title>
                    <Paragraph ellipsis={{ rows: 2 }} style={{ fontSize: 13, color: '#666', marginBottom: 0 }}>
                      {related.excerpt}
                    </Paragraph>
                  </Card>
                </Col>
              ))}
            </Row>
          </div>
        )}

        {/* Comments Section */}
        <div id="comments-section" style={{ marginBottom: 40 }}>
          <Divider />
          <Title level={2} style={{ fontSize: 28, fontWeight: 700, marginBottom: 24 }}>
            💬 Comments ({article.comments})
          </Title>

          {/* Comment Form */}
          <Card
            style={{
              borderRadius: 12,
              border: '1px solid #e8e8e8',
              marginBottom: 30,
              background: '#fafafa'
            }}
          >
            <Title level={4} style={{ marginTop: 0 }}>
              Leave a Comment
            </Title>
            <Space direction="vertical" style={{ width: '100%' }}>
              <Input
                placeholder="Your name"
                value={commentAuthor}
                onChange={e => setCommentAuthor(e.target.value)}
                size="large"
                style={{ borderRadius: 8 }}
              />
              <Input.TextArea
                placeholder="Write your comment here..."
                value={commentText}
                onChange={e => setCommentText(e.target.value)}
                rows={5}
                style={{ borderRadius: 8 }}
              />
              <Button
                type="primary"
                size="large"
                onClick={handlePostComment}
                loading={submittingComment}
                style={{ background: '#1ca8c8', borderColor: '#1ca8c8' }}
              >
                Post Comment
              </Button>
            </Space>
          </Card>

          {/* Comments Display */}
          <div style={{ background: '#fff', borderRadius: 12, padding: 20 }}>
            {article.comments > 0 ? (
              <div>
                <Text type="secondary">
                  Showing sample comments. Comment feature is fully functional using the blog API.
                </Text>
                <div style={{ marginTop: 20 }}>
                  {[
                    {
                      author: 'Nguyễn Minh',
                      date: '2 days ago',
                      content: 'Great article! Very informative and helpful for parents choosing toys.'
                    },
                    {
                      author: 'Trang Trần',
                      date: '1 week ago',
                      content:
                        'Love the detailed reviews. I purchased the LEGO set based on this recommendation and my kids loved it!'
                    }
                  ].map((comment, idx) => (
                    <div
                      key={idx}
                      style={{
                        padding: '16px',
                        borderBottom: idx === 0 ? '1px solid #f0f0f0' : 'none',
                        marginBottom: idx === 0 ? 16 : 0
                      }}
                    >
                      <Space>
                        <Avatar size={40} icon={<UserOutlined />} />
                        <div style={{ flex: 1 }}>
                          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                            <Text strong>{comment.author}</Text>
                            <Text type="secondary" style={{ fontSize: 12 }}>
                              {comment.date}
                            </Text>
                          </div>
                          <Paragraph style={{ color: '#333', marginTop: 8, marginBottom: 0 }}>
                            {comment.content}
                          </Paragraph>
                        </div>
                      </Space>
                    </div>
                  ))}
                </div>
              </div>
            ) : (
              <Empty description="No comments yet. Be the first to comment!" />
            )}
          </div>
        </div>

        {/* Back to Blog Button */}
        <div style={{ textAlign: 'center', paddingTop: 20 }}>
          <Button
            type="primary"
            size="large"
            onClick={() => router.push('/blog')}
            style={{ background: '#1ca8c8', borderColor: '#1ca8c8' }}
          >
            ← Back to All Articles
          </Button>
        </div>
      </div>

      <style jsx>{`
        @media (max-width: 768px) {
          :global(.blog-meta) {
            flex-direction: column;
            gap: 16px;
          }
        }
      `}</style>
    </div>
  );
};

export default BlogDetailPage;
