// Copyright (c) 2012  Bluespec, Inc.  ALL RIGHTS RESERVED
`ifdef BSV_ASSIGNMENT_DELAY
`else
 `define BSV_ASSIGNMENT_DELAY
`endif
module xilinx_x7_pcie_wrapper #( parameter C_DATA_WIDTH        = 64, // RX/TX interface data width
    parameter PCIE_LANE          = 6'h08,                       // PCIe number of lanes
				parameter KEEP_WIDTH          = C_DATA_WIDTH / 8 // TSTRB width
                                )
(
 output txoutclk, input clk_125mhz_, input clk_250mhz_, input clkout2, input locked,
 output [7:0]                                pci_exp_txn,
 output [7:0]                                pci_exp_txp,
 input  [7:0]                                pci_exp_rxn,
 input  [7:0]                                pci_exp_rxp,
 output                                     user_clk_out,
 output wire                                user_reset_out,
 output wire                                user_lnk_up,
 output wire                                user_app_rdy,
 output  [5:0]                              tx_buf_av,
 output                                     tx_err_drop,
 output                                     tx_cfg_req,
 output                                     s_axis_tx_tready,
 input   [C_DATA_WIDTH-1:0]                             s_axis_tx_tdata,
 input   [KEEP_WIDTH-1:0]                              s_axis_tx_tkeep,
 input   [3:0]                              s_axis_tx_tuser,
 input                                      s_axis_tx_tlast,
 input                                      s_axis_tx_tvalid,
 input                                      tx_cfg_gnt,
 output  [C_DATA_WIDTH-1:0]                             m_axis_rx_tdata,
 output  [KEEP_WIDTH-1:0]                              m_axis_rx_tkeep,
 output                                     m_axis_rx_tlast,
 output                                     m_axis_rx_tvalid,
 input                                      m_axis_rx_tready,
 output  [21:0]                             m_axis_rx_tuser,
 input                                      rx_np_ok,
 input                                      rx_np_req,
 output  [11:0]                             fc_cpld,
 output  [7:0]                              fc_cplh,
 output  [11:0]                             fc_npd,
 output  [7:0]                              fc_nph,
 output  [11:0]                             fc_pd,
 output  [7:0]                              fc_ph,
 input   [2:0]                              fc_sel,
 output wire  [31:0]  cfg_mgmt_do,
 output wire          cfg_mgmt_rd_wr_done,
 output wire  [15:0]  cfg_status,
 output wire  [15:0]  cfg_command,
 output wire  [15:0]  cfg_dstatus,
 output wire  [15:0]  cfg_dcommand,
 output wire  [15:0]  cfg_lstatus,
 output wire  [15:0]  cfg_lcommand,
 output wire  [15:0]  cfg_dcommand2,
 output       [2:0]   cfg_pcie_link_state,
 output wire          cfg_pmcsr_pme_en,
 output wire  [1:0]   cfg_pmcsr_powerstate,
 output wire          cfg_pmcsr_pme_status,
 output wire          cfg_received_func_lvl_rst,
 input wire   [31:0]  cfg_mgmt_di,
 input wire   [3:0]   cfg_mgmt_byte_en,
 input wire   [9:0]   cfg_mgmt_dwaddr,
 input wire           cfg_mgmt_wr_en,
 input wire           cfg_mgmt_rd_en,
 input wire           cfg_mgmt_wr_readonly,
 input wire           cfg_err_ecrc,
 input wire           cfg_err_ur,
 input wire           cfg_err_cpl_timeout,
 input wire           cfg_err_cpl_unexpect,
 input wire           cfg_err_cpl_abort,
 input wire           cfg_err_posted,
 input wire           cfg_err_cor,
 input wire           cfg_err_atomic_egress_blocked,
 input wire           cfg_err_internal_cor,
 input wire           cfg_err_malformed,
 input wire           cfg_err_mc_blocked,
 input wire           cfg_err_poisoned,
 input wire           cfg_err_norecovery,
 input wire  [47:0]   cfg_err_tlp_cpl_header,
 output wire          cfg_err_cpl_rdy,
 input wire           cfg_err_locked,
 input wire           cfg_err_acs,
 input wire           cfg_err_internal_uncor,
 input wire           cfg_trn_pending,
 input wire           cfg_pm_halt_aspm_l0s,
 input wire           cfg_pm_halt_aspm_l1,
 input wire           cfg_pm_force_state_en,
 input wire   [1:0]   cfg_pm_force_state,
 input wire  [63:0]   cfg_dsn,
 input wire           cfg_interrupt,
 output wire          cfg_interrupt_rdy,
 input wire           cfg_interrupt_assert,
 input wire   [7:0]   cfg_interrupt_di,
 output wire  [7:0]   cfg_interrupt_do,
 output wire  [2:0]   cfg_interrupt_mmenable,
 output wire          cfg_interrupt_msienable,
 output wire          cfg_interrupt_msixenable,
 output wire          cfg_interrupt_msixfm,
 input wire           cfg_interrupt_stat,
 input wire   [4:0]   cfg_pciecap_interrupt_msgnum,
 output               cfg_to_turnoff,
 input wire           cfg_turnoff_ok,
 output wire  [7:0]   cfg_bus_number,
 output wire  [4:0]   cfg_device_number,
 output wire  [2:0]   cfg_function_number,
 input wire           cfg_pm_wake,
 input wire   [1:0]   pl_directed_link_change,
 input wire   [1:0]   pl_directed_link_width,
 input wire           pl_directed_link_speed,
 input wire           pl_directed_link_auton,
 input wire           pl_upstream_prefer_deemph,
 output wire          pl_sel_lnk_rate,
 output wire  [1:0]   pl_sel_lnk_width,
 output wire  [5:0]   pl_ltssm_state,
 output wire  [1:0]   pl_lane_reversal_mode,
 output wire          pl_phy_lnk_up,
 output wire  [2:0]   pl_tx_pm_state,
 output wire  [1:0]   pl_rx_pm_state,
 output wire          pl_link_upcfg_cap,
 output wire          pl_link_gen2_cap,
 output wire          pl_link_partner_gen2_supported,
 output wire  [2:0]   pl_initial_link_width,
 output wire          pl_directed_change_done,
 output wire          pl_received_hot_rst,
 input wire [127:0]   cfg_err_aer_headerlog,
 input wire   [4:0]   cfg_aer_interrupt_msgnum,
 output wire          cfg_err_aer_headerlog_set,
 output wire          cfg_aer_ecrc_check_en,
 output wire          cfg_aer_ecrc_gen_en,
 output wire [6:0]    cfg_vc_tcvc_map,
 input wire           sys_clk,
 input wire           sys_reset_n);
   wire                PIPE_PCLK_IN;
   wire [7:0]          PIPE_PCLK_SEL_OUT;
(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *)    reg         [PCIE_LANE-1:0] pclk_sel_reg1 = {PCIE_LANE{1'd0}};
(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *)    reg         [PCIE_LANE-1:0] pclk_sel_reg2 = {PCIE_LANE{1'd0}};
    reg                pclk_sel = 1'd0;
    BUFGCTRL pclk_i1 ( .CE0 (1'd1), .CE1 (1'd1),
        .I0 (clk_125mhz_), .I1 (clk_250mhz_), .IGNORE0 (1'd0), .IGNORE1 (1'd0),
        .S0 (~pclk_sel), .S1 ( pclk_sel), .O (PIPE_PCLK_IN));
    always @ (posedge PIPE_PCLK_IN)
    begin
        pclk_sel_reg1 <= PIPE_PCLK_SEL_OUT;
        pclk_sel_reg2 <= pclk_sel_reg1;
        if (&pclk_sel_reg2)
            pclk_sel <= 1'd1;
        else if (&(~pclk_sel_reg2))
            pclk_sel <= 1'd0;
        else
            pclk_sel <= pclk_sel;
    end
  pcie_7x_0 #() pcie_7x_i(
      .pci_exp_txn ( pci_exp_txn ), .pci_exp_txp ( pci_exp_txp ),
      .pci_exp_rxn ( pci_exp_rxn ), .pci_exp_rxp ( pci_exp_rxp ),
      .pipe_pclk_in ( PIPE_PCLK_IN ),
      .pipe_rxusrclk_in ( PIPE_PCLK_IN ), .pipe_rxoutclk_in ( 8'd0),
      .pipe_dclk_in ( clk_125mhz_ ),
      .pipe_userclk1_in ( clkout2 ), .pipe_userclk2_in ( clkout2 ),
      .pipe_oobclk_in ( clk_125mhz_ ),
      .pipe_mmcm_lock_in ( locked ),
      .pipe_txoutclk_out ( txoutclk ),
      .pipe_pclk_sel_out ( PIPE_PCLK_SEL_OUT ),
      .user_clk_out ( user_clk_out ), .user_reset_out ( user_reset_out ), .user_lnk_up ( user_lnk_up ), .user_app_rdy ( user_app_rdy ),
      .tx_buf_av ( tx_buf_av ),
      .tx_err_drop ( tx_err_drop ),
      .tx_cfg_req ( tx_cfg_req ),
      .s_axis_tx_tready ( s_axis_tx_tready ), .s_axis_tx_tdata ( s_axis_tx_tdata ), .s_axis_tx_tkeep ( s_axis_tx_tkeep ),
      .s_axis_tx_tuser ( s_axis_tx_tuser ), .s_axis_tx_tlast ( s_axis_tx_tlast ), .s_axis_tx_tvalid ( s_axis_tx_tvalid ),
      .tx_cfg_gnt ( tx_cfg_gnt ),
      .m_axis_rx_tdata ( m_axis_rx_tdata ), .m_axis_rx_tkeep ( m_axis_rx_tkeep ), .m_axis_rx_tlast ( m_axis_rx_tlast ),
      .m_axis_rx_tvalid ( m_axis_rx_tvalid ), .m_axis_rx_tready ( m_axis_rx_tready ), .m_axis_rx_tuser ( m_axis_rx_tuser ),
      .rx_np_ok ( rx_np_ok ), .rx_np_req ( rx_np_req ),
      .fc_cpld ( fc_cpld ), .fc_cplh ( fc_cplh ), .fc_npd ( fc_npd ), .fc_nph ( fc_nph ), .fc_pd ( fc_pd ), .fc_ph ( fc_ph ), .fc_sel ( fc_sel ),
      .cfg_mgmt_do ( cfg_mgmt_do ), .cfg_mgmt_rd_wr_done ( cfg_mgmt_rd_wr_done ),
      .cfg_status ( cfg_status ),
      .cfg_command ( cfg_command ),
      .cfg_dstatus ( cfg_dstatus ), .cfg_dcommand ( cfg_dcommand ),
      .cfg_lstatus ( cfg_lstatus ), .cfg_lcommand ( cfg_lcommand ),
      .cfg_dcommand2 ( cfg_dcommand2 ),
      .cfg_pcie_link_state ( cfg_pcie_link_state ),
      .cfg_pmcsr_pme_en ( cfg_pmcsr_pme_en ), .cfg_pmcsr_powerstate ( cfg_pmcsr_powerstate ), .cfg_pmcsr_pme_status ( cfg_pmcsr_pme_status ),
      .cfg_received_func_lvl_rst ( cfg_received_func_lvl_rst ),
      .cfg_mgmt_di ( cfg_mgmt_di ),
      .cfg_mgmt_byte_en ( cfg_mgmt_byte_en ), .cfg_mgmt_dwaddr ( cfg_mgmt_dwaddr ),
      .cfg_mgmt_wr_en ( cfg_mgmt_wr_en ), .cfg_mgmt_rd_en ( cfg_mgmt_rd_en ), .cfg_mgmt_wr_readonly ( cfg_mgmt_wr_readonly ),
      .cfg_err_ecrc ( cfg_err_ecrc ), .cfg_err_ur ( cfg_err_ur ),
      .cfg_err_cpl_timeout ( cfg_err_cpl_timeout ), .cfg_err_cpl_unexpect ( cfg_err_cpl_unexpect ), .cfg_err_cpl_abort ( cfg_err_cpl_abort ),
      .cfg_err_posted ( cfg_err_posted ), .cfg_err_cor ( cfg_err_cor ),
      .cfg_err_atomic_egress_blocked ( cfg_err_atomic_egress_blocked ),
      .cfg_err_internal_cor ( cfg_err_internal_cor ), .cfg_err_malformed ( cfg_err_malformed ),
      .cfg_err_mc_blocked ( cfg_err_mc_blocked ), .cfg_err_poisoned ( cfg_err_poisoned ), .cfg_err_norecovery ( cfg_err_norecovery ),
      .cfg_err_tlp_cpl_header ( cfg_err_tlp_cpl_header ),
      .cfg_err_cpl_rdy ( cfg_err_cpl_rdy ), .cfg_err_locked ( cfg_err_locked ),
      .cfg_err_acs ( cfg_err_acs ), .cfg_err_internal_uncor ( cfg_err_internal_uncor ),
      .cfg_trn_pending ( cfg_trn_pending ),
      .cfg_pm_halt_aspm_l0s ( cfg_pm_halt_aspm_l0s ), .cfg_pm_halt_aspm_l1 ( cfg_pm_halt_aspm_l1 ),
      .cfg_pm_force_state_en ( cfg_pm_force_state_en ), .cfg_pm_force_state ( cfg_pm_force_state ),
      .cfg_dsn ( cfg_dsn ),
      .cfg_interrupt ( cfg_interrupt ), .cfg_interrupt_rdy ( cfg_interrupt_rdy ),
      .cfg_interrupt_assert ( cfg_interrupt_assert ),
      .cfg_interrupt_di ( cfg_interrupt_di ), .cfg_interrupt_do ( cfg_interrupt_do ),
      .cfg_interrupt_mmenable ( cfg_interrupt_mmenable ),
      .cfg_interrupt_msienable ( cfg_interrupt_msienable ), .cfg_interrupt_msixenable ( cfg_interrupt_msixenable ),
      .cfg_interrupt_msixfm ( cfg_interrupt_msixfm ), .cfg_interrupt_stat ( cfg_interrupt_stat ),
      .cfg_pciecap_interrupt_msgnum ( cfg_pciecap_interrupt_msgnum ),
      .cfg_to_turnoff ( cfg_to_turnoff ), .cfg_turnoff_ok ( cfg_turnoff_ok ),
      .cfg_bus_number ( cfg_bus_number ), .cfg_device_number ( cfg_device_number ), .cfg_function_number ( cfg_function_number ),
      .cfg_pm_wake ( cfg_pm_wake ), .cfg_pm_send_pme_to ( 1'b0 ),
      .cfg_ds_bus_number ( 8'b0 ), .cfg_ds_device_number ( 5'b0 ), .cfg_ds_function_number ( 3'b0 ),
      .cfg_mgmt_wr_rw1c_as_rw ( 1'b0 ),
      .pl_directed_link_change ( pl_directed_link_change ), .pl_directed_link_width ( pl_directed_link_width ),
      .pl_directed_link_speed ( pl_directed_link_speed ), .pl_directed_link_auton ( pl_directed_link_auton ),
      .pl_upstream_prefer_deemph ( pl_upstream_prefer_deemph ),
      .pl_sel_lnk_rate ( pl_sel_lnk_rate ), .pl_sel_lnk_width ( pl_sel_lnk_width ),
      .pl_ltssm_state ( pl_ltssm_state ),
      .pl_lane_reversal_mode ( pl_lane_reversal_mode ),
      .pl_phy_lnk_up ( pl_phy_lnk_up ),
      .pl_tx_pm_state ( pl_tx_pm_state ), .pl_rx_pm_state ( pl_rx_pm_state ),
      .pl_link_upcfg_cap ( pl_link_upcfg_cap ), .pl_link_gen2_cap ( pl_link_gen2_cap ),
      .pl_link_partner_gen2_supported ( pl_link_partner_gen2_supported ),
      .pl_initial_link_width ( pl_initial_link_width ),
      .pl_directed_change_done ( pl_directed_change_done ),
      .pl_received_hot_rst ( pl_received_hot_rst ), .pl_transmit_hot_rst ( 1'b0 ),
      .pl_downstream_deemph_source ( 1'b0 ),
      .cfg_err_aer_headerlog ( cfg_err_aer_headerlog ), .cfg_err_aer_headerlog_set ( cfg_err_aer_headerlog_set ),
      .cfg_aer_interrupt_msgnum ( cfg_aer_interrupt_msgnum ),
      .cfg_aer_ecrc_check_en ( cfg_aer_ecrc_check_en ), .cfg_aer_ecrc_gen_en ( cfg_aer_ecrc_gen_en ),
      .cfg_vc_tcvc_map ( cfg_vc_tcvc_map ),
      .sys_clk ( sys_clk ), .sys_rst_n ( sys_reset_n ));
endmodule // xilinx_k7_pcie_wrapper
