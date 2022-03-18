library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level_god is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
            TX : out STD_LOGIC;
            RX : in STD_LOGIC;
            MISO_TOP : in std_logic;
            SCLK_TOP : out std_logic;
            SS_N_TOP : out std_logic_vector (0 downto 0);
            MOSI_TOP : out std_logic
            );
end top_level_god;

architecture Behavioral of top_level_god is
--declaración de componentes
component modulo_uart is
    Port (
                     CLK : in STD_LOGIC;
                     RST : in STD_LOGIC;
                     --pines de comunicación con PicoBlaze
                 PORT_ID : in STD_LOGIC_VECTOR (7 downto 0);
              INPUT_PORT : in STD_LOGIC_VECTOR (7 downto 0);
             OUTPUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
            WRITE_STROBE : in STD_LOGIC;
                      --pines de comunicación serial
                      TX : out STD_LOGIC;
                      RX : in STD_LOGIC
                      );
end component;

component registro_puerto_entrada is
	 generic(
				n : integer := 8			--ancho del registro
	 );
    Port (
			  CLK  : in  STD_LOGIC;
           RST  : in  STD_LOGIC;
           D    : in  STD_LOGIC_VECTOR(n-1 downto 0);
           Q    : out STD_LOGIC_VECTOR(n-1 downto 0));
end component;

component embedded_kcpsm6 is
  port (
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                           --    sleep : in std_logic;
                                 clk : in std_logic;
                                 rst : in std_logic);
end component;

component mux_reg_entrada is
  Port (
              MUX_ENTRADA : in  STD_LOGIC_VECTOR (7 downto 0);
               MUX_SALIDA : out STD_LOGIC_VECTOR (7 downto 0);
              --pines de comunicación con Picoblaze
                  PORT_ID : in  STD_LOGIC_VECTOR (7 downto 0)
         );
end component;

component modulo_spi is
  Port (
                 CLK : in STD_LOGIC;
                 RST : in STD_LOGIC;
             PORT_ID : in STD_LOGIC_VECTOR (7 downto 0);
         OUTPUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
                MISO : in  STD_LOGIC;
                SCLK : buffer STD_LOGIC;
                SS_N : buffer STD_LOGIC_VECTOR(0 DOWNTO 0);
                MOSI : out    STD_LOGIC
  );
end component;

--declaración de señales
signal in_port_s, out_port_s, port_id_s : std_logic_vector(7 downto 0);
signal write_strobe_s : std_logic;
signal interrupt_s, interrupt_ack_s : std_logic;
signal output_port_s, D_S, mux_s, mux_entrada_s: std_logic_vector(7 downto 0);

begin
      D_S <= output_port_s when (port_id_s(4) = '1') else
             mux_s when(port_id_s(6) = '1') else
             (others => '0');

        acelerometro : modulo_spi port map(
                              CLK => CLK,
                              RST => RST,
                              PORT_ID => port_id_s,
                              OUTPUT_PORT => mux_entrada_s,
                              MISO => MISO_TOP,
                              SCLK => SCLK_TOP,
                              SS_N => SS_N_TOP,
                              MOSI => MOSI_TOP
        );

        uart :  modulo_uart
                port map (
                             CLK => CLK,
                             RST => RST,
                         PORT_ID => port_id_s,
                      INPUT_PORT => out_port_s,
                     OUTPUT_PORT => output_port_s,
                    WRITE_STROBE => write_strobe_s,
                              TX => TX,
                              RX => RX
                );

        reg_entrada : registro_puerto_entrada
                      port map (
                              CLK => CLK,
                              RST => RST,
                                D => D_S,
                                Q => in_port_s
                                );

        uprocesador : embedded_kcpsm6
                      port map(
                                in_port => in_port_s,
                               out_port => out_port_s,
                                port_id => port_id_s,
                           write_strobe => write_strobe_s,
                         k_write_strobe => open,
                            read_strobe => open,
                              interrupt => interrupt_s,
                          interrupt_ack => interrupt_ack_s,
                                    clk => CLK,
                                    rst => RST
                                );

        multiplexor_entrada : mux_reg_entrada
                  port map(
                             MUX_ENTRADA => mux_entrada_s,
                              MUX_SALIDA => mux_s,
                             --pines de comunicación con Picoblaze
                                 PORT_ID => port_id_s
                             );


end Behavioral;