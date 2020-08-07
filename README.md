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
- HOPE: 0xE0bEA5898d8f1C680bB64F8bc09B95f17bC98f7C
- DAI:  0x4969D629Fa7AAaC886D3326CaD983eaE8CE3E6AC
- CDAI: 0xAc8f813A100f316528c9F6781e081e6f055E26aE
- GLXRouter: 0x3eBD5291F974E943E18c037960b3816cDcDd553b
- GLXFactory: 0x4E8c0faA057Bc6aeDBFd88420D4785e3125CA51B