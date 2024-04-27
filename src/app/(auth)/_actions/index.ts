'use server';

import { cookies } from 'next/headers';
import { redirect } from 'next/navigation';
import { compare, hash } from 'bcrypt-ts';
import { createId, isCuid } from '@paralleldrive/cuid2';

import { lucia } from '../../../../auth';
import db from '@/lib/database/db';
import { TLogin } from '../_types';
import { changePasswordSchema, loginSchema } from '../_utils/schema';
import { employeeUsers } from '@/migrations/schema';
import { eq } from 'drizzle-orm';

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

  const token = createId();

  if (user.password === null && password !== user.idNumber) {
    return { error: 'Invalid contact or password!' };
  } else if (user.password === null && password === user.idNumber) {
    await db.update(employeeUsers).set({ resetToken: token });
    return redirect(`/change-password?stage=first-time&resetToken=${token}`);
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

export const changePassword = async (passwords: any, token: string) => {
  const validated = changePasswordSchema.safeParse(passwords);

  if (!validated.success)
    return {
      error:
        'Invalid data password. Ensure your passwords are corrently entered.',
    };

  if (!isCuid(token)) return { error: 'Invalid reset token entered.' };

  const { password } = validated.data;

  const user = await db.query.employeeUsers.findFirst({
    columns: { id: true, name: true, employeeType: true, image: true },
    where: (user, { eq }) => eq(user.resetToken, token),
  });

  if (!user) return { error: 'Invalid reset token passed' };

  const hashedPassword = await hash(password, 10);

  const returned: { id: string }[] = await db
    .update(employeeUsers)
    .set({
      resetToken: null,
      password: hashedPassword,
      promptPasswordChange: false,
    })
    .where(eq(employeeUsers.id, user.id))
    .returning({ id: employeeUsers.id });

  if (!returned.length)
    return {
      error:
        'Something went wrong while changing your password. Contact support',
    };

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
