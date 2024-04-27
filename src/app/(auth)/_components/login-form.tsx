'use client';
import { useState, useTransition } from 'react';
import Link from 'next/link';
import { zodResolver } from '@hookform/resolvers/zod';
import clsx from 'clsx';
import { useForm } from 'react-hook-form';

import { Button } from '@/components/ui/button';
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { toast } from 'sonner';
import TogglePassword from './toggle-password';

import { login } from '../_actions';
import { TLogin } from '../_types';
import { loginSchema } from '../_utils/schema';
import { Alert } from '@/components/ui/alert';

export default function LoginForm() {
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState<string>();
  const [isPending, startTransition] = useTransition();

  function togglePassword() {
    setShowPassword(prev => !prev);
  }

  const form = useForm<TLogin>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      contact: '',
      password: '',
    },
  });

  function onSubmit(values: TLogin) {
    setError(undefined);
    startTransition(() => {
      login(values)
        .then(data => {
          if (data.error) setError(data.error);
        })
        .catch(err => setError(err.message));
    });
  }

  return (
    <div className="space-y-4">
      {error && <Alert variant="destructive" message={error} />}
      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
          <FormField
            control={form.control}
            name="contact"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Phone No</FormLabel>
                <FormControl>
                  <Input
                    placeholder="Your phone number"
                    {...field}
                    disabled={isPending}
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="password"
            render={({ field }) => (
              <FormItem>
                <div className="flex items-center justify-between">
                  <FormLabel>Password</FormLabel>
                  <TogglePassword
                    showPassword={showPassword}
                    togglePassword={togglePassword}
                    disabled={isPending}
                  />
                </div>
                <FormControl>
                  <Input
                    type={showPassword ? 'text' : 'password'}
                    placeholder="******"
                    {...field}
                    disabled={isPending}
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <Button type="submit" className="w-full" disabled={isPending}>
            Submit
          </Button>
          <Link
            href="/forgot-password"
            className={clsx(
              'text-center block text-sm font-medium text-link transition-all hover:underline',
              {
                'cursor-not-allowed pointer-events-none text-blue-300':
                  isPending,
              }
            )}
          >
            Forgot password?
          </Link>
        </form>
      </Form>
    </div>
  );
}
