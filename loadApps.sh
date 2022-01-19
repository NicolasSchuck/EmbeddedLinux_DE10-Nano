# !bin/bash/

filePath=$(pwd)

ip_addr="false";
usr="false";

while getopts i:u: flag
do 
	case "${flag}" in
		i) ip_addr=${OPTARG};;
		u) usr=${OPTARG};;
	esac
done

echo "ip_addr: $ip_addr";
echo "usr: $usr";

if [ ! $ip_addr = 'false' ] && [ ! $usr = 'false' ];
then
	scp -r software/ $usr@$ip_addr:/home/$usr/software/
	scp -r Django/ $usr@$ip_addr:/home/$usr/
else
	scp -r software/ socfpga@192.168.0.222:/home/socfpga/software/
	scp -r Django/ socfpga@192.168.0.222:/home/socfpga/
fi
