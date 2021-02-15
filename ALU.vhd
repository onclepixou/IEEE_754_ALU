-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- COMPUTE BLOCK --> ALU
-- DESCRIPTION : Performs +, -, *, / operations depending of OP 
--
--  OP = 00 --> Addition
--       01 --> Substraction
--       10 --> Multiplication
--       11 --> Division
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY ALU IS

    PORT(

        A             :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 1
        B             :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 2
        OP            :  IN STD_LOGIC_VECTOR( 1 DOWNTO 0); -- Hint operands type
        ALU_OUT       : OUT STD_LOGIC_VECTOR(36 DOWNTO 0)  -- Non normalized ALU output
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF ALU IS 

    SIGNAL ALU_ADD_A : STD_LOGIC_VECTOR(36 DOWNTO 0);
    SIGNAL ALU_ADD_B : STD_LOGIC_VECTOR(36 DOWNTO 0);

    SIGNAL ALU_SUB_A : STD_LOGIC_VECTOR(36 DOWNTO 0);
    SIGNAL ALU_SUB_B : STD_LOGIC_VECTOR(36 DOWNTO 0);

    SIGNAL ALU_MUL_A : STD_LOGIC_VECTOR(36 DOWNTO 0);
    SIGNAL ALU_MUL_B : STD_LOGIC_VECTOR(36 DOWNTO 0);

    SIGNAL ALU_DIV_A : STD_LOGIC_VECTOR(36 DOWNTO 0);
    SIGNAL ALU_DIV_B : STD_LOGIC_VECTOR(36 DOWNTO 0);

    BEGIN

        alu_add_a_value : WITH OP SELECT

            ALU_ADD_A <= A WHEN "00",
            "-------------------------------------" WHEN OTHERS;

        alu_add_b_value : WITH OP SELECT

            ALU_ADD_B <= B WHEN "00",
            "-------------------------------------" WHEN OTHERS;

        alu_sub_a_value : WITH OP SELECT

            ALU_SUB_A <= A WHEN "01",
            "-------------------------------------" WHEN OTHERS;

        alu_sub_b_value : WITH OP SELECT

            ALU_SUB_B <= B WHEN "01",
            "-------------------------------------" WHEN OTHERS;

        alu_mul_a_value : WITH OP SELECT

            ALU_MUL_A <= A WHEN "10",
            "-------------------------------------" WHEN OTHERS;

        alu_mul_b_value : WITH OP SELECT

            ALU_MUL_B <= B WHEN "10",
            "-------------------------------------" WHEN OTHERS;

        alu_div_a_value : WITH OP SELECT

            ALU_DIV_A <= A WHEN "11",
            "-------------------------------------" WHEN OTHERS;

        alu_div_b_value : WITH OP SELECT

            ALU_DIV_B <= B WHEN "11",
            "-------------------------------------" WHEN OTHERS; 


END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------