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
- HOPE: 0xC2242d5135b8bF97079AD9A198358F9c3361f6f1
- DAI:  0x21717B701dec71178fb0dad4886bfE319E935823
- CDAI: 0x55b9F1f0c30d5E5c35E45d0F418a1d89bE9557D8
- GLXRouter: 0x64E1FbDE3a56d49C766e4F8Bb6f638f60b0aD91C
- GLXFactory: 0x213f526876932CE71CE264d242977b0076E93eE4
- Game1（demo押注）: 0x4f25a03e1d54eeab15cbffc058a60b797253f789
- Game2（demo提取收益）: 0xaf1534cbD8571bE3b9Fa440A68a7E59CeFF2bde7