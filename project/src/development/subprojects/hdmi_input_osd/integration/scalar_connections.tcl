# Resolve and preflight all groups before calling latency_connect_scalar.
# Reject net merging. Preserve existing fanout and connect only open endpoints.
proc latency_scalar_plan {pins} {
    set pins [lsort -unique $pins]
    if {[llength $pins]<2} {error {scalar group requires two unique pins}}
    set known {}
    set pending {}
    foreach pin $pins {
        set net [get_bd_nets -quiet -of_objects $pin]
        if {[llength $net]>1} {error "ambiguous scalar pin $pin"}
        if {[llength $net]} {lappend known [lindex $net 0]} else {lappend pending $pin}
    }
    set known [lsort -unique $known]
    if {[llength $known]>1} {error "conflicting scalar nets $known for $pins"}
    return [list $known $pending $pins]
}

proc latency_connect_scalar {pins} {
    lassign [latency_scalar_plan $pins] known pending pins
    if {![llength $pending]} {return UNCHANGED}
    if {[llength $known]} {
        connect_bd_net -net [lindex $known 0] {*}$pending
    } else {
        connect_bd_net {*}$pins
    }
    lassign [latency_scalar_plan $pins] actual remaining
    if {[llength $actual]!=1 || [llength $remaining]} {error {scalar connection readback failed}}
    return CONNECTED
}
