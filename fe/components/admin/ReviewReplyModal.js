import React, { useState, useEffect } from 'react';
import { Modal, Input, Rate, Space, Typography, Form, message } from 'antd';

const { Text, Paragraph } = Typography;
const { TextArea } = Input;

export default function ReviewReplyModal({ 
    open, 
    onCancel, 
    review, 
    onSuccess, 
    mode = 'reply' 
}) {
    const [form] = Form.useForm();
    const [submitting, setSubmitting] = useState(false);

    useEffect(() => {
        if (open && review) {
            form.setFieldsValue({
                reply: review.adminReply || '',
                reason: review.hiddenReason || ''
            });
        }
    }, [open, review, form]);

    const handleSubmit = async () => {
        try {
            const values = await form.validateFields();
            setSubmitting(true);
            
            // Note: Caller (Review Management Page) will provide the actual API call
            await onSuccess(review.id, values);
            
            message.success(mode === 'reply' ? "Reply saved" : "Visibility updated");
            form.resetFields();
        } catch (err) {
            if (err.errorFields) return; // Validation error
            message.error("Action failed");
        } finally {
            setSubmitting(false);
        }
    };

    if (!review) return null;

    return (
        <Modal
            title={mode === 'reply' ? "Reply to Review" : "Moderate Review"}
            open={open}
            onCancel={onCancel}
            onOk={handleSubmit}
            confirmLoading={submitting}
            width={600}
        >
            <div style={{ marginBottom: 16, padding: '12px', background: '#f5f5f5', borderRadius: '4px' }}>
                <Space direction="vertical" style={{ width: '100%' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                        <Text strong>{review.user?.fullName || `User #${review.userId}`}</Text>
                        <Rate disabled defaultValue={review.rating} style={{ fontSize: 14 }} />
                    </div>
                    <Paragraph ellipsis={{ rows: 2, expandable: true }}>
                        {review.comment}
                    </Paragraph>
                    <Text type="secondary" style={{ fontSize: 12 }}>
                        Product: {review.product?.productName || `ID: ${review.productId}`}
                    </Text>
                </Space>
            </div>

            <Form form={form} layout="vertical">
                {mode === 'reply' ? (
                    <Form.Item
                        name="reply"
                        label="Admin Reply"
                        rules={[{ required: true, message: 'Please enter a reply' }]}
                    >
                        <TextArea rows={4} placeholder="Write your response to the customer..." />
                    </Form.Item>
                ) : (
                    <Form.Item
                        name="reason"
                        label="Reason for Hiding"
                        rules={[{ required: true, message: 'Please provide a reason for hiding' }]}
                    >
                        <TextArea rows={3} placeholder="e.g. Inappropriate language, spam, etc." />
                    </Form.Item>
                )}
            </Form>
        </Modal>
    );
}
