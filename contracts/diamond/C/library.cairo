%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from diamond.A.library import A, setA, s_a

@external
func setCA{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(val: felt) {
    setA(val);
    return ();
}

@view
func getCA{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt) {
    let (val) = s_a.read();
    return (val,);
}

namespace C {
    func getVal() -> (res: felt) {
        let (val) = A.getVal();
        return (val,);
    }
}
