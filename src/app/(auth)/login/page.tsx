import { Metadata } from 'next';
import { redirect } from 'next/navigation';

import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import LoginForm from '../_components/login-form';

import { validateRequest } from '../../../../auth';

export const metadata: Metadata = {
  title: 'Login',
};

export default async function Login() {
  const { session } = await validateRequest();

  if (session) return redirect('/dashboard');
  return (
    <Card className="max-w-md w-full mx-4 sm:mx-0 ">
      <CardHeader>
        <CardTitle>Log In</CardTitle>
        <CardDescription>
          Enter your credentials to access the employee portal.
        </CardDescription>
      </CardHeader>
      <CardContent>
        <LoginForm />
      </CardContent>
    </Card>
  );
}
