'use client';

import { useState, useTransition } from 'react';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';

import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { toast } from 'sonner';

import { changePasswordSchema } from '../_utils/schema';
import { changePassword } from '../_actions';
import { Alert } from '@/components/ui/alert';

type Props = { token: string | undefined };

export default function ChangePassword({ token }: Props) {
  const [isPending, startTransition] = useTransition();
  const [error, setError] = useState<string>();
  const form = useForm<z.infer<typeof changePasswordSchema>>({
    defaultValues: {
      password: '',
      confirmPassword: '',
    },
    resolver: zodResolver(changePasswordSchema),
  });

  function onSubmit(values: z.infer<typeof changePasswordSchema>) {
    if (!token) {
      setError('Invalid request. Reset token missing!😞');
      return;
    }
    startTransition(() => {
      changePassword(values, token)
        .then(data => {
          if (data.error) setError(data.error);
        })
        .catch(err => toast.error(`😞 ${err.message}`));
    });
  }

  return (
    <div className="space-y-4">
      {error && <Alert variant="destructive" message={error} />}
      <Form {...form}>
        <form
          onSubmit={form.handleSubmit(onSubmit)}
          className="grid grid-cols-1 space-y-6"
        >
          <FormField
            control={form.control}
            name="password"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Password</FormLabel>
                <FormControl>
                  <Input
                    type="password"
                    placeholder="Enter password..."
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
            name="confirmPassword"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Confirm Password</FormLabel>
                <FormControl>
                  <Input
                    type="password"
                    placeholder="Confirm entered password..."
                    {...field}
                    disabled={isPending}
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <Button type="submit" disabled={isPending}>
            Change Password
          </Button>
        </form>
      </Form>
    </div>
  );
}
