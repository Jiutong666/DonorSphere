import { Button, Dropdown, DropdownItem, DropdownMenu, DropdownTrigger, Image } from '@nextui-org/react';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import { useRouter } from 'next/navigation';
import { useDisconnect } from 'wagmi';
export default function WalletConnect() {
  const { disconnect } = useDisconnect();
  const router = useRouter();
  return (
    <div
      style={{
        display: 'flex',
        justifyContent: 'flex-end',
        padding: 12,
      }}
    >
      <ConnectButton.Custom>
        {({ account, chain, openChainModal, openConnectModal, mounted }) => {
          return (
            <div
              {...(!mounted && {
                'aria-hidden': true,
                style: {
                  opacity: 0,
                  pointerEvents: 'none',
                  userSelect: 'none',
                },
              })}
            >
              {(() => {
                if (!mounted || !account || !chain) {
                  return (
                    <Button
                      onClick={openConnectModal}
                      className="bg-[--main-color] text-white font-bold text-[1rem] cursor-pointer"
                    >
                      Connect Wallet
                    </Button>
                  );
                }

                if (chain.unsupported) {
                  return (
                    <Button
                      onClick={openChainModal}
                      className="bg-red-600 text-white font-bold text-[1rem] cursor-pointer"
                    >
                      Wrong network
                    </Button>
                  );
                }

                return (
                  <div style={{ display: 'flex', gap: 12 }}>
                    <Button
                      onClick={openChainModal}
                      style={{ display: 'flex', alignItems: 'center' }}
                      className="bg-white rounded-xl border-2 font-bold"
                    >
                      {chain.hasIcon && (
                        <div
                          style={{
                            background: chain.iconBackground,
                            width: 12,
                            height: 12,
                            borderRadius: 999,
                            overflow: 'hidden',
                          }}
                        >
                          {chain.iconUrl && <Image alt={chain.name ?? 'Chain icon'} src={chain.iconUrl} width={12} />}
                        </div>
                      )}
                      {chain.name}
                    </Button>

                    <Dropdown placement="bottom-end">
                      <DropdownTrigger>
                        <Button className="bg-white rounded-xl border-2 font-bold">
                          {account.displayName}
                          {account.displayBalance ? ` (${account.displayBalance})` : ''}
                        </Button>
                      </DropdownTrigger>
                      <DropdownMenu aria-label="Profile Actions" variant="flat" className="text-[1rem] font">
                        <DropdownItem key="myAccount">My Account</DropdownItem>
                        <DropdownItem key="myProjects">My Projects</DropdownItem>
                        <DropdownItem key="createProject">Create a Project</DropdownItem>
                        <DropdownItem
                          key="createCampaign"
                          onPress={() => {
                            router.push('/organization/create');
                          }}
                        >
                          Create a Orginazation
                        </DropdownItem>
                        <DropdownItem
                          key="logout"
                          color="danger"
                          onPress={(e) => {
                            disconnect();
                          }}
                        >
                          Log Out
                        </DropdownItem>
                      </DropdownMenu>
                    </Dropdown>
                  </div>
                );
              })()}
            </div>
          );
        }}
      </ConnectButton.Custom>
    </div>
  );
}
