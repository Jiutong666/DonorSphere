'use client';

import { Tab, Tabs } from '@nextui-org/react';
import DonateCard from './DonateCard';
import DonateTable from './DonateTable';

export default function InfoTabs({ description }: { description?: string }) {
  return (
    <div className="flex w-full flex-col">
      <Tabs aria-label="Options" color="primary" fullWidth size="lg">
        <Tab key="About" title="About">
          <div>{description}</div>
        </Tab>
        <Tab key="Update" title="Update">
          Waiting
        </Tab>
        <Tab key="Donations" title="Donations">
          <div className="flex flex-row gap-6">
            <DonateTable rows={[]} />
            <DonateCard />
          </div>
        </Tab>
      </Tabs>
    </div>
  );
}
