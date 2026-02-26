import '../styles/globals.css';
import 'antd/dist/reset.css';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import AdminLayout from '../components/AdminLayout';

function MyApp({ Component, pageProps }) {
  const router = useRouter();
  const isAdmin = router.pathname.startsWith('/admin');
  const isLogin = router.pathname === '/login';
  const Wrapper = isAdmin ? AdminLayout : Layout;
  return (
    <>
      <Wrapper isLogin={isLogin}>
        <Component {...pageProps} />
      </Wrapper>
    </>
  );
}

export default MyApp;