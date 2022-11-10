%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from diamond.A.library import getA
from diamond.B.library import getBA, setBA
from diamond.C.library import getCA, setCA
from diamond.D.library import D

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return ();
}

@view
func getVal() -> (resB: felt, resC: felt) {
    let (val1, val2) = D.getVal();
    return (val1, val2,);
}
