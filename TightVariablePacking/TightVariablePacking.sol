pragma solidity ^0.5.16;

contract TightVariablePacking {
    struct CheapStruct {
        uint8 x1;
        uint8 x2;
        uint8 x3;
        uint8 x4;
        uint8 x5;
        uint8 x6;
        uint8 x7;
        uint8 x8;
    }
    
    CheapStruct example;
    event ViewInt(uint8, uint8, uint8, uint8, uint8, uint8, uint8, uint8);
    
    constructor() public {
        CheapStruct memory someStruct = CheapStruct(1, 2, 3, 4, 5, 6, 7, 8);
        example = someStruct;
    }
    
    function setParameter(uint8 _a, uint8 _b, uint8 _c, uint8 _d, uint8 _e, uint8 _f, uint8 _g, uint8 _h) public {
        example.x1 = _a;
        example.x2 = _b;
        example.x3 = _c;
        example.x4 = _d;
        example.x5 = _e;
        example.x6 = _f;
        example.x7 = _g;
        example.x8 = _h;
        
        emit ViewInt(_a, _b, _c, _d, _e, _f, _g, _h);
    }
}