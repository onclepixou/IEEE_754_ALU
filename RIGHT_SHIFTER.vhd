-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- RIGHT_SHIFTER
-- DESCRIPTION : Logarithmic right shifter
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY RIGHT_SHIFTER IS

    PORT(

        M_RAW     :  IN STD_LOGIC_VECTOR(27 DOWNTO 0); -- Mantissa to shift
        SHIFT_VAL :  IN STD_LOGIC_VECTOR( 4 DOWNTO 0); -- Number of shifts
        M_SHIFTED : OUT STD_LOGIC_VECTOR(27 DOWNTO 0)  -- Shifted mantissa
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF RIGHT_SHIFTER IS 

    COMPONENT MUX 

        PORT(

            A   :  IN STD_LOGIC;
            B   :  IN STD_LOGIC;
            Sel :  IN STD_LOGIC;
            Z   : OUT STD_LOGIC 
        );
    END COMPONENT;

    SIGNAL Z1 : STD_LOGIC_VECTOR(27 DOWNTO 0);
    SIGNAL Z2 : STD_LOGIC_VECTOR(27 DOWNTO 0);
    SIGNAL Z3 : STD_LOGIC_VECTOR(27 DOWNTO 0);
    SIGNAL Z4 : STD_LOGIC_VECTOR(27 DOWNTO 0);
    SIGNAL Z5 : STD_LOGIC_VECTOR(27 DOWNTO 0);

    BEGIN

        Build : FOR i IN 0 TO 27 GENERATE

            STAGE_0_0 : IF( i = 0 ) GENERATE

                shift_0 : MUX 
                    PORT MAP(A   => '0',
                             B   => M_RAW(27),
                             Sel => SHIFT_VAL(0),
                             Z   => Z1(27) );
            END GENERATE;

            STAGE_0_i : IF( ( i >= 1 )  AND ( i < 28 ) ) GENERATE

                shift_0_i : MUX 
                    PORT MAP(A   => M_RAW(27 - (i - 1) ),
                             B   => M_RAW(27 - i),
                             Sel => SHIFT_VAL(0),
                             Z   => Z1(27 - i) );
            END GENERATE;

            STAGE_1_0 : IF( ( i >= 0 )  AND ( i < 2 ) ) GENERATE

                shift_1_0 : MUX 
                    PORT MAP(A   => '0',
                             B   => Z1(27 - i),
                             Sel => SHIFT_VAL(1),
                             Z   => Z2(27 - i) );
            END GENERATE;

            STAGE_1_i : IF( ( i >= 2 )  AND ( i < 28 ) ) GENERATE

                shift_1_i : MUX 
                    PORT MAP(A   => Z1(27 - (i - 2) ),
                             B   => Z1(27 - i),
                             Sel => SHIFT_VAL(1),
                             Z   => Z2(27 - i ) );
            END GENERATE;

            STAGE_2_0 : IF( ( i >= 0 )  AND ( i < 4 ) ) GENERATE

                shift_2_0 : MUX 
                    PORT MAP(A   => '0',
                             B   => Z2(27 - i),
                             Sel => SHIFT_VAL(2),
                             Z   => Z3(27 - i) );
            END GENERATE;

            STAGE_2_i : IF( ( i >= 4 )  AND ( i < 28 ) ) GENERATE

                shift_2_i : MUX 
                    PORT MAP(A   => Z2(27 - (i - 4) ),
                             B   => Z2(27 - i),
                             Sel => SHIFT_VAL(2),
                             Z   => Z3(27 - i) );
            END GENERATE;


            STAGE_3_0 : IF( ( i >= 0 )  AND ( i < 8 ) ) GENERATE

                shift_3_0 : MUX 
                    PORT MAP(A   => '0',
                             B   => Z3(27 - i),
                             Sel => SHIFT_VAL(3),
                             Z   => Z4(27 - i) );
            END GENERATE;

            STAGE_3_i : IF( ( i >= 8 )  AND ( i < 28 ) ) GENERATE

                shift_3_i : MUX 
                    PORT MAP(A   => Z3(27 - (i - 8) ),
                             B   => Z3(27 - i),
                             Sel => SHIFT_VAL(3),
                             Z   => Z4(27 - i) );
            END GENERATE;

            STAGE_4_0 : IF( ( i >= 0 )  AND ( i < 16 ) ) GENERATE

                shift_4_0 : MUX 
                    PORT MAP(A   => '0',
                             B   => Z4(27 - i),
                             Sel => SHIFT_VAL(4),
                             Z   => Z5(27 - i) );
            END GENERATE;

            STAGE_4_i : IF( ( i >= 16 )  AND ( i < 28 ) ) GENERATE

                shift_4_i : MUX 
                    PORT MAP(A   => Z4(27 - (i - 16) ),
                             B   => Z4(27 - i),
                             Sel => SHIFT_VAL(4),
                             Z   => Z5(27 - i) );
            END GENERATE;

        END GENERATE;

        M_SHIFTED <= Z5;

END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------