"""Generate actual PS pause packets and a bounded real-GPU RTL testbench.

Run: .venv/Scripts/python.exe -B tools/prepare_preview_generation_sim.py
Output: build/preview-generation-rtl/{zero,bound}.mem, tb_preview_generations.sv.
Next: launch tb_preview_generations with Vivado XSim; require terminal TEST_PASS.
"""
from pathlib import Path
import struct,sys
from types import SimpleNamespace
from unittest.mock import Mock
ROOT=Path(__file__).resolve().parents[1]
sys.path[:0]=[str(ROOT/'subprojects/ps_ui_r23b2/python'),str(ROOT/'python')]
from pynq_multimodal_game.agent.c6i_shell import C6IShellRuntimeBackend
out=ROOT/'build/preview-generation-rtl';out.mkdir(parents=True,exist_ok=True)
r=C6IShellRuntimeBackend(SimpleNamespace(build_id=0xC0061000),menu_fps=0)
sink=Mock();sink.resource_generations=(17,23,42);r._sink=sink;r._show_preview_pause()
bound=sink.submit_scene.call_args.args[0];zero=bytearray(bound)
for word in (8,10,11):struct.pack_into('<I',zero,word*4,0)
for name,packet in (('zero',zero),('bound',bound)):
    (out/(name+'.mem')).write_text('\n'.join(f'{v:016x}' for (v,) in struct.iter_unpack('<Q',packet))+'\n')
tb=(ROOT/'sim/scene2d_gpu/tb_scene2d_c4m3_core.sv').read_text()
tb=tb.split('    initial begin\n        $readmemh')[0]
tb=tb.replace('tb_scene2d_c4m3_core','tb_preview_generations')
tb=tb.replace('.OUTPUT_SCALE(1)',
    '.OUTPUT_SCALE(1), .RUNTIME_PALETTE_ENABLE(1), .RUNTIME_ASSET_ENABLE(1), .RUNTIME_TILEMAP_ENABLE(1)')
tb=tb.replace('.runtime_palette_valid(1\'b0)', '.runtime_palette_valid(1\'b1)')
tb=tb.replace(".runtime_palette_generation('0)",".runtime_palette_generation(32'd17)")
tb=tb.replace('.runtime_asset_valid(1\'b0)', '.runtime_asset_valid(1\'b1)')
tb=tb.replace(".runtime_asset_generation('0)",".runtime_asset_generation(32'd23)")
tb=tb.replace(".runtime_asset_read_byte('0),", ".runtime_asset_read_byte('0),\n"+
    "        .runtime_tilemap_valid(1'b1), .runtime_tilemap_generation(32'd42),\n"+
    "        .runtime_tilemap_width_tiles(16'd1), .runtime_tilemap_height_tiles(16'd1), .runtime_tilemap_tile_size(16'd1),\n"+
    "        .runtime_tilemap_read_word_data(32'd0),")
tb+='''
    initial begin
        #2ms; $fatal(1,"preview identity watchdog");
    end
    initial begin
        $readmemh("ZERO",payload);
        repeat(5) @(posedge clk);
        @(negedge clk); resetn=1;
        repeat(5) @(posedge pixel_clk);
        @(negedge pixel_clk); pixel_resetn=1;
        send_payload(32'hC6A10001);
        repeat(3000) @(posedge clk);
        if(accepted_packet_count!=1 || render_completed_count!=0 || dut.renderer_start!==0)
            $fatal(1,"zero generation did not reproduce accepted-but-unrendered stall");
        $display("EXPECTED_STALL accepted=%0d rendered=%0d palette_ready=%b asset_ready=%b tilemap_ready=%b",
                 accepted_packet_count,render_completed_count,dut.palette_ready,dut.asset_ready,dut.tilemap_ready);
        @(negedge clk); resetn=0;pixel_resetn=0;
        repeat(5) @(posedge clk);
        $readmemh("BOUND",payload);
        @(negedge clk); resetn=1;
        repeat(5) @(posedge pixel_clk);
        @(negedge pixel_clk); pixel_resetn=1;
        send_payload(32'hC6A10002);
        wait(render_completed_count==1);
        if(accepted_packet_count!=1 || render_status[11:4]!=0)
            $fatal(1,"bound generation pause did not render cleanly");
        wait(present_completed_count==1);
        $display("TEST_PASS preview resource identity accepted=%0d rendered=%0d presented=%0d",
                 accepted_packet_count,render_completed_count,present_completed_count);
        $finish;
    end
endmodule
'''
tb=tb.replace('ZERO',(out/'zero.mem').as_posix()).replace('BOUND',(out/'bound.mem').as_posix())
(out/'tb_preview_generations.sv').write_text(tb)
print(out)
