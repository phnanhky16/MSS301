import { useState, useEffect } from 'react';
import { Table, Typography, message, Button, Input, Modal, Form, Switch } from 'antd';
import { fetchWarehouses, createWarehouse, updateWarehouse, deleteWarehouse } from '../../services/api';

const { Title } = Typography;

export default function WarehousesPage() {
  const [warehouses, setWarehouses] = useState([]);
  const [loading, setLoading] = useState(false);
  const [formVisible, setFormVisible] = useState(false);
  const [editing, setEditing] = useState(null);
  const [form] = Form.useForm();

  const load = () => {
    setLoading(true);
    fetchWarehouses()
      .then(res => setWarehouses(res))
      .catch(() => message.error('Failed to load warehouses'))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    load();
  }, []);

  function openForm(item) {
    if (item) {
      setEditing(item);
      form.setFieldsValue({
        warehouseName: item.warehouseName,
        warehouseCode: item.warehouseCode,
        isActive: item.isActive,
      });
    } else {
      setEditing(null);
      form.resetFields();
    }
    setFormVisible(true);
  }

  function handleSubmit(values) {
    const payload = {
      warehouseCode: values.warehouseCode,
      warehouseName: values.warehouseName,
      isActive: values.isActive,
    };
    const action = editing
      ? updateWarehouse(editing.warehouseId, payload)
      : createWarehouse(payload);
    action
      .then(() => {
        message.success('Warehouse saved');
        setFormVisible(false);
        load();
      })
      .catch(() => message.error('Failed to save warehouse'));
  }

  const columns = [
    { title: 'ID', dataIndex: 'warehouseId', key: 'warehouseId' },
    { title: 'Name', dataIndex: 'warehouseName', key: 'warehouseName' },
    { title: 'Code', dataIndex: 'warehouseCode', key: 'warehouseCode' },
    { title: 'Status', dataIndex: 'isActive', key: 'isActive', render: v => (v ? 'Active' : 'Inactive') },
    {
      title: 'Action',
      key: 'action',
      render: (_text, record) => (
        <>
          <Button type="link" onClick={() => openForm(record)}>Edit</Button>
          <Button
            type="link"
            danger
            onClick={() => {
              deleteWarehouse(record.warehouseId)
                .then(() => {
                  message.success('Deleted');
                  load();
                })
                .catch(() => message.error('Delete failed'));
            }}
          >
            Delete
          </Button>
        </>
      ),
    },
  ];

  return (
    <div>
      <Title level={2}>Warehouses</Title>
      <Button type="primary" style={{ marginBottom: 12 }} onClick={() => openForm(null)}>
        Add warehouse
      </Button>
      <Table
        dataSource={warehouses}
        columns={columns}
        rowKey="warehouseId"
        loading={loading}
      />

      <Modal
        title={editing ? 'Edit warehouse' : 'New warehouse'}
        open={formVisible}
        onCancel={() => setFormVisible(false)}
        onOk={() => {
          form.validateFields().then(handleSubmit);
        }}
      >
        <Form form={form} layout="vertical">
          <Form.Item name="warehouseName" label="Name" rules={[{ required: true }]}
          >
            <Input />
          </Form.Item>
          <Form.Item name="warehouseCode" label="Code" rules={[{ required: true }]}
          >
            <Input />
          </Form.Item>
          <Form.Item name="isActive" valuePropName="checked">
            <Switch checkedChildren="Active" unCheckedChildren="Inactive" />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
