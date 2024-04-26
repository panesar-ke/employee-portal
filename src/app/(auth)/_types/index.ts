import { z } from 'zod';
import { loginSchema } from '../_utils/schema';

export type TLogin = z.infer<typeof loginSchema>;
