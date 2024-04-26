import NotFoundActions from '@/components/ui/not-found-actions';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Dot } from 'lucide-react';
import { Metadata } from 'next';
import Link from 'next/link';

type Props = {};

export const metadata: Metadata = {
  title: '404 Page not found.',
};

function NotFoundPage({}: Props) {
  return (
    <main className="h-full flex items-center justify-center">
      <div className="max-w-lg w-full flex flex-col gap-3 items-center">
        <Badge variant="destructive">404 error</Badge>
        <h1 className="font-bold text-4xl">Page not found</h1>
        <p className="text-muted-foreground text-sm">
          Sorry, we couldn&apos;t find the page you&apos;re looking for.
        </p>
        <NotFoundActions />
      </div>
    </main>
  );
}

export default NotFoundPage;
