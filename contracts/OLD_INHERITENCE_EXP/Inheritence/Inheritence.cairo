%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import (
    get_caller_address,
    get_tx_info,
    call_contract,
    get_contract_address,
)

from OLD_INHERITENCE_EXP.Base import Base
from OLD_INHERITENCE_EXP.Inheritence.library import s_lol, asd, Inheritence

@event
func SomeEvent(val: felt) {
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    Inheritence.constructor();

    return ();
}

@view
func getLol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (amount: felt) {
    let (lol) = Inheritence.getLol();
    return (lol,);
}

@external
func increaseLol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    s_lol.write(100);
    SomeEvent.emit(101);
    return ();
}

@view
func get_lol_addr{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    address: felt
) {
    let (addr) = s_lol.addr();
    return (addr,);
}

@view
func getOriginAndCaller{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    origin: felt, caller: felt
) {
    return Inheritence.getOriginAndCaller();
}

@view
func dymmy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(val: felt) {
    let (txInfo) = get_tx_info();
    return ();
}

@view
func getTxInfoVal{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    origin: felt
) {
    let (txInfo) = get_tx_info();
    return (txInfo.account_contract_address,);
}

@external
func callF{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    to: felt, function_selector: felt, calldata_len: felt, calldata: felt*
) -> (retdata_len: felt, retdata: felt*) {
    let (retdata_size: felt, retdata: felt*) = call_contract(
        to, function_selector, calldata_len, calldata
    );

    return (retdata_size, retdata);
}

// Why calldata_size compiles fine with raw_input but not without
@external
@raw_input
func test_raw_input{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    selector: felt, calldata_size: felt, calldata: felt*
) {
    assert calldata_size = 2;
    assert calldata[0] = 1;
    assert selector = 22;
    return ();
}

@external
func call_sys_raw_input{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    const func_selector = 892498851357712316939839418832507568028894994438215514301164357317402684105;
    let (to) = get_contract_address();
    // let asd : felt* = cast(new (1, 1), felt*)
    call_contract(to, func_selector, 2, cast(new (1, 1), felt*));
    return ();
}

@external
func call_raw_input{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    calldata_len: felt, calldata: felt*
) {
    test_raw_input(22, calldata_len, calldata);
    return ();
}
