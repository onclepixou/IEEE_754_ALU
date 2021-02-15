-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- PRECOMPUTE BLOCK --> MIX_BLOCK 
-- DESCRIPTION : Prepare subnormal and normal operand for computation
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY MIX_BLOCK IS

    PORT(

        A       :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 1 ( normal or subnormal )
        B       :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 2 ( normal or subnormal )
        A_NORM  : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented normalized operand 1 ( normal or subnormal )
        B_NORM  : OUT STD_LOGIC_VECTOR(36 DOWNTO 0)  -- Augmented normalized operand 1 ( normal or subnormal )
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF MIX_BLOCK IS 

    COMPONENT NORMAL_SUBNORMAL_COMP 

        PORT(

            A             :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B             :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            NORMAL_OUT    : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); 
            SUBNORMAL_OUT : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); 
            A_IS_NORMAL   : OUT STD_LOGIC
        );

    END COMPONENT;

    COMPONENT LEADING_ZEROS_COUNTER 

        PORT(

            M     :  IN STD_LOGIC_VECTOR(27 DOWNTO 0);
            COUNT : OUT STD_LOGIC_VECTOR( 4 DOWNTO 0)
        );

    END COMPONENT;

    COMPONENT LEFT_SHIFTER 

        PORT(

            M_RAW     :  IN STD_LOGIC_VECTOR(27 DOWNTO 0); 
            SHIFT_VAL :  IN STD_LOGIC_VECTOR( 4 DOWNTO 0);
            M_SHIFTED : OUT STD_LOGIC_VECTOR(27 DOWNTO 0) 
        );

    END COMPONENT;

    SIGNAL NORMAL_OPERAND    : STD_LOGIC_VECTOR(36 DOWNTO 0);
    SIGNAL SUBNORMAL_OPERAND : STD_LOGIC_VECTOR(36 DOWNTO 0);
    SIGNAL A_IS_NORMAL : STD_LOGIC;
    SIGNAL ZERO_COUNT : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    SIGNAL SHIFTED_MANTISSA : STD_LOGIC_VECTOR(27 DOWNTO 0);
    SIGNAL EXPONENT_OUT : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
    SIGNAL NORMALIZED_OPERAND : STD_LOGIC_VECTOR(36 DOWNTO 0);

    BEGIN

        comp0 : NORMAL_SUBNORMAL_COMP

            PORT MAP (

                A => A,
                B => B,
                NORMAL_OUT => NORMAL_OPERAND,
                SUBNORMAL_OUT => SUBNORMAL_OPERAND,
                A_IS_NORMAL => A_IS_NORMAL
            );

        comp1 : LEADING_ZEROS_COUNTER 

            PORT MAP (

                M => SUBNORMAL_OPERAND(27 DOWNTO 0),
                COUNT => ZERO_COUNT
            );

        comp2 : LEFT_SHIFTER 

            PORT MAP (

                M_RAW => SUBNORMAL_OPERAND(27 DOWNTO 0),
                SHIFT_VAL => ZERO_COUNT,
                M_SHIFTED => SHIFTED_MANTISSA
            );

        -- Computation of NORMALIZED OPERAND
        NORMALIZED_OPERAND( 27 DOWNTO 0 ) <= SHIFTED_MANTISSA WHEN ZERO_COUNT = "-----" ELSE
                                             SHIFTED_MANTISSA( 27 DOWNTO 1 ) & '1'; -- mark on bit 0 on normalized operand

        EXPONENT_OUT <= "--------" WHEN ZERO_COUNT = "-----" ELSE
                        "000" & ZERO_COUNT;

        NORMALIZED_OPERAND(36) <= SUBNORMAL_OPERAND(36);
        NORMALIZED_OPERAND(35 DOWNTO 28) <= EXPONENT_OUT;

        -- Reordering of operands   
        A_NORM <= NORMAL_OPERAND WHEN A_IS_NORMAL = '1' ELSE 
                  NORMALIZED_OPERAND ;        
        
        B_NORM <= NORMALIZED_OPERAND WHEN A_IS_NORMAL = '1' ELSE 
                  NORMAL_OPERAND ; 

END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------