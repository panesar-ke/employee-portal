import { z } from 'zod';

export const loginSchema = z.object({
  contact: z
    .string()
    .min(10, {
      message: 'Contact must be at least 10 characters.',
    })
    .max(10, { message: 'Phone number can not be more than 10 characters.' }),
  password: z.string().min(6, {
    message: 'Password must be at least 6 characters.',
  }),
});

export const changePasswordSchema = z
  .object({
    password: z
      .string()
      .min(6, 'Password needs to be six characters and above'),
    confirmPassword: z.string().min(6, 'Needs to be six characters and above'),
  })
  .superRefine(({ confirmPassword, password }, ctx) => {
    if (confirmPassword !== password) {
      ctx.addIssue({
        code: 'custom',
        message: "Passwords don't match",
        path: ['confirmPassword'],
      });
    }
  });

export const changePasswordExistingSchema = z
  .object({
    currentPassword: z
      .string()
      .min(6, 'Current password needs to be six characters and above'),
    password: z
      .string()
      .min(6, 'Password needs to be six characters and above'),
    confirmPassword: z.string().min(6, 'Needs to be six characters and above'),
  })
  .superRefine(({ confirmPassword, password }, ctx) => {
    if (confirmPassword !== password) {
      ctx.addIssue({
        code: 'custom',
        message: "Passwords don't match",
        path: ['confirmPassword'],
      });
    }
  });

export const resetPasswordSchema = z.object({
  phoneNumber: z.string().length(10, 'Invalid phone number entered'),
});
