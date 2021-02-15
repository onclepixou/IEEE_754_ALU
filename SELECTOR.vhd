-----------------------------------------------------------------------------------------------------------
-- Floating Point Unit IEEE 754 ( 32 bits support )
-----------------------------------------------------------------------------------------------------------
-- PRECOMPUTE BLOCK --> SELECTOR
-- DESCRIPTION : Prepare operands by adding implicit and guard bits.
--               Detect if operands are normals, subnormals or a mix (through E_DATA)
--
--  E_DATA = 00 --> Subnormals
--           01 --> Normals
--           10 --> Mix
--           11 --> NOT ENABLED
--
--  A_OUT and B_OUT contain augmented logic_vector organised as follow :
--
--  - Bit 36    : Sign
--  - Bit 35-28 : Exponent
--  - Bit 27    : Implicit bit (1 when normal, 0 otherwise)
--  - Bit 26- 4 : Mantissa
--  - Bit  3- 0 : Guard bits   
-----------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ENTITY DECLARATION
-----------------------------------------------------------------------------------------------------------

ENTITY SELECTOR IS

    PORT(

        A      :  IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- 32 bit operand 1
        B      :  IN STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- 32 bit operand 1
        ENABLE :  IN STD_LOGIC;                       -- Block activation
        A_OUT  : OUT STD_LOGIC_VECTOR( 36 DOWNTO 0 ); -- Augmented operand 1
        B_OUT  : OUT STD_LOGIC_VECTOR( 36 DOWNTO 0 ); -- Augmented operand 2
        E_DATA : OUT STD_LOGIC_VECTOR(  1 DOWNTO 0 )  -- Hint operands type
    );

END ENTITY;

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
-----------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH OF SELECTOR IS 

    SIGNAL SA : STD_LOGIC;
    SIGNAL EA : STD_LOGIC_VECTOR( 7 DOWNTO 0);
    SIGNAL MA : STD_LOGIC_VECTOR(22 DOWNTO 0);

    SIGNAL SB : STD_LOGIC;
    SIGNAL EB : STD_LOGIC_VECTOR( 7 DOWNTO 0);
    SIGNAL MB : STD_LOGIC_VECTOR(22 DOWNTO 0);

    BEGIN 

        -- Extract sign, exponent mantissa for A
        SA <= A(31);
        EA <= A(30 DOWNTO 23);
        MA <= A(22 DOWNTO  0);

        -- Extract sign, exponent mantissa for B
        SB <= B(31);
        EB <= B(30 DOWNTO 23);
        MB <= B(22 DOWNTO  0);

        -- Update E_DATA output according to A and B
        E_DATA <= "11" WHEN ( ( ENABLE = '0' ) ) ELSE  -- NOT ENABLED
                  "00" WHEN ( ( ENABLE = '1' ) AND ( UNSIGNED(EA) = 0 ) AND ( UNSIGNED(EB) = 0 ) )    ELSE  -- Subnormals
                  "01" WHEN ( ( ENABLE = '1' ) AND ( UNSIGNED(EA) > 0 ) AND ( UNSIGNED(EB) > 0 ) )    ELSE  -- Normals
                  "10" WHEN ( ( ENABLE = '1' ) AND ( ( UNSIGNED(EA) = 0 ) OR ( UNSIGNED(EB) = 0 ) ) ) ELSE  -- Combination
                  "--"; -- This should never happen

        PROCESS(SA, EA, MA, SB, EB, MB , ENABLE)

            BEGIN

            IF(enable = '1') THEN

                -- A exponent and sign
                A_OUT(36) <= SA;
                A_OUT(35 DOWNTO 28) <= EA;

                -- B exponent and sign
                B_OUT(36) <= SB;
                B_OUT(35 DOWNTO 28) <= EB;

                -- A Mantissa
                IF ( UNSIGNED(EA) > 0 ) THEN    -- Normal number case (exponent > 0) --> implicit bit is 1

                    A_OUT(27) <= '1';           -- Implicit bit
                    A_OUT(26 DOWNTO 4) <= MA;   -- Mantissa
                    A_OUT( 3 DOWNTO 0) <= X"0"; -- Guard bits

                ELSIF ( UNSIGNED(EA) = 0 ) THEN -- Subnormal number case (exponent = 0) --> implicit bit is 0

                    A_OUT(27) <= '0';           -- Implicit bit
                    A_OUT(26 DOWNTO 4) <= MA;   -- Mantissa
                    A_OUT( 3 DOWNTO 0) <= X"0"; -- Guard bits

                ELSE 

                    A_OUT <= "-------------------------------------"; -- This should not happen

                END IF;

                -- B Mantissa
                IF ( UNSIGNED(EB) > 0 ) THEN           -- Normal number case (exponent > 0) --> implicit bit is 1

                    B_OUT(27) <= '1';           -- Implicit bit
                    B_OUT(26 DOWNTO 4) <= MB;   -- Mantissa
                    B_OUT( 3 DOWNTO 0) <= X"0"; -- Guard bits

                ELSIF ( UNSIGNED(EB) = 0 ) THEN        -- Subnormal number case (exponent = 0) --> implicit bit is 0

                    B_OUT(27) <= '0';           -- Implicit bit
                    B_OUT(26 DOWNTO 4) <= MB;   -- Mantissa
                    B_OUT( 3 DOWNTO 0) <= X"0"; -- Guard bits

                ELSE 

                    B_OUT <= "-------------------------------------"; -- This should not happen

                END IF;

            ELSE -- Precomputation is not needed

                A_OUT <= "-------------------------------------";
                B_OUT <= "-------------------------------------";

            END IF;

        END PROCESS;

END ARCHITECTURE;

-----------------------------------------------------------------------------------------------------------