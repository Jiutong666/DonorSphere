'use client';
import { Avatar, Button, Image, Input } from '@nextui-org/react';
import { useSearchParams } from 'next/navigation';
import { ChangeEvent, useState } from 'react';

export default function DonateForm() {
  const searchParams = useSearchParams();
  const id = searchParams.get('projectId');
  const projectTitle = searchParams.get('projectTitle');

  const [amount, setAmount] = useState('');
  const amountHandler = (event: ChangeEvent<HTMLInputElement>) => {
    const inputValue = event.target.value;
    // 使用正则表达式匹配数字和小数点
    const regex = /^\d*\.?\d*$/;
    if (regex.test(inputValue)) {
      setAmount(inputValue);
    }
  };

  return (
    <div className="flex justify-around gap-8">
      <form className="p-6 bg-white rounded-lg border-1 w-[50%] flex flex-col gap-6">
        <div className="rounded-xl border-1 p-4 bg-white">
          <p className="font-semibold text-[1.2rem] mb-4">100% goes to the project always.</p> Every donation is
          peer-to-peer, with no fees and no middlemen.
        </div>
        <Input label="Address" value="0000" labelPlacement="outside" isDisabled isRequired />
        <Input
          value={amount}
          placeholder="Amount"
          label="Amount"
          labelPlacement="outside"
          isRequired
          onChange={amountHandler}
        />
        <Button type="submit" className="font-bold text-[1rem]" color="primary">
          Transfer
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
            {projectTitle}111
          </p>
          <div className="flex gap-4 items-center ">
            <Avatar src="" />
            <p className="text-[--main-color] font-medium">{}Shawbit</p>
          </div>
          <div className="flex gap-4 items-center">
            <p className="text-gray-500 text-[1.2rem]"> Raised:</p>
            <p className="text-green-500 text-[1.5rem] font-normal">${`0`}</p>
          </div>
          <p className=" text-[#656c82] h-[4.5rem] overflow-hidden">{}description</p>
        </div>
      </div>
    </div>
  );
}
