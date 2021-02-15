-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- COMPUTE BLOCK --> ALU --> ADD --> ADD_EXPONENT_EQUALIZER --> ADD_SUB_SHIFT
-- DESCRIPTION : Logarithmic left shifter
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY ADD_SUB_SHIFT IS

    PORT(

        MA        :  IN STD_LOGIC_VECTOR(27 DOWNTO 0); -- Mantissa 1
        MB        :  IN STD_LOGIC_VECTOR(27 DOWNTO 0); -- Mantissa 2
        SHIFT_VAL :  IN STD_LOGIC_VECTOR( 4 DOWNTO 0); -- Number of shifts
        A_SHIFT   :  IN STD_LOGIC;                     -- 0  means MA must be shifted, 1 means MB must be shifted
        MA_OUT    : OUT STD_LOGIC_VECTOR(27 DOWNTO 0); -- Mantissa A Out (possibly shifted)
        MB_OUT    : OUT STD_LOGIC_VECTOR(27 DOWNTO 0)  -- Mantissa A Out (possibly shifted)
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF ADD_SUB_SHIFT IS 

    COMPONENT RIGHT_SHIFTER 

        PORT(

            M_RAW     :  IN STD_LOGIC_VECTOR(27 DOWNTO 0); 
            SHIFT_VAL :  IN STD_LOGIC_VECTOR( 4 DOWNTO 0); 
            M_SHIFTED : OUT STD_LOGIC_VECTOR(27 DOWNTO 0) 
        );
    END COMPONENT;

    SIGNAL MANTISSA_TO_SHIFT  : STD_LOGIC_VECTOR(27 DOWNTO 0);
    SIGNAL MANTISSA_UNCHANGED : STD_LOGIC_VECTOR(27 DOWNTO 0);
    SIGNAL MANTISSA_SHIFTED   : STD_LOGIC_VECTOR(27 DOWNTO 0);


    BEGIN

        MANTISSA_TO_SHIFT <= MA WHEN (A_SHIFT = '0') ELSE
                             MB WHEN (A_SHIFT = '1') ELSE
                             "----------------------------";
    
        MANTISSA_UNCHANGED <= MA WHEN (A_SHIFT = '1') ELSE
                              MB WHEN (A_SHIFT = '0') ELSE
                              "----------------------------";

        MA_OUT <= MANTISSA_SHIFTED WHEN (A_SHIFT = '0') ELSE
                  MANTISSA_UNCHANGED WHEN (A_SHIFT = '1') ELSE
                  "----------------------------";

        MB_OUT <= MANTISSA_SHIFTED WHEN (A_SHIFT = '1') ELSE
                  MANTISSA_UNCHANGED WHEN (A_SHIFT = '0') ELSE
                  "----------------------------";

        comp0 : RIGHT_SHIFTER
            PORT MAP(

                M_RAW => MANTISSA_TO_SHIFT,
                SHIFT_VAL => SHIFT_VAL,
                M_SHIFTED => MANTISSA_SHIFTED
            );

        
END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------