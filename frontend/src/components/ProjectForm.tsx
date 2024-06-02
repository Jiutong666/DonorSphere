'use client';
import { VotingBase } from '@/abis/VotingBase';
import { ImageUploadPreview } from '@/components/ImageUploadPreview';
import { VotingBaseAddress } from '@/constants';
import { Button, DatePicker, Input, Textarea } from '@nextui-org/react';
import { useRouter } from 'next/navigation';
import { useState } from 'react';
import toast from 'react-hot-toast';
import { useWriteContract } from 'wagmi';

export default function ProjectForm() {
  const router = useRouter();
  const { writeContractAsync } = useWriteContract();
  const submitHandler = (formData: FormData) => {
    const title = formData.get('title') as string;
    const targetAmount = BigInt(formData.get('targetAmount') as unknown as number);
    const beneficiary = formData.get('beneficiary') as `0x${string}`;
    const startDate = BigInt(new Date(formData.get('startDate') as string).getTime());
    const endDate = BigInt(new Date(formData.get('endDate') as string).getTime());
    const duration = formData.get('duration');

    writeContractAsync({
      abi: VotingBase,
      address: VotingBaseAddress,
      functionName: 'createProposal',
      args: [
        title,
        BigInt(targetAmount as unknown as number),
        startDate,
        endDate,
        endDate - startDate,
        beneficiary,
        BigInt(5),
      ],
    })
      .then(() => {
        toast.success('Created Successfully');
        router.push('/');
      })
      .catch(() => {
        toast.error('Interaction has been rejected');
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

      <DatePicker label="Start Date" labelPlacement="outside" name="startDate" isRequired />
      <DatePicker label="End Date" labelPlacement="outside" name="endDate" isRequired />

      <Button type="submit" className="w-[11rem] bg-[--main-color] text-white font-bold mx-auto">
        Submit
      </Button>
    </form>
  );
}
