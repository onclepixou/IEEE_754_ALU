---------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
ENTITY TB_PRECOMPUTATION_2 IS 
END ENTITY;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
ARCHITECTURE ARCH OF TB_PRECOMPUTATION_2 IS 

    COMPONENT PRECOMPUTATION_2


        PORT(

            A             :  IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
            B             :  IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
            OP            :  IN STD_LOGIC_VECTOR(  1 DOWNTO 0 ); 
            EARLY_OUT     : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
            A_RDY         : OUT STD_LOGIC_VECTOR( 36 DOWNTO 0 ); 
            B_RDY         : OUT STD_LOGIC_VECTOR( 36 DOWNTO 0 )  
        );

    END COMPONENT;

    SIGNAL A           : STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := (OTHERS => '0'); 
    SIGNAL B           : STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := (OTHERS => '0'); 
    SIGNAL OP          : STD_LOGIC_VECTOR(  1 DOWNTO 0 ) := (OTHERS => '0'); 
    SIGNAL EARLY_OUT   : STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := (OTHERS => '0'); 
    SIGNAL A_RDY       : STD_LOGIC_VECTOR( 36 DOWNTO 0 ) := (OTHERS => '0'); 
    SIGNAL B_RDY       : STD_LOGIC_VECTOR( 36 DOWNTO 0 ) := (OTHERS => '0'); 

    CONSTANT ZERO : STD_LOGIC_VECTOR( 31 DOWNTO 0 )    := "00000000000000000000000000000000";
    CONSTANT POS_INF : STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := "01111111100000000000000000000000";
    CONSTANT NEG_INF : STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := "11111111100000000000000000000000";
    CONSTANT NAN : STD_LOGIC_VECTOR( 31 DOWNTO 0 )     := "01111111100000000000000000000001";
    CONSTANT POS_N : STD_LOGIC_VECTOR( 31 DOWNTO 0 )   := "00000111100000000000000000000011";
    CONSTANT NEG_N : STD_LOGIC_VECTOR( 31 DOWNTO 0 )   := "10000111100000000000000000000011";
    CONSTANT POS_S : STD_LOGIC_VECTOR( 31 DOWNTO 0 )   := "00000000000000000000000000000011";
    CONSTANT NEG_S : STD_LOGIC_VECTOR( 31 DOWNTO 0 )   := "10000000000000000000000000000011";

    CONSTANT NOCARE : STD_LOGIC_VECTOR( 31 DOWNTO 0 )  := "--------------------------------";
    

    BEGIN 

        uut : PRECOMPUTATION_2

            PORT MAP( A           => A, 
                      B           => B, 
                      OP          => OP, 
                      EARLY_OUT   => EARLY_OUT, 
                      A_RDY       => A_RDY, 
                      B_RDY       => B_RDY );

        stim_proc : PROCESS 
        
            BEGIN

                A <= ZERO;
                B <= POS_INF;
                OP <= "00";

                wait for 10 ns;

                A <= POS_N;
                B <= POS_N;
                OP <= "00";

                wait for 10 ns;

                A <= POS_N;
                B <= POS_S;
                OP <= "00";

                wait for 10 ns;

                A <= POS_S;
                B <= NEG_S;
                OP <= "00";

                wait for 10 ns;

                REPORT "FINISH";

--                WAIT;


        END PROCESS;



END ARCHITECTURE;
---------------------------------------------------------------------------------