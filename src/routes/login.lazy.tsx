import { createLazyFileRoute } from '@tanstack/react-router';

import { LoginPage } from '../features/auth';

export const Route = createLazyFileRoute('/login')({
  component: () => <LoginPage />,
});
