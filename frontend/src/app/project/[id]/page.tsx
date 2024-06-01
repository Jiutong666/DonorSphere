import InfoMain from '@/components/InfoMain';
import InfoTabs from '@/components/InfoTabs';
import { Params } from 'next/dist/shared/lib/router/utils/route-matcher';

export default function ProjectDetails({ params }: Params) {
  return (
    <div className="max-w-[114rem] w-full mt-2 bg-white px-[20rem] py-10 shadow-lg min-h-[93vh]">
      <InfoMain id={params.id} />
      <InfoTabs />
    </div>
  );
}
