import { createRootRoute, Link, Outlet } from '@tanstack/react-router';
import { TanStackRouterDevtools } from '@tanstack/router-devtools';
import { isAuthenticated } from './dashboard';

export const Route = createRootRoute({
  component: () => (
    <>
      {isAuthenticated ? (
        <>
          <div className="p-2 flex gap-2">
            <Link to="/login" className="[&.active]:font-bold">
              Home
            </Link>
            <Link to="/dashboard" className="[&.active]:font-bold">
              Dashboard
            </Link>
          </div>
          <hr />
          <Outlet />
        </>
      ) : (
        <>
          <main className="h-full flex items-center justify-center">
            <Outlet />
          </main>
        </>
      )}

      <TanStackRouterDevtools />
    </>
  ),
});
