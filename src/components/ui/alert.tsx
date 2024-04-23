import React from 'react';
import { VariantProps, cva } from 'class-variance-authority';

import { cn } from '@/lib/utils';

const alertVariants = cva(
  'relative w-full rounded-lg border-l-4 p-4 [&>svg~*]:pl-7 [&>svg+div]:translate-y-[-3px] [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:text-foreground',
  {
    variants: {
      variant: {
        default: 'bg-background text-foreground',
        success:
          'border-l-emerald-400 bg-emerald-50 text-emerald-900 dark:border-success [&>svg]:text-success',
        destructive:
          'border-l-rose-400 bg-rose-50 text-rose-900 dark:border-success [&>svg]:text-success',
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
