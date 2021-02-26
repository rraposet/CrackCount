# CrackCount
This tool has two functionalities:
* Crack: use john the ripper or hashcat to crack NTLM hashes
* Count: indicates the number of repeated passwords previously cracked, useful to analyze passwords policies

The NT hashes file must be the output of secretsdump.py or other tool that has the same estructure:
```
<user>:<pid>:<LM_hash>:<NTLM_hash>:::
```

## Pre-requisites
This tool has been tested in Kali Linux 2020.1, so i you use this OS, you will not need install john the ripper and hashcat.

## Usage
Cracking process using john the ripper

```
./crackcount -j -i <hashes.NT> -w <dictionary>
```

Cracking process using hashcat
```
./crackcount -t -i <hashes.NT> -w <dictionary>
```

Count passwords, from hashes previously cracked with john the ripper
```
./crackcount -j -i <hashes.NT>
```

Count passwords, from hashes previously cracked with hashcat
```
./crackcount -t -i <hashes.NT>
```

![poc](https://raw.githubusercontent.com/mrodriguezsv/CrackCount/main/poc.png?token=AIX2PVY6XOLZW5GOV2CIH5DAHDWDA)
