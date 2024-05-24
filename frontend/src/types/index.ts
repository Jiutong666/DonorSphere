export interface HomeCard {
  title: string;
  description: string;
  buttonLabel: string;
  icon: string;
}

export interface ProjectInfo {
  id: string;
  name: string;
  description: string;
  ngoID?: string;
  picture: string;
  raisedAmount: string;
  targetAmount: string;
  beneficiary: string;
  founder: string;
  createTime?: string;
  endTime?: string;
}

export interface UserInfo {
  id: string;
  name: string;
  avatar: string;
  ngoID: string;
  ngoName: string;
  createdTime: string;
}

export interface OrgInfo {
  id: string;
  name: string;
  description: string;
  founder: string;
  founders: string[];
  picture: string;
  createTime: string;
}

export interface DonateTable {
  key: string;
  donatedAt: string;
  donor: string;
  amount: string;
  usdValue: string;
  tx?: string;
}
