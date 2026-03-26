import { useState, useEffect } from 'react';
import { Table, Typography, message, Select, Button, InputNumber, Modal, Form } from 'antd';
import { fetchStores, fetchInventoryByStore, addOrUpdateInventory, updateStock, removeInventory, fetchProducts } from '../../services/api';

const { Title } = Typography;

export default function InventoryPage() {
  const [stores, setStores] = useState([]);
  const [selectedStore, setSelectedStore] = useState(null);
  const [inventory, setInventory] = useState([]);
  const [loading, setLoading] = useState(false);
  const [formVisible, setFormVisible] = useState(false);
  const [editing, setEditing] = useState(null);
  const [form] = Form.useForm();
  const [products, setProducts] = useState([]);

  useEffect(() => {
    fetchStores().then(setStores).catch(() => message.error('Cannot load stores'));
    // load product list for dropdown
    fetchProducts(0, 1000, { status: 'ACTIVE' }).then(r => setProducts(r.content || [])).catch(() => {});
  }, []);

  useEffect(() => {
    if (selectedStore) {
      setLoading(true);
      fetchInventoryByStore(selectedStore)
        .then(setInventory)
        .catch(() => message.error('Failed to load inventory'))
        .finally(() => setLoading(false));
    } else {
      setInventory([]);
    }
  }, [selectedStore]);

  function openForm(item) {
    setEditing(item);
    if (item) {
      form.setFieldsValue({ productId: item.productId, quantity: item.quantity });
    } else {
      form.resetFields();
    }
    setFormVisible(true);
  }

  function handleSubmit(values) {
    const prod = products.find(p => p.id === values.productId);
    const data = { 
      productId: values.productId, 
      productName: prod ? prod.name : '',
      quantity: values.quantity 
    };
    const action = editing
      ? updateStock(selectedStore, editing.productId, { quantity: values.quantity })
      : addOrUpdateInventory(selectedStore, data);
    action
      .then(() => {
        message.success('Inventory updated');
        setFormVisible(false);
        // refresh list
        setSelectedStore(s => s); // trigger useEffect
      })
      .catch(() => message.error('Failed to save'));
  }

  const columns = [
    { 
      title: 'Product', 
      key: 'productName', 
      render: (_, r) => {
        const found = products.find(p => p.id === r.productId);
        return r.productName || (found ? found.name : `Product #${r.productId}`);
      }
    },
    { title: 'Quantity', dataIndex: 'quantity', key: 'quantity' },
    {
      title: 'Action', key: 'action', render: (_t, record) => (
        <>
          <Button type="link" onClick={() => openForm(record)}>Edit</Button>
          <Button type="link" danger onClick={() => {
            removeInventory(selectedStore, record.productId)
              .then(() => { message.success('Removed'); setSelectedStore(s => s); })
              .catch(() => message.error('Fail'));
          }}>Delete</Button>
        </>
      )
    }
  ];

  return (
    <div>
      <Title level={2}>Store Inventory</Title>
      <div style={{ marginBottom: 12 }}>
        <Select
          placeholder="Choose a store"
          value={selectedStore}
          style={{ width: 240 }}
          onChange={val => setSelectedStore(val)}
        >
          {stores.map(s => <Select.Option key={s.storeId} value={s.storeId}>{s.storeName}</Select.Option>)}
        </Select>
        <Button
          type="primary"
          disabled={!selectedStore}
          style={{ marginLeft: 8 }}
          onClick={() => openForm(null)}
        >
          Add inventory
        </Button>
      </div>
      <Table
        dataSource={inventory}
        columns={columns}
        rowKey="productId"
        loading={loading}
      />

      <Modal
        title={editing ? 'Edit stock' : 'Add product to inventory'}
        open={formVisible}
        onCancel={() => setFormVisible(false)}
        onOk={() => { form.validateFields().then(handleSubmit); }}
      >
        <Form form={form} layout="vertical">
          {!editing && (
            <Form.Item name="productId" label="Product" rules={[{ required: true }]}> 
              <Select showSearch optionFilterProp="children">
                {products.map(p => <Select.Option key={p.id} value={p.id}>{p.name}</Select.Option>)}
              </Select>
            </Form.Item>
          )}
          <Form.Item name="quantity" label="Quantity" rules={[{ required: true }]}> 
            <InputNumber min={0} style={{ width: '100%' }} />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
