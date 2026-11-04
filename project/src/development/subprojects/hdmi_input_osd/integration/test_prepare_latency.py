import unittest

from prepare_latency import connections, interface_lines, quote


class CaptureTopologyTests(unittest.TestCase):
    def design(self, endpoints, *, scalar=False):
        kind='nets' if scalar else 'interface_nets'
        field='ports' if scalar else 'interface_ports'
        return {'components':{},kind:{'test':{field:endpoints}}}

    def test_source_single_ended_output_is_preserved_as_unused(self):
        donor=self.design(['capture_source_fault/capture_aresetn'],scalar=True)
        self.assertEqual(connections(donor,{'components':{}},'nets'),[])

    def test_lost_external_connection_is_rejected(self):
        donor=self.design(['dual_mask_capture/S_AXIS','missing/M_AXIS'])
        with self.assertRaisesRegex(ValueError,'missing capture boundary driver'):
            connections(donor,{'components':{}},'interface_nets')

    def test_missing_scalar_driver_is_not_hidden_by_two_capture_sinks(self):
        donor=self.design(['dual_mask_capture/aclk','capture_lifecycle/common_aclk','clock/dout'],scalar=True)
        donor['components']['clock']={'ports':{'dout':{'direction':'O'}}}
        with self.assertRaisesRegex(ValueError,'missing capture boundary driver'):
            connections(donor,{'components':{}},'nets')

    def test_c0d_control_alias_uses_free_port_and_retains_capture(self):
        donor=self.design(['capture_control/s_axi','vision_control_smc/M08_AXI'])
        actual=connections(donor,{'components':{'vision_control_smc':{}}},'interface_nets')
        self.assertEqual(actual,[('test',['capture_control/s_axi','vision_control_smc/M06_AXI'])])

    def test_internal_connection_is_complete(self):
        donor=self.design(['capture_lifecycle/capture_aresetn','dual_mask_capture/aresetn'],scalar=True)
        self.assertEqual(len(connections(donor,{'components':{}},'nets')[0][1]),2)

    def test_tcl_values_reject_injection(self):
        self.assertEqual(quote('E:/vvl/space path'),'{E:/vvl/space path}')
        for value in ('{value','value}','value\ncommand','value\rcommand'):
            with self.assertRaises(ValueError): quote(value)

    def test_monitor_interfaces_use_two_objects_per_native_call(self):
        native='\n'.join(interface_lines())
        self.assertNotIn('{*}$pins',native)
        self.assertIn('connect_bd_intf_net $root $sink',native)
        self.assertIn('if {[llength $root_net] && $root_net eq $sink_net} {continue}',native)

    def test_disabled_parent_ps_slave_gp0_clock_is_not_created(self):
        donor=self.design(['capture_lifecycle/common_aclk','ps7_0/FCLK_CLK0','ps7_0/S_AXI_GP0_ACLK'],scalar=True)
        parent={'components':{'ps7_0':{'parameters':{'PCW_USE_S_AXI_GP0':{'value':'0'}}}}}
        actual=connections(donor,parent,'nets')
        self.assertEqual(actual,[('test',['capture_lifecycle/common_aclk','ps7_0/FCLK_CLK0'])])


if __name__=='__main__':
    unittest.main()