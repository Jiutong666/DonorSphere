'use client';
import { VotingFactory } from '@/abis/VotingFactory';
import { ImageUploadPreview } from '@/components/ImageUploadPreview';
import { VotingFactoryAddress } from '@/constants';
import { Button, Input, Textarea } from '@nextui-org/react';
import { useRouter } from 'next/navigation';
import { useState } from 'react';
import toast from 'react-hot-toast';
import { useWriteContract } from 'wagmi';

export default function OrganizationForm() {
  const [imagePreview, setImagePreview] = useState('');

  const router = useRouter();

  const { writeContractAsync } = useWriteContract();

  const submitHandler = async (formData: FormData) => {
    writeContractAsync({ abi: VotingFactory, address: VotingFactoryAddress, functionName: 'createCampaign' }).then(
      () => {
        toast.success('创建成功');
        router.push('/');
      }
    );
  };

  return (
    <form action={submitHandler} className="flex flex-col gap-6">
      <Input
        isRequired
        name="name"
        type="text"
        label="Name"
        labelPlacement="outside"
        errorMessage="Project enter this field"
        placeholder="Please enter your organization's name"
      />
      <Textarea
        isRequired
        name="description"
        label="Description"
        labelPlacement="outside"
        errorMessage="Project enter this field"
        placeholder="Enter your description"
      />

      <div>
        <p className="flex gap-1 mb-3">
          {`Organization's image`} <span className="text-red-600">*</span>
        </p>
        <ImageUploadPreview imagePreview={imagePreview} setImagePreview={setImagePreview} />
      </div>

      <Button type="submit" className="w-[11rem] bg-[--main-color] text-white font-bold mx-auto">
        Submit
      </Button>
    </form>
  );
}
