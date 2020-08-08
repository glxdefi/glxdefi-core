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
- HOPE: 0x1E75c133bA496Bf24D718555A732538E2D0B7111
- DAI:  0xED60D292438fDE4733e6DfB166A196e9e8443642
- CDAI: 0x374a4c09B5eA23324eE073eb00EFBca346CEc389
- GLXRouter: 0x6E4A62f2ddc3350031A6C1FAbF5E5456C2766955
- GLXFactory: 0x3D78d80Ebddef4bBfEa95211Bb09C628b5f6BfC8
- Game: 0x5913e0c3C1f1Ea0B410a00ef8b40263887BD3650