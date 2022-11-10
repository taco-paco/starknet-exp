%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

@storage_var
func s_pendingOwner() -> (pendingOwner: felt) {
}

@storage_var
func s_owner() -> (owner: felt) {
}

@event
func ownershipTransferRequested(previousOwner: felt, newOwner: felt) {
}

@event
func ownershipTransferred(previousOwner: felt, newOwner: felt) {
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (caller) = get_caller_address();
    s_owner.write(caller);

    ret;
}

@external
func transferOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    newOwner: felt
) -> (newOwner: felt) {
    // Q: Why return instead emit?
    // Ownable_owner.write(new_owner)
    // return (new_owner=new_owner)

    let (currentOwner) = s_owner.read();
    s_pendingOwner.write(newOwner);
    ownershipTransferRequested.emit(currentOwner, newOwner);

    ret;
}

@external
func acceptOwnership{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (caller) = get_caller_address();
    let (pendingOwner) = s_pendingOwner.read();
    with_attr error_message("Must be proposed owner") {
        assert caller = pendingOwner;
    }

    let (oldOwner) = s_owner.read();
    s_owner.write(pendingOwner);
    s_pendingOwner.write(0);

    ownershipTransferred.emit(oldOwner, pendingOwner);
    ret;
}

@external
func onlyOwner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (owner) = s_owner.read();
    let (caller) = get_caller_address();
    with_attr error_message("Only callable by owner") {
        assert owner = caller;
    }
    return ();
}

@external
func getAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    address: felt
) {
    let (address) = s_owner.read();
    return (address,);
}

@external
func getCallerAddress{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    address: felt
) {
    let (caller) = get_caller_address();
    return (caller,);
}
