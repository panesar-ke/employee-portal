import * as React from 'react';
import { Slot } from '@radix-ui/react-slot';
import { cva, type VariantProps } from 'class-variance-authority';

import { cn } from '@/lib/utils';

const alertVariants = cva(
  'p-2 rounded-sm text-sm transition-colors border-l-4',
  {
    variants: {
      variant: {
        default: 'bg-sky-200 text-sky-800 border-l-sky-400',
        destructive: 'bg-rose-200 text-rose-800 border-l-rose-400',
        success: 'bg-emerald-200 text-emerald-800 border-l-emerald-400',
      },
    },
    defaultVariants: {
      variant: 'default',
    },
  }
);

export interface AlertProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof alertVariants> {
  message: string;
}

const Alert = React.forwardRef<HTMLDivElement, AlertProps>(
  ({ className, variant, message, ...props }, ref) => {
    return (
      <div
        className={cn(alertVariants({ variant, className }))}
        ref={ref}
        {...props}
      >
        {message}
      </div>
    );
  }
);
Alert.displayName = 'Alert';

export { Alert, alertVariants };
