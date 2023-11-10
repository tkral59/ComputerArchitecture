----------------------------------------------------------------------------------
-- Company: Stony Brook University ESE 345
-- Engineer: Thomas Kral
-- 
-- Create Date: 10/28/2023 01:54:08 PM
-- Design Name: MMXALU
-- Module Name: MMXALU - Behavioral
-- Project Name: Project Part 1
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
use IEEE.numeric_std.ALL;
use ieee.std_logic_signed.ALL;


entity MMXALU is
port(
Rs1: in std_logic_vector(127 downto 0);
Rs2: in std_logic_vector(127 downto 0);
Rs3: in std_logic_vector(127 downto 0); 
Instr: in std_logic_vector(24 downto 0);
Rd: out std_logic_vector(127 downto 0));
end MMXALU;

architecture Behavioral of MMXALU is
function saturate32(x: signed(31 downto 0); y:signed(31 downto 0)) return std_logic_vector is
variable sum: signed(31 downto 0);
begin
    sum := (x + y);
    if sum < 0 and x > 0 and y > 0 then
        sum := x"7fffffff";
        return std_logic_vector(sum);
    elsif sum > 0 and x < 0 and y < 0 then
        sum := x"80000000";
        return std_logic_vector(sum);
    else
        return std_logic_vector(sum);
    end if;
end function;
function saturate32sub(x: signed(31 downto 0); y:signed(31 downto 0)) return std_logic_vector is
variable sum: signed(31 downto 0);
begin
    sum := (x - y);
    if sum < 0 and x > 0 and y < 0 then
        sum := x"7fffffff";
        return std_logic_vector(sum);
    elsif sum > 0 and x < 0 and y > 0 then
        sum := x"80000000";
        return std_logic_vector(sum);
    else
        return std_logic_vector(sum);
    end if;
end function;
function saturate64(x: signed(63 downto 0); y:signed(63 downto 0)) return std_logic_vector is
variable sum: signed(63 downto 0);
begin
    sum := (x + y);
    if sum < 0 and x > 0 and y > 0 then
        sum := x"7fffffffffffffff";
        return std_logic_vector(sum);
    elsif sum > 0 and x < 0 and y < 0 then
        sum := x"8000000000000000";
        return std_logic_vector(sum);
    else
        return std_logic_vector(sum);
    end if;
end function;
function saturate64sub(x: signed(63 downto 0); y:signed(63 downto 0)) return std_logic_vector is
variable sum: signed(63 downto 0);
begin
    sum := (x - y);
    if sum < 0 and x > 0 and y < 0 then
        sum := x"7fffffffffffffff";
        return std_logic_vector(sum);
    elsif sum > 0 and x < 0 and y > 0 then
        sum := x"8000000000000000";
        return std_logic_vector(sum);
    else
        return std_logic_vector(sum);
    end if;
end function;

begin
    process(Rs1,Rs2,Rs3,Instr)
    variable temp64: std_logic_vector(63 downto 0);
    variable temp128: std_logic_vector(127 downto 0);
    variable sig1:std_logic_vector(31 downto 0);
    variable sig2:std_logic_vector(15 downto 0);
    variable sigint:integer;
    variable sigint2:integer;
    variable sign164:signed(63 downto 0);
    variable sign264:signed(63 downto 0);
    variable sign132:signed(31 downto 0);
    variable sign232:signed(31 downto 0);
    variable sign116:signed(15 downto 0);
    variable sign216:signed(15 downto 0);
    variable sign316:signed(15 downto 0);
    
    begin
        if Instr(24 downto 24) = "0" then
            Rd(((TO_INTEGER(unsigned(Instr(23 downto 21))))*16)+15 downto ((TO_INTEGER(unsigned(Instr(23 downto 21))))*16)) <= Instr(20 downto 5); --Rd(Instr(23:21)*16+15 downto Instr(23:21)*16) <= Instr(20:5) dont need to worry about 0:4
            
        elsif Instr(24 downto 23) = "10" then
            case Instr(22 downto 20) is --R4 instruction
                when "000" => --signed int mult-add low with sat
                    for i in 0 to 3 loop
                        sign116 := signed(Rs3((i*32)+15 downto (i*32)));
                        sign216 := signed(Rs2((i*32)+15 downto (i*32)));
                        sign132 := sign116 * sign216;
                        sign232 := signed(Rs1((i*32)+31 downto (i*32)));
                        Rd((i*32)+31 downto (i*32)) <= saturate32(sign132, sign232);
                    end loop;
                when "001" =>--signed int mult-add high with sat
                    for i in 0 to 3 loop
                        sign116 := signed(Rs3((i*32)+31 downto (i*32)+15));
                        sign216 := signed(Rs2((i*32)+31 downto (i*32)+15));
                        sign132 := sign116 * sign216;
                        sign232 := signed(Rs1((i*32)+31 downto (i*32)));
                        Rd((i*32)+31 downto (i*32)) <= saturate32(sign132, sign232);
                    end loop;
                when "010" =>--signed int mult-sub low with sat
                    for i in 0 to 3 loop
                        sign116 := signed(Rs3((i*32)+15 downto (i*32)));
                        sign216 := signed(Rs2((i*32)+15 downto (i*32)));
                        sign132 := sign116 * sign216;
                        sign232 := signed(Rs1((i*32)+31 downto (i*32)));
                        Rd((i*32)+31 downto (i*32)) <= saturate32sub(sign132, sign232);
                        
                    end loop;
                when "011" =>--signed int mult-sub high with sat
                    for i in 0 to 3 loop
                        sign116 := signed(Rs3((i*32)+31 downto (i*32)+15));
                        sign216 := signed(Rs2((i*32)+31 downto (i*32)+15));
                        sign132 := sign116 * sign216;
                        sign232 := signed(Rs1((i*32)+31 downto (i*32)));
                        Rd((i*32)+31 downto (i*32)) <= saturate32sub(sign132, sign232);
                    end loop;
                when "100" => --sign long int mult-add low with sat
                    for i in 0 to 1 loop
                        sign132 := signed(Rs3((i*64)+31 downto (i*64)));
                        sign232 := signed(Rs2((i*64)+31 downto (i*64)));
                        sign164 := (sign132 * sign232);
                        sign264 := signed(Rs1((i*64)+63 downto (i*64)));
                        Rd((i*64)+63 downto (i*64)) <= saturate64(sign164, sign264);
                    end loop;
                when "101" => --sign long int mult-add high with sat
                    for i in 0 to 1 loop
                        sign132 := signed(Rs3((i*64)+63 downto (i*64)+31));
                        sign232 := signed(Rs2((i*64)+63 downto (i*64)+31));
                        sign164 := sign132 * sign232;
                        sign264 := signed(Rs1((i*64)+63 downto (i*64)));
                        Rd((i*64)+63 downto (i*64)) <= saturate64(sign164, sign264);
                    end loop;
                when "110" => --sign long int mult-sub low with sat
                    for i in 0 to 1 loop
                        sign132 := signed(Rs3((i*64)+31 downto (i*64)));
                        sign232 := signed(Rs2((i*64)+31 downto (i*64)));
                        sign164 := (sign132 * sign232);
                        sign264 := signed(Rs1((i*64)+63 downto (i*64)));
                        Rd((i*64)+63 downto (i*64)) <= saturate64sub(sign164, sign264);
                    end loop;
                when others => --sign long int mult-add high with sat
                    for i in 0 to 1 loop
                        sign132 := signed(Rs3((i*64)+63 downto (i*64)+31));
                        sign232 := signed(Rs2((i*64)+63 downto (i*64)+31));
                        sign164 := sign132 * sign232;
                        sign264 := signed(Rs1((i*64)+63 downto (i*64)));
                        Rd((i*64)+63 downto (i*64)) <= saturate64sub(sign164, sign264);
                    end loop;
            end case;
        else
            case Instr(18 downto 15)is
                when "0000" =>
                    NULL;
                when "0001" => --SHRHI
                    for i in 0 to 7 loop
                        sig2 := Rs1((i*16)+15 downto (i*16));
                        sigint := TO_INTEGER(unsigned(Instr(13 downto 10)));
                        sig2 := std_logic_vector(shift_right(unsigned(sig2), sigint));
                        Rd((i*16)+15 downto (i*16)) <= sig2;
                    end loop;
                when "0010" => --AU (DOES NOT SAY SATURATED)
                    for i in 0 to 3 loop
                        Rd((i*32)+31 downto (i*32)) <= Rs1((i*32)+31 downto (i*32))+Rs2((i*32)+31 downto (i*32));
                    end loop;
                when "0011" => --CNT1H
                    for i in 0 to 7 loop
                        sigint := 0;
                        for j in 0 to 15 loop
                            if Rs1((i*16)+j downto (i*16)+j) = "1" then
                                sigint := sigint + 1;
                            else
                                null;
                            end if;
                        end loop;
                        Rd((i*16)+15 downto (i*16)) <= std_logic_vector(TO_UNSIGNED(sigint, 16));
                    end loop;
                when "0100" => --AHS
                    for i in 0 to 7 loop
                        sign116 := signed(Rs1((i*16)+15 downto (i*16)));
                        sign216 := signed(Rs2((i*16)+15 downto (i*16)));
                        sign316 := sign116 + sign216;
                        if sign316 < 0 and sign116 > 0 and sign216 > 0 then
                            sign316 := x"efff";
                            Rd((i*16)+15 downto (i*16)) <= std_logic_vector(sign316);
                        elsif sign316 > 0 and sign116 < 0 and sign216 < 0 then
                            sign316 := x"8000";
                            Rd((i*16)+15 downto (i*16)) <= std_logic_vector(sign316);
                        else
                            Rd((i*16)+15 downto (i*16)) <= std_logic_vector(sign316);
                        end if;
                    end loop;
                when "0101" => --OR
                    Rd <= Rs1 or Rs2;
                when "0110" => --BCW
                    for i in 0 to 3 loop
                        Rd((i*32)+31 downto (i*32)) <= Rs1(31 downto 0);
                    end loop;
                when "0111" => --MAXWS
                    for i in 0 to 3 loop
                        if signed(Rs1((i*32)+31 downto (i*32))) >= signed(Rs2((i*32)+31 downto (i*32))) then
                            Rd((i*32)+31 downto (i*32)) <= Rs1((i*32)+31 downto (i*32));
                        else
                            Rd((i*32)+31 downto (i*32)) <= Rs2((i*32)+31 downto (i*32));
                        end if;
                    end loop;
                when "1000" => --MINWS
                    for i in 0 to 3 loop
                        if signed(Rs1((i*32)+31 downto (i*32))) >= signed(Rs2((i*32)+31 downto (i*32))) then
                            Rd((i*32)+31 downto (i*32)) <= Rs2((i*32)+31 downto (i*32));
                        else
                            Rd((i*32)+31 downto (i*32)) <= Rs1((i*32)+31 downto (i*32));
                        end if;
                    end loop;
                when "1001" => --MLHU
                    for i in 0 to 3 loop
                        Rd((i*32)+31 downto (i*32)) <= Rs1((i*32)+15 downto (i*32)) * Rs2((i*32)+15 downto (i*32));
                    end loop;
                when "1010" => --MLHSS
                    for i in 0 to 7 loop
                        sign116 := signed(Rs1((i*16)+15 downto (i*16)));
                        sign216 := signed(Rs2((i*16)+15 downto (i*16)));
                        sign132 := sign116 * sign216;
                        sign316 := sign132(15 downto 0);
                        if sign316 < 0 and sign116 > 0 and sign216 > 0 then
                            sign316 := x"efff";
                            Rd((i*16)+15 downto (i*16)) <= std_logic_vector(sign316);
                        elsif sign316 > 0 and sign116 < 0 and sign216 < 0 then
                            sign316 := x"8000";
                            Rd((i*16)+15 downto (i*16)) <= std_logic_vector(sign316);
                        else
                            Rd((i*16)+15 downto (i*16)) <= std_logic_vector(sign316);
                        end if;
                    end loop;
                when "1011" => --AND
                    Rd <= Rs1 and Rs2;
                when "1100" => --invb
                    Rd <= not Rs1;
                when "1101" => --ROTW
                    for i in 0 to 3 loop
                        Rd((i*32)+31 downto (i*32)) <= std_logic_vector(rotate_right(unsigned(Rs1((i*32)+31 downto (i*32))), TO_INTEGER(unsigned(Rs2((i*32)+4 downto (i*32))))));
                    end loop;
                when "1110" => --SFWU
                    for i in 0 to 3 loop
                        Rd((i*32)+31 downto (i*32)) <= Rs2((i*32)+31 downto (i*32)) - Rs1((i*32)+31 downto (i*32));
                    end loop;
                when others => --SFHS
                    for i in 0 to 7 loop
                        sign116 := signed(Rs2((i*16)+15 downto (i*16)));
                        sign216 := signed(Rs1((i*16)+15 downto (i*16)));
                        sign316 := sign116 - sign216;
                        if sign316 < 0 and sign116 > 0 and sign216 > 0 then
                            sign316 := x"efff";
                            Rd((i*16)+15 downto (i*16)) <= std_logic_vector(sign316);
                        elsif sign316 > 0 and sign116 < 0 and sign216 < 0 then
                            sign316 := x"8000";
                            Rd((i*16)+15 downto (i*16)) <= std_logic_vector(sign316);
                        else
                            Rd((i*16)+15 downto (i*16)) <= std_logic_vector(sign316);
                        end if;
                    end loop;
            end case;
        end if;
    end process;

end Behavioral;
