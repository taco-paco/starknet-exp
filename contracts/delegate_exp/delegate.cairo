%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (
    get_caller_address,
    get_contract_address,
    library_call,
    call_contract,
    deploy,
)
from starkware.cairo.common.alloc import alloc

@storage_var
func s_address() -> (res: felt) {
}

@storage_var
func s_sender() -> (res: felt) {
}

@storage_var
func s_delegee() -> (res: felt) {
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    class_hash: felt
) {
    let (arr: felt*) = alloc();

    let (address) = deploy(
        class_hash=class_hash,
        contract_address_salt=0,
        constructor_calldata_size=0,
        constructor_calldata=arr,
        deploy_from_zero=1,
    );

    s_delegee.write(address);

    return ();
}

@external
func delegateCall{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    class_hash: felt, selector: felt, calldata_len: felt, calldata: felt*
) {
    library_call(class_hash, selector, calldata_len, calldata);
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

@view
func getData{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(selector: felt) -> (
    res: felt
) {
    let (arr: felt*) = alloc();
    let (address) = s_delegee.read();
    let (size, ptr) = call_contract(address, selector, 0, arr);
    return (ptr[0],);
}

@external
func setData{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(selector: felt) {
    let (arr: felt*) = alloc();
    let (address) = s_delegee.read();
    call_contract(address, selector, 0, arr);
    return ();
}
