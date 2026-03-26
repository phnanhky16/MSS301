import { useState, useEffect } from 'react';
import { Table, Typography, message, Button, Input, Modal, Form, Switch, Select, Space, Spin, Tag } from 'antd';
import { EnvironmentOutlined } from '@ant-design/icons';
import { fetchWarehouses, createWarehouse, updateWarehouse, deleteWarehouse, fetchProvinces, fetchDistricts } from '../../services/api';

const { Title, Text } = Typography;
const { Option } = Select;

export default function WarehousesPage() {
  const [warehouses, setWarehouses] = useState([]);
  const [loading, setLoading] = useState(false);
  const [formVisible, setFormVisible] = useState(false);
  const [editing, setEditing] = useState(null);
  const [form] = Form.useForm();

  // Address states
  const [provinces, setProvinces] = useState([]);
  const [districts, setDistricts] = useState([]);
  
  const [selectedProvinceId, setSelectedProvinceId] = useState(null);
  const [selectedProvinceName, setSelectedProvinceName] = useState('');
  const [selectedDistrictName, setSelectedDistrictName] = useState('');

  const [loadingProvinces, setLoadingProvinces] = useState(true);
  const [loadingDistricts, setLoadingDistricts] = useState(false);

  // Map states
  const [mapCoords, setMapCoords] = useState(null);
  const [isLocating, setIsLocating] = useState(false);

  const load = () => {
    setLoading(true);
    fetchWarehouses()
      .then(res => setWarehouses(res))
      .catch(() => message.error('Failed to load warehouses'))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    load();
    fetchProvinces()
      .then(setProvinces)
      .catch(() => message.error('Failed to load provinces'))
      .finally(() => setLoadingProvinces(false));
  }, []);

  const handleProvinceChange = async (val, option) => {
    setSelectedProvinceId(val);
    setSelectedProvinceName(option.children);
    setDistricts([]);
    form.setFieldsValue({ district: undefined });
    setLoadingDistricts(true);
    try {
      const data = await fetchDistricts(val);
      setDistricts(data);
    } catch {
      message.error('Failed to load districts');
    } finally {
      setLoadingDistricts(false);
    }
  };

  const handleDistrictChange = (_, option) => {
    setSelectedDistrictName(option.children);
  };

  function openForm(item) {
    if (item) {
      setEditing(item);
      form.setFieldsValue({
        warehouseName: item.warehouseName,
        warehouseCode: item.warehouseCode,
        address: item.address,
        city: item.city,
        district: item.district,
        phone: item.phone,
        managerName: item.managerName,
        latitude: item.latitude,
        longitude: item.longitude,
        isActive: item.isActive,
      });
      setSelectedProvinceName(item.city || '');
      setSelectedDistrictName(item.district || '');
      if (item.latitude && item.longitude) {
        setMapCoords({ lat: item.latitude, lon: item.longitude });
      } else {
        setMapCoords(null);
      }
    } else {
      setEditing(null);
      form.resetFields();
      setSelectedProvinceId(null);
      setSelectedProvinceName('');
      setSelectedDistrictName('');
      setDistricts([]);
      setMapCoords(null);
    }
    setFormVisible(true);
  }

  function handleSubmit(values) {
    const payload = {
      warehouseCode: values.warehouseCode,
      warehouseName: values.warehouseName,
      address: values.address,
      city: typeof values.city === 'number' || typeof values.city === 'string' && /^\d+$/.test(values.city) 
        ? selectedProvinceName 
        : values.city,
      district: typeof values.district === 'number' || typeof values.district === 'string' && /^\d+$/.test(values.district) 
        ? selectedDistrictName 
        : values.district,
      phone: values.phone,
      managerName: values.managerName,
      latitude: values.latitude ? parseFloat(values.latitude) : null,
      longitude: values.longitude ? parseFloat(values.longitude) : null,
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

  const handleVerifyAddress = async () => {
    const values = form.getFieldsValue(['address']);
    const street = values.address || '';
    if (!selectedDistrictName || !selectedProvinceName) {
      message.warning('Vui lòng chọn Tỉnh/Thành và Quận/Huyện trước khi xác nhận trên bản đồ.');
      return;
    }
    setIsLocating(true);
    
    const tryGeocode = async (query) => {
      try {
        const res = await fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}`);
        const data = await res.json();
        return (data && data.length > 0) ? { lat: parseFloat(data[0].lat), lon: parseFloat(data[0].lon) } : null;
      } catch (err) {
        return null;
      }
    };

    let coords = null;
    let accuracy = "exact";
    
    // Try 1: Full Address
    if (street) {
      coords = await tryGeocode(`${street}, ${selectedDistrictName}, ${selectedProvinceName}, Vietnam`);
    }
    
    // Try 2: District + City
    if (!coords) {
      accuracy = "district";
      coords = await tryGeocode(`${selectedDistrictName}, ${selectedProvinceName}, Vietnam`);
    }
    
    // Try 3: City
    if (!coords) {
      accuracy = "city";
      coords = await tryGeocode(`${selectedProvinceName}, Vietnam`);
    }

    if (coords) {
      form.setFieldsValue({ latitude: coords.lat, longitude: coords.lon });
      setMapCoords(coords);
      if (accuracy === "address" || accuracy === "exact") {
        message.success('Đã tìm thấy tọa độ chính xác!');
      } else if (accuracy === "district") {
        message.warning('Không tìm thấy địa chỉ cụ thể. Bản đồ đang hiển thị vị trí trung tâm Quận/Huyện.');
      } else {
        message.warning('Không tìm thấy điểm cụ thể. Bản đồ đang hiển thị Thành phố.');
      }
    } else {
      message.error('Hoàn toàn không tìm thấy tọa độ cho địa điểm này.');
      setMapCoords(null);
      form.setFieldsValue({ latitude: null, longitude: null });
    }
    setIsLocating(false);
  };

  const columns = [
    { title: 'ID', dataIndex: 'warehouseId', key: 'warehouseId', width: 60 },
    { title: 'Code', dataIndex: 'warehouseCode', key: 'warehouseCode' },
    { title: 'Name', dataIndex: 'warehouseName', key: 'warehouseName' },
    { title: 'Address', dataIndex: 'address', key: 'address', ellipsis: true },
    { title: 'Manager', dataIndex: 'managerName', key: 'managerName' },
    { title: 'Phone', dataIndex: 'phone', key: 'phone' },
    { title: 'Status', dataIndex: 'isActive', key: 'isActive', render: v => (v ? <Tag color="green">Active</Tag> : <Tag color="red">Inactive</Tag>) },
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
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0 16px' }}>
            <Form.Item name="warehouseName" label="Name" rules={[{ required: true }]}>
              <Input />
            </Form.Item>
            <Form.Item name="warehouseCode" label="Code" rules={[{ required: true }]}>
              <Input />
            </Form.Item>
            <Form.Item name="managerName" label="Manager Name">
              <Input />
            </Form.Item>
            <Form.Item name="phone" label="Phone">
              <Input />
            </Form.Item>
            <Form.Item name="city" label="City" rules={[{ required: true }]}>
              <Select
                showSearch
                loading={loadingProvinces}
                placeholder={loadingProvinces ? 'Loading...' : 'Select City'}
                optionFilterProp="children"
                onChange={handleProvinceChange}
              >
                {provinces.map(p => (
                  <Option key={p.id} value={p.id}>{p.name}</Option>
                ))}
              </Select>
            </Form.Item>
            <Form.Item name="district" label="District" rules={[{ required: true }]}>
              <Select
                showSearch
                loading={loadingDistricts}
                placeholder={loadingDistricts ? 'Loading...' : 'Select District'}
                optionFilterProp="children"
                onChange={handleDistrictChange}
                disabled={!selectedProvinceId && !editing}
              >
                {districts.map(d => (
                  <Option key={d.id} value={d.id}>{d.name}</Option>
                ))}
              </Select>
            </Form.Item>
            <Form.Item name="latitude" hidden>
              <Input type="number" step="any" />
            </Form.Item>
            <Form.Item name="longitude" hidden>
              <Input type="number" step="any" />
            </Form.Item>
          </div>
          <Form.Item name="address" label="Address" rules={[{ required: true }]}>
            <Input.TextArea rows={2} />
          </Form.Item>

          <Form.Item label="Xác nhận Địa chỉ Bản đồ">
            <Button 
              type="dashed" 
              icon={<EnvironmentOutlined />} 
              onClick={handleVerifyAddress} 
              loading={isLocating}
              block
            >
              Lấy Tọa độ & Xem Bản đồ
            </Button>
            {mapCoords && (
              <div style={{ marginTop: 12 }}>
                <Text type="secondary" style={{ display: 'block', marginBottom: 8 }}>
                  Tọa độ: {mapCoords.lat}, {mapCoords.lon}
                </Text>
                <iframe
                  width="100%"
                  height="250"
                  frameBorder="0"
                  style={{ border: 0, borderRadius: 8 }}
                  src={`https://maps.google.com/maps?q=${mapCoords.lat},${mapCoords.lon}&hl=vi&z=16&output=embed`}
                  allowFullScreen
                ></iframe>
              </div>
            )}
          </Form.Item>

          <Form.Item name="isActive" valuePropName="checked">
            <Switch checkedChildren="Active" unCheckedChildren="Inactive" />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
