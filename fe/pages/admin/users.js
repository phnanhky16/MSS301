import { useState, useEffect } from 'react';
import { Table, Typography, message, Button } from 'antd';
import { fetchUsers, deleteUser } from '../../services/api';

const { Title } = Typography;

export default function UsersPage() {
  const [users, setUsers] = useState([]);
  const [total, setTotal] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  const [loadError, setLoadError] = useState(null);

  const load = (page = currentPage - 1, size = pageSize) => {
    fetchUsers(page, size)
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
      render: val => (val ? 'Active' : 'Inactive'),
    },
    { title: 'Role', dataIndex: 'role', key: 'role' },
    {
      title: 'Action',
      key: 'action',
      render: (_text, record) => (
        <Button
          type="link"
          danger
          onClick={() => {
            deleteUser(record.id, true)
              .then(() => {
                message.success('Deleted');
                load(0, pageSize);
              })
              .catch(() => message.error('Delete failed'));
          }}
        >
          Delete
        </Button>
      )
    }
  ];

  return (
    <div>
      <Title level={2}>Users</Title>
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