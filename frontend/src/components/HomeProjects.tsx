'use client';
import { VotingBase } from '@/abis/VotingBase';
import { config } from '@/configs/rainbowkit';
import { VotingBaseAddress } from '@/constants';
import { Proposal } from '@/types';
import { useState } from 'react';
import { useReadContract } from 'wagmi';
import { readContract } from 'wagmi/actions';
import ProjectCardItem from './ProjectCardItem';
import VoteCardItem from './VoteCardItem';

export default function HomeProjects() {
  const projects: Proposal[] = [];

  const [projectsLength, setProjectsLength] = useState(projects.length);

  const ids = useReadContract({
    abi: VotingBase,
    address: VotingBaseAddress,
    functionName: 'getAllProposalIds',
  });

  if (ids.data && ids.isFetched && !projectsLength) {
    ids.data.forEach((id: bigint) => {
      readContract(config, {
        abi: VotingBase,
        address: VotingBaseAddress,
        functionName: 'getProposal',
        args: [id],
      }).then((value: Proposal) => {
        projects.push(value);
        setProjectsLength(projects.length);
      });
    });
  }

  if (!projectsLength) {
    return <div>Hold on</div>;
  }

  return (
    <div className="max-w-[114rem] w-full mt-20 bg-white px-[20rem] py-10">
      {!projectsLength ? (
        <div>Please hold on ...</div>
      ) : (
        <div>
          <div className="">
            <p className="font-bold text-[3rem] text-[#515768] mb-4">Projects</p>
            <div className="flex flex-row flex-wrap gap-9 justify-between">
              {projects.map((project) => {
                project.passed ? (
                  <ProjectCardItem
                    key={project.name}
                    id={project.id}
                    name={project.name}
                    creator={'0xAA'}
                    length={projectsLength}
                    currentAmount={project.currentAmount}
                    targetAmount={project.targetAmount}
                    beneficiary={project.beneficiary}
                  />
                ) : (
                  <VoteCardItem
                    key={project.name}
                    id={project.id}
                    name={project.name}
                    creator={'0xAA'}
                    length={projectsLength}
                    currentAmount={project.currentAmount}
                    targetAmount={project.targetAmount}
                    beneficiary={project.beneficiary}
                  />
                );
              })}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
