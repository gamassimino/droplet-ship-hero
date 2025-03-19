import React from 'react';
import { createRoot } from 'react-dom/client';
import { Button } from '~/components/ui/button';

interface FluidProps {
  name: string;
}

const Fluid = ({ name }: FluidProps) => {
  const [count, setCount] = React.useState(1);

  const handleClick = () => setCount((count + 1) % 10);

  return (
    <div className="flex flex-col gap-2 justify-center items-center h-screen">
      <div className="bg-slate-900 rounded-lg p-2">
        <i className="text-4xl fa-solid fa-droplet text-teal-400"></i>
        &nbsp;
        <i className="text-4xl fa-solid fa-droplet text-fuchsia-600"></i>
        <br />
        <i className="text-4xl fa-solid fa-droplet text-amber-300"></i>
        &nbsp;
        <i className="text-4xl fa-solid fa-droplet text-blue-600"></i>
      </div>
      <Button variant="outline" size="sm" onClick={handleClick}>
        {name} ({count})
      </Button>
    </div>
  );
};

const root = createRoot(document.getElementById('root') as HTMLElement);
root.render(<Fluid name="Fluid" />);
