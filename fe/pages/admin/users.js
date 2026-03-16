import { useState, useEffect } from 'react';
import { Table, Typography, Button, Input, Select, App as AntApp } from 'antd';
import { useRouter } from 'next/router';
import { fetchUsers, archiveUser, sendUserPasswordResetLink } from '../../services/api';

const { Title } = Typography;

export default function UsersPage() {
  const router = useRouter();
  const { message } = AntApp.useApp();
  const [users, setUsers] = useState([]);
  const [total, setTotal] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  const [loadError, setLoadError] = useState(null);
  const [filters, setFilters] = useState({});
  const [sendingResetId, setSendingResetId] = useState(null);

  const load = (page = currentPage - 1, size = pageSize) => {
    fetchUsers(page, size, filters)
      .then(response => {
        setUsers(response.content);
        setTotal(response.totalElements);
        setCurrentPage(response.number + 1);
        setPageSize(response.size);
        setLoadError(null);
      })
      .catch(err => {
        message.error('Failed to load users (service unavailable)');
        setLoadError(err);
        // schedule another attempt
        setTimeout(() => load(0, pageSize), 3000);
      });
  };

  useEffect(() => {
    load();
  }, []);
  useEffect(() => {
    load(0, pageSize);
  }, [filters]);

  const columns = [
    { title: 'ID', dataIndex: 'id', key: 'id' },
    { title: 'Full Name', dataIndex: 'fullName', key: 'fullName' },
    { title: 'Username', dataIndex: 'userName', key: 'userName' },
    { title: 'Email', dataIndex: 'email', key: 'email' },
    { title: 'Phone', dataIndex: 'phone', key: 'phone' },
    {
      title: 'Status',
      dataIndex: 'status',
      key: 'status',
      render: (val, record) => {
        if (record.emailVerified === false) {
          return 'Unverified';
        }
        return val ? 'Active' : 'Inactive';
      },
    },
    { title: 'Role', dataIndex: 'role', key: 'role' },
    {
      title: 'Action',
      key: 'action',
      render: (_text, record) => (
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          <Button
            type="link"
            onClick={() => {
              setSendingResetId(record.id);
              sendUserPasswordResetLink(record.id)
                .then(() => message.success(`Reset link sent to ${record.email}`))
                .catch(err => {
                  const text = err?.message || 'Send reset link failed';
                  message.error(text);
                })
                .finally(() => setSendingResetId(null));
            }}
            loading={sendingResetId === record.id}
          >
            Send reset link
          </Button>
          <Button
            type="link"
            danger
            onClick={() => {
              archiveUser(record.id)
                .then(() => {
                  message.success('Archived');
                  load(0, pageSize);
                })
                .catch(() => message.error('Archive failed'));
            }}
          >
            Archive
          </Button>
        </div>
      )
    }
  ];

  return (
    <div>
      <Title level={2}>Users</Title>
      <div style={{ marginBottom: 12, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <Input
          placeholder="Keyword"
          style={{ width: 160 }}
          value={filters.keyword || ''}
          onChange={e => setFilters(f => ({ ...f, keyword: e.target.value }))}
        />
        <Select
          placeholder="Status"
          style={{ width: 120 }}
          allowClear
          value={filters.status}
          onChange={val => {
            if (val === 'UNVERIFIED') {
              setFilters(f => {
                const next = { ...f };
                delete next.status;
                next.emailVerified = false;
                next.status = 'UNVERIFIED';
                return next;
              });
              return;
            }

            setFilters(f => {
              const next = { ...f, status: val };
              delete next.emailVerified;
              return next;
            });
          }}
        >
          <Select.Option value={true}>Active</Select.Option>
          <Select.Option value={false}>Inactive</Select.Option>
          <Select.Option value="UNVERIFIED">Unverified</Select.Option>
        </Select>
        <Select
          placeholder="Role"
          style={{ width: 160 }}
          allowClear
          value={filters.role}
          onChange={val => setFilters(f => ({ ...f, role: val }))}
        >
          <Select.Option value="CUSTOMER">Customer</Select.Option>
          <Select.Option value="STAFF_FOR_STORE">Store Staff</Select.Option>
          <Select.Option value="STAFF_FOR_WAREHOUSE">Warehouse Staff</Select.Option>
          <Select.Option value="ADMIN">Admin</Select.Option>
        </Select>
        <Button onClick={() => { setFilters({}); load(0, pageSize); }}>Clear</Button>
        <Button onClick={() => router.push('/admin/users-archived')}>Manage archived users</Button>
      </div>
      {loadError && (
        <div style={{ marginBottom: 8 }}>
          <Button onClick={() => load(0, pageSize)}>Retry</Button>
        </div>
      )}
      <Table
        dataSource={users}
        columns={columns}
        rowKey="id"
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