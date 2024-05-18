import { HomeCard } from '@/types';
import { Image, Link, Spacer } from '@nextui-org/react';

export default function HomeCardItem({ title, description, buttonLabel, icon }: HomeCard) {
  return (
    <div className="rounded-2xl border-1 w-[21rem] flex flex-col items-center px-[1rem] py-[1rem] text-[#515768]">
      <div className="flex flex-row items-center">
        <Image alt={title} src={icon} />
        <h4 className="font-bold text-[1.5rem] ml-2">{title}</h4>
      </div>
      <p className="pl-[1rem]">{description}</p>
      <Spacer y={2} />
      <Link color="primary" className="text-[1.2rem] font-medium">
        {buttonLabel}
        <Image alt="right" src="chevron_right.svg" width="36" />
      </Link>
    </div>
  );
}
