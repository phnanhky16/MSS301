import '../styles/globals.css';
import 'antd/dist/reset.css';
import { useRouter } from 'next/router';
import { ConfigProvider, App as AntApp } from 'antd';
import Layout from '../components/Layout';
import AdminLayout from '../components/AdminLayout';
import { CartProvider } from '../hooks/useCart';

export default function App({ Component, pageProps }) {
  const router = useRouter();
  const isAdmin = router.pathname.startsWith('/admin');
  const isLogin = router.pathname === '/login';
  const Wrapper = isAdmin ? AdminLayout : Layout;

  return (
    <ConfigProvider theme={{ token: { primaryColor: '#1ca8c8' } }}>
      <AntApp>
        <CartProvider>
          <Wrapper isLogin={isLogin}>
            <Component {...pageProps} />
          </Wrapper>
        </CartProvider>
      </AntApp>
    </ConfigProvider>
  );
}