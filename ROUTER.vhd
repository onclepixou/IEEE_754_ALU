-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- PRECOMPUTE BLOCK --> ROUTER
-- DESCRIPTION : Send data to either SUBNORMAL, NORMAL or MIXED blocks according to E_DATA
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

ENTITY ROUTER IS

    PORT(

        A             :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 1
        B             :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 2
        E_DATA        :  IN STD_LOGIC_VECTOR( 1 DOWNTO 0); -- Hint operands type
        A_SUBNORMAL   : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); -- Subnormal A output
        B_SUBNORMAL   : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); -- Subnormal B output
        A_NORMAL      : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); -- Normal A output
        B_NORMAL      : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); -- Normal B output
        A_MIX         : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); -- Mixed A output
        B_MIX         : OUT STD_LOGIC_VECTOR(36 DOWNTO 0)  -- Mixed B output
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF ROUTER IS 

    BEGIN

        subnormal_case_a : WITH E_DATA SELECT

            A_SUBNORMAL <= A WHEN "00",
            "-------------------------------------" WHEN OTHERS;
        
        subnormal_case_b : WITH E_DATA SELECT

            B_SUBNORMAL <= B WHEN "00",
            "-------------------------------------" WHEN OTHERS;

        normal_case_a : WITH E_DATA SELECT

            A_NORMAL <= A WHEN "01",
            "-------------------------------------" WHEN OTHERS;
        
        normal_case_b : WITH E_DATA SELECT

            B_NORMAL <= B WHEN "01",
            "-------------------------------------" WHEN OTHERS;

        mix_case_a : WITH E_DATA SELECT

            A_MIX <= A WHEN "10",
            "-------------------------------------" WHEN OTHERS;
        
        mix_case_b : WITH E_DATA SELECT

            B_MIX <= B WHEN "10",
            "-------------------------------------" WHEN OTHERS;




END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------