import { Card, Divider } from '@nextui-org/react';

export default function DonateCard() {
  return (
    <Card className="p-6 bg-white rounded-lg shadow-lg w-[35%] mx-auto border-1">
      <p className="font-bold">All time donations received</p>
      <p className="text-4xl font-bold mb-2">$196,241.27</p>
      <p className="text-gray-400 mb-4 flex text-[0.75rem]">
        Raised from <p className="text-black mx-1">1602</p> contributors
      </p>
      <p className="text-xl font-semibold mb-2 text-gray-400">Project recipient address</p>
      <Divider />
      <p className="font-semibold mt-2 text-gray-400">0x384884848848484848484848939934</p>
    </Card>
  );
}
