%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin

@contract_interface
namespace Base {
    func increaseLol() {
    }

    func getLol() -> (amount: felt) {
    }

    func getOriginAndCaller() -> (origin: felt, caller: felt) {
    }
}
