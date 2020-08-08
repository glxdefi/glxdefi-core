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
- HOPE: 0xB860A43073F1DC10F73cAEc99e3136FC44DF22dc
- DAI:  0x4c20B2272966DC043c0AbFe24505898Fc23ff1d5
- CDAI: 0xba21404D1F3a5F0CABb9581f673f0340044cb0a4
- GLXRouter: 0xC8FD0C54B577e1FbAEd0fd40626D190723Ba8553
- GLXFactory: 0x2D0544EA634377d2ED5b4Dfa8f6F90647538C51E
- Game1（demo押注）: 0x44bC9f34ae09aC96C75e4Fd8da8dA5A86EfE4cc1
- Game2（demo提取收益）: 0x44bC9f34ae09aC96C75e4Fd8da8dA5A86EfE4cc1