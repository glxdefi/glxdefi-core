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
- HOPE: 0x412232CA155d90669317A79BB929dA8B7e86FBb1
- DAI:  0x655366B64875C781bA64056A39Fb02C11aD71a6A
- CDAI: 0xd01B0041f0d8166d41891A1a8ed13C3b3E3Ffa9D
- GLXRouter: 0xD713D714F3350878acE8955Fbaf1F4aA662763A7
- GLXFactory: 0x2f1aeD6b6486534505326937d6b71A6d00483960
- Game1（demo押注）: 0xf85e106dd9f53a7181673d43a53d5e3503833b22
- Game2（demo提取收益）: 