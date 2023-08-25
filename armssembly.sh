#!/bin/bash 
read -p "Enter the url: " url 
wget "${url}"
read -p "Enter the number the challenge gives: " argument 

OUT="chall.o"
read -p "ARMssembly? {nr}: " num 
if [ $num -eq 0 ];  then 
	file="chall.S"
else 
	file="chall_${num}.S"
fi
OUT2="chall${num}_compiled"
while true; do 
	if [ ! -e "$OUT" ] || [ ! -e "${OUT2}" ]; then 
		aarch64-linux-gnu-as -o "${OUT}" "${file}"
		sleep 1 
		aarch64-linux-gnu-gcc "${OUT}" -static -o "${OUT2}"
		echo "[+] Asm was compiled to a binary ^==^"
		break 
	else 
		read -p "[!] A file named ${OUT}/${OUT2} is already present. Do you wish to remove it so we can proceed (y/n): " choice 
		if [ "$choice"=="y"]; then 
			if [ ! -f ${OUT}]; then 
				rm "${OUT2}"
			elif [ ! -f ${OUT2}]; then 
				rm "${OUT2}"
			else 
				rm "${OUT}" "${OUT2}"
			fi 
			continue
       		else 
			echo "[-] Closing the script..."
			exit 1 
			
		fi 
	fi 
done 
echo "[+] Running the binary..."
COM="$(sudo qemu-aarch64-static "${OUT2}" "${argument}" -release)"
RES="${COM##Result: }"
echo "[+] Result is ..."
printf "picoCTF{%x}\n" "${RES}"
rm "${OUT}" "${file}" "${OUT2}"
