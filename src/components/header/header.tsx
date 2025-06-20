import React from 'react';


interface HeaderProps {
    organizationName?: string;
    organizationLogo?: string;
    onLogoClick?: () => void;
    onNavLinkClick?: (link: string) => void;
    navLinks?: { name: string; iconClass: string; id: string }[];
}
const Header: React.FC<HeaderProps> = ({ organizationName, organizationLogo, onLogoClick, onNavLinkClick, navLinks }) => {
  return (
    <header className="header"> 
      <div className="logo">
      </div>
      <nav className="nav-links">
      
      </nav>
    </header>
  );
}
export default Header;
