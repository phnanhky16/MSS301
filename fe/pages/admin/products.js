import { useState, useEffect } from 'react';
import { fetchProducts, fetchCategories, fetchBrands, createProduct, updateProduct, deleteProduct, updateProductStatus, fetchProductImages, uploadProductImage, deleteProductImage, setPrimaryImage, updateProductImageFile, uploadMultipleProductImages, reorderProductImages, setSalePrice, removeSalePrice } from '../../services/api';
import { Table, Typography, message, Input, Select, Button, Modal, Form, InputNumber, Switch, Upload, Card, Space, Divider, Tag as AntTag, App as AntApp, DatePicker } from 'antd';
import {
  DndContext,
  closestCenter,
  KeyboardSensor,
  PointerSensor,
  useSensor,
  useSensors,
} from '@dnd-kit/core';
import {
  arrayMove,
  SortableContext,
  sortableKeyboardCoordinates,
  verticalListSortingStrategy,
  rectSortingStrategy,
  useSortable,
} from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';
import { restrictToFirstScrollableAncestor } from '@dnd-kit/modifiers';
import { DragOutlined, PlusOutlined, DeleteOutlined, StarFilled, EditOutlined, TagsOutlined } from '@ant-design/icons';
import { formatVnd } from '../../utils/currency';

const { Title } = Typography;

export default function ProductsPage() {
  const { message, modal } = AntApp.useApp();
  const [products, setProducts] = useState([]);
  const [total, setTotal] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);
  // keep status=ALL so admin sees every product
  const [filters, setFilters] = useState({ status: 'ALL' });
  const [sort, setSort] = useState('createdAt,desc');
  const [categories, setCategories] = useState([]);
  const [brands, setBrands] = useState([]);
  const [formVisible, setFormVisible] = useState(false);
  const [editing, setEditing] = useState(null);

  // Sale price modal state
  const [saleModalVisible, setSaleModalVisible] = useState(false);
  const [saleTarget, setSaleTarget] = useState(null); // product being edited
  const [saleForm] = Form.useForm();

  const load = (page = currentPage - 1, size = pageSize) => {
    // always request every status when loading the admin table
    // send `ALL` explicitly but still allow the user to change the sort column
    // if they click a header – that sort value is passed back into load()
    // onChange (see table config) and the contract with the BE is that the
    // server will ignore it when status=ALL, preventing inactive items from
    // jumping around.
    fetchProducts(page, size, { ...filters, sort, status: 'ALL' })
      .then(response => {
        setProducts(response.content);
        setTotal(response.totalElements);
        setCurrentPage(response.number + 1);
        setPageSize(response.size);
      })
      .catch(() => message.error('Failed to load products'));
  };

  useEffect(() => {
    load();
    fetchCategories().then(setCategories).catch(() => { });
    fetchBrands().then(setBrands).catch(() => { });
  }, []);

  useEffect(() => {
    load(0, pageSize);
  }, [filters.keyword, filters.categoryId, filters.brandId, sort]);

  function openForm(item) {
    if (item) {
      // backend returns product with nested category/brand objects; our form
      // expects categoryId/brandId fields. convert here so the fields populate
      // correctly when the modal opens.
      setEditing({
        ...item,
        categoryId: item.category ? item.category.id : undefined,
        brandId: item.brand ? item.brand.id : undefined,
      });
    } else {
      setEditing(null);
    }
    setFormVisible(true);
  }

  function handleSubmit(data) {
    const action = editing ? updateProduct(editing.id, data) : createProduct(data);
    action
      .then(() => {
        message.success('Product updated');
        load(0, pageSize);
        setFormVisible(false);
        setEditing(null);
      })
      .catch(() => message.error('Failed to save product'));
  }

  function openSaleModal(record) {
    setSaleTarget(record);
    saleForm.setFieldsValue({
      salePrice: record.salePrice || null,
      saleStartDate: null,
      saleEndDate: null,
    });
    setSaleModalVisible(true);
  }

  function handleSetSale() {
    saleForm.validateFields().then(values => {
      const data = {
        salePrice: values.salePrice,
        saleStartDate: values.saleStartDate ? values.saleStartDate.format('YYYY-MM-DDTHH:mm:ss') : null,
        saleEndDate: values.saleEndDate ? values.saleEndDate.format('YYYY-MM-DDTHH:mm:ss') : null,
      };
      setSalePrice(saleTarget.id, data)
        .then(() => {
          message.success('Sale price updated!');
          setSaleModalVisible(false);
          load(currentPage - 1, pageSize);
        })
        .catch(() => message.error('Failed to set sale price'));
    });
  }

  function handleRemoveSale() {
    removeSalePrice(saleTarget.id)
      .then(() => {
        message.success('Sale price removed');
        setSaleModalVisible(false);
        load(currentPage - 1, pageSize);
      })
      .catch(() => message.error('Failed to remove sale'));
  }

  const columns = [
    {
      title: 'Image',
      dataIndex: 'imageUrls',
      key: 'image',
      render: urls => (
        urls && urls.length > 0 ? (
          <img src={urls[0]} alt="product" style={{ width: 50, height: 50, objectFit: 'cover', borderRadius: 4 }} />
        ) : (
          <div style={{ width: 50, height: 50, backgroundColor: '#f0f0f0', borderRadius: 4, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            No img
          </div>
        )
      )
    },
    { title: 'ID', dataIndex: 'id', key: 'id' },
    { title: 'Name', dataIndex: 'name', key: 'name' },
    { title: 'Price', dataIndex: 'price', key: 'price', render: v => formatVnd(v) },
    { title: 'Category', dataIndex: ['category', 'name'], key: 'category' },
    { title: 'Brand', dataIndex: ['brand', 'name'], key: 'brand' },
    {
      title: 'Sale',
      key: 'sale',
      width: 140,
      render: (_, record) => {
        if (record.onSale && record.salePrice) {
          const discount = Math.round(((record.price - record.salePrice) / record.price) * 100);
          return (
            <div>
              <AntTag color="red" style={{ marginBottom: 2 }}>-{discount}%</AntTag>
              <div style={{ fontSize: 12, color: '#ff4d4f', fontWeight: 600 }}>{formatVnd(record.salePrice)}</div>
            </div>
          );
        }
        return <AntTag color="default">No sale</AntTag>;
      }
    },
    {
      title: 'Status',
      dataIndex: 'status',
      key: 'status',
      render: (status, record) => (
        <Switch
          checked={status === 'ACTIVE'}
          checkedChildren="Active"
          unCheckedChildren="Inactive"
          onChange={checked => {
            const newStatus = checked ? 'ACTIVE' : 'INACTIVE';
            updateProductStatus(record.id, { status: newStatus })
              .then(() => {
                message.success('Status updated');
                // instead of reloading the entire page we just update the
                // state for this row.  calling `load()` causes the table to
                // refetch from the server and therefore re‑sort/paginate the
                // results; on older items this often meant the row would
                // disappear from the current page and show up at the end of
                // the dataset (seen as "moved to the last page").  when all
                // statuses are requested we don't care about the backend
                // filtering so there's no need to refetch at all.
                setProducts(prev =>
                  prev.map(p =>
                    p.id === record.id ? { ...p, status: newStatus } : p
                  )
                );
              })
              .catch(() => message.error('Update failed'));
          }}
        />
      ),
    },
    {
      title: 'Actions',
      key: 'actions',
      render: (_text, record) => (
        <>
          <Button type="link" onClick={() => openForm(record)}>Edit</Button>
          <Button type="link" style={{ color: '#fa8c16' }} onClick={() => openSaleModal(record)}><TagsOutlined /> Sale</Button>
          <Button type="link" danger onClick={() => {
            modal.confirm({
              title: 'Delete Product',
              content: 'Are you sure you want to delete this product?',
              onOk: () => {
                deleteProduct(record.id)
                  .then(() => {
                    message.success('Product deleted');
                    load();
                  })
                  .catch(() => message.error('Delete failed'));
              }
            });
          }}>Delete</Button>
        </>
      )
    }
  ];

  return (
    <div>
      <Title level={2}>Products</Title>
      <div style={{ marginBottom: 16, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <Input
          placeholder="Keyword"
          style={{ width: 160 }}
          value={filters.keyword || ''}
          onChange={e => setFilters(f => ({ ...f, keyword: e.target.value }))}
        />
        <Select
          placeholder="Category"
          style={{ width: 160 }}
          allowClear
          value={filters.categoryId}
          onChange={val => setFilters(f => ({ ...f, categoryId: val }))}
        >
          {categories.map(c => (
            <Select.Option key={c.id} value={c.id}>{c.name}</Select.Option>
          ))}
        </Select>
        <Select
          placeholder="Brand"
          style={{ width: 160 }}
          allowClear
          value={filters.brandId}
          onChange={val => setFilters(f => ({ ...f, brandId: val }))}
        >
          {brands.map(b => (
            <Select.Option key={b.id} value={b.id}>{b.name}</Select.Option>
          ))}
        </Select>
        <Select value={sort} onChange={setSort} style={{ width: 140 }} allowClear placeholder="Sort">
          <Select.Option value="createdAt,desc">Newest</Select.Option>
          <Select.Option value="createdAt,asc">Oldest</Select.Option>
          <Select.Option value="price,asc">Low price</Select.Option>
          <Select.Option value="price,desc">High price</Select.Option>
        </Select>
        <Button onClick={() => { setFilters({ status: 'ALL' }); setSort('createdAt,desc'); load(0, pageSize); }}>Clear</Button>
        <Button type="primary" onClick={() => openForm(null)}>New Product</Button>
      </div>
      <Table
        dataSource={products}
        columns={columns}
        rowKey="id"
        pagination={{
          current: currentPage,
          pageSize,
          total,
          onChange: (page, size) => load(page - 1, size),
        }}
        onChange={(pagination, tableFilters, sorter) => {
          if (sorter && sorter.field) {
            const order = sorter.order === 'ascend' ? 'asc' : 'desc';
            setSort(`${sorter.field},${order}`);
            load(pagination.current - 1, pagination.pageSize);
          }
        }}
      />
      {/* deletion not shown yet; we could add actions column if needed */}
      <ProductForm
        open={formVisible}
        onSubmit={handleSubmit}
        onCancel={() => { setFormVisible(false); setEditing(null); }}
        categories={categories}
        brands={brands}
        initialValues={editing}
      />

      {/* Sale price modal */}
      <Modal
        open={saleModalVisible}
        title={`Set Sale Price — ${saleTarget?.name || ''}`}
        okText="Save Sale"
        cancelText="Cancel"
        onCancel={() => setSaleModalVisible(false)}
        onOk={handleSetSale}
        footer={(_, { OkBtn, CancelBtn }) => (
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <Button danger onClick={handleRemoveSale} disabled={!saleTarget?.onSale}>
              Remove Sale
            </Button>
            <Space>
              <CancelBtn />
              <OkBtn />
            </Space>
          </div>
        )}
      >
        {saleTarget && (
          <div style={{ marginBottom: 16, padding: 12, background: '#f6f6f6', borderRadius: 8 }}>
            <strong>Original price:</strong> {formatVnd(saleTarget.price)}
            {saleTarget.onSale && saleTarget.salePrice && (
              <span style={{ marginLeft: 16, color: '#ff4d4f' }}>
                <strong>Current sale:</strong> {formatVnd(saleTarget.salePrice)}
                ({Math.round(((saleTarget.price - saleTarget.salePrice) / saleTarget.price) * 100)}% off)
              </span>
            )}
          </div>
        )}
        <Form form={saleForm} layout="vertical">
          <Form.Item name="salePrice" label="Sale Price" rules={[{ required: true, message: 'Enter sale price' }]}>
            <InputNumber
              style={{ width: '100%' }}
              min={0}
              max={saleTarget?.price || 999999999}
              placeholder={`Must be less than ${saleTarget?.price || 0}`}
              formatter={value => `${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')}
              parser={value => value.replace(/,/g, '')}
              addonAfter="VND"
            />
          </Form.Item>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
            <Form.Item name="saleStartDate" label="Start Date (optional)">
              <DatePicker showTime style={{ width: '100%' }} placeholder="From..." />
            </Form.Item>
            <Form.Item name="saleEndDate" label="End Date (optional)">
              <DatePicker showTime style={{ width: '100%' }} placeholder="Until..." />
            </Form.Item>
          </div>
        </Form>
      </Modal>
    </div>
  );
}

// form component
const ProductForm = ({ open, onSubmit, onCancel, categories, brands, initialValues }) => {
  const [form] = Form.useForm();
  // Get message and modal from AntApp context
  const { message, modal } = AntApp.useApp();

  useEffect(() => {
    if (open && initialValues) {
      form.setFieldsValue(initialValues);
    } else if (open) {
      form.resetFields();
    }
  }, [open, initialValues, form]);

  return (
    <Modal
      open={open}
      title={initialValues ? `Edit Product (ID: ${initialValues.id})` : 'New Product'}
      width={800}
      okText="Save"
      cancelText="Cancel"
      onCancel={onCancel}
      onOk={() => {
        form.validateFields()
          .then(values => {
            form.resetFields();
            onSubmit(values);
          })
          .catch(info => console.log('Validate Failed:', info));
      }}
    >
      <Form form={form} layout="vertical">
        <Space style={{ width: '100%' }} direction="vertical" size="small">
          <div style={{ display: 'grid', gridTemplateColumns: 'minmax(200px, 3fr) 1fr', gap: 16 }}>
            <Form.Item name="name" label="Product Name" rules={[{ required: true }]}>
              <Input placeholder="Enter product name" />
            </Form.Item>
            {initialValues && (
              <Form.Item label="Total Stock">
                <Input value={initialValues.totalStock || 0} disabled style={{ color: 'rgba(0,0,0,0.85)', backgroundColor: '#f5f5f5' }} />
              </Form.Item>
            )}
          </div>

          <Form.Item name="description" label="Description">
            <Input.TextArea rows={3} placeholder="Enter product description" />
          </Form.Item>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
            <Form.Item name="price" label="Price" rules={[{ required: true, type: 'number', min: 0 }]}>
              <InputNumber style={{ width: '100%' }} formatter={value => `${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')} parser={value => value.replace(/,/g, '')} addonAfter="VND" />
            </Form.Item>
            <Form.Item name="status" label="Status">
              <Select>
                <Select.Option value="ACTIVE">Active</Select.Option>
                <Select.Option value="INACTIVE">Inactive</Select.Option>
                <Select.Option value="DELETED">Deleted</Select.Option>
              </Select>
            </Form.Item>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
            <Form.Item name="categoryId" label="Category" rules={[{ required: true }]}>
              <Select placeholder="Select category">
                {categories.map(c => <Select.Option key={c.id} value={c.id}>{c.name}</Select.Option>)}
              </Select>
            </Form.Item>
            <Form.Item name="brandId" label="Brand" rules={[{ required: true }]}>
              <Select placeholder="Select brand">
                {brands.map(b => <Select.Option key={b.id} value={b.id}>{b.name}</Select.Option>)}
              </Select>
            </Form.Item>
          </div>
        </Space>

        {initialValues && (
          <>
            <Divider orientation="left">Product Images Management</Divider>
            <ProductImageManager productId={initialValues.id} />
            <div style={{ fontSize: '12px', color: '#888', textAlign: 'right', marginTop: 16 }}>
              Created: {new Date(initialValues.createdAt).toLocaleString()} |
              Last Updated: {new Date(initialValues.updatedAt).toLocaleString()}
            </div>
          </>
        )}
      </Form>
    </Modal>
  );
};

const SortableImageCard = ({ img, onReplace, onDelete }) => {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({ id: img.imageId });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    zIndex: isDragging ? 2 : 1,
    opacity: isDragging ? 0.5 : 1,
  };

  return (
    <div ref={setNodeRef} style={style} {...attributes}>
      <Card
        hoverable
        size="small"
        cover={
          <div style={{ position: 'relative', height: 130, background: '#f5f5f5', overflow: 'hidden', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <img
              src={img.imageUrl}
              alt={img.fileName || 'product-image'}
              style={{ maxWidth: '100%', maxHeight: '100%', objectFit: 'contain' }}
            />
            {img.isPrimary && (
              <AntTag color="gold" style={{ position: 'absolute', top: 4, right: 4, margin: 0 }}>
                <StarFilled /> Primary
              </AntTag>
            )}
            <div
              {...listeners}
              style={{
                position: 'absolute',
                top: 4,
                left: 4,
                cursor: 'grab',
                backgroundColor: 'rgba(255,255,255,0.8)',
                borderRadius: 4,
                padding: '2px 4px',
                display: 'flex',
                boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
              }}
            >
              <DragOutlined style={{ fontSize: 16, color: '#8c8c8c' }} />
            </div>
          </div>
        }
        actions={[
          <Upload
            showUploadList={false}
            beforeUpload={(file) => onReplace(img.imageId, file)}
            key="replace"
          >
            <EditOutlined title="Replace" />
          </Upload>,
          <DeleteOutlined key="delete" onClick={() => onDelete(img.imageId)} title="Delete" style={{ color: '#ff4d4f' }} />
        ]}
      >
        <Card.Meta
          description={
            <Typography.Text title={img.fileName} ellipsis style={{ fontSize: '12px', width: '100%' }}>
              {img.fileName || `Image ID: ${img.imageId}`}
            </Typography.Text>
          }
        />
      </Card>
    </div>
  );
};

const ProductImageManager = ({ productId }) => {
  const { message, modal } = AntApp.useApp();
  const [images, setImages] = useState([]);
  const [loading, setLoading] = useState(false);

  const sensors = useSensors(
    useSensor(PointerSensor),
    useSensor(KeyboardSensor, {
      coordinateGetter: sortableKeyboardCoordinates,
    })
  );

  const loadImages = () => {
    setLoading(true);
    fetchProductImages(productId)
      .then(setImages)
      .catch(() => message.error('Failed to load images'))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    if (productId) loadImages();
  }, [productId]);

  const handleUploadBatch = ({ file, onSuccess, onError }) => {
    const formData = new FormData();
    formData.append('file', file);
    uploadProductImage(productId, formData)
      .then(() => {
        message.success(`${file.name} uploaded successfully`);
        loadImages();
        onSuccess();
      })
      .catch((err) => {
        message.error(`Upload failed: ${err.message}`);
        onError(err);
      });
  };

  const handleReplace = (imageId, file) => {
    const formData = new FormData();
    formData.append('file', file);
    updateProductImageFile(imageId, formData)
      .then(() => {
        message.success('Image replaced successfully');
        loadImages();
      })
      .catch((err) => message.error(`Replace failed: ${err.message}`));
    return false;
  };

  const handleDelete = (imageId) => {
    modal.confirm({
      title: 'Are you sure you want to delete this image?',
      content: 'This action cannot be undone.',
      onOk: () => {
        deleteProductImage(imageId)
          .then(() => {
            message.success('Image deleted');
            loadImages();
          })
          .catch(() => message.error('Failed to delete image'));
      }
    });
  };

  const handleDragEnd = (event) => {
    const { active, over } = event;
    if (active.id !== over?.id) {
      setImages((items) => {
        const oldIndex = items.findIndex((i) => i.imageId === active.id);
        const newIndex = items.findIndex((i) => i.imageId === over.id);
        const newOrder = arrayMove(items, oldIndex, newIndex);

        // Optimistic update
        const updatedItems = newOrder.map((item, index) => ({
          ...item,
          displayOrder: index,
          isPrimary: index === 0
        }));

        // Call API to save order
        const imageIds = updatedItems.map(item => item.imageId);
        reorderProductImages(productId, imageIds)
          .then(() => message.success('Order updated'))
          .catch(() => {
            message.error('Failed to save order');
            loadImages(); // rollback
          });

        return updatedItems;
      });
    }
  };

  return (
    <div style={{ marginTop: 8 }}>
      <DndContext
        sensors={sensors}
        collisionDetection={closestCenter}
        onDragEnd={handleDragEnd}
        modifiers={[restrictToFirstScrollableAncestor]}
      >
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(130px, 1fr))', gap: 16, marginBottom: 16 }}>
          <SortableContext
            items={images.map(i => i.imageId)}
            strategy={rectSortingStrategy}
          >
            {images.map(img => (
              <SortableImageCard
                key={img.imageId}
                img={img}
                onReplace={handleReplace}
                onDelete={handleDelete}
              />
            ))}
          </SortableContext>
          {images.length < 10 && (
            <Upload
              customRequest={handleUploadBatch}
              showUploadList={false}
              accept="image/*"
              multiple
            >
              <div style={{
                width: 130,
                height: 180,
                border: '1px dashed #d9d9d9',
                borderRadius: 8,
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                cursor: 'pointer',
                backgroundColor: '#fafafa',
                transition: 'border-color 0.3s'
              }}
                onMouseOver={e => e.currentTarget.style.borderColor = '#40a9ff'}
                onMouseOut={e => e.currentTarget.style.borderColor = '#d9d9d9'}
              >
                <PlusOutlined style={{ fontSize: 24, color: '#8c8c8c' }} />
                <div style={{ marginTop: 8, color: '#595959' }}>Add Image</div>
              </div>
            </Upload>
          )}
        </div>
      </DndContext>
      {images.length === 0 && !loading && (
        <Typography.Text type="secondary" style={{ display: 'block', textAlign: 'center', padding: '20px 0' }}>
          No images found for this product. Upload one to get started.
        </Typography.Text>
      )}
    </div>
  );
};
