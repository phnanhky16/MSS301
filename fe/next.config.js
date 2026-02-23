/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  compiler: {
    styledComponents: true
  }
  ,
  // rewrite favicon requests to our existing image so browsers stop 404ing
  async rewrites() {
    return [
      {
        source: '/favicon.ico',
        destination: '/images.jpg',
      },
    ];
  }
};
module.exports = nextConfig;