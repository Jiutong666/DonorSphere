'use client';
import { VotingBase } from '@/abis/VotingBase';
import { VotingBaseAddress } from '@/constants';
import { Avatar, Button, Card, Divider, Image, Link } from '@nextui-org/react';
import { useReadContract } from 'wagmi';

export default function InfoMain({ id }: { id: string }) {
  const result = useReadContract({
    abi: VotingBase,
    address: VotingBaseAddress,
    functionName: 'getProposal',
    args: [BigInt(id.slice(0, -1))],
  });
  return (
    <div className="flex flex-row gap-6 h-[28rem] my-[4rem]">
      <div className="w-[70%] rounded-2xl border-1 relative overflow-hidden">
        <Image
          alt="project image"
          src="https://nextui-docs-v2.vercel.app/images/hero-card-complete.jpeg"
          className="object-cover overflow-hidden z-0"
        />
        <div className="absolute z-10 bottom-20 left-10">
          <p className="text-white font-bold text-[2rem]">{result.data?.name}</p>
          <div className="flex gap-4 mt-4 items-center text-white font-normal text-[1.2rem]">
            <Avatar alt="founder avatar" src={''} />
            <p>{'0xAA'}</p>
            <p className="ml-20"> End Time: {result.data?.endTime}</p>
          </div>
        </div>
      </div>
      <Card className="p-6 bg-white rounded-lg w-[30%] mx-auto border-1">
        <p className="font-bold text-gray-400">Total amount raised</p>
        <p className="text-4xl font-bold mb-2">${Number(result.data?.currentAmount)}</p>
        <p className="text-gray-400 mb-4 flex text-[0.75rem]">
          Raised from <span className="text-black mx-1">{0}</span> contributors
        </p>
        <Divider />
        <p className="font-bold text-gray-400 mt-2">Target Amount</p>
        <p className="text-2xl font-bold mb-2 text-green-400">${Number(result.data?.targetAmount)}</p>
        <div className="rounded-lg border-1 py-4 px-2 bg-white my-[2rem]">
          <p className="font-semibold">100% goes to the project always.</p> Every donation is peer-to-peer, with no fees
          and no middlemen.
        </div>
        <Button
          color="primary"
          className="font-bold"
          as={Link}
          href={`/donate?projectId=${id}&projectTitle=${result.data?.name}`}
        >
          DONATE
        </Button>
      </Card>
    </div>
  );
}
