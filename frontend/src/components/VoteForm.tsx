'use client';
import { VotingBase } from '@/abis/VotingBase';
import { VotingBaseAddress } from '@/constants';
import { Avatar, Button, Image, Radio, RadioGroup } from '@nextui-org/react';
import { useRouter, useSearchParams } from 'next/navigation';
import { useState } from 'react';
import toast from 'react-hot-toast';
import { useReadContract, useWriteContract } from 'wagmi';

export default function VoteForm() {
  const searchParams = useSearchParams();
  const router = useRouter();
  const id = searchParams.get('projectId');
  const [voteState, setVoteState] = useState(true);

  const { writeContractAsync } = useWriteContract();

  const result = useReadContract({
    abi: VotingBase,
    address: VotingBaseAddress,
    functionName: 'getProposal',
    args: [BigInt((id as string).slice(0, -1))],
  });

  const vote = () => {
    writeContractAsync({
      abi: VotingBase,
      address: VotingBaseAddress,
      functionName: 'vote',
      args: [BigInt((id as string).slice(0, -1)), voteState],
    }).then(() => {
      toast.success('投票成功');
      router.push('/');
    });
  };

  return (
    <div className="flex items-center gap-8">
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
            {result.data?.name}
          </p>
          <div className="flex gap-4 items-center ">
            <Avatar src="" />
            <p className="text-[--main-color] font-medium">{}</p>
          </div>
          <div className="flex gap-4 items-center">
            <p className="text-gray-500 text-[1.2rem]"> Target Amount:</p>
            <p className=" text-[1.5rem] font-normal">${Number(result.data?.targetAmount)}</p>
          </div>
          <p className=" text-[#656c82] h-[4.5rem] overflow-hidden">{}</p>
        </div>
      </div>
      <div className="flex flex-col gap-5">
        <RadioGroup
          label="Please Select your support state"
          color="primary"
          onChange={(e) => {
            e.target.value === 'yes' ? setVoteState(true) : setVoteState(false);
          }}
        >
          <Radio value="yes">Yes</Radio>
          <Radio value="no">No</Radio>
        </RadioGroup>
        <Button color="primary" className="text-[1rem] font-bold" onClick={vote}>
          Confirm
        </Button>
      </div>
    </div>
  );
}
