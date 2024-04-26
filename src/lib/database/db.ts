import { drizzle } from 'drizzle-orm/postgres-js';
import { DrizzlePostgreSQLAdapter } from '@lucia-auth/adapter-drizzle';
import postgres from 'postgres';

import * as schema from '@/migrations/schema';

export const client = postgres(`${process.env.DATABASE_URL!}?sslmode=require`);
const db = drizzle(client, { schema });

export const adapter = new DrizzlePostgreSQLAdapter(
  db,
  schema.employeeSession,
  schema.users
);

export default db;
