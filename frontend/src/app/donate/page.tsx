import DonateForm from '@/components/DonateForm';
import { Suspense } from 'react';

export default function Donate() {
  return (
    <div className="min-h-[93vh] bg-white max-w-[114rem] w-full mt-4 px-[20rem] py-10">
      <Suspense>
        <DonateForm />
      </Suspense>
    </div>
  );
}
