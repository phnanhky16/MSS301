import '../styles/globals.css';
import 'antd/dist/reset.css';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import AdminLayout from '../components/AdminLayout';

function MyApp({ Component, pageProps }) {
  const router = useRouter();
  const isAdmin = router.pathname.startsWith('/admin');
  const Wrapper = isAdmin ? AdminLayout : Layout;
  return (
    <Wrapper>
      <Component {...pageProps} />
    </Wrapper>
  );
}

export default MyApp;