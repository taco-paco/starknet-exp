%lang starknet

from OLD_INHERITENCE_EXP.Inheritence.library import Inheritence

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func s_kek() -> (lol: felt) {
}

namespace SuperInherited {
    func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        s_kek.write(1);
        Inheritence.constructor();

        return ();
    }
}
