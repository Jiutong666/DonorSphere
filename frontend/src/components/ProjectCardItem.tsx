import { ProjectInfo } from '@/types';
import { Button, Card, CardBody, Image } from '@nextui-org/react';

export default function ProjectCardItem({ ...props }: ProjectInfo) {
  return (
    <div className="flex justify-center flex-col items-center">
      <Card className="w-[22rem] h-[25rem] relative group overflow-hidden">
        <Image alt="clouds" src={props.picture} width={352} height={176} className="object-contain" />
        <CardBody className="px-[2rem] absolute top-[11rem] z-10 bg-white rounded-xl h-[18rem] transition-all duration-500 ease-in-out group-hover:top-[7rem]">
          <p className="font-semibold text-[1.5rem] overflow-hidden overflow-ellipsis whitespace-nowrap">
            {props.name}
          </p>
          <p className="text-[--main-color] font-normal">{props.founder}</p>
          <p className="mt-3 text-[#656c82] h-[4.5rem] overflow-hidden">{props.description}</p>
          <div className="flex justify-between mt-3">
            <div>
              <p className="text-[1.5rem] font-bold">${`${props.targetAmount}`}</p>
              <p className="text-gray-500 text-[0.75rem]">Target Amount</p>
            </div>
            <div>
              <p className="text-green-500 text-[1.5rem] font-normal">${`${props.raisedAmount}`}</p>
              <p className="text-gray-500 text-[0.75rem]">Total Raised</p>
            </div>
          </div>
          <Button color="primary" className="mt-4">
            Donate
          </Button>
        </CardBody>
      </Card>
    </div>
  );
}
