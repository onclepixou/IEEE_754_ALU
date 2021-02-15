-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- PRECOMPUTE BLOCK --> SUBNORMAL_BLOCK
-- DESCRIPTION : Prepare both subnormal operands for computation
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY SUBNORMAL_BLOCK IS

    PORT(

        A             :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 1 ( subnormal )
        B             :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 2 ( subnormal )
        SA            : OUT STD_LOGIC;                     -- Sign of operand A
        SB            : OUT STD_LOGIC;                     -- Sign of operand B
        MA            : OUT STD_LOGIC_VECTOR(27 DOWNTO 0); -- Mantissa of operand A + guard bits
        MB            : OUT STD_LOGIC_VECTOR(27 DOWNTO 0)  -- Mantissa of operand B + guard bits
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF SUBNORMAL_BLOCK IS 

    BEGIN

        SA <= A(36); -- Sign of A 
        SB <= B(36); -- Sign of B

        MA <= A(27 DOWNTO 0); -- Mantissa + guard bits for A
        MB <= B(27 DOWNTO 0); -- Mantissa + guard bits for B
        

END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------