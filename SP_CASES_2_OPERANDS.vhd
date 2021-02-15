-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- PRECOMPUTE BLOCK --> SP_CASES
-- DESCRIPTION : Provides early way out when operands are inf, 0 or NaN :
--
--  - NaN       --> E = 255 & M > 0
--  - Infinity  --> E = 255 & M = 0
--  - Normal    --> 0 < E < 255 & M > 0
--  - Subnormal --> E = 0 & M > 0
--  - Zero      --> E = 0 & M = 0
--
--  Result is returned through S output when special cases are met (ENABLE output takes value 0)
--  When actual computation stage is needed ENABLE output takes value 1
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY SP_CASES_2_OPERANDS IS

    PORT(

        A      :  IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- 32 bit operand 1
        B      :  IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- 32 bit operand 2
        OP     :  IN STD_LOGIC_VECTOR(  1 DOWNTO 0 ); -- OP code
        S      : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- Early result
        ENABLE : OUT STD_LOGIC                        -- 1 when need for precomputation
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF SP_CASES_2_OPERANDS IS 

    SIGNAL SA : STD_LOGIC := '0';
    SIGNAL EA : UNSIGNED(  7 DOWNTO 0 ) := (OTHERS => '0');
    SIGNAL MA : UNSIGNED( 22 DOWNTO 0 ) := (OTHERS => '0');

    SIGNAL SB : STD_LOGIC := '0';
    SIGNAL EB : UNSIGNED(  7 DOWNTO 0 ):= (OTHERS => '0');
    SIGNAL MB : UNSIGNED( 22 DOWNTO 0 ):= (OTHERS => '0');

    SIGNAL OutA  : UNSIGNED( 2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL OutB  : UNSIGNED( 2 DOWNTO 0) := (OTHERS => '0');

    SIGNAL AddResult : STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := (OTHERS => '0');
    SIGNAL SubResult : STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := (OTHERS => '0');
    SIGNAL MulResult : STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := (OTHERS => '0');
    SIGNAL DivResult : STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := (OTHERS => '0');

    CONSTANT ZERO : STD_LOGIC_VECTOR( 31 DOWNTO 0 )    := "00000000000000000000000000000000";
    CONSTANT POS_INF : STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := "01111111100000000000000000000000";
    CONSTANT NEG_INF : STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := "11111111100000000000000000000000";
    CONSTANT NAN : STD_LOGIC_VECTOR( 31 DOWNTO 0 )     := "01111111100000000000000000000001";
    CONSTANT NOCARE : STD_LOGIC_VECTOR( 31 DOWNTO 0 )  := "--------------------------------";

    

    BEGIN

        SA <= A( 31 );
        EA <= UNSIGNED( A( 30 DOWNTO 23 ) );
        MA <= UNSIGNED( A( 22 DOWNTO  0 ) );

        SB <= B( 31 );
        EB <= UNSIGNED( B( 30 DOWNTO 23 ) );
        MB <= UNSIGNED( B( 22 DOWNTO  0 ) );


        OutA <= "000" WHEN ( ( EA = TO_UNSIGNED(0, 8) )   AND ( MA = TO_UNSIGNED(0, 23) ) )                    ELSE -- ZERO
                "001" WHEN ( ( EA = TO_UNSIGNED(255, 8) ) AND ( MA = TO_UNSIGNED(0, 23) ) AND ( SA = '0' ) )   ELSE -- + INFINITY
                "010" WHEN ( ( EA = TO_UNSIGNED(255, 8) ) AND ( MA = TO_UNSIGNED(0, 23) ) AND ( SA = '1' ) )   ELSE -- - INFINITY
                "011" WHEN ( ( EA = TO_UNSIGNED(255, 8) ) AND ( MA > TO_UNSIGNED(0, 23) ) )                    ELSE -- NAN
                "100";                                                                                              -- SUBNORMAL/NORMAL
     
        OutB <= "000" WHEN ( ( EB = TO_UNSIGNED(0, 8) )   AND ( MB = TO_UNSIGNED(0, 23) ) )                    ELSE -- ZERO
                "001" WHEN ( ( EB = TO_UNSIGNED(255, 8) ) AND ( MB = TO_UNSIGNED(0, 23) ) AND ( SB = '0' ) )   ELSE -- + INFINITY
                "010" WHEN ( ( EB = TO_UNSIGNED(255, 8) ) AND ( MB = TO_UNSIGNED(0, 23) ) AND ( SB = '1' ) )   ELSE -- - INFINITY
                "011" WHEN ( ( EB = TO_UNSIGNED(255, 8) ) AND ( MB > TO_UNSIGNED(0, 23) ) )                    ELSE -- NAN
                "100";                                                                                              -- SUBNORMAL/NORMAL


        -- Add operations early results

        AddResult <= ZERO    WHEN ( ( OutA = TO_UNSIGNED(0, 3) ) AND ( OutB = TO_UNSIGNED(0, 3) ) ) ELSE
                     POS_INF WHEN ( ( OutA = TO_UNSIGNED(0, 3) ) AND ( OutB = TO_UNSIGNED(1, 3) ) ) ELSE
                     NEG_INF WHEN ( ( OutA = TO_UNSIGNED(0, 3) ) AND ( OutB = TO_UNSIGNED(2, 3) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(0, 3) ) AND ( OutB = TO_UNSIGNED(3, 3) ) ) ELSE
                     B       WHEN ( ( OutA = TO_UNSIGNED(0, 3) ) AND ( OutB = TO_UNSIGNED(4, 3) ) ) ELSE

                     POS_INF WHEN ( ( OutA = TO_UNSIGNED(1, 3) ) AND ( OutB = TO_UNSIGNED(0, 3) ) ) ELSE
                     POS_INF WHEN ( ( OutA = TO_UNSIGNED(1, 3) ) AND ( OutB = TO_UNSIGNED(1, 3) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(1, 3) ) AND ( OutB = TO_UNSIGNED(2, 3) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(1, 3) ) AND ( OutB = TO_UNSIGNED(3, 3) ) ) ELSE
                     POS_INF WHEN ( ( OutA = TO_UNSIGNED(1, 3) ) AND ( OutB = TO_UNSIGNED(4, 3) ) ) ELSE 

                     NEG_INF WHEN ( ( OutA = TO_UNSIGNED(2, 3) ) AND ( OutB = TO_UNSIGNED(0, 3) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(2, 3) ) AND ( OutB = TO_UNSIGNED(1, 3) ) ) ELSE
                     NEG_INF WHEN ( ( OutA = TO_UNSIGNED(2, 3) ) AND ( OutB = TO_UNSIGNED(2, 3) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(2, 3) ) AND ( OutB = TO_UNSIGNED(3, 3) ) ) ELSE
                     NEG_INF WHEN ( ( OutA = TO_UNSIGNED(2, 3) ) AND ( OutB = TO_UNSIGNED(4, 3) ) ) ELSE 

                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3) ) AND ( OutB = TO_UNSIGNED(0, 3) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3) ) AND ( OutB = TO_UNSIGNED(1, 3) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3) ) AND ( OutB = TO_UNSIGNED(2, 3) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3) ) AND ( OutB = TO_UNSIGNED(3, 3) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3) ) AND ( OutB = TO_UNSIGNED(4, 3) ) ) ELSE 
 
                     A       WHEN ( ( OutA = TO_UNSIGNED(4, 3) ) AND ( OutB = TO_UNSIGNED(0, 3) ) ) ELSE
                     POS_INF WHEN ( ( OutA = TO_UNSIGNED(4, 3) ) AND ( OutB = TO_UNSIGNED(1, 3) ) ) ELSE
                     NEG_INF WHEN ( ( OutA = TO_UNSIGNED(4, 3) ) AND ( OutB = TO_UNSIGNED(2, 3) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(4, 3) ) AND ( OutB = TO_UNSIGNED(3, 3) ) ) ELSE
                     NOCARE  WHEN ( ( OutA = TO_UNSIGNED(4, 3) ) AND ( OutB = TO_UNSIGNED(4, 3) ) ) ELSE

                     NOCARE;


        -- Sub operations early results
        SubResult <= ZERO    WHEN ( ( OutA = TO_UNSIGNED(0, 3) ) AND ( OutB = TO_UNSIGNED(0, 3) ) ) ELSE
                     NEG_INF WHEN ( ( OutA = TO_UNSIGNED(0, 3) ) AND ( OutB = TO_UNSIGNED(1, 3) ) ) ELSE
                     POS_INF WHEN ( ( OutA = TO_UNSIGNED(0, 3) ) AND ( OutB = TO_UNSIGNED(2, 3) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(0, 3) ) AND ( OutB = TO_UNSIGNED(3, 3) ) ) ELSE
                     ( NOT(B(31)) & B(30 DOWNTO 0) ) WHEN ( ( OutA = TO_UNSIGNED(0, 3) ) AND ( OutB = TO_UNSIGNED(4, 3) ) ) ELSE  -- result is -B

                     POS_INF WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE
                     POS_INF WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(3, 3 ) ) ) ELSE
                     POS_INF WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE 

                     NEG_INF WHEN ( ( OutA = TO_UNSIGNED(2, 3 ) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     NEG_INF WHEN ( ( OutA = TO_UNSIGNED(2, 3 ) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(2, 3 ) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(2, 3 ) ) AND ( OutB = TO_UNSIGNED(3, 3 ) ) ) ELSE
                     NEG_INF WHEN ( ( OutA = TO_UNSIGNED(2, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE 

                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(3, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE 
 
                     A       WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     NEG_INF WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE
                     POS_INF WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(3, 3 ) ) ) ELSE
                     NOCARE  WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE

                     NOCARE;

        -- Mul operations early results
        MulResult <= ZERO    WHEN ( ( OutA = TO_UNSIGNED(0, 3 ) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(0, 3 ) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(0, 3 ) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(0, 3 ) ) AND ( OutB = TO_UNSIGNED(3, 3 ) ) ) ELSE
                     ZERO    WHEN ( ( OutA = TO_UNSIGNED(0, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE

                     NAN     WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     POS_INF WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE
                     NEG_INF WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(3, 3 ) ) ) ELSE
                     ( B(31) & POS_INF(30 DOWNTO 0) )  WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE  -- result is sign(B) * inf

                     NAN     WHEN ( ( OutA = TO_UNSIGNED(2, 3) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     NEG_INF WHEN ( ( OutA = TO_UNSIGNED(2, 3) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE
                     POS_INF WHEN ( ( OutA = TO_UNSIGNED(2, 3) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(2, 3) ) AND ( OutB = TO_UNSIGNED(3, 3 ) ) ) ELSE
                     ( NOT( B(31) ) & POS_INF(30 DOWNTO 0) ) WHEN ( ( OutA = TO_UNSIGNED(2, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE -- result is  - sign(B) * inf

                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(3, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE 
 
                     ZERO    WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     ( A(31) & POS_INF(30 DOWNTO 0) ) WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE -- result is sign(A) * inf
                     ( NOT( A(31) ) & POS_INF(30 DOWNTO 0) ) WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE -- result is - sign(A) * inf
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(3, 3) ) ) ELSE
                     NOCARE  WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3) ) ) ELSE

                     NOCARE;

        -- Div operations early results
        DivResult <= NAN     WHEN ( ( OutA = TO_UNSIGNED(0, 3 ) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     ZERO    WHEN ( ( OutA = TO_UNSIGNED(0, 3 ) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE
                     ZERO    WHEN ( ( OutA = TO_UNSIGNED(0, 3 ) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(0, 3 ) ) AND ( OutB = TO_UNSIGNED(3, 3 ) ) ) ELSE
                     ZERO    WHEN ( ( OutA = TO_UNSIGNED(0, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE

                     NAN     WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(3, 3 ) ) ) ELSE
                     ( B(31) & POS_INF(30 DOWNTO 0) )  WHEN ( ( OutA = TO_UNSIGNED(1, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE  -- result is sign(B) * inf

                     NAN     WHEN ( ( OutA = TO_UNSIGNED(2, 3 ) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(2, 3 ) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(2, 3 ) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(2, 3 ) ) AND ( OutB = TO_UNSIGNED(3, 3 ) ) ) ELSE
                     ( NOT( B(31) ) & POS_INF(30 DOWNTO 0) ) WHEN ( ( OutA = TO_UNSIGNED(2, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE -- result is  - sign(B) * inf

                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(3, 3 ) ) ) ELSE
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(3, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE 
 
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(0, 3 ) ) ) ELSE
                     ZERO    WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(1, 3 ) ) ) ELSE 
                     ZERO    WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(2, 3 ) ) ) ELSE 
                     NAN     WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(3, 3 ) ) ) ELSE
                     NOCARE  WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE

                     NOCARE;

                     

        S <= AddResult WHEN OP = "00" ELSE
             SubResult WHEN OP = "01" ELSE
             MulResult WHEN OP = "10" ELSE
             DivResult WHEN OP = "11" ELSE
             NOCARE;

        ENABLE <= '1' WHEN ( ( OutA = TO_UNSIGNED(4, 3 ) ) AND ( OutB = TO_UNSIGNED(4, 3 ) ) ) ELSE '0';

END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------