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
- HOPE: 0x4e34A41A5B4Ec89C0eDeC4ca1a4d2f9d28c756e5
- DAI:  0x0062B12cE40f1CfF829aA7c3759872Bad65176e5
- CDAI: 0x0b98F0ef48D8027d3a0a7d7e41a46F27B7e2AF1f
- GLXRouter: 0xE7744Fb425408a6eFB4642839B86391b66753a00
- GLXFactory: 0x51560f4D00e06F0A9a55bFC1f967d07B9B03d5e8
- Game: 0x8E18a23e59aa42e9485754F78D39698A1E9df716