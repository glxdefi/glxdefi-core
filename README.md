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
- HOPE: 0xCa0F82B639801730c6D5e24E9804C0dFCDc466E5
- DAI:  0x4c20B2272966DC043c0AbFe24505898Fc23ff1d5
- CDAI: 0xba21404D1F3a5F0CABb9581f673f0340044cb0a4
- GLXRouter: 0xbf7c8bB77710d9BE1f532cD18fC0a239c4bE4055
- GLXFactory: 0x59400B58a3E0E3E0520C5432a8D23126e85fE4F7
- Game1（demo押注）: 0x44bC9f34ae09aC96C75e4Fd8da8dA5A86EfE4cc1
- Game2（demo提取收益）: 0x44bC9f34ae09aC96C75e4Fd8da8dA5A86EfE4cc1