%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from OLD_INHERITENCE_EXP.SuperInherited.library import SuperInherited

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    SuperInherited.constructor();

    return ();
}
