import { useEffect, useState } from 'react';
import { App as AntApp, Button, Input, Popconfirm, Select, Space, Table, Typography } from 'antd';
import { deleteUserPermanently, fetchArchivedUsers, restoreUser } from '../../services/api';

const { Title } = Typography;

export default function ArchivedUsersPage() {
  const { message } = AntApp.useApp();
  const [users, setUsers] = useState([]);
  const [total, setTotal] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  const [filters, setFilters] = useState({});
  const [loading, setLoading] = useState(false);
  const [workingId, setWorkingId] = useState(null);

  const load = (page = currentPage - 1, size = pageSize) => {
    setLoading(true);
    fetchArchivedUsers(page, size, filters)
      .then(response => {
        setUsers(response.content || []);
        setTotal(response.totalElements || 0);
        setCurrentPage((response.number || 0) + 1);
        setPageSize(response.size || size);
      })
      .catch(() => {
        message.error('Failed to load archived users');
      })
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    load(0, pageSize);
  }, []);

  useEffect(() => {
    load(0, pageSize);
  }, [filters]);

  const onRestore = id => {
    setWorkingId(id);
    restoreUser(id)
      .then(() => {
        message.success('User restored');
        load(0, pageSize);
      })
      .catch(() => message.error('Restore failed'))
      .finally(() => setWorkingId(null));
  };

  const onPermanentDelete = id => {
    setWorkingId(id);
    deleteUserPermanently(id)
      .then(() => {
        message.success('User permanently deleted');
        load(0, pageSize);
      })
      .catch(() => message.error('Permanent delete failed'))
      .finally(() => setWorkingId(null));
  };

  const columns = [
    { title: 'ID', dataIndex: 'id', key: 'id' },
    { title: 'Full Name', dataIndex: 'fullName', key: 'fullName' },
    { title: 'Username', dataIndex: 'userName', key: 'userName' },
    { title: 'Email', dataIndex: 'email', key: 'email' },
    { title: 'Phone', dataIndex: 'phone', key: 'phone' },
    { title: 'Role', dataIndex: 'role', key: 'role' },
    {
      title: 'Action',
      key: 'action',
      render: (_, record) => (
        <Space size={8} wrap>
          <Button
            type="link"
            onClick={() => onRestore(record.id)}
            loading={workingId === record.id}
          >
            Restore
          </Button>
          <Popconfirm
            title="Permanent delete user?"
            description="This cannot be undone and frees email/username for new registration."
            okText="Delete permanently"
            okButtonProps={{ danger: true }}
            cancelText="Cancel"
            onConfirm={() => onPermanentDelete(record.id)}
          >
            <Button type="link" danger loading={workingId === record.id}>
              Delete permanently
            </Button>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div>
      <Title level={2}>Archived Users</Title>
      <div style={{ marginBottom: 12, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <Input
          placeholder="Search name, username, email, phone"
          style={{ width: 280 }}
          value={filters.keyword || ''}
          onChange={e => setFilters(f => ({ ...f, keyword: e.target.value }))}
          allowClear
        />
        <Select
          placeholder="Role"
          style={{ width: 180 }}
          allowClear
          value={filters.role}
          onChange={val => setFilters(f => ({ ...f, role: val }))}
        >
          <Select.Option value="CUSTOMER">Customer</Select.Option>
          <Select.Option value="STAFF_FOR_STORE">Store Staff</Select.Option>
          <Select.Option value="STAFF_FOR_WAREHOUSE">Warehouse Staff</Select.Option>
          <Select.Option value="ADMIN">Admin</Select.Option>
        </Select>
        <Button onClick={() => setFilters({})}>Clear</Button>
      </div>
      <Table
        dataSource={users}
        columns={columns}
        rowKey="id"
        loading={loading}
        pagination={{
          current: currentPage,
          pageSize,
          total,
          onChange: (page, size) => load(page - 1, size),
        }}
      />
    </div>
  );
}
