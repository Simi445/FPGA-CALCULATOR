----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2023 04:31:41 PM
-- Design Name: 
-- Module Name: Alu - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Alu is
Port 
(
signal a:in std_logic_vector(7 downto 0);
signal b:in std_logic_vector(7 downto 0);
signal func:in std_logic_vector(1 downto 0);
signal result:out std_logic_vector(31 downto 0) 
 );
end Alu;

architecture Behavioral of Alu is

signal a1,b1:signed(15 downto 0):= (others=>'0');
signal int_res:signed(31 downto 0):= (others=>'0');
begin

a1<=resize(signed(a),16);
b1<=resize(signed(b),16);

ALU:process(func,a1,b1)
variable ext_res : signed(31 downto 0);
begin

case func is
when "00" => int_res<=resize(a1+b1,32);-- add
when "01" => int_res<=resize(a1-b1,32);-- sub
when "10" => int_res<=a1*b1;
when "11" => 
if(b1/=x"0000") then
int_res <= resize(a1/b1,32);--div
else int_res <=(others=>'0');
end if;
when others=>null; -- teoretic nu se poate sa fie alt ceva
end case;

end process;
result<=std_logic_vector(int_res);
end Behavioral;
