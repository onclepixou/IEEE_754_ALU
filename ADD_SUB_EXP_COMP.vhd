-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- COMPUTE BLOCK --> ALU --> ADD --> ADD_SUB_EXPONENT_EQUALIZER --> ADD_SUB_EXP_COMP
-- DESCRIPTION : Performs + operation
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY ADD_SUB_EXP_COMP IS

    PORT(

        A      :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 1
        B      :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); -- Augmented operand 2
        SA     : OUT STD_LOGIC;                     -- Sign of operand 1
        SB     : OUT STD_LOGIC;                     -- Sign of operand 2
        EXP    : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0); -- Output exponent;
        MA     : OUT STD_LOGIC_VECTOR(27 DOWNTO 0); -- Mantissa of operand 1
        MB     : OUT STD_LOGIC_VECTOR(27 DOWNTO 0); -- Mantissa of operand 1
        SHFT   : OUT STD_LOGIC_VECTOR( 4 DOWNTO 0); -- Shift value
        TARGET : OUT STD_LOGIC                      -- 0  means MA must be shifted, 1 means MB must be shifted
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF ADD_SUB_EXP_COMP IS 


    SIGNAL COMP : STD_LOGIC := '0';

    SIGNAL EA : UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL EB : UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');

    SIGNAL MANTISSA_A : STD_LOGIC_VECTOR(27 DOWNTO 0);
    SIGNAL MANTISSA_B : STD_LOGIC_VECTOR(27 DOWNTO 0);

    SIGNAL SHIFT_VALUE : UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
    
    BEGIN

        EA <= UNSIGNED(A(35 DOWNTO 28));
        EB <= UNSIGNED(B(35 DOWNTO 28));

        MANTISSA_A <= A(27 DOWNTO 0);
        MANTISSA_B <= B(27 DOWNTO 0);

        COMP <= '1' WHEN ( (MANTISSA_B(0) = '1') )          ELSE
                '0' WHEN ( (MANTISSA_A(0) = '1') )          ELSE  
                '1' WHEN ( ( EA > EB ) )                    ELSE 
                '0' WHEN ( ( EA < EB ) )                    ELSE
                '1' WHEN ( ( MANTISSA_A >= MANTISSA_B ) )   ELSE
                '0' WHEN ( ( MANTISSA_A < MANTISSA_B ) )    ELSE
                '-';

        SHIFT_VALUE <= ( EB - EA ) WHEN ( ( COMP = '0' ) AND ( MANTISSA_B(0) = '0' ) AND ( MANTISSA_A(0) = '0') )  ELSE 
                       ( EB + EA ) WHEN ( ( COMP = '0' ) AND ( MANTISSA_B(0) = '0' ) AND ( MANTISSA_A(0) = '1') )  ELSE
                       ( EA - EB ) WHEN ( ( COMP = '1' ) AND ( MANTISSA_B(0) = '0' ) AND ( MANTISSA_A(0) = '0') )  ELSE 
                       ( EA + EB ) WHEN ( ( COMP = '1' ) AND ( MANTISSA_B(0) = '1' ) AND ( MANTISSA_A(0) = '0') )  ELSE
                       "--------";


        TARGET <= COMP;

        PROCESS(SHIFT_VALUE)

            BEGIN 

                IF ( SHIFT_VALUE <= X"1B" ) THEN

                    SHFT  <= STD_LOGIC_VECTOR(SHIFT_VALUE(4 DOWNTO 0));

                ELSIF ( SHIFT_VALUE > X"1B" ) THEN

                    SHFT <= "11100";  -- valeur max de shift

                ELSE 

                    SHFT <= "-----";

                END IF;

        END PROCESS;

        EXP <= STD_LOGIC_VECTOR(EA) WHEN COMP = '1' ELSE
               STD_LOGIC_VECTOR(EB) WHEN COMP = '0' ELSE
               "--------";

        MA <= MANTISSA_A;
        MB <= MANTISSA_B;

        SA <= A(36);
        SB <= B(36);

        TARGET <= COMP;

END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------