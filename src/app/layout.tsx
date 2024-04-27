import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import { Toaster } from '@/components/ui/sonner';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: {
    default: 'Panesars Kenya Ltd',
    template: `%s / PKL`,
  },
  description: 'Employee portal for Panesars Kenya Ltd',
  icons: [
    {
      url: '/logos/favicon-black.svg',
      href: '/logos/favicon-black.svg',
    },
  ],
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={inter.className}>
        {children}
        <Toaster />
      </body>
    </html>
  );
}
