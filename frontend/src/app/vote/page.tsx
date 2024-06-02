import VoteForm from '@/components/VoteForm';
import { Suspense } from 'react';

export default function Vote() {
  return (
    <div className="min-h-[93vh] bg-white max-w-[114rem] w-full mt-4 px-[20rem] py-10">
      <Suspense>
        <VoteForm />
      </Suspense>
    </div>
  );
}
