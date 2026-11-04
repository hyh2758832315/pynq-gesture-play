"""Execute the real Tcl helper against native-like refusal semantics."""
from pathlib import Path
import tkinter
import unittest


class ScalarConnectionTests(unittest.TestCase):
    def setUp(self):
        self.tcl=tkinter.Tcl()
        self.tcl.eval('''
            array set pin_net {}
            set calls 0
            proc get_bd_nets {args} {
                global pin_net
                set pin [lindex $args end]
                if {[info exists pin_net($pin)]} {return $pin_net($pin)}
                return {}
            }
            proc connect_bd_net {args} {
                global pin_net calls
                incr calls
                if {[lindex $args 0] eq {-net}} {
                    set net [lindex $args 1];set pins [lrange $args 2 end]
                } else {set net /new;set pins $args}
                foreach pin $pins {
                    if {[info exists pin_net($pin)]} {error {native rejects already connected endpoints}}
                }
                foreach pin $pins {set pin_net($pin) $net}
                return $net
            }
        ''')
        self.tcl.call('source',str(Path(__file__).with_name('scalar_connections.tcl')))

    def test_same_net_skips_native_and_preserves_unlisted_fanout(self):
        self.tcl.eval('array set pin_net {a /clk b /clk fanout /clk}')
        self.assertEqual(self.tcl.call('latency_connect_scalar',('a','b')),'UNCHANGED')
        self.assertEqual(self.tcl.eval('set calls'),'0')
        self.assertEqual(self.tcl.eval('set pin_net(fanout)'),'/clk')

    def test_partial_net_adds_only_open_pin(self):
        self.tcl.eval('array set pin_net {a /clk fanout /clk}')
        self.assertEqual(self.tcl.call('latency_connect_scalar',('a','b','c')),'CONNECTED')
        self.assertEqual(self.tcl.eval('set pin_net(c)'),'/clk')
        self.assertEqual(self.tcl.eval('set calls'),'1')

    def test_new_net_connects_every_endpoint(self):
        self.assertEqual(self.tcl.call('latency_connect_scalar',('a','b')),'CONNECTED')
        self.assertEqual(self.tcl.eval('set pin_net(b)'),'/new')

    def test_conflict_refuses_before_mutation(self):
        self.tcl.eval('array set pin_net {a /clk b /different}')
        with self.assertRaisesRegex(tkinter.TclError,'conflicting scalar nets'):
            self.tcl.call('latency_connect_scalar',('a','b','c'))
        self.assertEqual(self.tcl.eval('set calls'),'0')
        self.assertEqual(self.tcl.eval('info exists pin_net(c)'),'0')

    def test_duplicate_pin_does_not_fake_two_endpoints(self):
        with self.assertRaisesRegex(tkinter.TclError,'two unique pins'):
            self.tcl.call('latency_connect_scalar',('a','a'))


if __name__=='__main__':
    unittest.main()
