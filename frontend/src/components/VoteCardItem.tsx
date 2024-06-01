'use client';
import { Proposal } from '@/types';
import { Button, Card, CardBody, Image } from '@nextui-org/react';
import Link from 'next/link';

export default function ProjectCardItem({ ...props }: Proposal) {
  return (
    <div className="flex justify-center flex-col items-center">
      <Card className="w-[22rem] h-[25rem] relative group overflow-hidden">
        <Image
          alt="clouds"
          src="https://nextui-docs-v2.vercel.app/images/hero-card-complete.jpeg"
          width={352}
          height={176}
          className="object-cover overflow-hidden"
        />
        <CardBody className="px-[2rem] absolute top-[11rem] z-10 bg-white rounded-xl h-[18rem] transition-all duration-500 ease-in-out group-hover:top-[7rem]">
          <p className="font-semibold text-[1.5rem] overflow-hidden overflow-ellipsis whitespace-nowrap">
            {props.name}
          </p>
          <p className="text-[--main-color] font-normal">{props.creator}</p>
          <p className="mt-3 text-[#656c82] h-[4.5rem] overflow-hidden">{}</p>
          <div className="flex justify-between mt-3">
            <div>
              <p className="text-[1.5rem] font-bold">${`${props.targetAmount}`}</p>
              <p className="text-gray-500 text-[0.75rem]">Target Amount</p>
            </div>
          </div>
          <Button
            color="primary"
            className="mt-4"
            as={Link}
            href={`/vote?projectId=${props.id}&projectTitle=${props.name}`}
          >
            Vote
          </Button>
        </CardBody>
      </Card>
    </div>
  );
}
