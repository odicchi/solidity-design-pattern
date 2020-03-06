pragma solidity ^0.5.16;

contract StringUtils {
    
    // コンパイルエラー
    // function equals(string memory a, string memory b) pure public returns (bool) {
    //    return a != b;
    // }
    // function equals(string memory a, string memory b) pure public returns (bool) {
    //     return bytes(a) != bytes(b);
    // }
    
    function hashCompareWithLengthCheck(string memory a, string memory b) pure internal returns (bool) {
        if(bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
        }
    }
}
