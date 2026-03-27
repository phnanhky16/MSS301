import { useState, useEffect } from 'react';
import { Table, Typography, message, Input, DatePicker, Select, Button, Modal, Tag, App as AntApp } from 'antd';
import { CopyOutlined } from '@ant-design/icons';
import { InfoCircleOutlined } from '@ant-design/icons';
import { fetchOrders, fetchOrderById } from '../../services/api';
import { formatVnd } from '../../utils/currency';

const { Title } = Typography;

export default function OrdersPage() {
  const { message } = AntApp.useApp();
  const [orders, setOrders] = useState([]);
  const [total, setTotal] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  const [filters, setFilters] = useState({});
  const [sort, setSort] = useState('createdAt,desc');
  const [detail, setDetail] = useState(null);
  const [orderNumberInput, setOrderNumberInput] = useState('');
  const [detailOpen, setDetailOpen] = useState(false);

  const load = (page = currentPage - 1, size = pageSize) => {
    fetchOrders(page, size, { ...filters, sort })
      .then(response => {
        setOrders(response.content);
        setTotal(response.totalElements);
        setCurrentPage(response.number + 1);
        setPageSize(response.size);
      })
      .catch(() => message.error('Failed to load orders'));
  };

  useEffect(() => {
    load();
  }, []);

  // whenever filters or sort change we automatically reload the first page
  // (we no longer need to guard against currentPage, always perform reload)
  // whenever non-orderNumber filters or sort change we automatically reload
  useEffect(() => {
    // do not fire when only orderNumberInput changes; those are handled by Search button
    load(0, pageSize);
  }, [filters.status, filters.date, filters.startDate, filters.endDate, sort]);

  // define table columns after effects
  const columns = [
    { title: 'ID', dataIndex: 'id', key: 'id' },
    {
      title: 'Order Number',
      dataIndex: 'orderNumber',
      key: 'orderNumber',
      render: num => (
        <span>
          {num}{' '}
          <CopyOutlined
            style={{ cursor: 'pointer' }}
            onClick={() => {
              if (navigator.clipboard) {
                navigator.clipboard.writeText(num);
                message.success('Copied order number');
              }
            }}
          />
        </span>
      )
    },
    {
      title: 'Status',
      dataIndex: 'status',
      key: 'status',
      render: status => {
        // colour based on actual OrderStatus values
        let color = 'default';
        switch (status) {
          case 'PENDING':
            color = 'blue';
            break;
          case 'CONFIRMED':
            color = 'green';
            break;
          case 'PROCESSING':
            color = 'purple';
            break;
          case 'SHIPPED':
            color = 'orange';
            break;
          case 'DELIVERED':
            color = 'cyan';
            break;
          case 'CANCELLED':
            color = 'red';
            break;
          case 'REFUNDED':
            color = 'magenta';
            break;
        }
        return <Tag color={color}>{status}</Tag>;
      }
    },
    { title: 'Total', dataIndex: 'totalAmount', key: 'totalAmount', render: (val) => formatVnd(val) },
    {
      title: 'Action',
      key: 'action',
      render: (_text, record) => (
        <InfoCircleOutlined style={{ cursor: 'pointer' }} onClick={() => showDetail(record.id)} />
      )
    }
  ];

  function showDetail(id) {
    fetchOrderById(id)
      .then(resp => {
        setDetail(resp);
        setDetailOpen(true);
      })
      .catch(() => message.error('Failed to load order details'));
  }

  return (
    <div>
      <Title level={2}>Orders</Title>
      <div style={{ marginBottom: 16, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <Input
          placeholder="Order number"
          style={{ width: 160 }}
          value={orderNumberInput}
          onChange={e => setOrderNumberInput(e.target.value)}
        />
        <Select
          placeholder="Status"
          style={{ width: 140 }}
          value={filters.status}
          allowClear
          onChange={val => setFilters(f => ({ ...f, status: val }))}
        >
          <Select.Option value="PENDING">Pending</Select.Option>
          <Select.Option value="CONFIRMED">Confirmed</Select.Option>
          <Select.Option value="PROCESSING">Processing</Select.Option>
          <Select.Option value="SHIPPED">Shipped</Select.Option>
          <Select.Option value="DELIVERED">Delivered</Select.Option>
          <Select.Option value="CANCELLED">Cancelled</Select.Option>
          <Select.Option value="REFUNDED">Refunded</Select.Option>
        </Select>
        <DatePicker placeholder="Date" onChange={date => setFilters(f => ({ ...f, date: date ? date.toISOString() : undefined }))} />
        <Select value={sort} onChange={setSort} style={{ width: 140 }} allowClear placeholder="Sort">
          <Select.Option value="createdAt,desc">Newest</Select.Option>
          <Select.Option value="createdAt,asc">Oldest</Select.Option>
          <Select.Option value="totalAmount,asc">Low price</Select.Option>
          <Select.Option value="totalAmount,desc">High price</Select.Option>
        </Select>
        {/* search button removed; filtering happens immediately */}
        {/* search button for order number; other filters auto-load */}
        <Button type="primary" onClick={() => {
          // trim whitespace before applying
          const trimmed = orderNumberInput.trim();
          setOrderNumberInput(trimmed);
          setFilters(f => ({ ...f, orderNumber: trimmed || undefined }));
          load(0, pageSize);
        }}>Search</Button>
        <Button onClick={() => {
          setOrderNumberInput('');
          setFilters({});
          setSort('');
          load(0, pageSize);
        }}>Clear</Button>
      </div>
      <Table
        dataSource={orders}
        columns={columns}
        rowKey="id"
        pagination={{
          current: currentPage,
          pageSize,
          total,
          onChange: (page, size) => load(page - 1, size),
        }}
        onChange={(pagination, tableFilters, sorter) => {
          // if user sorts by a column we map to our backend sort string
          if (sorter && sorter.field) {
            const order = sorter.order === 'ascend' ? 'asc' : 'desc';
            setSort(`${sorter.field},${order}`);
            load(pagination.current - 1, pagination.pageSize);
          }
        }}
      />
      <Modal
        open={detailOpen}
        title={`Order #${detail?.orderNumber}`}
        footer={null}
        onCancel={() => setDetailOpen(false)}
        width={800}
      >
        {detail && (
          <div>
            <p>
              <strong>Order #:</strong> {detail.orderNumber}{' '}
              <CopyOutlined
                style={{ cursor: 'pointer' }}
                onClick={() => {
                  if (navigator.clipboard) {
                    navigator.clipboard.writeText(detail.orderNumber);
                    message.success('Copied order number');
                  }
                }}
              />
            </p>
            <p><strong>Created:</strong> {detail.createdAt}</p>
            <p><strong>Status:</strong> {detail.status}</p>
            <p><strong>Total:</strong> {formatVnd(detail.totalAmount)}</p>
            {detail.couponCode && <p><strong>Coupon:</strong> {detail.couponCode}</p>}
            <p><strong>Shipping:</strong> {detail.shippingAddress}</p>
            <p><strong>Phone:</strong> {detail.phoneNumber}</p>
            <p><strong>Notes:</strong> {detail.notes}</p>
            <Table
              dataSource={detail.items}
              columns={[
                { title: 'Product', dataIndex: 'productName', key: 'productName' },
                { title: 'Qty', dataIndex: 'quantity', key: 'quantity' },
                { title: 'Unit', dataIndex: 'unitPrice', key: 'unitPrice', render: v => formatVnd(v) },
                { title: 'Subtotal', dataIndex: 'subtotal', key: 'subtotal', render: v => formatVnd(v) },
              ]}
              pagination={false}
              rowKey="id"
            />
          </div>
        )}
      </Modal>

      <style jsx>{`
        :global(.admin-page-container) {
          padding: 24px;
          background: #f5f7fa;
          min-height: 100vh;
        }
        :global(.admin-page-title) {
          color: #1a1a1a;
          font-weight: 800;
          margin-bottom: 24px !important;
          padding-bottom: 16px;
          border-bottom: 2px solid #1ca8c8;
        }
        :global(.admin-filter-bar) {
          background: white;
          padding: 16px;
          border-radius: 8px;
          margin-bottom: 20px;
          display: flex;
          gap: 12px;
          flex-wrap: wrap;
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        }
        :global(.admin-filter-bar input),
        :global(.admin-filter-bar .ant-select),
        :global(.admin-filter-bar .ant-picker) {
          min-width: 140px;
        }
        :global(.admin-table-wrapper) {
          background: white;
          border-radius: 8px;
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
          overflow: hidden;
        }
        :global(.admin-table-wrapper .ant-table) {
          font-size: 14px;
        }
        :global(.admin-table-wrapper .ant-table-thead > tr > th) {
          background: #fafafa;
          color: #1a1a1a;
          font-weight: 600;
          border-bottom: 2px solid #e8e8e8;
        }
        :global(.admin-table-wrapper .ant-table-tbody > tr:hover > td) {
          background: #f9f9f9;
        }
        :global(.ant-btn-primary) {
          background: #1ca8c8 !important;
          border-color: #1ca8c8 !important;
        }
        :global(.ant-btn-primary:hover) {
          background: #1691b0 !important;
        }
        @media (max-width: 768px) {
          :global(.admin-page-container) {
            padding: 16px;
          }
          :global(.admin-filter-bar) {
            flex-direction: column;
          }
          :global(.admin-filter-bar input),
          :global(.admin-filter-bar .ant-select),
          :global(.admin-filter-bar .ant-picker) {
            width: 100%;
          }
        }
      `}</style>
    </div>
  );
}