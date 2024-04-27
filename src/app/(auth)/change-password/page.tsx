import React from 'react';
import { Metadata } from 'next';

import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import ChangePassword from '../_components/change-password';

interface ChangePasswordPageProps {
  searchParams: {
    stage: 'first-time' | 'forgot-password';
    resetToken: string | undefined;
  };
}

export const metadata: Metadata = {
  title: 'Change password',
};

export default function ChangePasswordPage({
  searchParams,
}: ChangePasswordPageProps) {
  const { stage, resetToken } = searchParams;
  return (
    <Card className="max-w-md w-full mx-4 sm:mx-0 ">
      <CardHeader>
        <CardTitle>Change Password</CardTitle>
        <CardDescription>
          {stage == 'first-time' &&
            'You are required to change your password on your initial login.'}
          {stage == 'forgot-password' &&
            'You initiated a forgot password request. Reset your password below.'}
        </CardDescription>
      </CardHeader>
      <CardContent>
        {stage === 'first-time' && <ChangePassword token={resetToken} />}
        {/* {stage === 'forgot-password' && (
          <ChangePasswordExisting token={resetToken} />
        )} */}
      </CardContent>
    </Card>
  );
}
