%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address
from OLD_INHERITENCE_EXP.Base import Base

@storage_var
func s_lol() -> (lol: felt) {
}

@storage_var
func s_anotherContractAddress() -> (address: felt) {
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    anotherContractAddress: felt
) {
    s_lol.write(0);
    s_anotherContractAddress.write(anotherContractAddress);

    ret;
}

@external
func getLol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (amount: felt) {
    let (lol) = s_lol.read();
    return (lol,);
}

@external
func increaseLol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (address) = s_anotherContractAddress.read();
    Base.increaseLol(address);

    return ();
}

@external
func delegateGetLol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    lol: felt
) {
    s_lol.write(100);
    // TODO: ADD method get_class_hash() to cairo-lang
    let (address) = get_contract_address();
    let (lol) = Base.library_call_getLol(address);

    return (lol,);
}

@external
func delegateIncreaseLol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (address) = s_anotherContractAddress.read();
    Base.library_call_increaseLol(address);

    return ();
}

@view
func getOriginAndCaller{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    origin: felt, caller: felt
) {
    let (address) = s_anotherContractAddress.read();
    let (origin, caller) = Base.getOriginAndCaller(address);
    return (origin, caller);
}
