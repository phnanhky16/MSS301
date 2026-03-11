import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import { Spin } from 'antd';
import {
    UserOutlined,
    MailOutlined,
    PhoneOutlined,
    HomeOutlined,
    CalendarOutlined,
    SafetyOutlined,
    EditOutlined,
} from '@ant-design/icons';
import { fetchUserById } from '../services/api';
import { getCurrentUser } from '../services/auth';

export default function ProfilePage() {
    const router = useRouter();
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const tokenUser = getCurrentUser();
        if (!tokenUser) {
            router.push('/login');
            return;
        }
        // JWT "sub" is typically the user ID; some tokens use "userId" or "id"
        const userId = tokenUser.userId || tokenUser.id || tokenUser.sub;
        if (!userId) {
            setLoading(false);
            return;
        }
        fetchUserById(userId)
            .then(data => {
                const profile = data?.data || data;
                setUser(profile);
            })
            .catch(() => {
                // Fallback to JWT data if API fails
                setUser({
                    name: tokenUser.name || tokenUser.fullName,
                    email: tokenUser.email,
                    role: tokenUser.role,
                });
            })
            .finally(() => setLoading(false));
    }, []);

    if (loading) {
        return (
            <div className="profile-loading">
                <Spin size="large" />
                <p>Loading profile...</p>
            </div>
        );
    }

    if (!user) {
        return (
            <div className="profile-loading">
                <p>Could not load profile. Please <a href="/login">log in</a>.</p>
            </div>
        );
    }

    const displayName = user.fullName || user.name || user.username || 'User';
    const initials = displayName
        .split(' ')
        .map(w => w[0])
        .join('')
        .toUpperCase()
        .slice(0, 2);

    return (
        <div className="profile-page">
            {/* Hero banner */}
            <div className="profile-hero">
                <div className="profile-hero-bg" />
                <div className="profile-avatar-wrapper">
                    <div className="profile-avatar-large">{initials}</div>
                    <div className="profile-hero-info">
                        <h1 className="profile-name">{displayName}</h1>
                        <span className="profile-role-badge">{user.role || 'Customer'}</span>
                    </div>
                </div>
            </div>

            {/* Info cards */}
            <div className="profile-content">
                <div className="profile-card">
                    <h2 className="profile-card-title">
                        <UserOutlined /> Personal Information
                    </h2>
                    <div className="profile-fields">
                        <ProfileField icon={<UserOutlined />} label="Full Name" value={displayName} />
                        <ProfileField icon={<MailOutlined />} label="Email" value={user.email || '—'} />
                        <ProfileField icon={<PhoneOutlined />} label="Phone" value={user.phone || user.phoneNumber || '—'} />
                        <ProfileField icon={<HomeOutlined />} label="Address" value={user.address || '—'} />
                    </div>
                </div>

                <div className="profile-card">
                    <h2 className="profile-card-title">
                        <SafetyOutlined /> Account Details
                    </h2>
                    <div className="profile-fields">
                        <ProfileField icon={<UserOutlined />} label="Username" value={user.username || '—'} />
                        <ProfileField icon={<SafetyOutlined />} label="Role" value={user.role || 'Customer'} />
                        <ProfileField icon={<CalendarOutlined />} label="Member Since" value={user.createdAt ? new Date(user.createdAt).toLocaleDateString('vi-VN') : '—'} />
                        <ProfileField icon={<CalendarOutlined />} label="Last Updated" value={user.updatedAt ? new Date(user.updatedAt).toLocaleDateString('vi-VN') : '—'} />
                    </div>
                </div>
            </div>
        </div>
    );
}

function ProfileField({ icon, label, value }) {
    return (
        <div className="profile-field">
            <div className="profile-field-icon">{icon}</div>
            <div className="profile-field-body">
                <div className="profile-field-label">{label}</div>
                <div className="profile-field-value">{value}</div>
            </div>
        </div>
    );
}
