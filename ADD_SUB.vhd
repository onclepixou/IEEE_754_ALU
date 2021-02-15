-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- COMPUTE BLOCK --> ALU --> ADD_SUB
-- DESCRIPTION : Performs + operation
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY ADD_SUB IS

    PORT(

        A    :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 1
        B    :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 2
        OP   :  IN STD_LOGIC;                     -- 0 for add, 1 for sub
        RES  : OUT STD_LOGIC_VECTOR(36 DOWNTO 0)  -- Result
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF ADD_SUB IS 

    COMPONENT ADD_SUB_EXPONENT_EQUALIZER 

        PORT(

            A        :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B        :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            A_BIGGER : OUT STD_LOGIC;                     
            A_OUT    : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B_OUT    : OUT STD_LOGIC_VECTOR(36 DOWNTO 0)  
        );

    END COMPONENT;

    COMPONENT ADD_SUB_SIGN_OUT 

        PORT(

            SA       :  IN STD_LOGIC; 
            SB       :  IN STD_LOGIC; 
            A_BIGGER :  IN STD_LOGIC; 
            OP_IN    :  IN STD_LOGIC;  
            OP_OUT   : OUT STD_LOGIC;  
            SO       : OUT STD_LOGIC  
        );

    END COMPONENT;
 
    BEGIN



END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------