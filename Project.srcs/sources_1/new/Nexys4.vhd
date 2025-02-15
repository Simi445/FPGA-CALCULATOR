----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2023 04:28:05 PM
-- Design Name: 
-- Module Name: Nexys4 - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Nexys4 is
Port
(
signal clk:in std_logic;
signal btn:in std_logic_vector(1 downto 0);
signal sw:in std_logic_vector(15 downto 0);
signal led:out std_logic_vector(15 downto 0);
signal cat:out std_logic_vector(7 downto 0);
signal an:out std_logic_vector(7 downto 0);

signal Data_MEM: in std_logic_vector(17 downto 0);
signal FLAG: in std_logic;
signal is_reset: out std_logic
);
end Nexys4;

architecture Behavioral of Nexys4 is
signal choose_function:std_logic;
signal function_counter:std_logic_vector(1 downto 0):=(others=>'0');
signal rst:std_logic;
signal result:std_logic_vector(31 downto 0);
signal Data:std_logic_vector(31 downto 0);
signal Data_Formated:std_logic_vector(31 downto 0);

--Aici is toate chestiile care au treaba cu blink
signal blink_counter:integer:=0;
signal blink_clk:std_logic:='0';
signal blink_flag:std_logic:='0';

-- Operanzii
signal OP1,OP2:std_logic_vector(7 downto 0):=(others=>'0');
signal operation:std_logic_vector(1 downto 0):=(others=>'0');

begin

upper_button:entity WORK.MPG port map
(

btn=>btn(1),
clk=>clk,
en=>choose_function
);

central_button:entity WORK.MPG port map
(

btn=>btn(0),
clk=>clk,
en=>rst
);

alu_example:entity WORK.Alu port map
(
a=> OP1,
b=> OP2,
func=>operation,
result=>result
);

Data<=result;
is_reset<=blink_flag;
FORMAT_DATA: entity WORK.SignedIntegerExtractor port map
(
     input_vector=>Data,
     output_vector=>Data_Formated
);

displayer:entity WORK.displ7seg port map
(
clk=>clk,
rst=>'0',
Data=>Data_Formated,
An=>An,
Seg=>cat,
blink=>blink_clk,
blink_status=>blink_flag
);


CHOOSE_MODES: process(clk)
begin
    if clk = '1' and clk'event then
        if (FLAG = '1') then
            operation <= Data_MEM(17) & Data_MEM(16);
            OP1 <= Data_MEM(15 downto 8);
            OP2 <= Data_MEM(7 downto 0);
        elsif (FLAG = '0') then
            if choose_function = '1' then
                function_counter <= function_counter + 1;
            end if;
            operation <= function_counter;
            OP1 <= sw(15 downto 8);
            OP2 <= sw(7 downto 0);
        end if;
    end if;
end process;


BLINK_RATE:process(clk,rst)
begin
if rst='1' then
    blink_counter<=0;
    blink_clk<='0';
 elsif clk='1' and clk'event then
    if blink_counter<49999999 then
        blink_counter<=blink_counter+1;
    else
        blink_counter<=0;
        blink_clk<=not(blink_clk);
    end if;
 end if; 
end process;


RESET:process(rst,sw)
begin
if rst='1' and FLAG='0' then
    if sw=x"0000" then 
        blink_flag<='0';
    else
        blink_flag<='1';
    end if;
end if;

end process;


BLINK_P:process(clk)
begin
if clk='1'  and clk'event then
    if blink_flag='0' then
        led(15)<='0';
    else
        led(15)<=blink_clk;
    end if;
end if;
end process;
end Behavioral;
