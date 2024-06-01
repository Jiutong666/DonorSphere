'use client';
import { VotingBase } from '@/abis/VotingBase';
import { ImageUploadPreview } from '@/components/ImageUploadPreview';
import { VotingBaseAddress } from '@/constants';
import { Button, DateInput, Input, Textarea } from '@nextui-org/react';
import { useState } from 'react';
import { useWriteContract } from 'wagmi';

export default function ProjectForm() {
  const { writeContractAsync } = useWriteContract();
  const submitHandler = (formData: FormData) => {
    const title = formData.get('title') as string;
    const targetAmount = formData.get('targetAmount');
    const beneficiary = formData.get('beneficiary') as `0x${string}`;
    const startDate = formData.get('startDate');
    const endDate = formData.get('endDate');
    const duration = formData.get('duration');

    writeContractAsync({
      abi: VotingBase,
      address: VotingBaseAddress,
      functionName: 'createProposal',
      args: [
        title,
        BigInt(targetAmount as number),
        BigInt(new Date(startDate as string).getTime()),
        BigInt(new Date(endDate as string).getTime()),
        BigInt(duration as number),
        beneficiary,
        BigInt(0),
      ],
    });
  };
  const [imagePreview, setImagePreview] = useState('');

  return (
    <form action={submitHandler} className="flex flex-col gap-6">
      <div>
        <p className="flex gap-1 mb-3">
          Project Image <span className="text-red-600">*</span>
        </p>
        <ImageUploadPreview imagePreview={imagePreview} setImagePreview={setImagePreview} />
      </div>
      <Input
        isRequired
        name="title"
        type="text"
        label="Title"
        labelPlacement="outside"
        errorMessage="Please enter this field"
        placeholder="Please enter your project title"
      />
      <Textarea
        isRequired
        name="description"
        label="Description"
        labelPlacement="outside"
        errorMessage="Please enter this field"
        placeholder="Enter your description"
      />
      <Input
        isRequired
        type="text"
        name="beneficiary"
        label="Beneficiary"
        labelPlacement="outside"
        errorMessage="Please enter this field"
        placeholder="Please enter your address"
      />
      <Input
        isRequired
        type="number"
        label="Target Amount"
        name="targetAmount"
        labelPlacement="outside"
        errorMessage="Please enter this field"
        placeholder="Please enter your target amount"
      />

      <DateInput label="Start Date" labelPlacement="outside" name="startDate" isRequired />
      <DateInput label="End Date" labelPlacement="outside" name="endDate" isRequired />
      <Input
        type="number"
        label="Duration"
        labelPlacement="outside"
        name="duration"
        placeholder="Please enter the duration days"
        isRequired
      />

      <Button type="submit" className="w-[11rem] bg-[--main-color] text-white font-bold mx-auto">
        Submit
      </Button>
    </form>
  );
}
