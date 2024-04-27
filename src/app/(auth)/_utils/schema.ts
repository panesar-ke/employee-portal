import * as z from 'zod';

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

export const registerSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  contact: z
    .string()
    .min(10, 'Phone number must be at least 10 characters')
    .max(10, 'Phone number cannot be more than 10 characters'),
  userType: z.enum(['SUPER ADMIN', 'ADMIN', 'STANDARD USER']),
  role: z.string(),
  email: z.string().optional(),
  promptPasswordChange: z.boolean(),
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

export const createRoleSchema = z.object({
  role: z.string().min(1, {
    message: 'Role name is required.',
  }),
});

export type TLogin = z.infer<typeof loginSchema>;
