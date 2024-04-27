import clsx from 'clsx';
import { Eye, EyeOff } from 'lucide-react';

interface TogglePasswordProps {
  showPassword: boolean;
  togglePassword: () => void;
  disabled?: boolean;
}

export default function TogglePassword({
  showPassword,
  togglePassword,
  disabled,
}: TogglePasswordProps) {
  return (
    <>
      {showPassword ? (
        <div
          className={clsx('flex items-center gap-1 cursor-pointer', {
            'cursor-not-allowed': disabled,
          })}
          onClick={togglePassword}
        >
          <EyeOff className="icon-muted" />
          <span className="text-xs">Hide</span>
        </div>
      ) : (
        <div
          className={clsx('flex items-center gap-1 cursor-pointer', {
            'cursor-not-allowed': disabled,
          })}
          onClick={togglePassword}
        >
          <Eye className="icon-muted" />
          <span className="text-xs">Show</span>
        </div>
      )}
    </>
  );
}
