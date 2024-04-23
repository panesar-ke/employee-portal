import { createFileRoute } from '@tanstack/react-router';
import { requireAuth } from '../lib/route-auth';
export const isAuthenticated = false;

export const Route = createFileRoute('/dashboard')({
  beforeLoad: requireAuth,
  component: () => <div>Hello /dashboard!</div>,
});
