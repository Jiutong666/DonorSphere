'use client';
import { ImageUploadPreview } from '@/components/ImageUploadPreview';
import { Button, Input, Textarea } from '@nextui-org/react';
import { useState } from 'react';

export default function OrganizationForm() {
  const submitHandler = (formData: FormData) => {};
  const [imagePreview, setImagePreview] = useState('');
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
