`include "defines.sv"

module testbench (
	input clock,
);
	reg reset = 1;
	always @(posedge clock)
		reset <= 0;

	(* keep *) wire [31:0] external_interrupt;
	(* keep *) wire        timer_interrupt;
	(* keep *) wire        software_interrupt;

	assign external_interrupt = 32'b0;
	assign timer_interrupt    =  1'b0;
	assign software_interrupt =  1'b0;

	(* keep *) wire [29:0] ibus_adr;
	(* keep *) wire [31:0] ibus_dat_w;
	(* keep *) wire [31:0] ibus_dat_r;
	(* keep *) wire [ 3:0] ibus_sel;
	(* keep *) wire        ibus_cyc;
	(* keep *) wire        ibus_stb;
	(* keep *) wire        ibus_ack;
	(* keep *) wire        ibus_we;
	(* keep *) wire [ 2:0] ibus_cti;
	(* keep *) wire [ 1:0] ibus_bte;
	(* keep *) wire        ibus_err;

	(* keep *) wire [29:0] dbus_adr;
	(* keep *) wire [31:0] dbus_dat_w;
	(* keep *) wire [31:0] dbus_dat_r;
	(* keep *) wire [ 3:0] dbus_sel;
	(* keep *) wire        dbus_cyc;
	(* keep *) wire        dbus_stb;
	(* keep *) wire        dbus_ack;
	(* keep *) wire        dbus_we;
	(* keep *) wire [ 2:0] dbus_cti;
	(* keep *) wire [ 1:0] dbus_bte;
	(* keep *) wire        dbus_err;

	`rvformal_rand_reg [31:0] ibus_dat_r_randval;
	`rvformal_rand_reg        ibus_ack_randval;
	`rvformal_rand_reg [31:0] dbus_dat_r_randval;
	`rvformal_rand_reg        dbus_ack_randval;

	assign ibus_dat_r = ibus_dat_r_randval;
	assign ibus_ack   = ibus_ack_randval;
	assign ibus_err   = 1'b0;
	assign dbus_dat_r = dbus_dat_r_randval;
	assign dbus_ack   = dbus_ack_randval;
	assign dbus_err   = 1'b0;

	`RVFI_WIRES

	wire [31:0] imem_addr;
	wire [15:0] imem_data;

	rvfi_imem_check checker_inst (
		.clock     (clock),
		.reset     (reset),
		.enable    (1'b1),
		.imem_addr (imem_addr),
		.imem_data (imem_data),
		`RVFI_CONN
	);

	always @* begin
		if (!reset && ibus_cyc && ibus_stb && ibus_ack) begin
			if ({ibus_adr, 2'b00} == imem_addr)
				assume(ibus_dat_r[15: 0] == imem_data);
			if ({ibus_adr, 2'b10} == imem_addr)
				assume(ibus_dat_r[31:16] == imem_data);
		end
	end

	\minerva.core.Minerva #(
		.with_rvfi          (1),

		.with_icache        (1),
		.icache_nways       (2),
		.icache_nlines      (2),
		.icache_nwords      (4),
		.icache_base        (32'h1000),
		.icache_limit       (32'h4000),
	) uut (
		.clk                (clock),
		.rst                (reset),

		.external_interrupt (external_interrupt),
		.timer_interrupt    (timer_interrupt),
		.software_interrupt (software_interrupt),

		.ibus__adr          (ibus_adr),
		.ibus__dat_w        (ibus_dat_w),
		.ibus__dat_r        (ibus_dat_r),
		.ibus__sel          (ibus_sel),
		.ibus__cyc          (ibus_cyc),
		.ibus__stb          (ibus_stb),
		.ibus__ack          (ibus_ack),
		.ibus__we           (ibus_we),
		.ibus__cti          (ibus_cti),
		.ibus__bte          (ibus_bte),
		.ibus__err          (ibus_err),

		.dbus__adr          (dbus_adr),
		.dbus__dat_w        (dbus_dat_w),
		.dbus__dat_r        (dbus_dat_r),
		.dbus__sel          (dbus_sel),
		.dbus__cyc          (dbus_cyc),
		.dbus__stb          (dbus_stb),
		.dbus__ack          (dbus_ack),
		.dbus__we           (dbus_we),
		.dbus__cti          (dbus_cti),
		.dbus__bte          (dbus_bte),
		.dbus__err          (dbus_err),

		.rvfi__valid        (rvfi_valid),
		.rvfi__order        (rvfi_order),
		.rvfi__insn         (rvfi_insn),
		.rvfi__trap         (rvfi_trap),
		.rvfi__halt         (rvfi_halt),
		.rvfi__intr         (rvfi_intr),
		.rvfi__mode         (rvfi_mode),
		.rvfi__ixl          (rvfi_ixl),
		.rvfi__rs1_addr     (rvfi_rs1_addr),
		.rvfi__rs2_addr     (rvfi_rs2_addr),
		.rvfi__rs1_rdata    (rvfi_rs1_rdata),
		.rvfi__rs2_rdata    (rvfi_rs2_rdata),
		.rvfi__rd_addr      (rvfi_rd_addr),
		.rvfi__rd_wdata     (rvfi_rd_wdata),
		.rvfi__pc_rdata     (rvfi_pc_rdata),
		.rvfi__pc_wdata     (rvfi_pc_wdata),
		.rvfi__mem_addr     (rvfi_mem_addr),
		.rvfi__mem_rmask    (rvfi_mem_rmask),
		.rvfi__mem_wmask    (rvfi_mem_wmask),
		.rvfi__mem_rdata    (rvfi_mem_rdata),
		.rvfi__mem_wdata    (rvfi_mem_wdata),
	);
endmodule
