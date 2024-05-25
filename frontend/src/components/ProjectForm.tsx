'use client';
import { ImageUploadPreview } from '@/components/ImageUploadPreview';
import { Button, DateInput, Input, Textarea } from '@nextui-org/react';
import { useState } from 'react';

export default function ProjectForm() {
  const submitHandler = (formData: FormData) => {};
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
        type="text"
        label="Target Amount"
        name="targetAmount"
        labelPlacement="outside"
        errorMessage="Please enter this field"
        placeholder="Please enter your target amount"
      />

      <DateInput label="End Date" labelPlacement="outside" name="endDate" isRequired />

      <Button type="submit" className="w-[11rem] bg-[--main-color] text-white font-bold mx-auto">
        Submit
      </Button>
    </form>
  );
}
