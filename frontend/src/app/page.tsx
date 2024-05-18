import HomeCardItem from '@/components/HomeCardItem';
import ProjectCardItem from '@/components/ProjectCardItem';
import { homeCardList, testProjectInfo } from '@/constants';
import { Button, Image } from '@nextui-org/react';

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
            <Button className="bg-[--main-color] text-white font-bold text-[1.2rem] w-[12rem]">Create a Project</Button>
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
      <div className="max-w-[114rem] w-full mt-[5rem] bg-white px-[20rem] py-10 shadow-lg">
        <p className="font-bold text-[3rem] text-[#515768] mb-4">Projects</p>
        <div className="flex flex-row flex-wrap gap-9 justify-between">
          {testProjectInfo.map((item) => (
            <ProjectCardItem
              key={item.name}
              id={item.id}
              name={item.name}
              description={item.description}
              picture={item.picture}
              founder={item.founder}
              raisedAmount={item.raisedAmount}
              targetAmount={item.targetAmount}
              beneficiary={item.beneficiary}
            />
          ))}
        </div>
      </div>
    </div>
  );
}
