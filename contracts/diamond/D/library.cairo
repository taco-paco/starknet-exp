%lang starknet

// from diamond.B.library import B
// from diamond.C.library import C

from diamond.B.library import B
from diamond.C.library import C
namespace D {
    func getVal() -> (resB: felt, resC: felt) {
        let (val1) = B.getVal();
        let (val2) = C.getVal();
        return (val1, val2,);
    }
}
