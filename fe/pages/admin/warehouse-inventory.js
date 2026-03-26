import { useState, useEffect } from 'react';
import { Table, Typography, message, Select, Button, InputNumber, Modal, Form } from 'antd';
import {
  fetchWarehouses,
  fetchWarehouseProducts,
  addOrUpdateWarehouseProduct,
  updateWarehouseProductStock,
  removeWarehouseProduct,
  fetchProducts
} from '../../services/api';

const { Title } = Typography;

export default function WarehouseInventoryPage() {
  const [warehouses, setWarehouses] = useState([]);
  const [selectedWarehouse, setSelectedWarehouse] = useState(null);
  const [inventory, setInventory] = useState([]);
  const [loading, setLoading] = useState(false);
  const [formVisible, setFormVisible] = useState(false);
  const [editing, setEditing] = useState(null);
  const [form] = Form.useForm();
  const [products, setProducts] = useState([]);

  useEffect(() => {
    // try a few times in case the inventory service is just starting and
    // the gateway returns a transient 500/connection-refused error.
    let attempts = 0;
    const loadWarehouses = () => {
      attempts += 1;
      fetchWarehouses()
        .then(setWarehouses)
        .catch(err => {
          if (attempts < 3) {
            setTimeout(loadWarehouses, 500); // half‑second backoff
          } else {
            message.error('Cannot load warehouses');
          }
        });
    };
    loadWarehouses();

    fetchProducts(0, 1000, { status: 'ACTIVE' }).then(r => setProducts(r.content || [])).catch(() => {});
  }, []);

  useEffect(() => {
    if (selectedWarehouse) {
      setLoading(true);
      fetchWarehouseProducts(selectedWarehouse)
        .then(setInventory)
        .catch(() => message.error('Failed to load inventory'))
        .finally(() => setLoading(false));
    } else {
      setInventory([]);
    }
  }, [selectedWarehouse]);

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
      ? updateWarehouseProductStock(selectedWarehouse, editing.productId, { quantity: values.quantity })
      : addOrUpdateWarehouseProduct(selectedWarehouse, data);
    action
      .then(() => {
        message.success('Inventory updated');
        setFormVisible(false);
        setSelectedWarehouse(s => s);
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
            removeWarehouseProduct(selectedWarehouse, record.productId)
              .then(() => { message.success('Removed'); setSelectedWarehouse(s => s); })
              .catch(() => message.error('Fail'));
          }}>Delete</Button>
        </>
      )
    }
  ];

  return (
    <div>
      <Title level={2}>Warehouse Inventory</Title>
      <div style={{ marginBottom: 12 }}>
        <Select
          placeholder="Choose a warehouse"
          value={selectedWarehouse}
          style={{ width: 240 }}
          onChange={val => setSelectedWarehouse(val)}
        >
          {warehouses.map(w => <Select.Option key={w.warehouseId} value={w.warehouseId}>{w.warehouseName}</Select.Option>)}
        </Select>
        <Button
          type="primary"
          disabled={!selectedWarehouse}
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
        title={editing ? 'Edit stock' : 'Add product to warehouse'}
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
