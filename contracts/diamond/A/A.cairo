%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from diamond.A.library import A

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return ();
}

@view
func getVal() -> (res: felt) {
    let (val) = A.getVal();
    return (val,);
}
