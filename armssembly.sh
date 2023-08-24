#!/bin/bash

read -p "Enter the url: " url
wget "${url}"
read -p "Enter the number the challenge gives: " argument

OUT="chall.o"
read -p "ARMssembly? {nr}: " num
if [ $num -eq 0 ]; 
then
	file="chall.S"
else
	file="chall_${num}.S"
fi

while true; do
	    if [ ! -e "$OUT" ]; then
		    OUT2="chall${num}_compiled"
		    aarch64-linux-gnu-as -o "${OUT}" "${file}"
		    sleep 1
		    aarch64-linux-gnu-gcc "${OUT}" -static -o "${OUT2}"
		    echo "[+] Asm was compiled to a binary ^==^"
		    break
	    else
                    read -p "[!] A file named ${OUT} is already present. Do you wish to remove it so we can proceed (y/n): " choice
	            if [ "$choice" == "y" ]; then
			rm "${OUT}"
			continue
		    else
			echo "[-] Closing the script..."
			exit 1	
		        fi														        fi
done

															echo "[+] Running the binary..."
COM="$(sudo qemu-aarch64-static "${OUT2}" "${argument}" -release)"
RES="${COM##Result: }"
echo "[+] Result is ..."
printf "%x\n" "${RES}"
