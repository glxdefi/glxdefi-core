# glxdefi-core
Core smart contracts of glxdefi
##合约部署顺序
1、GLXFactory
2、GLXRouter(需要factory地址)
3、GLXToken(需要router地址,以及押注的代币)
4、GLXGame(通过GLXFactory合约的createGame创建)

## Install Dependencies
npm install