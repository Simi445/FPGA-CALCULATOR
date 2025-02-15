library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity SignedIntegerExtractor is
    Port (
        input_vector : in  std_logic_vector(31 downto 0);
        output_vector: out std_logic_vector(31 downto 0)
    );
end SignedIntegerExtractor;

architecture Behavioral of SignedIntegerExtractor is
    signal sign: std_logic_vector(3 downto 0);
    signal digits: std_logic_vector(27 downto 0);
begin

    process(input_vector)
    variable abs_input_int,input_int: integer:=0;
    begin
        input_int := to_integer(signed(input_vector));

        if input_int < 0 then
            abs_input_int := -input_int;
            sign <= "1010";
        else
            abs_input_int := input_int;
            sign <= (others => '0');
        end if;

        for i in 0 to 6 loop
            digits(4*i+3 downto 4*i) <= std_logic_vector(to_unsigned(abs_input_int mod 10, 4));
            abs_input_int := abs_input_int / 10;
        end loop;
    end process;

    output_vector <= sign & digits;

end Behavioral;
