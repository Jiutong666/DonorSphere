import Provider from '@/components/Provider';
import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  icons: '/logo.svg',
  title: 'DonorSphere',
  description: '',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>
        <Provider>{children}</Provider>
      </body>
    </html>
  );
}
