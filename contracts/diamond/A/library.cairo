%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func s_a() -> (res: felt) {
}

@external
func setA{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(val: felt) {
    s_a.write(val);
    return ();
}

@view
func getA{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt) {
    let (val) = s_a.read();
    return (val,);
}

namespace A {
    func getVal() -> (res: felt) {
        return (2,);
    }
}
