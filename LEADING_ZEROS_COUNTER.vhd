-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- PRECOMPUTE BLOCK --> MIX_BLOCK --> LEADING_ZEROS_COUNTER
-- DESCRIPTION : Count the number of leading zeros in subnormal operand mantissa
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY LEADING_ZEROS_COUNTER IS

    PORT(

        M     :  IN STD_LOGIC_VECTOR(27 DOWNTO 0); -- Subnormal operand mantissa + guard bits
        COUNT : OUT STD_LOGIC_VECTOR( 4 DOWNTO 0)  -- Number of leading zeros in M
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF LEADING_ZEROS_COUNTER IS 

    SIGNAL AUX : STD_LOGIC_VECTOR( 7 DOWNTO 0);
    SIGNAL ZERO_VECTOR : STD_LOGIC_VECTOR( 27 DOWNTO 0) := (OTHERS => '0');

    BEGIN 

        AUX <= "--------" WHEN M(27) = '-' else
               X"1C" WHEN M(27 DOWNTO  0) = ZERO_VECTOR(27 DOWNTO  0) ELSE
               X"1B" WHEN M(27 DOWNTO  1) = ZERO_VECTOR(27 DOWNTO  1) ELSE
               X"1A" WHEN M(27 DOWNTO  2) = ZERO_VECTOR(27 DOWNTO  2) ELSE
               X"19" WHEN M(27 DOWNTO  3) = ZERO_VECTOR(27 DOWNTO  3) ELSE
               X"18" WHEN M(27 DOWNTO  4) = ZERO_VECTOR(27 DOWNTO  4) ELSE
               X"17" WHEN M(27 DOWNTO  5) = ZERO_VECTOR(27 DOWNTO  5) ELSE
               X"16" WHEN M(27 DOWNTO  6) = ZERO_VECTOR(27 DOWNTO  6) ELSE
               X"15" WHEN M(27 DOWNTO  7) = ZERO_VECTOR(27 DOWNTO  7) ELSE
               X"14" WHEN M(27 DOWNTO  8) = ZERO_VECTOR(27 DOWNTO  8) ELSE
               X"13" WHEN M(27 DOWNTO  9) = ZERO_VECTOR(27 DOWNTO  9) ELSE
               X"12" WHEN M(27 DOWNTO 10) = ZERO_VECTOR(27 DOWNTO 10) ELSE
               X"11" WHEN M(27 DOWNTO 11) = ZERO_VECTOR(27 DOWNTO 11) ELSE
               X"10" WHEN M(27 DOWNTO 12) = ZERO_VECTOR(27 DOWNTO 12) ELSE
               X"0F" WHEN M(27 DOWNTO 13) = ZERO_VECTOR(27 DOWNTO 13) ELSE
               X"0E" WHEN M(27 DOWNTO 14) = ZERO_VECTOR(27 DOWNTO 14) ELSE
               X"0D" WHEN M(27 DOWNTO 15) = ZERO_VECTOR(27 DOWNTO 15) ELSE
               X"0C" WHEN M(27 DOWNTO 16) = ZERO_VECTOR(27 DOWNTO 16) ELSE
               X"0B" WHEN M(27 DOWNTO 17) = ZERO_VECTOR(27 DOWNTO 17) ELSE
               X"0A" WHEN M(27 DOWNTO 18) = ZERO_VECTOR(27 DOWNTO 18) ELSE
               X"09" WHEN M(27 DOWNTO 19) = ZERO_VECTOR(27 DOWNTO 19) ELSE
               X"08" WHEN M(27 DOWNTO 20) = ZERO_VECTOR(27 DOWNTO 20) ELSE
               X"07" WHEN M(27 DOWNTO 21) = ZERO_VECTOR(27 DOWNTO 21) ELSE
               X"06" WHEN M(27 DOWNTO 22) = ZERO_VECTOR(27 DOWNTO 22) ELSE
               X"05" WHEN M(27 DOWNTO 23) = ZERO_VECTOR(27 DOWNTO 23) ELSE
               X"04" WHEN M(27 DOWNTO 24) = ZERO_VECTOR(27 DOWNTO 24) ELSE
               X"03" WHEN M(27 DOWNTO 25) = ZERO_VECTOR(27 DOWNTO 25) ELSE
               X"02" WHEN M(27 DOWNTO 26) = ZERO_VECTOR(27 DOWNTO 26) ELSE
               X"01" WHEN M(27 DOWNTO 27) = ZERO_VECTOR(27 DOWNTO 27) ELSE
               X"00" ;

        COUNT <= AUX(4 DOWNTO 0);
  
END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------