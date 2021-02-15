-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- PRECOMPUTE BLOCK --> MIX_BLOCK --> NORMAL_SUBNORMAL_COMP
-- DESCRIPTION : Tells subnormal and normal operands apart
--
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY NORMAL_SUBNORMAL_COMP IS

    PORT(

        A             :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 1 ( normal or subnormal )
        B             :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 2 ( normal or subnormal )
        NORMAL_OUT    : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 1 ( subnormal )
        SUBNORMAL_OUT : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 2 ( subnormal )
        A_IS_NORMAL   : OUT STD_LOGIC                      -- 1 if A was the normal operand 0 otherwise
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF NORMAL_SUBNORMAL_COMP IS 

    SIGNAL EA : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
    SIGNAL EB : STD_LOGIC_VECTOR( 7 DOWNTO 0 );

    BEGIN

        EA <= A( 35 DOWNTO 28 );
        EB <= B( 35 DOWNTO 28 );

        PROCESS(A, B, EA, EB)

            BEGIN 

                IF EA = X"00" THEN -- A is subnormal

                    NORMAL_OUT    <=  B;
                    SUBNORMAL_OUT <=  A;
                    A_IS_NORMAL   <= '0';

                ELSIF EB = X"00" THEN -- B is subnormal

                    NORMAL_OUT    <=  A;
                    SUBNORMAL_OUT <=  B;
                    A_IS_NORMAL   <= '1';

                ELSE -- No precomputation needed  

                    NORMAL_OUT    <= "-------------------------------------";
                    SUBNORMAL_OUT <= "-------------------------------------";
                    A_IS_NORMAL   <= '-';

                END IF;

        END PROCESS;
        
END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------