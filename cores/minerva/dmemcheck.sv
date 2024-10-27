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

	wire [31:0] dmem_addr;
	reg  [31:0] dmem_data;

	rvfi_dmem_check checker_inst (
		.clock     (clock),
		.reset     (reset),
		.enable    (1'b1),
		.dmem_addr (dmem_addr),
		`RVFI_CONN
	);

	wire dbus_write = dbus_cyc && dbus_stb && dbus_ack && dbus_we;
	wire dbus_read  = dbus_cyc && dbus_stb && dbus_ack;

	always @(posedge clock) begin
		if (dbus_write && (dbus_adr == dmem_addr[31:2])) begin
			if (dbus_sel[0]) dmem_data[ 7: 0] <= dbus_dat_w[ 7: 0];
			if (dbus_sel[1]) dmem_data[15: 8] <= dbus_dat_w[15: 8];
			if (dbus_sel[2]) dmem_data[23:16] <= dbus_dat_w[23:16];
			if (dbus_sel[3]) dmem_data[31:24] <= dbus_dat_w[31:24];
		end
		if (reset) begin
			dmem_data <= 0;
		end
	end

	always @* begin
		if (!reset && dbus_read && (dbus_adr == dmem_addr[31:2]))
			assume(dbus_dat_r == dmem_data);
	end

	\minerva.core.Minerva #(
		.with_rvfi          (1),

		.with_dcache        (1),
		.dcache_nways       (2),
		.dcache_nlines      (2),
		.dcache_nwords      (4),
		.dcache_base        (32'h1000),
		.dcache_limit       (32'h4000),
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
