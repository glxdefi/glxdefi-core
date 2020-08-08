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
- HOPE: 0x8F50C1F8bf97399566ca81F87808ee843D6F89F2
- DAI:  0x4bd4F73a8614Fb92eF72af852b5BA32a6041d40d
- CDAI: 0x0eb5b91C6cbf5195aa5e08B99Fa799400e920A0f
- GLXRouter: 0xb7c39f881d6C302493144272090305CB595586f2
- GLXFactory: 0xB664cd4ba6D339F74F11143707D7eC2DcDcf0125
- Game: 0x5913e0c3C1f1Ea0B410a00ef8b40263887BD3650