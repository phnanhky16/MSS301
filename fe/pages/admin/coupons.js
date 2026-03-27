import { useState, useEffect } from 'react';
import dayjs from 'dayjs';
import { Table, Button, Modal, Form, Input, InputNumber, DatePicker, Select, Switch, Typography, message, App as AntApp } from 'antd';
// Coupon icon wasn't available in the current icon set, fall back to tag
import { TagOutlined } from '@ant-design/icons';
import { fetchCoupons, createCoupon, updateCoupon, deleteCoupon } from '../../services/api';
import { formatVnd } from '../../utils/currency';

const { Title } = Typography;

const CouponForm = ({ open, onCreate, onCancel, initialValues }) => {
  const [form] = Form.useForm();
  useEffect(() => {
    if (open && initialValues) {
      form.setFieldsValue(initialValues);
    }
  }, [open, initialValues]);

  return (
    <Modal
      open={open}
      title={initialValues ? 'Edit Coupon' : 'New Coupon'}
      okText="Save"
      cancelText="Cancel"
      onCancel={onCancel}
      onOk={() => {
        form
          .validateFields()
          .then(values => {
            form.resetFields();
            onCreate(values);
          })
          .catch(info => {
            console.log('Validate Failed:', info);
          });
      }}
    >
      <Form form={form} layout="vertical" name="coupon_form" initialValues={initialValues}>
        <Form.Item
          name="code"
          label="Code"
          rules={[{ required: true, message: 'Please input coupon code!' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="discountType"
          label="Type"
          rules={[{ required: true, message: 'Please select discount type!' }]}
        >
          <Select>
            <Select.Option value="PERCENT">Percent</Select.Option>
            <Select.Option value="FIXED">Fixed</Select.Option>
          </Select>
        </Form.Item>
        <Form.Item
          name="discountValue"
          label="Value"
          rules={[{ required: true, message: 'Please input value!' }]}
        >
          <InputNumber min={0} style={{ width: '100%' }} />
        </Form.Item>
        <Form.Item name="expiresAt" label="Expires">
          <DatePicker showTime style={{ width: '100%' }} />
        </Form.Item>
        <Form.Item name="maxRedemptions" label="Max Redemptions">
          <InputNumber min={0} style={{ width: '100%' }} />
        </Form.Item>
        <Form.Item name="active" label="Active" valuePropName="checked">
          <Switch />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default function CouponsPage() {
  const { message } = AntApp.useApp();
  const [coupons, setCoupons] = useState([]);
  const [modalOpen, setModalOpen] = useState(false);
  const [editing, setEditing] = useState(null);
  const [total, setTotal] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  const [filters, setFilters] = useState({});

  const load = (page = currentPage - 1, size = pageSize) => {
    fetchCoupons(page, size, filters)
      .then(response => {
        setCoupons(response.content);
        setTotal(response.totalElements);
        setCurrentPage(response.number + 1);
        setPageSize(response.size);
      })
      .catch(e => message.error('Failed to load'));;
  };
  useEffect(() => { load(); }, []);
  // reload when filters change
  useEffect(() => {
    load(0, pageSize);
  }, [filters]);

  const handleCreate = data => {
    // serialize date
    if (data.expiresAt && data.expiresAt.toISOString) {
      data = { ...data, expiresAt: data.expiresAt.toISOString() };
    }
    const action = editing ? updateCoupon(editing.code, data) : createCoupon(data);
    action.then(() => {
      message.success('Saved');
      setModalOpen(false);
      setEditing(null);
      load();
    }).catch(() => message.error('Error saving'));
  };

  const handleDelete = record => {
    deleteCoupon(record.code)
      .then(() => {
        message.success('Deleted');
        load();
      })
      .catch(() => message.error('Error deleting'));;
  };

  const columns = [
    { title: 'ID', dataIndex: 'id', key: 'id' },
    { title: 'Code', dataIndex: 'code', key: 'code' },
    {
      title: 'Discount',
      key: 'discount',
      render: (_text, record) => {
        if (record.discountType === 'PERCENT') {
          return `${record.discountValue}%`;
        }
        if (record.discountType === 'FIXED') {
          return formatVnd(record.discountValue);
        }
        return record.discountValue;
      }
    },
    { title: 'Expires', dataIndex: 'expiresAt', key: 'expiresAt' },
    { title: 'Max Reds', dataIndex: 'maxRedemptions', key: 'maxRedemptions' },
    { title: 'Redeemed', dataIndex: 'timesRedeemed', key: 'timesRedeemed' },
    {
      title: 'Active',
      dataIndex: 'active',
      key: 'active',
      render: v => (v ? 'Yes' : 'No')
    },
    {
      title: 'Actions',
      key: 'actions',
      render: (_text, record) => (
        <>
          <Button type="link" onClick={() => {
            const copy = { ...record };
            if (copy.expiresAt) copy.expiresAt = dayjs(copy.expiresAt);
            setEditing(copy);
            setModalOpen(true);
          }}>Edit</Button>
          <Button type="link" danger onClick={() => handleDelete(record)}>Delete</Button>
        </>
      )
    }
  ];

  return (
    <div>
      <Title level={2} style={{ marginBottom: 16 }}>
        <TagOutlined style={{ marginRight: 8 }} />
        Coupons
      </Title>
      <div style={{ marginBottom: 12, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <Input
          placeholder="Code"
          style={{ width: 160 }}
          value={filters.code || ''}
          onChange={e => setFilters(f => ({ ...f, code: e.target.value }))}
        />
        <Select
          placeholder="Active"
          style={{ width: 120 }}
          allowClear
          value={filters.active}
          onChange={val => setFilters(f => ({ ...f, active: val }))}
        >
          <Select.Option value={true}>Yes</Select.Option>
          <Select.Option value={false}>No</Select.Option>
        </Select>
        <Select
          placeholder="Type"
          style={{ width: 140 }}
          allowClear
          value={filters.discountType}
          onChange={val => setFilters(f => ({ ...f, discountType: val }))}
        >
          <Select.Option value="PERCENT">Percent</Select.Option>
          <Select.Option value="FIXED">Fixed</Select.Option>
        </Select>
        <Button
          onClick={() => {
            setFilters({});
            load(0, pageSize);
          }}
        >
          Clear
        </Button>
      </div>
      <Button type="primary" onClick={() => setModalOpen(true)} style={{ marginBottom: 16 }}>
        New Coupon
      </Button>
      <Table
        dataSource={coupons}
        columns={columns}
        rowKey="code"
        pagination={{
          current: currentPage,
          pageSize,
          total,
          onChange: (page, size) => load(page - 1, size),
        }}
      />
      <CouponForm
        open={modalOpen}
        onCreate={handleCreate}
        onCancel={() => { setModalOpen(false); setEditing(null); }}
        initialValues={editing}
      />
    </div>

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
      :global(.admin-filter-bar .ant-select) {
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
        :global(.admin-filter-bar .ant-select) {
          width: 100%;
        }
      }
    `}</style>
  </div>
  );
}