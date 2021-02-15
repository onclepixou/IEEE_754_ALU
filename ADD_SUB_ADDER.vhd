-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- COMPUTE BLOCK --> ALU --> ADD_SUB --> ADD_SUB_ADDER
-- DESCRIPTION : Performs +/- operation
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY ADD_SUB_ADDER IS

    PORT(

        A    :  IN STD_LOGIC_VECTOR(27 DOWNTO 0); -- Mantissa 1 (equalized exponent)
        B    :  IN STD_LOGIC_VECTOR(27 DOWNTO 0); -- Mantissa 2 (equalized exponent)
        OP   :  IN STD_LOGIC;                     -- 0 for add, 1 for sub
        CO   : OUT STD_LOGIC;                     -- Carry Out
        RES  : OUT STD_LOGIC_VECTOR(27 DOWNTO 0)  -- Result
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF ADD_SUB_ADDER IS 

    COMPONENT CLA 

        PORT(

            A     :  IN STD_LOGIC; 
            B     :  IN STD_LOGIC; 
            C_IN  :  IN STD_LOGIC; 
            C_OUT : OUT STD_LOGIC;                    
            S     : OUT STD_LOGIC 
        );

    END COMPONENT;
 
    SIGNAL B_compA2 : STD_LOGIC_VECTOR(27 DOWNTO 0);
    SIGNAL aux : STD_LOGIC_VECTOR(27 DOWNTO 0);

    BEGIN

        comp0 : FOR i IN 0 TO 27 GENERATE 

            B_compA2(i) <= B(i) XOR OP;

            sum0 : IF (i = 0 ) GENERATE 

                sum0_CLA :  CLA 
                    PORT MAP(

                        A => A(i),
                        B => B_compA2(i),
                        C_IN => OP,
                        S => RES(i),
                        C_OUT => aux(i)
                    );

            END GENERATE;

            sumi : IF ( (i > 0 ) AND ( i < 28 ) ) GENERATE 

                sumi_CLA :  CLA 
                    PORT MAP(

                        A => A(i),
                        B => B_compA2(i),
                        C_IN => aux(i-1),
                        S => RES(i),
                        C_OUT => aux(i)
                    );

            END GENERATE;
        
        END GENERATE;

        CO <= aux(27);


END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------