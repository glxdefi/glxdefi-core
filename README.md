# glxdefi-core
Core smart contracts of glxdefi
##合约部署顺序
1、GLXFactory
2、GLXRouter(需要factory地址)
3、GLXToken(需要router地址,以及押注的代币)
4、GLXGame(通过GLXFactory合约的createGame创建)

## Install Dependencies
npm install

## ropsten
- HOPE: 0x07cb0142D9b8fce61a321cffAf2c3a09933B1C37
- DAI:  0xa2Fd9953b79171e32C9895DD7b538c0ccac75628
- CDAI: 0x1D7DC6Ab4B122eF3398E134C15ebD6A3A0771DAd
- GLXRouter: 0xf72211d9142BB681f15C006479060d04e47F698d
- GLXFactory: 0x109f60d6716E798bb198Bc0ce2B2a26cf8855b33
- Game: 0x44bC9f34ae09aC96C75e4Fd8da8dA5A86EfE4cc1