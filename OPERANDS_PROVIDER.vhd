-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- PRECOMPUTE BLOCK ( 2 OPERANDS ) --> OPERANDS_PROVIDER
-- DESCRIPTION : Return operands ready for computation according to E_DATA value
--
--  E_DATA = 00 --> Subnormals (as provided)
--           01 --> Normals (as provided)
--           10 --> Mix ( Subnormal value normalized)
--           11 --> ERROR
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY OPERANDS_PROVIDER IS

    PORT(

        A_SUBNORM     :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Operands A when both operands are subnormal
        B_SUBNORM     :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Operands B when both operands are subnormal
        A_NORM        :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Operands A from Normalization stage
        B_NORM        :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Operands B from Normalization stage
        E_DATA        :  IN STD_LOGIC_VECTOR( 1 DOWNTO 0); -- Hint operands type
        A_RDY       : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); -- A ready for computation
        B_RDY       : OUT STD_LOGIC_VECTOR(36 DOWNTO 0)  -- B ready for computation
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF OPERANDS_PROVIDER IS 

    BEGIN

        ready_operand_a : WITH E_DATA SELECT

            A_RDY <= A_SUBNORM WHEN "00",
                     A_NORM    WHEN "01",
                     A_NORM    WHEN "10",
                     "-------------------------------------" WHEN OTHERS;

        ready_operand_b : WITH E_DATA SELECT

            B_RDY <= B_SUBNORM WHEN "00",
                     B_NORM    WHEN "01",
                     B_NORM    WHEN "10",
                     "-------------------------------------" WHEN OTHERS;





END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------