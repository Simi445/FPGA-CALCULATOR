----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2023 19:18:16
-- Design Name: 
-- Module Name: Command Unit - Behavioral
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
Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use IEEE.std_logic_arith.All;
Use IEEE.std_logic_unsigned.All;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

Entity Command_Unit Is
	Port (
		Signal clk : In Std_logic;
		Signal btn : In Std_logic_vector(4 Downto 0);
		Signal sw : In Std_logic_vector(15 Downto 0);
		Signal led : Out Std_logic_vector(15 Downto 0);
		Signal cat : Out Std_logic_vector(7 Downto 0);
		Signal an : Out Std_logic_vector(7 Downto 0)
	);
End Command_Unit;

Architecture Behavioral Of Command_Unit Is
	Signal PC : Std_logic_vector(2 Downto 0) := (Others => '0');
	Signal rst_mem : Std_logic:='0';
	Signal DataO : Std_logic_vector(17 Downto 0);
	signal is_reset: Std_logic;
	Signal sel_mode, scroll_up, scroll_down : Std_logic;
	Signal FLAG : Std_logic := '0'; -- incepe automat cu mod manual : 0 - manual, 1 memorie
	Type store Is Array (0 to 7) Of Std_logic_vector(17 Downto 0);
	Signal memory : store :=
		("000000001100000001", "000000001000000001",
		"011000000000000001", "011000000010000001",
		"101000000001111111", "101000000000000010",
		"111000000000000010", "111000000011110000");

Begin
	DataO <= memory(conv_integer(PC));
	down_button : Entity WORK.MPG Port Map
		(

		btn => btn(4),
		clk => clk,
		en => sel_mode
		);

	right_button : Entity WORK.MPG Port Map --cu butonul drept dau scroll down in memorie
		(

		btn => btn(3),
		clk => clk,
		en => scroll_down
		);
		
	central_button:entity WORK.MPG port map
        (
        btn=>btn(0),
        clk=>clk,
        en=>rst_mem
        );

	left_button : Entity WORK.MPG Port Map --cu butonul stang dau scroll up in memorie
		(
		btn => btn(2),
		clk => clk,
		en => scroll_up
		);

	BOARD : Entity WORK.Nexys4 Port Map
		(
		clk => clk,
		btn => btn(1 downto 0),
		sw => sw,
		led => led,
		cat => cat,
		an => an,

		Data_MEM => DataO,
		FLAG => FLAG,
		is_reset=>is_reset
		);

	SHOW_MODE : Process (FLAG) is
	Begin
		If (FLAG = '0') then
			led(8) <= '1';
			led(9) <= '0';
		Elsif (FLAG = '1') then
			led(8) <= '0';
			led(9) <= '1';
		End If;
	End Process;


	FLAGS : Process (clk) is
	Begin
		If clk = '1' And clk'event Then
			If (sel_mode = '1' and is_reset = '0') Then
				FLAG <= Not(FLAG);
			End If;
		End If;
	End Process;
	
	
	NAVIGATE_MEM : Process (clk) Is
    Begin
    If clk = '1' And clk'event Then
        If (FLAG = '1' and rst_mem = '0') Then
            If scroll_down = '1' And scroll_up = '0' Then
                PC <= PC + '1';
            Elsif scroll_down = '0' And scroll_up = '1' Then
                PC <= PC - '1';
            Else
                PC <= PC;
            End If;
       elsif (FLAG = '1'and rst_mem = '1') Then
		PC<="000";
        End If;
    End If;
End Process;


End Behavioral;