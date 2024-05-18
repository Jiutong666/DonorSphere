import { Image, Link, Navbar, NavbarBrand, NavbarContent, NavbarItem } from '@nextui-org/react';
import '@rainbow-me/rainbowkit/styles.css';
import WalletConnect from './WalletConnect';

export default function Navigation() {
  return (
    <Navbar maxWidth="2xl" isBlurred={false}>
      <NavbarBrand>
        <Link className="text-black" href="/">
          <Image src="/logo.svg" width="50" alt="logo" />
          <p className="ml-[0.5rem] font-medium text-[2rem] ">DonorSphere</p>
        </Link>
      </NavbarBrand>

      <NavbarContent justify="end">
        <NavbarItem>
          <Link className="text-[--main-color] font-bold text-[1rem] cursor-pointer" href="/project/create">
            CREATE A PROJECT
          </Link>
        </NavbarItem>
        <NavbarItem>
          <WalletConnect />
        </NavbarItem>
      </NavbarContent>
    </Navbar>
  );
}
