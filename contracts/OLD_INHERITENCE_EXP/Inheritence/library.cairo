%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_contract_address, get_tx_info, get_caller_address

// from node_modules.@joriksch.oz-cairo.src.openzeppelin.token.erc20.ERC20 import name

from OLD_INHERITENCE_EXP.Base import Base

@storage_var
func s_lol() -> (lol: felt) {
}

@storage_var
func s_owner() -> (lol: felt) {
}

@external
func asd{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(lol: felt) -> (
    lol: felt
) {
    s_lol.write(1);
    let (caller) = get_caller_address();
    let (this_address) = get_contract_address();

    assert caller = this_address;

    return (lol,);
}

@external
func set_owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) -> (
    ) {
    s_owner.write(address);
    return ();
}

@view
func get_owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    address: felt
) {
    let (address) = s_owner.read();
    return (address,);
}

func require_owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(address: felt) {
    let (owner) = s_owner.read();
    with_attr error_message("invalid owner") {
        assert owner = address;
    }

    return ();
}

@external
func deposit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    from_address: felt, value: felt
) {
    s_lol.write(value);
    return ();
}

@external
func asd_arr{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    lol_len: felt, lol: felt*
) -> (lol_len: felt, lol: felt*) {
    s_lol.write(1);
    let (caller) = get_caller_address();
    let (this_address) = get_contract_address();

    assert caller = this_address;

    return (lol_len, lol);
}

@external
func callInherited{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (contractAddresss) = get_contract_address();
    Base.increaseLol(contractAddresss);
    return ();
}

namespace Inheritence {
    func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        s_lol.write(0);

        return ();
    }

    func getLol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        amount: felt
    ) {
        let (lol) = s_lol.read();
        let (lol) = asd(lol);
        return (lol,);
    }

    func increaseLol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (lol) = Inheritence.getLol();
        s_lol.write(lol + 1);

        return ();
    }

    func getOriginAndCaller{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        origin: felt, caller: felt
    ) {
        let (txInfo) = get_tx_info();
        let (caller) = get_caller_address();

        return (txInfo.account_contract_address, caller);
    }
}
