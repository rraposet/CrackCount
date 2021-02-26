#!/bin/bash

crack_john() {
        file_to_crack=${i}
        wordlist=${w}

	john --format=NT --wordlist=$wordlist $file_to_crack
}

count_john() {
        file_count=${i}

        john --show --format=NT $file_count | head -n -2 > hash+passJohn.txt
        arrayPass=()
        for i in $(cut -d: -f2,5 hash+passJohn.txt | sort | uniq);
        do
                pass=$(echo $i | cut -d: -f1)

                if [ -z "$pass" ]
                then
                        pass="<blank_password>"
                fi

                hash=$(echo $i | cut -d: -f2,3)
                ocurrencias=$(grep $hash $file_count | wc -l)

                arrayPass+=('Password: '${pass}' Occurrences: '${ocurrencias})
        done

        echo "---------------"
        echo "TOP 5 PASSWORDS"
        echo "---------------"
        printf "%s\n" "${arrayPass[@]}" | sort -t " " -k 4 -g -r | head -5

        rm -rf hash+passJohn.txt
}

crack_hashcat() {
        file_to_crack=${i}
        wordlist=${w}

	hashcat -m 1000 -a 0 $file_to_crack $wordlist --force
}

count_hashcat() {
        file_count=${i}

        hashcat -m 1000 --show $file_count > hash+pass_hashcat.txt
	arrayPass=()
        for i in $(cut -d: -f1,2 hash+pass_hashcat.txt | sort | uniq);
        do
                pass=$(echo $i | cut -d: -f2)

                if [ -z "$pass" ]
                then
                        pass="<blank_password>"
                fi

                hash=$(echo $i | cut -d: -f1)
		ocurrencias=$(grep $hash $file_count | wc -l)

		arrayPass+=('Password: '${pass}' Occurrences: '${ocurrencias})
        done

        echo "---------------"
        echo "TOP 5 PASSWORDS"
        echo "---------------"
        printf "%s\n" "${arrayPass[@]}" | sort -t " " -k 4 -g -r | head -5
	rm -rf pass_hashcat.txt
}

banner() {
cat << "EOF"
   ___               _      ___                  _   
  / __\ __ __ _  ___| | __ / __\___  _   _ _ __ | |_ 
 / / | '__/ _` |/ __| |/ // /  / _ \| | | | '_ \| __|
/ /__| | | (_| | (__|   </ /__| (_) | |_| | | | | |_ 
\____/_|  \__,_|\___|_|\_\____/\___/ \__,_|_| |_|\__|
                                                     

EOF
}

usage() {
        echo "Options avaiables:"
        echo "-j: use the tool john the ripper"
        echo "-t: use the tool hashcat"
        echo "-i: input file with NT hashes"
        echo -e "-w: input wordlist to use in cracking process\n"
        echo "Examples:"
        echo "./crackcount -j -i <hashes.NT> -w <dictionary> # Start a cracking process using john the ripper"
        echo "./crackcount -h -i <hashes.NT> # Counts the number of iterations for each password found by hashcat"
}

OPTERR=0
while getopts "jth :i:w:" o; do
    case "${o}" in
        j) j=true ;;
        t) t=true ;;
        i) i=${OPTARG} ;;
        w) w=${OPTARG} ;;
        h) banner; usage; exit 2 ;;
        ?) echo -e "ERROR! Wrong parameters\n" ; usage; exit 2;;

    esac
done

if [[ ! -z ${j} ]] && [[ ! -z ${i} ]] && [[ -z ${t} ]]; then

        if [[ ! -z ${w} ]]; then
                crack_john ${w} ${i}
        else
                count_john ${i}
        fi

elif [[ ! -z ${t} ]] && [[ ! -z ${i} ]] && [[ -z ${j} ]]; then

        if [[ ! -z ${w} ]]; then
                crack_hashcat ${w} ${i}
        else
                count_hashcat ${i}
        fi
else
        echo -e "ERROR! Wrong parameters\n"
        usage;
fi
