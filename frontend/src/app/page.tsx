import HomeCardItem from '@/components/HomeCardItem';
import HomeProjects from '@/components/HomeProjects';
import { homeCardList } from '@/constants';
import { Button, Image } from '@nextui-org/react';
import Link from 'next/link';

export default function Home() {
  return (
    <div>
      <div className="max-w-[114rem] w-full mt-2 bg-white px-[20rem] py-10 shadow-lg">
        <div className="flex flex-row items-start  justify-around">
          <div className="flex flex-col py-[3rem]">
            <h1 className="text-3xl font-bold text-left mb-4 w-[24rem] ">
              DonorSphere empowers changemakers with evolutionary funding.
            </h1>
            <p className="text-left text-lg mb-6 w-[26rem]">
              Join our community-driven movement to transform the way we fund nonprofits and social causes.
            </p>
            <Button
              className="bg-[--main-color] text-white font-bold text-[1.2rem] w-[12rem]"
              as={Link}
              href="/project/create"
            >
              Create a Project
            </Button>
          </div>
          <div>
            <Image alt="theme" src="home.svg" />
          </div>
        </div>
        <div className="mt-[4rem] flex flex-row justify-around">
          {homeCardList.map((item) => (
            <HomeCardItem
              key={item.title}
              title={item.title}
              icon={item.icon}
              description={item.description}
              buttonLabel={item.buttonLabel}
            />
          ))}
        </div>
      </div>
      <HomeProjects />
    </div>
  );
}
