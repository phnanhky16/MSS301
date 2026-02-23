import { useState, useEffect } from 'react';
import { Table, Typography, message, Input, Select, Button, Modal, Form, InputNumber } from 'antd';
import { fetchProducts, fetchCategories, fetchBrands, createProduct, updateProduct, deleteProduct } from '../../services/api';

const { Title } = Typography;

export default function ProductsPage() {
  const [products, setProducts] = useState([]);
  const [total, setTotal] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  const [filters, setFilters] = useState({});
  const [sort, setSort] = useState('createdAt,desc');
  const [categories, setCategories] = useState([]);
  const [brands, setBrands] = useState([]);
  const [formVisible, setFormVisible] = useState(false);
  const [editing, setEditing] = useState(null);

  const load = (page = currentPage - 1, size = pageSize) => {
    fetchProducts(page, size, { ...filters, sort })
      .then(response => {
        setProducts(response.content);
        setTotal(response.totalElements);
        setCurrentPage(response.number + 1);
        setPageSize(response.size);
      })
      .catch(() => message.error('Failed to load products'));
  };

  useEffect(() => {
    load();
    fetchCategories().then(setCategories).catch(() => {});
    fetchBrands().then(setBrands).catch(() => {});
  }, []);

  useEffect(() => {
    load(0, pageSize);
  }, [filters.keyword, filters.categoryId, filters.brandId, sort]);

  function openForm(item) {
    setEditing(item);
    setFormVisible(true);
  }

  function handleSubmit(data) {
    const action = editing ? updateProduct(editing.id, data) : createProduct(data);
    action
      .then(() => {
        message.success('Saved');
        setFormVisible(false);
        setEditing(null);
        load(0, pageSize);
      })
      .catch(() => message.error('Error saving'));
  }

  const columns = [
    { title: 'ID', dataIndex: 'id', key: 'id' },
    { title: 'Name', dataIndex: 'name', key: 'name' },
    { title: 'Price', dataIndex: 'price', key: 'price', render: v => `$${v}` },
    { title: 'Category', dataIndex: ['category', 'name'], key: 'category' },
    { title: 'Brand', dataIndex: ['brand', 'name'], key: 'brand' },
    { title: 'Status', dataIndex: 'status', key: 'status' },
    {
      title: 'Actions',
      key: 'actions',
      render: (_text, record) => (
        <>
          <Button type="link" onClick={() => openForm(record)}>Edit</Button>
          <Button type="link" danger onClick={() => {
            deleteProduct(record.id)
              .then(() => { message.success('Deleted'); load(); })
              .catch(() => message.error('Delete failed'));
          }}>Delete</Button>
        </>
      )
    }
  ];

  return (
    <div>
      <Title level={2}>Products</Title>
      <div style={{ marginBottom: 16, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <Input
          placeholder="Keyword"
          style={{ width: 160 }}
          value={filters.keyword || ''}
          onChange={e => setFilters(f => ({ ...f, keyword: e.target.value }))}
        />
        <Select
          placeholder="Category"
          style={{ width: 160 }}
          allowClear
          value={filters.categoryId}
          onChange={val => setFilters(f => ({ ...f, categoryId: val }))}
        >
          {categories.map(c => (
            <Select.Option key={c.id} value={c.id}>{c.name}</Select.Option>
          ))}
        </Select>
        <Select
          placeholder="Brand"
          style={{ width: 160 }}
          allowClear
          value={filters.brandId}
          onChange={val => setFilters(f => ({ ...f, brandId: val }))}
        >
          {brands.map(b => (
            <Select.Option key={b.id} value={b.id}>{b.name}</Select.Option>
          ))}
        </Select>
        <Select value={sort} onChange={setSort} style={{ width: 140 }} allowClear placeholder="Sort">
          <Select.Option value="createdAt,desc">Newest</Select.Option>
          <Select.Option value="createdAt,asc">Oldest</Select.Option>
          <Select.Option value="price,asc">Low price</Select.Option>
          <Select.Option value="price,desc">High price</Select.Option>
        </Select>
        <Button onClick={() => { setFilters({}); setSort('createdAt,desc'); load(0,pageSize); }}>Clear</Button>
        <Button type="primary" onClick={() => openForm(null)}>New Product</Button>
      </div>
      <Table
        dataSource={products}
        columns={columns}
        rowKey="id"
        pagination={{
          current: currentPage,
          pageSize,
          total,
          onChange: (page, size) => load(page - 1, size),
        }}
        onChange={(pagination, tableFilters, sorter) => {
          if (sorter && sorter.field) {
            const order = sorter.order === 'ascend' ? 'asc' : 'desc';
            setSort(`${sorter.field},${order}`);
            load(pagination.current - 1, pagination.pageSize);
          }
        }}
      />
      {/* deletion not shown yet; we could add actions column if needed */}
      <ProductForm
        visible={formVisible}
        onSubmit={handleSubmit}
        onCancel={() => { setFormVisible(false); setEditing(null); }}
        categories={categories}
        brands={brands}
        initialValues={editing}
      />
    </div>
  );
}

// form component
const ProductForm = ({ visible, onSubmit, onCancel, categories, brands, initialValues }) => {
  const [form] = Form.useForm();
  useEffect(() => {
    if (visible) {
      if (initialValues) {
        form.setFieldsValue(initialValues);
      } else {
        form.resetFields();
      }
    }
  }, [visible, initialValues]);

  return (
    <Modal
      visible={visible}
      title={initialValues ? 'Edit Product' : 'New Product'}
      okText="Save"
      cancelText="Cancel"
      onCancel={onCancel}
      onOk={() => {
        form.validateFields()
          .then(values => {
            form.resetFields();
            onSubmit(values);
          })
          .catch(info => console.log('Validate Failed:', info));
      }}
    >
      <Form form={form} layout="vertical" initialValues={initialValues || {}}>
        <Form.Item name="name" label="Name" rules={[{ required: true }]}> <Input /> </Form.Item>
        <Form.Item name="description" label="Description"> <Input.TextArea /> </Form.Item>
        <Form.Item name="price" label="Price" rules={[{ required: true, type: 'number', min: 0 }]}> <InputNumber style={{ width: '100%' }} /> </Form.Item>
        <Form.Item name="categoryId" label="Category" rules={[{ required: true }]}> 
          <Select>
            {categories.map(c => <Select.Option key={c.id} value={c.id}>{c.name}</Select.Option>)}
          </Select>
        </Form.Item>
        <Form.Item name="brandId" label="Brand" rules={[{ required: true }]}> 
          <Select>
            {brands.map(b => <Select.Option key={b.id} value={b.id}>{b.name}</Select.Option>)}
          </Select>
        </Form.Item>
      </Form>
    </Modal>
  );
};
