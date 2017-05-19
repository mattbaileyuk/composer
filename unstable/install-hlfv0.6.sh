(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �BY �[o�0�yx�� �21�BJ��EI`�
��ɹ�l�w��2HHXW��4�?�\���9>��ؾ�E�n�n����s�ʻ)�N��ū6���$��(��ӂmH�bK� �?�"q��JD���u���SDB�{2�6�!"	�P(_ �"wE}$�� �5�H�]����5"�"تg�Oםe�U��NC�%=���D��D �A�
�[2��R�L|�E^t����ڢ����=�S&�Ut#�TF��5=[�DK�I _�9@��)ZȢ���Md61ok2[3o��M��J�SMY�E[�M���ܘC�ǵ��1M�`6M�n��'Y��$�=�N�s#��� u:�&å�,�;Pn�ÒϏ]�����h��
�X��L�Y�荷�U��F�J����b?�I����uE(���ŝ�諦���}��ڷ8X����6��n�ta�u�B� �?�e��m�!�t@�;��2��O>S��9M���/A=p�ݚ��g���5��2�������bK�?Ϧ:�b:�e�i� ���	���{�"z�̈��V圂j6��-x��3]D�G���F�Ep�>��w�Ā�tH�n/���p?sѹE����OR���]tȳ�8d�"ȦY��'�gq�}��5�M�&�Ew�I�'`��9v �(�q�ūR�T����w_L8M�aA���ߢ�('yμ=_��I̛
n�.N�5&��n���:��_�8>���U���p8���p8���p8���p�&?���& (  