'use client';
import { Tab, Tabs } from '@nextui-org/react';
import DonateCard from './DonateCard';
import DonateTable from './DonateTable';

export default function InfoTabs() {
  return (
    <div className="flex w-full flex-col">
      <Tabs aria-label="Options" color="primary" fullWidth size="lg">
        <Tab key="About" title="About">
          <div>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et
            dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex
            ea commodo consequat.
          </div>
        </Tab>
        <Tab key="Update" title="Update">
          Waiting
        </Tab>
        <Tab key="Donations" title="Donations">
          <div className="flex flex-row gap-6">
            <DonateTable />
            <DonateCard />
          </div>
        </Tab>
      </Tabs>
    </div>
  );
}
