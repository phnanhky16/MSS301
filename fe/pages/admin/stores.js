import { useState, useEffect } from 'react';
import { Table, Typography, message, Button, Input, Modal, Form, Switch } from 'antd';
import { fetchStores, createStore, updateStore, deleteStore } from '../../services/api';

const { Title } = Typography;

export default function StoresPage() {
  const [stores, setStores] = useState([]);
  const [loading, setLoading] = useState(false);
  const [formVisible, setFormVisible] = useState(false);
  const [editing, setEditing] = useState(null);
  const [form] = Form.useForm();

  const load = () => {
    setLoading(true);
    fetchStores()
      .then(res => setStores(res))
      .catch(() => message.error('Failed to load stores'))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    load();
  }, []);

  function openForm(item) {
    if (item) {
      setEditing(item);
      // form uses backend field names directly
      form.setFieldsValue({
        storeName: item.storeName,
        storeCode: item.storeCode,
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
      storeCode: values.storeCode,
      storeName: values.storeName,
      isActive: values.isActive,
    };
    const action = editing
      ? updateStore(editing.storeId, payload)
      : createStore(payload);
    action
      .then(() => {
        message.success('Store saved');
        setFormVisible(false);
        load();
      })
      .catch(() => message.error('Failed to save store'));
  }

  const columns = [
    { title: 'ID', dataIndex: 'storeId', key: 'storeId' },
    { title: 'Name', dataIndex: 'storeName', key: 'storeName' },
    { title: 'Code', dataIndex: 'storeCode', key: 'storeCode' },
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
              deleteStore(record.storeId)
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
      <Title level={2}>Stores</Title>
      <Button type="primary" style={{ marginBottom: 12 }} onClick={() => openForm(null)}>
        Add store
      </Button>
      <Table
        dataSource={stores}
        columns={columns}
        rowKey="storeId"
        loading={loading}
      />

      <Modal
        title={editing ? 'Edit store' : 'New store'}
        open={formVisible}
        onCancel={() => setFormVisible(false)}
        onOk={() => {
          form.validateFields().then(handleSubmit);
        }}
      >
        <Form form={form} layout="vertical">
          <Form.Item name="storeName" label="Name" rules={[{ required: true }]}
          >
            <Input />
          </Form.Item>
          <Form.Item name="storeCode" label="Code" rules={[{ required: true }]}
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
