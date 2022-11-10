%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (
    get_caller_address,
    get_contract_address,
    library_call,
)

@storage_var
func s_address() -> (res: felt) {
}

@storage_var
func s_sender() -> (res: felt) {
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    return ();
}

@external
func delegee{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (address) = get_contract_address();
    let (sender) = get_caller_address();

    s_address.write(address);
    s_sender.write(sender);

    return ();
}

@view
func getAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt) {
    let (address) = s_address.read();
    return (address,);
}

@view
func getSender{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: felt) {
    let (sender) = s_sender.read();
    return (sender,);
}
