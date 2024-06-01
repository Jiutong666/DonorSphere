'use client';
import { VotingBase } from '@/abis/VotingBase';
import { VotingBaseAddress } from '@/constants';

import { Avatar, Button, Image, Input } from '@nextui-org/react';
import { useRouter, useSearchParams } from 'next/navigation';
import toast from 'react-hot-toast';
import { parseEther } from 'viem';
import { useWriteContract } from 'wagmi';

export default function DonateForm() {
  const searchParams = useSearchParams();
  const router = useRouter();
  const id = searchParams.get('projectId');
  const projectTitle = searchParams.get('projectTitle');

  const { writeContractAsync } = useWriteContract();

  const submitHandler = (formDate: FormData) => {
    const amount = formDate.get('amount');
    writeContractAsync({
      abi: VotingBase,
      address: VotingBaseAddress,
      functionName: 'donate',
      args: [BigInt((id as string).slice(0, -1))],
      value: parseEther(amount as string),
    }).then(() => {
      toast.success('捐款成功！');
      router.push('/');
    });
  };

  return (
    <div className="flex justify-around gap-8">
      <form className="p-6 bg-white rounded-lg border-1 w-[50%] flex flex-col gap-6" action={submitHandler}>
        <div className="rounded-xl border-1 p-4 bg-white">
          <p className="font-semibold text-[1.2rem] mb-4">100% goes to the project always.</p> Every donation is
          peer-to-peer, with no fees and no middlemen.
        </div>
        <Input
          type="number"
          name="amount"
          label="Amount"
          labelPlacement="outside"
          placeholder="Please enter amount"
          isRequired
          endContent={
            <div className="pointer-events-none flex items-center">
              <span className="text-default-400 text-small">ETH</span>
            </div>
          }
        />
        <Button type="submit" className="font-bold text-[1rem]" color="primary">
          Donate
        </Button>
      </form>
      <div className="w-[50%] border-1 rounded-lg p-4 flex flex-col gap-6">
        <Image
          alt="clouds"
          src={'https://nextui-docs-v2.vercel.app/images/hero-card-complete.jpeg'}
          width={530}
          height={348}
          className="object-cover overflow-hidden w-full"
        />
        <div className=" bg-white rounded-xl flex flex-col gap-4">
          <p className="font-semibold text-[1.5rem] overflow-hidden overflow-ellipsis whitespace-nowrap">
            {projectTitle}
          </p>
          <div className="flex gap-4 items-center ">
            <Avatar src="" />
            <p className="text-[--main-color] font-medium">{}</p>
          </div>
          <div className="flex gap-4 items-center">
            <p className="text-gray-500 text-[1.2rem]"> Raised:</p>
            <p className="text-green-500 text-[1.5rem] font-normal">${`0`}</p>
          </div>
          <p className=" text-[#656c82] h-[4.5rem] overflow-hidden">{}</p>
        </div>
      </div>
    </div>
  );
}
