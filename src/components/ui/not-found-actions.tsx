'use client';
import Link from 'next/link';
import { ArrowLeft } from 'lucide-react';

import { Button } from '../ui/button';
import { useRouter } from 'next/navigation';

export default function NotFoundActions() {
  const router = useRouter();
  return (
    <div className="flex items-center gap-4">
      <Button
        asChild
        variant="outline"
        onClick={() => router.back()}
        className="cursor-pointer"
      >
        <div className="flex gap-2 items-center">
          <ArrowLeft className="icon-muted" />
          <span>Go Back</span>
        </div>
      </Button>
      <Button asChild>
        <Link href="/dashboard">Go Home</Link>
      </Button>
    </div>
  );
}
