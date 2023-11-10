----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/28/2023 07:26:24 PM
-- Design Name: 
-- Module Name: MMXALU_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MMXALU_tb is
end MMXALU_tb;

architecture Behavioral of MMXALU_tb is

component MMXALU is
    Port (Rs1: in std_logic_vector(127 downto 0);
    Rs2: in std_logic_vector(127 downto 0);
    Rs3: in std_logic_vector(127 downto 0);
    Instr: in std_logic_vector(24 downto 0);
    Rd: out std_logic_vector(127 downto 0)
    );
end component;

signal Rs1, Rs2, Rs3, Rd : std_logic_vector(127 downto 0);
signal Instr : std_logic_vector(24 downto 0);

begin
mmx_alu : MMXALU port map(Rs1 => Rs1, Rs2 => Rs2, Rs3 => Rs3, Instr => Instr, Rd => Rd);

sim: process
begin
    Instr <= "0011000000000000111100000"; wait for 10 ns;
    report to_hstring(Rd);
    Instr <= "0001000000000000100000000"; wait for 10 ns; --tests load word works, and preserves
    report to_hstring(Rd);
    wait for 10 ns; report "R4 Instructions";
    --R4 Instructions
    Rs3 <= x"8000800000000002000000027fff7fff"; 
    Rs2 <= x"7fff7fff00000002000000027fff7fff"; 
    Rs1 <= x"8000000070000000000000007fffffff"; 
    Instr <= "1000000000000000100000000"; report " Rs1: " & to_hstring( Rs1) & " Rs2: " & to_hstring( Rs2) & " Rs3:" & to_hstring(Rs3) &  " Rd: " & to_hstring(Rd);wait for 10 ns; --SIMAL 
    Instr <= "1000100000000000100000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) & " Rs3:" & to_hstring(Rs3) &  " Rd: " & to_hstring(Rd); --SIMAH
    Rs1 <= x"7fffffff700000000000000080000000"; 
    Instr <= "1001000000000000100000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) & " Rs3:" & to_hstring(Rs3) &  " Rd: " & to_hstring(Rd);--SIMSL
    Instr <= "1001100000000000100000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) & " Rs3:" & to_hstring(Rs3) &  " Rd: " & to_hstring(Rd);--SIMSH
    Rs3 <= x"7fffffff70000000000000007fffffff";
    Rs2 <= x"7fffffff700000000000000080000000";
    Rs1 <= x"7fffffffffffffff8000000000000000";
    Instr <= "1010000000000000100000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) & " Rs3:" & to_hstring(Rs3) &  " Rd: " & to_hstring(Rd);--SLMAL
    Instr <= "1010100000000000100000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) & " Rs3:" & to_hstring(Rs3) &  " Rd: " & to_hstring(Rd);--SLMAH
    Rs1 <= x"80000000000000007fffffffffffffff";
    Instr <= "1011000000000000100000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) & " Rs3:" & to_hstring(Rs3) &  " Rd: " & to_hstring(Rd);--SLMSL
    Instr <= "1011100000000000100000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) & " Rs3:" & to_hstring(Rs3) &  " Rd: " & to_hstring(Rd);--SLMSH
    wait for 10 ns; report "R3 Instructions";
    -- R3 Instructions
    Instr <= "1111110000000000100000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd);--NOP, just need to see change
    Rs1 <= x"00020001000a000800020001000c0008";
    Instr <= "1111110001000110000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd);--SHRHI, shifting by three to confirm shift, and zero brought in on left
    Rs2 <= x"7fffffff000000020000000080000000";
    Instr <= "1111110010000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd);--AU, just adds unsigned, will test max and min values
     Rs1 <= x"000100020003ffff0000000000000000";
    Instr <= "1111110011000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --CNT1H, counts 1s
    Rs2 <= x"7fff7fff00000002000000027fff7fff"; 
    Rs1 <= x"8000000070000000000000007fffffff"; 
    Instr <= "1111110100000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --AHS, test max and min overflow for saturation and also normal cases
    Rs1 <= not Rs2;
    Instr <= "1111110101000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --OR, should be all one
    Rs1 <= not Rs1;
    Instr <= "1111110101000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --OR, should match rs2
    Rs1 <= x"000000000000000000000000f000000f";
    Instr <= "1111110110000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --BCW, should all be f000000f
    Rs2 <= x"ffffffff0000000000000000ffffffff";
    Rs1 <= not Rs2;
    Instr <= "1111110111000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --MAXWS, should be all f
    Instr <= "1111111000000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --MINWS, should be all 0
    Rs1 <= x"000100020003ffff0000000000000000";
    Instr <= "1111111001000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --MLHU
    Rs1 <= x"ffffffff00000000000000007fff7fff";
    Instr <= "1111111010000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --MLHSS
    Rs1 <= x"ffff00000000000000000000ffffffff";
    Instr <= "1111111011000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --AND
    Instr <= "1111111100000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring( Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --INVB
    Rs1 <= x"00020001000300040002000100030004";
    Rs2 <= x"00000003000000030000000300000003";
    Instr <= "1111111101000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --ROTW
    Rs2 <= x"7fff7fff00000002000000027fff7fff"; 
    Rs1 <= x"8000000070000000000000007fffffff"; 
    Instr <= "1111111100000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --SFWU
    Instr <= "1111111110000000000000000"; wait for 10 ns;report " Rs1: " & to_hstring(Rs1) & " Rs2: " & to_hstring(Rs2) &  " Rd: " & to_hstring(Rd); --SFHS
    
    
    wait;
    
    
    
end process;

end Behavioral;
