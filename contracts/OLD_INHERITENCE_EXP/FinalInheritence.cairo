%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address, get_tx_info

from OLD_INHERITENCE_EXP.Inheritence.library import s_lol, Inheritence

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    s_lol.write(0);

    return ();
}

@view
func getLol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (amount: felt) {
    let (lol) = Inheritence.getLol();
    return (lol,);
}

@external
func increaseLol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (val) = s_lol.read();
    let asd = val + 100;
    s_lol.write(val + 100);
    return ();
}

@view
func getOriginAndCaller{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    origin: felt, caller: felt
) {
    return Inheritence.getOriginAndCaller();
}

using TypeAlias = (address: felt, x: (z: felt, f: (felt, (felt, felt, felt))));
using TupleTypeAlias = ((A, felt), felt, (felt, A));

struct A {
    frfr: felt,
    trtr: felt,
}

@view
func normal(point_len: felt, some_len: felt) -> (res_len: felt, other_len: felt) {
    return (3, 2);
}

@view
func tuple(bar: (A, (felt, felt))) {
    alloc_locals;
    local asd: A = bar[0];
    return ();
}

@view
func type_struct(bar: A) {
    alloc_locals;
    local asd: A = bar;
    return ();
}

@view
func type_alias(bar: TypeAlias) -> (res: TypeAlias) {
    alloc_locals;
    local asd: TypeAlias = bar;
    return (asd,);
}

@view
func tuple_type_alias(bar: TupleTypeAlias) -> (res_len: felt, res: TupleTypeAlias*) {
    alloc_locals;
    local asd: TupleTypeAlias = bar;
    let a: TupleTypeAlias* = alloc();
    assert a[0] = asd;
    return (1, a);
}
