-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- PRECOMPUTE BLOCK ( 2 OPERANDS ) --> NORMAL_SUBNORMAL_ROUTER
-- DESCRIPTION : Returns normalized mix operands or normal operands depending of E_DATA
--
--  E_DATA = 00 --> Subnormals 
--           01 --> Normals 
--           10 --> Mix 
--           11 --> ERROR
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY NORMAL_SUBNORMAL_ROUTER IS

    PORT(

        A_NORM        :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Operands A when both operands are normal
        B_NORM        :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Operands B when both operands are normal
        A_NORMALIZED  :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Operands A from Normalization stage
        B_NORMALIZED  :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Operands B from Normalization stage
        E_DATA        :  IN STD_LOGIC_VECTOR( 1 DOWNTO 0); -- Hint operands type
        A_OUT         : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); -- ROUTER_OUT
        B_OUT         : OUT STD_LOGIC_VECTOR(36 DOWNTO 0)  -- ROUTER_OUT
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF NORMAL_SUBNORMAL_ROUTER IS 

    BEGIN

        ready_operand_a : WITH E_DATA SELECT

            A_OUT <= A_NORM          WHEN "01",
                     A_NORMALIZED    WHEN "10",
                     "-------------------------------------" WHEN OTHERS;

        ready_operand_b : WITH E_DATA SELECT

            B_OUT <= B_NORM          WHEN "01",
                     B_NORMALIZED    WHEN "10",
                     "-------------------------------------" WHEN OTHERS;





END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------