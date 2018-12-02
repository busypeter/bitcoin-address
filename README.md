# bitcoin-address
A small script that shows (roughly) how a (pre-SegWit) bitcoin address is computed from a private key. Meant only for educational purposes.

The script takes one parameter, which is the "private" key, and outputs the results of different stages of the procedure. The last line includes the Base58 encoded address (see example below).

```
PS C:\temp> .\Get-BitcoinAddress.ps1 "busypeter"
sha256 - 31e8f92e1e022c2652e160a4a4a9fe608034ad6b4b275973e5c61a5e8e98357c
ripemd160(sha256) - f2627fa1a0f562714d131a7a41feb5b72195ad61
with network ID - 00f2627fa1a0f562714d131a7a41feb5b72195ad61
base58 - 14NreVPXi6g6WEZ8qt33ftq8d8eNt
```
