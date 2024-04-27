'use server';

import { cookies } from 'next/headers';
import { redirect } from 'next/navigation';
import { compare } from 'bcrypt-ts';

import { lucia } from '../../../../auth';
import db from '@/lib/database/db';
import { TLogin } from '../_types';
import { loginSchema } from '../_utils/schema';

export const login = async (values: TLogin) => {
  const validated = loginSchema.safeParse(values);

  if (!validated.success) return { error: 'Invalid data passed.' };

  const { contact, password } = validated.data;

  const user = await db.query.employeeUsers.findFirst({
    where: (model, { eq }) => eq(model.contact, contact),
  });

  if (!user) return { error: 'Invalid contact or password!' };

  if (!user.active)
    return { error: 'This account is currently deactivated.Contact support' };

  if (user.password === null && password !== user.idNumber) {
    return { error: 'Invalid contact or password!' };
  } else if (user.password === null && password === user.idNumber) {
    return redirect('/change-password');
  }

  const passwordMatches = await compare(password, user.password!);
  if (!passwordMatches) return { error: 'Invalid contact or password!' };

  const session = await lucia.createSession(user.id, {
    name: user.name,
    employeeType: user.employeeType as
      | 'NON-UNIONISABLE'
      | 'MANEGEMENT'
      | 'UNIONISABLE',
    image: user.image,
  });
  const sessionCookie = lucia.createSessionCookie(session.id);
  cookies().set(
    sessionCookie.name,
    sessionCookie.value,
    sessionCookie.attributes
  );

  return redirect('/dashboard');
};
