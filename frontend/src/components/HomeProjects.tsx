'use client';
import { VotingBase } from '@/abis/VotingBase';
import { config } from '@/configs/rainbowkit';
import { VotingBaseAddress } from '@/constants';
import { Proposal } from '@/types';
import { useEffect, useState } from 'react';
import { useReadContract } from 'wagmi';
import { readContract } from 'wagmi/actions';
import ProjectCardItem from './ProjectCardItem';
import VoteCardItem from './VoteCardItem';

export default function HomeProjects() {
  const [projects, setProjects] = useState<Proposal[]>([]);

  const ids = useReadContract({
    abi: VotingBase,
    address: VotingBaseAddress,
    functionName: 'getAllProposalIds',
  });

  const getProjects = async (ids: any) => {
    const requests = ids.map((id: any) => {
      return readContract(config, {
        abi: VotingBase,
        address: VotingBaseAddress,
        functionName: 'getProposal',
        args: [id],
      });
    });

    Promise.all(requests).then((results) => setProjects(results));
  };

  useEffect(() => {
    if (ids.data && ids.isFetched && ids.data.length) {
      getProjects(ids.data as bigint[]);
    }
  }, [ids.data, ids.isFetched]);

  return (
    <div className="max-w-[114rem] w-full mt-20 bg-white px-[20rem] py-10">
      {!projects ? (
        <div>Please hold on ...</div>
      ) : (
        <div>
          <div className="">
            <p className="font-bold text-[3rem] text-[#515768] mb-4">Projects</p>
            <div className="flex flex-row flex-wrap gap-9 justify-start">
              {projects.map((project, index) =>
                project.id !== BigInt(0) ? (
                  project?.passed ? (
                    <ProjectCardItem
                      key={index}
                      id={project?.id}
                      name={project?.name}
                      creator={'0xAA'}
                      currentAmount={project?.currentAmount}
                      targetAmount={project?.targetAmount}
                      beneficiary={project?.beneficiary}
                    />
                  ) : (
                    <VoteCardItem
                      key={index}
                      id={project?.id}
                      name={project?.name}
                      creator={'0xAA'}
                      targetAmount={project?.targetAmount}
                      beneficiary={project?.beneficiary}
                    />
                  )
                ) : (
                  ''
                )
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
