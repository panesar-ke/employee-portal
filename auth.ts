// check the next-auth file for config for authentication using NextAuth v5
import { cache } from 'react';
import { Lucia } from 'lucia';
import { cookies } from 'next/headers';

import type { Session, User } from 'lucia';

import { adapter } from '@/lib/database/db';
import { EMPLOYEECATEGORY } from './index';

export const lucia = new Lucia(adapter, {
  sessionCookie: {
    expires: false,
    attributes: {
      secure: process.env.NODE_ENV === 'production',
    },
  },
  getUserAttributes: attributes => {
    return {
      name: attributes.name,
      contact: attributes.contact,
      image: attributes.image,
      email: attributes.email,
      employeeType: attributes.employeeType,
    };
  },
  getSessionAttributes: attributes => {
    return {
      name: attributes.name,
      employeeType: attributes.employeeType,
      image: attributes.image,
    };
  },
});

export const validateRequest = cache(
  async (): Promise<
    { user: User; session: Session } | { user: null; session: null }
  > => {
    const sessionId = cookies().get(lucia.sessionCookieName)?.value ?? null;
    if (!sessionId) {
      return {
        user: null,
        session: null,
      };
    }

    const result = await lucia.validateSession(sessionId);
    // next.js throws when you attempt to set cookie when rendering page
    try {
      if (result.session && result.session.fresh) {
        const sessionCookie = lucia.createSessionCookie(result.session.id);
        cookies().set(
          sessionCookie.name,
          sessionCookie.value,
          sessionCookie.attributes
        );
      }
      if (!result.session) {
        const sessionCookie = lucia.createBlankSessionCookie();
        cookies().set(
          sessionCookie.name,
          sessionCookie.value,
          sessionCookie.attributes
        );
      }
    } catch {}
    return result;
  }
);

// IMPORTANT!
declare module 'lucia' {
  interface Register {
    Lucia: typeof lucia;
    DatabaseUserAttributes: DatabaseUserAttributes;
    DatabaseSessionAttributes: DatabaseSessionAttributes;
  }
}

interface DatabaseUserAttributes {
  id: string;
  name: string;
  contact: string;
  image: string | null;
  email: string | null;
  employeeType: EMPLOYEECATEGORY;
}

interface DatabaseSessionAttributes {
  name: string;
  employeeType: EMPLOYEECATEGORY;
  image: string | null;
}
