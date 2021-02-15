-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- COMPUTE BLOCK --> ALU --> ADD --> ADD_SUB_EXPONENT_EQUALIZER
-- DESCRIPTION : Right shift operands with lowest exponent to make exponent equal
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY ADD_SUB_EXPONENT_EQUALIZER IS

    PORT(

        A        :  IN STD_LOGIC_VECTOR(36 DOWNTO 0);  -- Operand 1
        B        :  IN STD_LOGIC_VECTOR(36 DOWNTO 0);  -- Operand 2
        A_BIGGER : OUT STD_LOGIC;                      -- 1 : A is bigger
        EXP      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Equalized exponent
        A_OUT    : OUT STD_LOGIC_VECTOR(36 DOWNTO 0);  -- Operand 1 with equalized exponent
        B_OUT    : OUT STD_LOGIC_VECTOR(36 DOWNTO 0)   -- Operand 2 with equalized exponent
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF ADD_SUB_EXPONENT_EQUALIZER IS 

    COMPONENT ADD_EXP_COMP 

        PORT(
        
            A      :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B      :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            SA     : OUT STD_LOGIC;                     
            SB     : OUT STD_LOGIC;                     
            EXP    : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0); 
            MA     : OUT STD_LOGIC_VECTOR(27 DOWNTO 0); 
            MB     : OUT STD_LOGIC_VECTOR(27 DOWNTO 0); 
            SHFT   : OUT STD_LOGIC_VECTOR( 4 DOWNTO 0); 
            TARGET : OUT STD_LOGIC                      
        );

    END COMPONENT;

    COMPONENT ADD_SHIFT 

        PORT(

            MA        :  IN STD_LOGIC_VECTOR(27 DOWNTO 0); 
            MB        :  IN STD_LOGIC_VECTOR(27 DOWNTO 0); 
            SHIFT_VAL :  IN STD_LOGIC_VECTOR( 4 DOWNTO 0); 
            A_SHIFT   :  IN STD_LOGIC;                     
            MA_OUT    : OUT STD_LOGIC_VECTOR(27 DOWNTO 0); 
            MB_OUT    : OUT STD_LOGIC_VECTOR(27 DOWNTO 0)  
        );

    END COMPONENT;


    SIGNAL SIGN_A :  STD_LOGIC;
    SIGNAL SIGN_B :  STD_LOGIC;
    SIGNAL EXP_EQUALIZED : STD_LOGIC_VECTOR( 7 DOWNTO 0); 
    SIGNAL MANTISSA_A : STD_LOGIC_VECTOR( 27 DOWNTO 0); 
    SIGNAL MANTISSA_B : STD_LOGIC_VECTOR( 27 DOWNTO 0);
    SIGNAL SHFT_VAL : STD_LOGIC_VECTOR( 4 DOWNTO 0);
    SIGNAL TARGET_OUT : STD_LOGIC;
    SIGNAL SHIFTED_MANTISSA_A : STD_LOGIC_VECTOR( 27 DOWNTO 0); 
    SIGNAL SHIFTED_MANTISSA_B : STD_LOGIC_VECTOR( 27 DOWNTO 0);

    BEGIN

        comp0 : ADD_EXP_COMP
            PORT MAP(

                A => A,
                B => B,
                SA => SIGN_A,
                SB => SIGN_B,
                EXP => EXP_EQUALIZED,
                MA => MANTISSA_A,
                MB => MANTISSA_B,
                SHFT => SHFT_VAL,
                TARGET => TARGET_OUT
            );

        comp1 : ADD_SHIFT
            PORT MAP(

                MA => MANTISSA_A,
                MB => MANTISSA_B,
                SHIFT_VAL => SHFT_VAL,
                A_SHIFT => TARGET_OUT,
                MA_OUT => SHIFTED_MANTISSA_A,
                MB_OUT => SHIFTED_MANTISSA_B
            );

        A_OUT <= SIGN_A & EXP_EQUALIZED & SHIFTED_MANTISSA_A;
        B_OUT <= SIGN_B & EXP_EQUALIZED & SHIFTED_MANTISSA_B;

        A_BIGGER <= TARGET_OUT;

 
END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------