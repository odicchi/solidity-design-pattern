pragma solidity ^0.5.16;

contract NonTightVariablePacking {
    
    uint8 x1;
    uint8 x2;
    uint8 x3;
    uint8 x4;
    uint8 x5;
    uint8 x6;
    uint8 x7;
    uint8 x8;
    
    event ViewInt(uint8, uint8, uint8, uint8, uint8, uint8, uint8, uint8);
    
    constructor() public {
        x1 = 1;
        x2 = 2;
        x3 = 3;
        x4 = 4;
        x5 = 5;
        x6 = 6;
        x7 = 7;
        x8 = 8;
    }
    
    function setParameter(uint8 _a, uint8 _b, uint8 _c, uint8 _d, uint8 _e, uint8 _f, uint8 _g, uint8 _h) public {
        x1 = _a;
        x2 = _b;
        x3 = _c;
        x4 = _d;
        x5 = _e;
        x6 = _f;
        x7 = _g;
        x8 = _h;
        emit ViewInt(_a, _b, _c, _d, _e, _f, _g, _h);
    }
}