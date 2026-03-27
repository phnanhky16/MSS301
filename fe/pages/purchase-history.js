import { useEffect, useMemo, useState } from 'react';
import {
  Button,
  Card,
  Empty,
  Modal,
  Space,
  Spin,
  Table,
  Tag,
  Typography,
  message,
} from 'antd';
import { EyeOutlined, ReloadOutlined } from '@ant-design/icons';
import { fetchOrderById, getOrdersByUser } from '../services/api';
import { getCurrentUser } from '../services/auth';
import { formatVnd } from '../utils/currency';

const { Title, Text } = Typography;

function toSafeArray(data) {
  if (Array.isArray(data)) return data;
  if (Array.isArray(data?.content)) return data.content;
  if (Array.isArray(data?.data)) return data.data;
  return [];
}

function statusTagColor(status) {
  switch (status) {
    case 'PENDING':
      return 'blue';
    case 'CONFIRMED':
      return 'green';
    case 'PROCESSING':
      return 'purple';
    case 'SHIPPED':
      return 'orange';
    case 'DELIVERED':
      return 'cyan';
    case 'CANCELLED':
      return 'red';
    case 'REFUNDED':
      return 'magenta';
    default:
      return 'default';
  }
}

function isOrderOwnedByCurrentUser(order, currentUserId) {
  if (!order || !currentUserId) return false;

  const ownerCandidates = [
    order.userId,
    order.customerId,
    order.accountId,
    order.createdBy,
    order.user?.id,
    order.customer?.id,
  ]
    .filter((value) => value !== undefined && value !== null)
    .map((value) => String(value));

  if (ownerCandidates.length === 0) {
    return true;
  }

  return ownerCandidates.includes(String(currentUserId));
}

export default function PurchaseHistoryPage() {
  const [userId, setUserId] = useState(null);
  const [loading, setLoading] = useState(true);
  const [orders, setOrders] = useState([]);
  const [detailOpen, setDetailOpen] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [detailLoading, setDetailLoading] = useState(false);
  const allowedOrderIds = useMemo(
    () => new Set(orders.map((order) => order?.id).filter((id) => id !== undefined && id !== null).map((id) => String(id))),
    [orders]
  );

  useEffect(() => {
    const token = typeof window !== 'undefined' ? localStorage.getItem('accessToken') : null;
    const currentUser = token ? getCurrentUser() : null;

    if (!token || !currentUser) {
      if (typeof window !== 'undefined') {
        window.location.replace('/login');
      }
      return;
    }

    const resolvedUserId = currentUser.userId || currentUser.id || currentUser.sub;
    if (!resolvedUserId) {
      if (typeof window !== 'undefined') {
        window.location.replace('/login');
      }
      return;
    }

    setUserId(resolvedUserId);
  }, []);

  const loadOrders = async (uid) => {
    setLoading(true);
    try {
      const res = await getOrdersByUser(uid);
      const normalized = toSafeArray(res).sort((a, b) => {
        const aTime = new Date(a?.createdAt || 0).getTime();
        const bTime = new Date(b?.createdAt || 0).getTime();
        return bTime - aTime;
      });
      setOrders(normalized);
    } catch (error) {
      console.error('Failed to load purchase history', error);
      message.error('Khong tai duoc lich su mua hang');
      setOrders([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (!userId) return;
    loadOrders(userId);
  }, [userId]);

  const openDetail = async (orderId) => {
    const normalizedOrderId = String(orderId);
    if (!allowedOrderIds.has(normalizedOrderId)) {
      message.error('Ban khong co quyen xem don hang nay');
      return;
    }

    setDetailLoading(true);
    setDetailOpen(true);
    setSelectedOrder(null);

    try {
      const detail = await fetchOrderById(orderId);
      const detailId = detail?.id !== undefined && detail?.id !== null ? String(detail.id) : normalizedOrderId;
      const allowedByList = allowedOrderIds.has(detailId);
      const ownedByUser = isOrderOwnedByCurrentUser(detail, userId);

      if (!allowedByList || !ownedByUser) {
        message.error('Ban khong co quyen xem don hang nay');
        setDetailOpen(false);
        return;
      }

      setSelectedOrder(detail);
    } catch (error) {
      console.error('Failed to load order detail', error);
      message.error('Khong tai duoc chi tiet don hang');
      setDetailOpen(false);
    } finally {
      setDetailLoading(false);
    }
  };

  const orderColumns = useMemo(
    () => [
      {
        title: 'Ma don',
        dataIndex: 'orderNumber',
        key: 'orderNumber',
        render: (value, record) => value || `#${record.id}`,
      },
      {
        title: 'Ngay dat',
        dataIndex: 'createdAt',
        key: 'createdAt',
        render: (value) => (value ? new Date(value).toLocaleString('vi-VN') : '-'),
      },
      {
        title: 'Trang thai',
        dataIndex: 'status',
        key: 'status',
        render: (status) => <Tag color={statusTagColor(status)}>{status || 'UNKNOWN'}</Tag>,
      },
      {
        title: 'Tong tien',
        dataIndex: 'totalAmount',
        key: 'totalAmount',
        align: 'right',
        render: (value) => formatVnd(value || 0),
      },
      {
        title: 'Thao tac',
        key: 'action',
        align: 'center',
        render: (_, record) => (
          <Button
            icon={<EyeOutlined />}
            onClick={() => openDetail(record.id)}
            style={{ borderColor: '#1ca8c8', color: '#1ca8c8' }}
          >
            Chi tiet
          </Button>
        ),
      },
    ],
    []
  );

  const itemColumns = [
    {
      title: 'San pham',
      dataIndex: 'productName',
      key: 'productName',
      render: (v) => v || '-',
    },
    {
      title: 'So luong',
      dataIndex: 'quantity',
      key: 'quantity',
      align: 'center',
      render: (v) => v || 0,
    },
    {
      title: 'Don gia',
      dataIndex: 'unitPrice',
      key: 'unitPrice',
      align: 'right',
      render: (v) => formatVnd(v || 0),
    },
    {
      title: 'Thanh tien',
      dataIndex: 'subtotal',
      key: 'subtotal',
      align: 'right',
      render: (v, r) => formatVnd(v != null ? v : (r.unitPrice || 0) * (r.quantity || 0)),
    },
  ];

  if (!userId) {
    return (
      <div style={{ minHeight: '50vh', display: 'grid', placeItems: 'center' }}>
        <Spin size="large" />
      </div>
    );
  }

  return (
    <div className="purchase-history-page">
      <Card className="purchase-history-card" bordered={false}>
        <Space style={{ width: '100%', justifyContent: 'space-between', marginBottom: 16 }}>
          <Title level={2} style={{ margin: 0 }}>
            Lich su mua hang
          </Title>
          <Button
            icon={<ReloadOutlined />}
            onClick={() => loadOrders(userId)}
            style={{ borderColor: '#1ca8c8', color: '#1ca8c8' }}
          >
            Tai lai
          </Button>
        </Space>

        <Text type="secondary">Chi hien thi cho tai khoan da dang nhap.</Text>

        <div style={{ marginTop: 16 }}>
          <Table
            rowKey={(record) => record.id || record.orderNumber}
            columns={orderColumns}
            dataSource={orders}
            loading={loading}
            locale={{
              emptyText: <Empty description="Ban chua co don hang nao" />,
            }}
            pagination={{
              pageSize: 8,
              showSizeChanger: false,
            }}
            scroll={{ x: 780 }}
          />
        </div>
      </Card>

      <Modal
        title={selectedOrder ? `Chi tiet don ${selectedOrder.orderNumber || `#${selectedOrder.id}`}` : 'Chi tiet don hang'}
        open={detailOpen}
        onCancel={() => {
          setDetailOpen(false);
          setSelectedOrder(null);
        }}
        footer={null}
        width={920}
      >
        {detailLoading || !selectedOrder ? (
          <div style={{ minHeight: 240, display: 'grid', placeItems: 'center' }}>
            <Spin />
          </div>
        ) : (
          <>
            <Space direction="vertical" size={6} style={{ marginBottom: 16 }}>
              <Text>
                <strong>Ngay dat:</strong>{' '}
                {selectedOrder.createdAt ? new Date(selectedOrder.createdAt).toLocaleString('vi-VN') : '-'}
              </Text>
              <Text>
                <strong>Trang thai:</strong>{' '}
                <Tag color={statusTagColor(selectedOrder.status)} style={{ marginInlineStart: 6 }}>
                  {selectedOrder.status || 'UNKNOWN'}
                </Tag>
              </Text>
              <Text>
                <strong>Tong tien:</strong> {formatVnd(selectedOrder.totalAmount || 0)}
              </Text>
              {selectedOrder.shippingAddress ? (
                <Text>
                  <strong>Dia chi giao hang:</strong> {selectedOrder.shippingAddress}
                </Text>
              ) : null}
              {selectedOrder.phoneNumber ? (
                <Text>
                  <strong>So dien thoai:</strong> {selectedOrder.phoneNumber}
                </Text>
              ) : null}
            </Space>

            <Table
              rowKey={(record, index) => record.id || `${record.productId || 'item'}-${index}`}
              columns={itemColumns}
              dataSource={selectedOrder.items || []}
              pagination={false}
              locale={{ emptyText: 'Khong co san pham trong don' }}
              scroll={{ x: 720 }}
            />
          </>
        )}
      </Modal>

      <style jsx>{`
        .purchase-history-page {
          min-height: calc(100vh - 120px);
          background: #f5f7fa;
          padding: 24px;
        }
        .purchase-history-card {
          max-width: 1200px;
          margin: 0 auto;
          border-radius: 12px;
          box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        }
        :global(.purchase-history-page .ant-table-thead > tr > th) {
          background: #fafafa;
          font-weight: 700;
        }
        :global(.purchase-history-page .ant-btn:hover) {
          border-color: #1691b0 !important;
          color: #1691b0 !important;
        }
        @media (max-width: 768px) {
          .purchase-history-page {
            padding: 12px;
          }
        }
      `}</style>
    </div>
  );
}
