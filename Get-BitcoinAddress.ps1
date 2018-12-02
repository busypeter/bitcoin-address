param([string] $pubKey)

function toBase58([byte[]] $inputByteArray)
{
    $base = 58
    $code_string = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

    $zeroes = -1
    do
    {
        $zeroes++
    } while ($inputByteArray[$zeroes] -eq 0)

    [array]::Reverse($inputByteArray) # [bigint] expects little endian.

    $x = [bigint] $inputByteArray

    $outputStringBuilder = New-Object System.Text.StringBuilder

    while ($x -gt 0)
    {
        $r = [bigint]::Remainder($x, $base)
        $x = [bigint]::Divide($x, $base)

        [void] $outputStringBuilder.Append($code_string[$r])
    }

    $outputByteArray = [System.Text.Encoding]::UTF8.GetBytes($outputStringBuilder.ToString())

    [array]::Reverse($outputByteArray)

    $code_string[0].ToString() * $zeroes + [System.Text.Encoding]::UTF8.GetString($outputByteArray)
}

$sha256 = [System.Security.Cryptography.HashAlgorithm]::Create("SHA256")
$ripemd160 = [System.Security.Cryptography.HashAlgorithm]::Create("RIPEMD160")
    
## Standard BTC address
$uncompressedKeyPrefix = [System.Byte[]] 4 # From bitcoin source code: #define SECP256K1_TAG_PUBKEY_UNCOMPRESSED 0x04
$networkID = [System.Byte[]] 0 # From bitcoin source code: base58Prefixes[PUBKEY_ADDRESS] = std::vector<unsigned char>(1,0);

$sbSha256 = New-Object System.Text.StringBuilder
$sbRipemd160 = New-Object System.Text.StringBuilder
$sbFinal = New-Object System.Text.StringBuilder
    
$byteArray = $uncompressedKeyPrefix + [System.Text.Encoding]::UTF8.GetBytes($pubKey)
$byteArray = $sha256.ComputeHash($byteArray)
$byteArray | %{[Void]$sbSha256.Append($_.ToString("x2"))}
"sha256 - " + $sbSha256.ToString()

$byteArray = $ripemd160.ComputeHash($byteArray)
$byteArray | %{[Void]$sbRipemd160.Append($_.ToString("x2"))}
"ripemd160(sha256) - " + $sbRipemd160.ToString()

$byteArray = $networkID + $byteArray
$byteArray | %{[Void]$sbFinal.Append($_.ToString("x2"))}
"with network ID - " + $sbFinal

"base58 - " + (toBase58($byteArray))
