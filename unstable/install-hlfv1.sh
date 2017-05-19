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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �BY �]Ys⺶����y�����U]u�	�`c�֭�gf0��I:Cg �x�����1HB�����%����Mt�F�`�}	�4MW�&���;���(BSB�����5�y�m���Z��Mb���������}$����nګ���L�U�)#�r�S4AT�/o��6���p��1���J�e���/^|P\.�$�J�e�B�߽��W콣�r�h5���/���M��o���O�+���k���N�
;�����Q���;Y?���{4%�\�w��=�p'�$�6��{+�_�ϙ�4B�����yNٔK�(M�(M�Iظ�E����OS$����Q����O�7�W��
�����?E���q}����s�_5������UNl�jM�>��t��Xk��)R�.4Q�e$ڧ���$X`�+X�\v�&�m�0R�?�D�_7�
�B ��@���c��6�'pG���&zHPt�C��I�@O�<a��t�����24H���֮ޗG�.��P��-Q�j�u��w��XQ^z���S������t����u��r��¨j��|���2���ױ�|p�7�?J��S�O ��/�?/�,�|�6o5�,�M���A&s �5e%����!ǳ�Jܵ���\�'�Y��i�q����k�`jZC�Z��(J~#�D�S�&��p�s�dl�P�S�W�&meq|��!9�G��9����'��6̅;g㣸��B��b�Mn1�z���+1�C�Aɔ�z�ŌF�!�i�A=ާe� v0?�`����#Сs͡��Չ�X,�����^���9�53ϛrw)m-lq�0�U�����L�N�"��$̓��V���Nip�3m�P<Q(tz�S(@d���*.	����c����G�v#f����+6F�T��G~�A�ڀ��,c%�U.܍PޕV�e��(jugJ7u-j6:r����=!98��B���N}���=/���kp+O<��p `�v!r�r�,��t�2	m�&Fv���	��J=2�6H�\�j�D�i��&C.J !P�/k<y:>���D�	t#.b�f)u4������-��ۙr�IҒ�hb�x>��C&�!f�ɱhDsfы��(�e��F�?=3��/��t���?���ۊ���'��Q�S�M�G��?�t��e�-�g9�;�;�ׁzd�5�{���Ǜ�D=q��%���|�!q���^B������
|Hʐ�zGE󫂩�d�i9���2s��I��G�:��2��4]� �l��b�p����Y.&�ne8�5�5�!���Y������|��,�G�̢��A�晘Y��N�]�����{�Х��Soz�.��Ti�LOT�Z�@n��ð�@
Zoi�rf�m qY�����+ d��TɌ�L�@����C� ���o䠛��>�u�^��[��kSR�F�D�����d:��u\6�.��̶��	�4���Q/%�E�l����ņ�熂�`~�n3�'0 ���臙\���p=E�̺9�8�7!����S���w�w�����!�*��|��_s������P��?�=*����+��ϵ~A��;&�r��=B���2�K�������+U�O�����):�I#������8E���!h��Ew�e
���E� W�8�^��O������,��"���+����88�;���p�����Ҏg	}.�@���p����6����̈ɸ!�MS�wL��V-eX��C����c�}��t�Y�̱�1G[+|���i�,�F1�+ٞ�U��G�K��+����R�Y�������e�Z�������j��C��+�*�/�$�G��S���}�?�{���
_
�G(L��6.@s^����`�����F?�5(�>��.to;M�~t��q���G&]���xR�M��5�{&h�G����ޡ��ct�$an�:�9^o�e�����5���@S�(Z��|��t�A��u;�,�=Ѻ��-��٠�H*�{�����Y�i�f�%�S�q�3 ��l(bK Ӑ���3'��ۼ��k�2	]X�7h�y��磅iϞ�P���I`*�e��w{�χf}yX@�I�F�M���^��Ҳ��h�����j"8���cq)e#���K�HȜ'pr�5CZ�?�����W������O��W��T�_
*����+��ϵޭ�]��G�]��(�V�_
.��4�".�������KA���W��������R�m�S�*��\��c��;���`h@��C0���xκ��9�3,���0��(͒$eWQ~�ʐ���H�]�%���?�	�"�^�U��csbkL̶��s�u����ؓ��b�J }'̢N�VjhH�h��D�*�G�	�6v�f씶����#Bݞ���%@<Z���&#���9�d�~?���>���?J<?��#�/��Q������;��#��`�����.����eJ�r��]��R�Q�?H�}��r�\�4�c����g������GQ���[
~��G�������2�%�:w�Y�X�ql�t�b)��(�s	��l<!p�u<�Y�	ǷY���j��4�!���p�8��Z��z\���Et|KD�X�Ř���6�,�3�)��D�l����z@.�j�uw�9��+>��z"�F����L8�u~�zͥ|�G�|F�D��Nc�;����&���k��3[��>�Ϝ�/m���GP��W
~�%���U��^�_�/���/��P&ʐ��J�O㿉�'��2�V�W������?w��Z�����k,a	�0������g��,	��3����#�J���.�j�s���]��� �w�ݰ����s��Mk?lڹe�@��S�����b�?�]h�i���&1]���6�����k��$�/�H�g�����f�N��7o�(6SS��v�N\4Wߛ��
�;g���|�G�-ãe��q�#=�$l��v�$f\h��k ��ݚ�r.k�)ZV�y:E��ڔ�9��r��nw�cC��B�w{�c ����䮷��,����à�bM p"�r65�y{_W\�y����Fw��4N3�Y�<%���?m{�ȡ �<�Jd&��'eM��������Z���"m�JC�y�`���_����+������U��?����?ɭ܀�e��M����O%���K�������� ����ͽdv�
9����,?}�ǽ��O��|�o �my�>��} �Gܖ�^��}�4��r���=8"6v�c�MH�I;T�Dcg6�^�˴F߲���m{���L�؍4�aH���NS�28�PЍDr��8�q�� ��B��<���]j�?6�Y�l�9����F�lޥ7ݤo���<m���Ž������Z�-Xr�\o��������i4l����BE8$ǭ�<{�)>S��t���?B�U�_)�-��Y�G���$|�����=(C�Y�/~���������_��W�����:�b�ð�������ܺ���1*�*�/�W�_��������E=_��~��\���G�4�a(�R�C�,�2��`���h��.��>J8d��T��>B�.�8�W���V(C�o�?;������Rp����Lɖ��eN�6;}�!Bs�m�k��E�ȖڢEM^��c�s:j+� �Jx����^�����8��=ܱr#Jj�9��sG� ?��}K'��@9���C�ި��Q��Ь���Qx�;��|�/�(��������������/�V��U
v~��Z�[�o�oJ�d7u��T��6R\j����o��!�����tl'��W��m�P7q�^#�ȕ��'��3�j7M���_mΕ�jW5	p������U�ﰿq��zU��ON��d����?4Bߊ?�9��wi��o�tR�rk?��V�wS��S��Պ`��ko���yh?:����e�|��y�+�v�`���7���]y�.�E����G��%��}{�S���jcOW~r�����p훻ʠ����p;r���}cX��hluuA�E��!��:7�o�*]���#ק/�.�}���F�+|/d�VQI��d�;j��7Y%az}�(��"׳/7�˃����������7K����4�3�^����o��:b���"}�a���L���m��a����!�����~�����jmz�k����^�ʾ����|�%��rQi�a��?55���t�x��[��F����i���t3�:׹���t{$�{��0�&�u R(B�gJ��O�����g~���Gd~�S7�\=����E������	d��
�8��!�"v�w��@�Uő�}�l��ɦ���וU��v5��ax�xg'p�]�gK�:}8�O����ͧ���{��W�����9����m�jc]'�8\.��s�r(A.��.�/]׽t�H׭�N�m������u��n�i�NLPb��/Ac�&A#�DL����Q�(�@B�Q���m��g;���9.�}nrO����>��Ͽ����1�fPB@�!bWH?K$d,�³���`�^�5��db�K�t$�uk[֎	������������x��}3-�Y�.-`�@��l^���<<��M�9��]L�aG[�UY���o�Ϳ�k�98Q7N���9䖙I��*E7 �G�o0�`5S��#KFl�M�M]�{�*i ����Ǚ���9�%	J��h2��n�B2MѺ�|b\�z��Wَ�~�x7�s�M8ZFL�5���qUfMi�<"�*��@�3�2l����Y#~��y�-��!c�Q��U�.��us�5FSd9�"l4]�!�[4]h�p�N�f��Ԇӣ��oN��8u�#8���i��N�-����e;�~Q�؁�ʝVeQo߃�0�}����Z�1u�c]�t����$�J�8R���[���u�p8��l���)U6^�5�}3��(�tn�~������G�JTx�Sk�Q�!��2ifqt��h>_[��E�/�0�g�����!��a���|�X�.�"��5J��A����5�P�kN����~FhNf�r�_�Ԟk{�z&_G��f���pc�Q��;�<��s�����F�?I���`�cNJ��XȐ���kv���z����{�3��7��;^k���{�}C�����wu�^�]�_��:|����Yޮ��,�:sNN�+zU5�g�f��h�8��\^!�=��h����v�ݪc��?n���g��j��g�y�x%���֞��c?��y���F�n���=� �l{Q��G�ض��� ��l��U�>*`�
�����PN���!8ix����ۯ�q��p=vk5�������v��?z��P`�ҍ'(�gNp�8��	�~' �qq��;7~t\e>s��9�s3׿� Rc�36�O�7���7�9#Y����z7��yx/*r	:���z�Gg��1��<'̞��i~"�{X���;��l�Fa��ް���j3������c��[�6p��gH���"��vz�p�6�, �NY���/���Ur��a���y������>'���h�d����os��[�&�<��tw@?�Q�R��p����O�Y:8�.�cJt��'d�>��5�B(���J���*
.2!�ʞZ=��QB�Qʋr˩jK�	I�����	m���2Ų��z)5��I��^
Qx�K�����O�LX�	k3aWa�BO���!a�}6<�����֦���蚝�R3��=`����nUCLpl-��)و�[�]�d ����D`����2���ׯl�L��ITh�[��@kpGBI1&�w8��H�0�ᐕd�&���)�i�A��#ky�<��{�gd��
��D6ar��[E<��*�uвBP��Z�����/�d����ka(FIs�N��{�]��n&�uz;/rA�f�]���w�w_Y�Ǥ,K6`�Q�-wf3��Y.�};�J�`8�N3����=-���b��"�~%�c�TKlR�B�]l��P��2���6u8e���kE����B�
(��}Lϴ�Ԝ����]�,QՃ�|�>��IB��1�U`�@N�0�ՉD�'o�"���2V�9�NTA��-$�R�H͏�L9�+T�n_,!���B��{�,�E��_�,�������D�X�g(ߪpy�$�~	J hb�N
����m0/�W�<��C�a\�孝\;1���l�����0�h�	��%,&kRl���(� �0)W:S�dNY���.U&�	{�>��m�j�O%U��� K���Z�`	!��&�tчn0�fCRw|D��5U�MHy��P��H6)��2H�=�b���,N�g�}6�g[�g�8�?͉�k
j�ͫ���ڕ������X�b�t�������G�ȡ��>�g:3�g����<[9TUw��l����iC7B׀��^WS�D�g�7?�d������8��J���ɍ;�M�(��浶Z3�jh��TU����u��@�u�8�ɒl�8��fk2�!��^�?�r���m:��9�Y�
���',����A̳R�b���^��zS�Y�fɌOL�L��r��΃Ӹ��}1����ːX1#������8QV��g�� �6#���'���W�V�<r�(���:��:��������`嗂��G&���I(�L���D �
w�<[ٹ��c_x�RGB�-u4gG����`4(Y�y�S�.8Xڳ���� G]pp�*`z�͚2�pO���f"�'�MMpgHmJ�~���6�`V
tQ&���D�?$Zq$B"���$�A�[D�l1�<�ם�d�Nj\�W/����ك�A����h1A��Cx$(��c|�4&�CҸ9d�����p,Q�4L�u{��p������Z�d����4�����t�Jܯ�-e�{���\�z]���a��N��S��l��I!jAu��,`�0Iz�����q��{��kN�8l㰍� ?ֵ�%�ݦ;��L9��h�L��L+�@,���]�֩�C���>���r�a��ߺr������=,�e��H�'��� ��
���R��D�\�L��y�6�@*opdw��A��RT��<X=(��E&1pԠȤU`�n֔e��������l0�Q�JS�N\�Ai�$S8"�S��\�	�(��|��0��J��!�r{:�,w�������RJB�����!{c!����XQ�n�a��v9L���R�oG=;�A)ʓC��D��FP^�˗v���e��>*߯z�TO�r�PF\p�I T?�Ì>�Е-����q��51�%�p��M��r���t;�$��K�����+{X�q����f��~ܳ���2�����+��V
ɭf۸n5�v!��FYM���L[�p�jF��������M�RQyM�5��n ���y-��`}\(.	�~b��5p*��^�qWꕻ��F���q:]a�����z��߾��z�O#���z���~ח^���o����5�j����i6-��~�u��D�{���yl��eI���x��?��A������/@7�~ ~�߼�/>���ȟ�?	}/����āܺv���k�2���ۼ6�NT�@��7⟿�{拍�I7�����˿��o|�I�u
�FA��?MQ;_pBo�R;_���6�Ӧv�4�&`S;�������v@�H��N��iS;m�������C�-/#��!H���@��,a�f��	��k�m�����@=�x�1C'}�~���צ�	/B6��v�l���)���j�l㰍�=��#y��� 3X��kS�l�yZ��;�jϙ�����93�q��q��a����\��9�;w��ڪ��w�<z�d���Z�������d';�o���[o  