-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- PRECOMPUTE BLOCK --> MUX_NORMAL
-- DESCRIPTION : MUX 
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY MUX_NORMAL IS

    PORT(

        A_NORMAL :  IN STD_LOGIC_VECTOR(36 DOWNTO 0);
        B_NORMAL :  IN STD_LOGIC_VECTOR(36 DOWNTO 0);
        A_MIX    :  IN STD_LOGIC_VECTOR(36 DOWNTO 0);
        B_MIX    :  IN STD_LOGIC_VECTOR(36 DOWNTO 0);
        E_DATA   :  IN STD_LOGIC_VECTOR( 1 DOWNTO 0);
        A        : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); 
        B        : OUT STD_LOGIC_VECTOR(36 DOWNTO 0) 
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF MUX_NORMAL IS 

    BEGIN 

        A <= A_NORMAL WHEN E_DATA = "01" ELSE        -- Normal number
             A_MIX    WHEN E_DATA = "10" ELSE        -- Mixed  number
             "-------------------------------------";
    
        B <= B_NORMAL WHEN E_DATA = "01" ELSE        -- Normal number
             B_MIX    WHEN E_DATA = "10" ELSE        -- Mixed  number
             "-------------------------------------";  

END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------