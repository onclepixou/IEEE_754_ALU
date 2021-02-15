-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- PRECOMPUTE BLOCK ( 2 OPERANDS )
-- DESCRIPTION : Precomputation of input data for 2 operands op :
--
--
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY PRECOMPUTATION_2 IS

    PORT(

        A             :  IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- 32 bit operand 1
        B             :  IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- 32 bit operand 2
        OP            :  IN STD_LOGIC_VECTOR(  1 DOWNTO 0 ); -- OP code
        EARLY_OUT     : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- SP cases early out
        A_RDY         : OUT STD_LOGIC_VECTOR( 36 DOWNTO 0 ); -- Augmented 32 bit operand 1 ready for computation
        B_RDY         : OUT STD_LOGIC_VECTOR( 36 DOWNTO 0 )  -- Augmented 32 bit operand 2 ready for computation
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF PRECOMPUTATION_2 IS 

    COMPONENT SP_CASES_2_OPERANDS 

        PORT(

            A      :  IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
            B      :  IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
            OP     :  IN STD_LOGIC_VECTOR(  1 DOWNTO 0 ); 
            S      : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
            ENABLE : OUT STD_LOGIC
        );

    END COMPONENT;

    COMPONENT SELECTOR 

        PORT(

            A      :  IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
            B      :  IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
            ENABLE :  IN STD_LOGIC;                       
            A_OUT  : OUT STD_LOGIC_VECTOR( 36 DOWNTO 0 ); 
            B_OUT  : OUT STD_LOGIC_VECTOR( 36 DOWNTO 0 ); 
            E_DATA : OUT STD_LOGIC_VECTOR(  1 DOWNTO 0 )
        );

    END COMPONENT;

    COMPONENT ROUTER 

        PORT(

            A            :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B            :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            E_DATA       :  IN STD_LOGIC_VECTOR( 1 DOWNTO 0); 
            A_SUBNORMAL  : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B_SUBNORMAL  : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); 
            A_NORMAL     : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B_NORMAL     : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); 
            A_MIX        : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B_MIX        : OUT STD_LOGIC_VECTOR(36 DOWNTO 0)  
        );

    END COMPONENT;

    COMPONENT MIX_BLOCK 

        PORT(

            A       :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B       :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            A_NORM  : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B_NORM  : OUT STD_LOGIC_VECTOR(36 DOWNTO 0)   
        );

    END COMPONENT;

    COMPONENT NORMAL_SUBNORMAL_ROUTER 

        PORT(

            A_NORM        :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B_NORM        :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            A_NORMALIZED  :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B_NORMALIZED  :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            E_DATA        :  IN STD_LOGIC_VECTOR( 1 DOWNTO 0); 
            A_OUT         : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B_OUT         : OUT STD_LOGIC_VECTOR(36 DOWNTO 0)  
        );

    END COMPONENT;

    COMPONENT OPERANDS_PROVIDER 

        PORT(

            A_SUBNORM  :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B_SUBNORM  :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            A_NORM     :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B_NORM     :  IN STD_LOGIC_VECTOR(36 DOWNTO 0); 
            E_DATA     :  IN STD_LOGIC_VECTOR( 1 DOWNTO 0); 
            A_RDY      : OUT STD_LOGIC_VECTOR(36 DOWNTO 0); 
            B_RDY      : OUT STD_LOGIC_VECTOR(36 DOWNTO 0)  
        );

    END COMPONENT;

    SIGNAL ENABLE_PRECOMPUTE   : STD_LOGIC := '0';
    SIGNAL SELECTOR_E_DATA     : STD_LOGIC_VECTOR( 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL SELECTOR_A_OUT      : STD_LOGIC_VECTOR(36 DOWNTO 0) := (OTHERS => '0');
    SIGNAL SELECTOR_B_OUT      : STD_LOGIC_VECTOR(36 DOWNTO 0) := (OTHERS => '0');

    SIGNAL A_SUBNORMAL_BLOCK_INPUT : STD_LOGIC_VECTOR(36 DOWNTO 0) := (OTHERS => '0');
    SIGNAL B_SUBNORMAL_BLOCK_INPUT : STD_LOGIC_VECTOR(36 DOWNTO 0) := (OTHERS => '0');
    SIGNAL A_NORMAL_BLOCK_INPUT : STD_LOGIC_VECTOR(36 DOWNTO 0) := (OTHERS => '0');
    SIGNAL B_NORMAL_BLOCK_INPUT : STD_LOGIC_VECTOR(36 DOWNTO 0) := (OTHERS => '0');
    SIGNAL A_MIX_BLOCK_INPUT   : STD_LOGIC_VECTOR(36 DOWNTO 0) := (OTHERS => '0');
    SIGNAL B_MIX_BLOCK_INPUT   : STD_LOGIC_VECTOR(36 DOWNTO 0) := (OTHERS => '0');

    SIGNAL MIX_BLOCK_A_OUTPUT : STD_LOGIC_VECTOR(36 DOWNTO 0) := (OTHERS => '0');
    SIGNAL MIX_BLOCK_B_OUTPUT : STD_LOGIC_VECTOR(36 DOWNTO 0) := (OTHERS => '0');

    SIGNAL NORMAL_SUBNORMAL_ROUTER_A_OUTPUT : STD_LOGIC_VECTOR(36 DOWNTO 0) := (OTHERS => '0');
    SIGNAL NORMAL_SUBNORMAL_ROUTER_B_OUTPUT : STD_LOGIC_VECTOR(36 DOWNTO 0) := (OTHERS => '0');

    
    BEGIN

        comp0 : SP_CASES_2_OPERANDS 
                PORT MAP(A   => A,
                         B   => B,
                         OP  => OP,
                         S   => EARLY_OUT,
                         ENABLE   => ENABLE_PRECOMPUTE);

        comp1 : SELECTOR 
                PORT MAP(A      => A,
                         B      => B,
                         ENABLE => ENABLE_PRECOMPUTE,
                         A_OUT  => SELECTOR_A_OUT,
                         B_OUT  => SELECTOR_B_OUT,
                         E_DATA => SELECTOR_E_DATA);

        comp2 : ROUTER 
                PORT MAP(  A             => SELECTOR_A_OUT, 
                           B             => SELECTOR_B_OUT, 
                           E_DATA        => SELECTOR_E_DATA,
                           A_SUBNORMAL   =>  A_SUBNORMAL_BLOCK_INPUT,
                           B_SUBNORMAL   =>  B_SUBNORMAL_BLOCK_INPUT,
                           A_NORMAL      =>  A_NORMAL_BLOCK_INPUT,
                           B_NORMAL      =>  B_NORMAL_BLOCK_INPUT,
                           A_MIX         =>  A_MIX_BLOCK_INPUT,
                           B_MIX         =>  B_MIX_BLOCK_INPUT);

        comp3 : MIX_BLOCK
                PORT MAP( A       => A_MIX_BLOCK_INPUT,
                          B       => B_MIX_BLOCK_INPUT,
                          A_NORM  => MIX_BLOCK_A_OUTPUT,
                          B_NORM  => MIX_BLOCK_B_OUTPUT);

        comp4 : NORMAL_SUBNORMAL_ROUTER
                PORT MAP( A_NORM        =>  A_NORMAL_BLOCK_INPUT,
                          B_NORM        =>  B_NORMAL_BLOCK_INPUT,
                          A_NORMALIZED  =>  MIX_BLOCK_A_OUTPUT,
                          B_NORMALIZED  =>  MIX_BLOCK_B_OUTPUT,
                          E_DATA        =>  SELECTOR_E_DATA,
                          A_OUT         =>  NORMAL_SUBNORMAL_ROUTER_A_OUTPUT,
                          B_OUT         =>  NORMAL_SUBNORMAL_ROUTER_B_OUTPUT);

        comp5 : OPERANDS_PROVIDER
                PORT MAP( A_SUBNORM  => A_SUBNORMAL_BLOCK_INPUT,
                          B_SUBNORM  => B_SUBNORMAL_BLOCK_INPUT,
                          A_NORM     => NORMAL_SUBNORMAL_ROUTER_A_OUTPUT,
                          B_NORM     => NORMAL_SUBNORMAL_ROUTER_B_OUTPUT,
                          E_DATA     => SELECTOR_E_DATA,
                          A_RDY    => A_RDY,
                          B_RDY    => B_RDY);

END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------