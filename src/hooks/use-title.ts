import { useRef, useEffect } from 'react';
const useTitle = (title: string) => {
  const documentDefined = typeof document !== 'undefined';
  const originalTitle = useRef(
    documentDefined ? document.title : 'Panesars Kenya Ltd'
  );

  useEffect(() => {
    if (!documentDefined) return;

    if (document.title !== title) document.title = title;

    return () => {
      // eslint-disable-next-line react-hooks/exhaustive-deps
      document.title = originalTitle.current;
    };
  }, [documentDefined, title]);
};

export { useTitle };
