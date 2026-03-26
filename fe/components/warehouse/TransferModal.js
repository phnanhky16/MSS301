import React, { useState, useEffect } from 'react';
import { Modal, Form, Input, Select, InputNumber, Button, Alert, message, Space } from 'antd';
import { transferWarehouseStock, fetchWarehouses } from '../../services/api';

const { Option } = Select;

export default function TransferModal({ open, onCancel, onSuccess, product, fromWarehouseId }) {
    const [form] = Form.useForm();
    const [loading, setLoading] = useState(false);
    const [warehouses, setWarehouses] = useState([]);

    useEffect(() => {
        if (open) {
            loadWarehouses();
            form.setFieldsValue({
                productId: product?.productId,
                productName: product?.productName,
                quantity: 1
            });
        }
    }, [open, product]);

    const loadWarehouses = async () => {
        try {
            const res = await fetchWarehouses();
            setWarehouses((res || []).filter(w => w.warehouseId !== fromWarehouseId && w.isActive));
        } catch (err) {
            console.error("Failed to load destination warehouses", err);
        }
    };

    const handleFinish = async (values) => {
        setLoading(true);
        try {
            const payload = {
                fromWarehouseId: fromWarehouseId,
                toWarehouseId: values.toWarehouseId,
                productId: product.productId,
                quantity: values.quantity,
                notes: values.notes
            };
            const result = await transferWarehouseStock(payload);
            message.success(`Successfully transferred ${values.quantity} units to ${result.toWarehouseName}`);
            onSuccess();
            onCancel();
        } catch (err) {
            message.error(err.message || "Failed to transfer stock");
        } finally {
            setLoading(false);
        }
    };

    return (
        <Modal
            title={`Transfer Stock: ${product?.productName}`}
            open={open}
            onCancel={onCancel}
            footer={null}
            destroyOnClose
        >
            <Form
                form={form}
                layout="vertical"
                onFinish={handleFinish}
                initialValues={{ quantity: 1 }}
            >
                <Alert 
                    message={`Available Stock: ${product?.quantity || 0}`} 
                    type="info" 
                    showIcon 
                    style={{ marginBottom: '20px' }}
                />

                <Form.Item label="Product ID" name="productId">
                    <Input disabled />
                </Form.Item>

                <Form.Item 
                    label="Destination Warehouse" 
                    name="toWarehouseId" 
                    rules={[{ required: true, message: 'Please select destination warehouse' }]}
                >
                    <Select placeholder="Select warehouse">
                        {warehouses.map(w => (
                            <Option key={w.warehouseId} value={w.warehouseId}>
                                {w.warehouseName} ({w.warehouseCode})
                            </Option>
                        ))}
                    </Select>
                </Form.Item>

                <Form.Item 
                    label="Transfer Quantity" 
                    name="quantity" 
                    rules={[
                        { required: true, message: 'Please enter quantity' },
                        { type: 'number', min: 1, max: product?.quantity || 0, message: 'Invalid quantity' }
                    ]}
                >
                    <InputNumber style={{ width: '100%' }} />
                </Form.Item>

                <Form.Item label="Notes (Optional)" name="notes">
                    <Input.TextArea rows={3} placeholder="Reason for transfer..." />
                </Form.Item>

                <Form.Item style={{ marginBottom: 0, textAlign: 'right' }}>
                    <Space>
                        <Button onClick={onCancel}>Cancel</Button>
                        <Button type="primary" htmlType="submit" loading={loading}>
                            Confirm Transfer
                        </Button>
                    </Space>
                </Form.Item>
            </Form>
        </Modal>
    );
}
