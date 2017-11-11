ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

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

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.15.1
docker tag hyperledger/composer-playground:0.15.1 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

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

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �]Z �=�r�z�Mr����S�T.���X���f`��rv�a	$n�%�G��f�\@�ѩ<©��5������o�{�Hػ櫲A�_����uS3�2���
t4�o���ׂ����~���
�3s�O��>�#a�Ĩ?��h�?�=�?ˆ& �lvUk6ޢ�_)t�i�����[c!��*��a �9a����/݆���s���0�f�m��i�~��5����E��m�$��mn��!�m�4�wU���H�H����aI.�'��lf��2 �8�F�U�Y���v<}��F6�Ab�����Ŀ�����qO`4�!S��U��S 馡i�a%���&��JIN�+�!ڦ�(�6,P�d�:�\ܙ���\O��⹡#�ƝvduUC�;X�����a�T�yͯ!K1Վ��7�a M�.��Q�q��.?����P+نI�CM����8Nh<x5<�*Ԭ���md8d�#7�0k��Sn����!-������B� ��펆Hvb���v׳'ŜV(�"�:j�4�T��dS�̡��s��y���eKq��7m��ۯ����N�_X�D�sJ��]7cmP�tO�k���J��7̄:7�����&���|[��O�;w�P|Kl莦���Q�ftd��Eϕ�CG�Nti#S���,?��=\�s��8PC� 9��<�{Dȋ��Y�����E��'�Q�)��S��FX�2z�{���u��g�?�e~>�� �D"��a-����!TU�PZM�2SA��|
����&�1���	��w^:���[��5����@�W��B����'�W���a��'k��g]���z������)���FC�BK�m�[�ab	Q���\�����*`���n���;Pi�
^X�~/uP��0����0����Y��+bt�nNj@�Y�Y.��n�iid�M��m ҳ6�a�u��&�b�j�e��cˌWo�T��(��m�A4�D8_��?�-���^~C��
ᜦS%F��T�m�$��(�B�n��9�p��T��[«��a�M��=��F�,�*pY���4��j�Z���#��ʺ�l��[uT����T��5�6��A�� �N�I��x�(��)�Az銊|4	&���H0�ij�q��Y|PZ��,<�^N|"gP�R{�5s�>�@�c��4-E��˪��?��ǈ��b|4�qD��9q������)��:�݄6h���^&j]�0]W���)l1�B�mt�>c>2�����F��X �����["M�X���.`Y��%!��=)M���>B�jo���C��	��^�OJ������x��_{xf�E��A����lJ��kҋ�a�^�^r@�&1�1���шi���~[̸[n�*��ǰK ��c�hw����!3Ou�x�L;�����X�*`b�֧��_=<}ӟC�%���Z`rG�i!�{��_�vw����"�쑆����4�ؠ�T�&0�d^�q�Z�O��? �و�z����,��}�x��:Pu2l��?c��%f� UnR��+k��gt9������˗#ĉ���n׼�Y����Хj{�Ȃ
S3t�>��V�r���to�_w��b1@X��������)�4��Tǂ��gτ��������+'�FvW:s��F3E�#Ҙih,C�݌	����&!�7,�f�Ie�����0�l鼔,f�ʻ��	y�8�O�+z����G��a��ʁ+,䦥D1�<?����a����Hj�d�1�Z��-d��2��In� ƿ$��`���T� �B�ib�D�����E�&���T,���9��R����4�y<�����F�J���"�hw�o�@���M���x�lN�x�O`�D��{0�H�l9���ǒ8�Ӯ"��~��R)�IY�':١c^��I���5�v8όb'�Fa�g��a3�M΋�]�4X$����	������U���T���7X�w���DVqu�A��j�nm�傼� �q���_�}`���AӾOp����ܤ���%p��y�b�����D�@ �w��z	9&<d�;��Z��0e�OL��q����?���+���OU��f���0��u�����n;��\
Xd�!�}\���y�>�W�_��ᆎ�pӲ2M�|:��۞C�݆z�
2D�.9�M|]4�|sL�H����/=��_曉��l'�dKMǦ�?J���X�H�շl�$�sO+��Ef��&��s�nŃ@}"�\�wΘ�[!	�>��f(P#AR6b��m0��O�{��[�X�Z��]�	�э�Џ��ht�b�s+c�;x��Lv���N��5�>���F(XA��"�on��/s)d��&�#q}�c%���J�+�5W��9^���^
i��_q��Z�����8PoƓk�;� �A.(,�W����w�R����:Gi֪cE��m��2�B����E&�!���V�׿�����Z��`1)-7���rŚ��C�CXp����ht����>kb�Ge¯�Qo>��0;�7 {-H��GL��f�'^|湢���h�sn�_q| �/�����*��*C{ur�=*�z�Z���h`��#rC'p=��j*�	9�4�t��ӛ{F�UfH��3�P��͚���	yF7��IR�H�_�6���qy�T� �#�@�p!�V�*����য়�|��@�nw��:�z����}��f��^��GR>�a�`�n����e�Ϝx�Qxϖx�L>2VF`_���{�bʋOM}�c����9�=�1V����x�&����w����X����Yo���k�\3x�樘=�����|�{C�G�cD������	u�
Ұ��d7���JV��4?��Č�p�-���V9�V�ێp���8�+Bu[����bt�9%"p
�c0^�cơ ��s��$�by%\[jC'keR�d;�M�F� >l��7@�����.����Ѳ5�a%}Ji���Q�:�W.8# ���F���PM�f��M�|
�Wtk��L�$�Lp��i�¢Rx�t��[�@2�R��WJ	+x�F�W5����1a~�z���^����nm���_L �?���������/�h�Ea"�/#k�%��Wc��E[m4m������+F�b�)2L1����w��?-(l���(Y�� �e4�������J`���0V��xCB?NE��(F�������7���/�eI|��nav�<�*�t�l W8�aĕ����1h�6����1��v�6C%�����J��%ε>���Y����F>G��&�H�qgdm�+��b�a�k�����]��O	���������=<�y�G���=��Eu����'�&���(��W��}˜3�����}�?�����W��O�??��"UN�p|���
/�a�Z��x<Z�Ɖ�"�GBT�W�A�B\���jl[W�Eq�?�e��-3IxC���o�NG#�,�l0�1I���G�o2L��-ôU�����lN�Q�����Ɵ�'���|�͈�2��&=k�7��`�7���q����ʫim���c��7�?N�hc��0������{�]������������j��h)�M���;�c��[��_	|�t,��UC�ᴡ�1��ez��:�T�>���ܛ?m2���|d��K�Y���}����W��}d}NhL<@ !g�y@�S�t6)�e��N�e���E2))Ɇ��&�F�(�C�8��_%2}�ML5�V�%��}�,{u����\�����H|EN4s���ܥ|%��1&UN���jFkW#�x"_�/�����S�8OMd��J;휆�����e�,�q1�����Ϯd��M�Y}���J�E5�]�$����r8�|���b���J>WVz��l8W�r��l���]�4n��N?�HTs��,������{}\���9�q�u�Dn�N[�䬫���iY>�%
n�/s�wz%�v��Y��D��o��+��KpC��N
'E���=W5�I�J�R;h��r��d"�I�?dJ9!.5�L2�}��{��g{�2Q�3��R9wltc�7���ɅhGS�N��׉=��urӊ��)ܗ�ӰVRU1;��uz��|)��r��b�L���Fo��\N�$�涖�ɉP�@�x���r������Tߖ�I�%-ҪZ�Wh��R6�6ϠKd�w�Y<h���:m�������hN���,wr�1l���5��\IfI��/D��I��Z>E�6���'�PS?{KeET�O*��x7Y5����5������6����\<���o�s{G�S�I!��򕢴�N�S^Χ�,���:
�~>0�Ɓ��h���������x�n�P�x>J�<?c0��Mð��-����'��������n�V4���Ȥ�'���:�s%������/����L.���g�4�Nd�$2T���l�� �o���ڪF3g��1W�ߠ|�DӺZ:����~A;M,r%%�hv�V��/vr��U&cϯ��vR3�WQ�1#�*�BQ�i���pFm$�'z�0��a��"�R���+s�����K>f�'�͆}�^�r`Y�/H��u,X���|�Cŵ����'1˪I̲Z����,�#1˪H̲����,�1˪G̲���r�LӍ���ѯ<��.�e��M�O\���Ϧ�9����5<�2����OX���J���U٤_�K�zr�tϓ�Ra(㥤��*4$�z��NU`9�:wy�pB�^7:�y���t�%#�)��q���x�0$������l�n��Q�?���%���r����_����s��o>a��nE���-�c��������?1[��������4.>����NH��$�ED�E-�<!Q�G�7��g��/��"s�~��a��������f�bA �P]�U1k�IT��ZhC6�UY/j�F�>xr�,��!?-~��	=��� y�#� Hm��;�_K��nB�-u�BG���rGzT�f�h*�j�}E��=7���o���a��/�{s��'򠽷��$��A��������A'o������=}�~E'�,�=
�I�����aUs��B�$�M���O!�N�3���=��vL:�� �0�7�A�<`Ճ:}L���[F����^��ѥ�ѡ�&@A@ӄ}R!I�|٦�,L[�g�(�O�����?{O�:����04�aw�����.���y3=�%v��}�ڱ�8���t¡U��'N�N�d��【vّ@Z�\7ܐ�WX�eB�q��7�U�8����y���h�%媯����\����$T����{[G���L���� s?��'��|BZ`ly�~Т?
��A��c�6T�� �Gx,HA��loz(�A�A�<S]�!���6W��c��`f؟���o>��ؕ���|�?�'O�_.%?y�%/7������!n����	��h0h�h$�H���>?!��5A�6W��;#퐴�^��i�2}�.��$�a�%w>ܩ�W֥Өv2\V��
�z��)d��Upy �:;�$��%嫻.>ޝ|������m

��'qE	�4	�jpE�B�h��c�Ąxt�K�¿�Pu/꼯컭bH�����~H�d�1gP�-�|�F�
@#Ě�|�}��ūƙ�Ɗ� 4��<p�4֟Yn�$����0����_�m�`ń��Fv��1(��hf�B�P�3r��<0�UR6���n&3�;д��!���\�Ս{9P�C��8�~=���3C��e�r�G��v�E��܍�~H&��5�@�V����<�_�LO����;�,�[��{8�6(�V�z�E�Bms�)"<|jzG#���Z�k^�o�CS�PC[�p�+�����J�c��?R4�����!������i�~������/S�G��kD��>����7����#�C�R��(bI����o�|����"���{8Ĩ�|��D*��+*��D\I��*��K���8�US�TL��d����j2�P4��L�V��K��#�#�~�����?��̧���O�d�T?K���O"ߏߍE~+�����׷(��_���ۻ.XD�����.���[�����Y������"�x��iϿ9�a������Ց^�Jru�ɴl��-�I��s�j��`xV���sƮ��1q۳c���wE��6���g�|OdM�|y!J���+2jމ-*+��:�Ϻ �-ݲzPF�Eq�[1%�p�#1Ʊ$6D�w�&�΄���(��G�@lt�<��y���Zc\ȣʤGW�bc��\�_�p��Eyt��)G.�f:k��)h�G���Y���]��İNS��e�C�@X���H)����w��#�w&���+��M�Pm&_-�ۍ��P&�|�2oR��\-4Z)X19 ����9f#Vc��(����
#���#�ď�t
�G?�speɭ�rt��b&�L������m��-^+�6?��sp>"���30�y]81���x�L���\�l0��[NϢF��f;��D�Xd3Fru��[��6I�,��uVG噖
'F��L�y�ٲLa�a�9%U�pz$LT�'�}1sl5�W����޵���SɗN%���Jد�6�y�M�J-�49�v���O$��e�VT�R�ƌFn���v蟈�YS�Bl+�Ŋ@�狨��έU�t��TO�)��{�E7&o�~_����Zj6�5
��,�`��A���m=�mK���Ҙ�3�.�CEVh�OJ�~N����J�[ �m8����L)ڜ8&�'�����gQ?���rL6D��W櫓*m�b0g+��!���s�R�Sf��D�J3>�M��(�ԒN�b[��w�ZV_&�v)C%�9�9)��9gT�CZ�գc=�궪�^�Pb}��~n4ϤF�\\؍ߏ���ˑw"{��࿯�t�ut{׳����ߛ���߬EpC���[^,�z�G�bMC�-#F���Jd���w�^��w^� ]�`��yG"{p,�F^���f���E��N�_�N��"?���?���?����������?�V��WP�)`��;3�J������§')�߻����u~�c������|�s�`�x'�XK.�6V���/���X�a�E�����'�{[��l˗�U$|�
�L���H������Ȳ�ǯ�u�Y��+*_L�R�T逛���Y�Ȧj���HɎ�Ju�N�@�j]�h�K1�����I���ce����(_�taR:6��C�HLՕ2��Z_"p9V���;�1��=�J�Ũ�ô�pZ]gs,���Hg���3�~� w|�N۠`�C	�Xr�|���3\1GĆ��*E�cyFg�u9��dJ�F�c*&�'���
--���uk4l9=!�(W�I̪s}*:`�� a������J�hO�ft�҃�U���o\�49d(ˁ�\����Y��g�UK������Kd_������9�dnT�����M�p�βr�/+�pY1LX&�e\P���e�݉������Ϙ�7<h��rۘ�7S�D�rU��������=׀Q+��N��f��.W��j�=��zk��W�!� �FY��Nc��R���.ԘqFϝ��
�jv�+��v�p��5�y�PΉ���r���`2Z{���V�%-_\�5�?;H��G�N�iͶ΅c-W(�Tulԅ#��Q�$SS�c�Tl��2�K���D�����yW䋋FC��qR"S(��\Q�4���7�jX�Q1Z�Փf���?~&��/�削��r�H��|T��O��L��lY��x�*qd��*�)0�"Y�}�� n�#�L��n��ʄX��W* _�|e�@漯P��;��
�Y����Qnr`��f�'j�#�=�S�N�����tfޭ7��W҄�mv*�$k��J�h���A!n�2��NdV�)�(�U(��Qv(�t�ܑ��l�|�r�J5��S�J�h��<8S�E��C��Җ�
K�z3�RZ���ˋ�T��LWbNN��3	�N���<�o��ފ�i.:�ɎȦv}��Q.a,�n���6��Q�b��.�����oB�~�.�j䍰�4����m�k��ƍ���{�-�P-{���b�=���_&~��ckfIˉy3��efPe��ؽAS_���"��o>}��z��S2��M�\Gr�E�y�x�^G������0���+n�/�ф��J����"��Xc̈́�#d�������y<��k��G��)F�����ׂ��8��LU�R�H2r�x��}
�㈎����D��G������|nq�������\���X*~!�O���<�{����E��������z������~_�q�7<��(�vUR�Yr +�sxXdy�a
,r�`��8\��%"r�]S��i�n����Y��96aN�dl�=f�O�I�ow]�>���!����s�*��
�K6ے��w{���c��&[/���ǠWϑ3 骘��8��oP-pjBOo�8л"��t�9��ƥ�'��P�9B����B���� �)�� �OUܨ�y�L����}Wѻ �-4�~��΀ς��1	-Fr�S^a/\ŻtB��MZsf(�X�:M
9vy�t����ŗ<�}��� ���հo�	{��<�\�xH~��%�#=�	�0� ���=����|c�SW�>ҰS�\5�	vV�s}j����͆�>\��!х2ub��!?��z�@�Ja�'�O}�V,���`��y�����	�����TJf0�P6��\I�Ay'�̠ɸ��H�k!�l��T��	0Ɇ	!����b���r9�|��B�c��� �ՍQ�`��Ҹ70������}/�hcP�u�7�x��
�0ϯ!�$SӲp�~�'8m�l��(>�G�益���Қcϣu�7���H����K �s�{��A|�g��ؼ�pj&�D1��N��9I�V�׀��5��9���J�	��|��c���)��0,i�+YS����k��n��k)�<P�����I���q�D��*�R�߾�^ƾ��{�t��Ѿ�>������n�^n���w�ʽ愇�e/��p�.�mc��#�剅,F�t�n�&�1R���Q['�rH��&t���쬱=5k��z���ch�30	�^�064
X���6�3;}4�� �����
��7���Nȱpo��<��u�.m�dW~��~eTe81��:,��W�:0ഔ��{�q^�g��l����j��B[��7	<��_�)J�`C��q��Dؿ�#�D��
�&o�ư�fk|�]#$I�䑇�#�'���٩9D��;�S�uH�}�	k ;Ĭ^*+�R��C��U�⼁c�޴M����4E����a6��ג"|9�3��!����;,$	\��x/���t"rn1��n�+��0Vmǜ=��i)?wḥBz�ŨR�/F���v���b��z�Q�?ϼ�w1�ٵ}\s�?�������i������RF��"��Z%;r.��RAEr�3�<��<�*�^x�����r�9�eFzU�^t'8�&w4l�c���Ub�`���j���B����Z/K�{eGG|���4��~<��i �d:K� W��~*����>��� ���giE���l
$�)�2c�!��ܾ�2l�i�p���Z�������/��� �n�ݛ�bǂsa�峁��@N%�,˱D&�V�B�j�Y @*�Ȫ�X&�Q�@VP
!���d�DZ�@
�1�C���v��N��7�C�m�������?�@����KOy�ޓ�EŰ�����wT��c�7c�j����|�o0��r�P���cE�g��Մ��W�k������b��F�6���K�*�o�_Su7{�;��\X�bR9�,6k�8�=v]m����P�o�x_�@����*hw&jN�f�}��5�E5��dLK�j�i� ;�2��;�%�d�k��3n��i�;�!�b������ �M�Wl�\N����=Wm���B�pZ������"#TrUn]��	�g[�ͪ��)_�jU�"=����a4E���s0�Ngc϶zd���D��B��r�(\��K�������UsG�i�ڔr�J^(�Vx�]m�pv�}6:_���t�u�ɋ�`���Hŋ<�0�zx� �6%�Z���a�&�8g�z���~���9֛���GP5W��d6�x��m	�(*y�aߙ|���^����"�|�8��eL��&M}q�����{���Ķ�������8&��
~��+�D+���`p�V[��#	$�|�ح��zW�Ķ��ZqDk"�!�8���(�.���Fё���NѨ������_��d9ql���oND��܈�B!ZMn�C�$���Tf���G'�{*��$Xg�n����y����hR�x�i�E��/����~G�<���;�O�&8������9��i8�����n��I��F�����,�߳6� (�������H���������>P���\(�m��@������{�����Gp�p���4e�
X�?���/�H�J�ő�_��IL��D#��,EF����8�CI�0�ER�0!�	L �b�QL���/��O���?�S���!�w����^�\L*�t�����_�7�DeЛl���)#���Lg�ŝ����۟�Zժn�IW��0����31��awOs(��5��]*g����Us�6ǳ]2��:`H)>��t�N7Յ���Ͽ���������y�|��)�u����'�O
��G��&����@��?�,��y �����7�?N��Q�d��vj��|i ������p�������(��D���_:�s�-����(��?���D���[�'K�7�O�P�GX�	�:aU�o���!`���;������Ї�4@�������� �#F��% ����n�?)��E������˿�?�fО�b��/�R#�Y�Pn�?ϥ����~���]G?���~^#��������'��Ϣ�?nf�������Ob��?V4q>�*��l��e��N��j�{\^���MfR�ܞ}m��q.��Mg�mT�1=�j�����!�w�����������'�3s�u?_l�LOt��{���.	���5�c�>�ƫ�d�ٲ?��TO�Yuџ����+'����Ε���w�dêYj���'�Q-�>�����ϻr}%ʇM����|�3�M��	gb��̭�iI,���K��a@R � ������������\�P�������� ����	�����������A�� �/Kh�/�m���?~6����?
`���	��O�?����W��{��?����t�P�sy�Ӧ�,��_����-����Ǹ�)�/���d�?�����N��*�8��F��������m�;���p	��jb�l1M��6R��J���H
J=K���6���m��]�!C����m��CXO�3��eK.�z�q&@�d�0C���:����Q�'���o-㻗?�u��l�)�8ӄ�Hb�0k�yzk�x5�έ��SlF��u�������ޑ��I���2/'�zҠb�2�I=y��X��=v���W`���;�����y|���.��@�����ϼ�,<�A�	p��hPB8�($y*�D.`E��$)�ɘ�@C1��y!�� $��9Fb2&aG�������?�J�������1U֝j�j�D�����,7KY�0��1�Y�m��'�G#wu`��C�O�Γt�R7{J�ԉ����c�9���t�b� �	Z�%z�i�V���ul�	�����{4����o�?������|U�R����_y������4`������%,�������!�+�2��ێ�ۛz�&B�{�;����筝�f�797�����Oo1|[�I��
�}������u�9W�Ĥp�PU�K���d�}Xk��[9-
�1�Wz�pY�Ev��.�&[���[���OC��$`p���_��O|o����_��`��`��?������,X�?A��I�^��������'a�*��~9ZG��S�8����f�����������f�EmM?��xx�; ����� ���p&�U��u	��; d�0Y�ݾ)W+�|͘�����so7!:�ZU1��Ѫ�f��u��9�+���s$�QE��h;�XH�E�9��d��,�H<玾&O/�����z�� �_S
K��;%�k�E|��ڴ/7�I҉��a�h�H��]3V�K"1D�����l��,5y�@p���T��JYx#��ԴJ(��_��4ʖ>0Is��Ԫb�o�C�2�%M��h��5?�n�&��[r��b���v�2��ȗk���5���Tux����v"�=h�����;�������>tx���Z������x�?P ���;���G$��~�����?'��� ����?������O���$������� HV$�ȏ(:fCҗ|��yV�R�Ř���gh:��b���;?8��w�9�?H�+��v����M�/�^�&�4�Y=jv�N��=�Ů.~��u�Z0�$z��gvf�WF�#�ۆx�]b�d��&]�Q�����^O����B��	��7�~��ZÝ*�^��k�̲��o�?�����$�|��Z<��*?��G���i��� ���������-S�x�����e�?M���`���|��P����g��i�(����������}{5�+����O두���¹��ϥ�k���������H���1�#���R6��E1t���r��J����~���yT�>?�=k�n{�����ymJ����X��Á���'cߔ͚�i�Y�'x�BmW02+�ty��O��0g��Ҳd�N\k�ڣ���l���vne������D캭ya.������n�H��[)�����o�������lf:<���6�cV��7��ӕW4���հ_��U#q9�_/��)Z����׍��K�V���Ie%�����u[62��.j���4����
�����Á�/���%-�C#8n�!�����������������P���y�/_d���m���C��< ���!����������( ��������[n����7	�>���g�?Z�����O��@��8�?M���?�����~�?\e���|����e�d�s����_:�Sw�?@�#��%���t������$����5P����?0����� ����[�p|X�?�&�������ɐ����X�?w�����?��� ��{��? �?���?����A������D@�������Ҁ��9j`���`��	������ʍ���?�D�_�&��_ ������l���a�;`�����8����_���������?,�uG�Q��P �7�OY����� �����Á������8�?E]�`@�L�PR��R<	�@%�fb��x1�����O��/����ϲ���>�.p��� �/	�����1�D@�g�����޸D��E�J�,�kn�q�4�VK1�iUJ�Oxmy@��(����Ⱘiqx�Ί�O����rwwP3�ow7V~���P9إ�XW�8!���r�܉�-b�?h��4Q��U����tL��\���SKk��x+�tm��B��U��p�����<�|�����
������?��|޿.a`�o���_y���_'d,�X�۽�VY�"��&�ژu�s�~�?kT瘟䍾��^<�ݽ���U�]�ѻ�Ԉ��^s&�)I���o$�:֌m�?�+��[?OǛc]�v���i3��$c{m��u�:gC��V�q�����/"`p���_��O|o����_��`��`��?������,X�˗�^�����5��~��������z��Cuǯܑ����8�?\�ղ_����U�i��xuj���@�-̦���7��Z�si˳nc�	�A�D��aj4�(�恪��!Ov3vh��Ĝ�3�|Υ��l���~Þ�n��ۙU_ĭ�&O��������k��ӯ)��\>;%�k��_'�d�xuX�M�r��$�خ���9�5c�LQ$�Q�qۙ����vX �-�Q��p�[I��'�
F��I�����a@,���7q�{�Ro�=SN�;�j%���AE�|�W"I��ɦ1�*�~�̫�Ն����Y���zŻ�W���xc��&����h��"�g����o<���
�p��(���'�#�g�ݠ�[�8�����H����i�������(���}=��?�����^��.��C�^���=U���7��>,��j�
{���V4��Wگ���i������/�����q�.�V� ޻�ê)?�{?�S~ķ��S��Sͷ�_�.}KI�S��k�򚹼���ۖ{rOI§L��|˺Z�R\���q���T7��_���p�b�ԥ�^'�]��ɐ��	��+��/d��UN�[��/���`ZggqH	�<ݭ)����c�V|H�=d���s9wq9�BI���gY�;�i?��{���F�R>��8��*B�5�m���lW��n�*��y�6�2��c�툹�Z�ދ,sb7dM��T����*a�����דG#�ؑK�]�\L��Jb$Jگ�J����_�����9��^��ũ�y�Pr�ڢ���y�g`�����?��"�'���D�Xڗ&LH���Y>�&$K�4?���H�>�B2$ʏɐ�`����C����������_㓉����I�E@��ƃ���g��y�gL"z�)�S���\�^��+W���o�g����w��k����%0���H����?����_�����?$x-��:_��������v/K��2<ٺ���$����=�����=5������&؈��������]S�r#K�?����y��񶼟ä��p�3Uk{^�mӉk3���;<�������4�q��.Ɏ��Ӑ��e�٦^�G��3q2<���f������#ޛ�{N�w�~~��{W��&�e��+4nGGO��,b�:���mb��M @BRE���T�N[r9�re�a[�X�;��{�;ml�EM�R�&T$w����X��ך��lub��~?֞��Uw*���m6c�S�\M;q�bb�����jiH#�kK��=,�U�8G�ȵ^���D^�IT�[��e�Z���~�A�����7���S
���N��8V2����it��bt�PUJ���R��5Z�e�"��%x�R�οWD�����J��o��^?��O��O���H)�Cw�*�L_7���X5�h�;мV�����.[Ղ��l���������������4����k����Ki��JR�3<�����Y�?�e����l�A�AZ����?�U������o�������q��ެ���h�k�M������_�?x?��a����C��y�;���Xݴ����q��#�աPjUg��R8���c{�������e�x)4/#Wȏ]]F��ǩ+�����Z�H\����'���y��p��N�E���Me�mv��w���s���n�����<}rWU��M=�G�ͼ�S����]�)��r���,=�m��ܰ�������?�-���q�%��"�e���Т\��%eS��������m����L��F[yl�R�ue�5�w����RvmZ���|��k��p��������d��F��[B���Y�5�C�,�$c��lY`XCs�Q(*��c8F���_پ�O#��5�7����4�M��?������_���i�?$�������?�S�B�'�B�'����{����� r	���[���a�?;���`�3�"����W��* �7��7��w�����g���,_C������?���+�w��L	���U�?�9�?���#��SAV���f}� ���������?`����%��/D� ��Ϝ������i '��!-��>��x	��� ���_�B�a7���#d���(${@���/�_�����������쐋����!��H�� ��� �0��/m�����������9���������b����T ��� ���������IY��6!�?c@���/�O�����T�����������3��C�?���/r��0�2B��o����u����������%�*���RB.�_�	�1��,(E��C/T�B�f(�T�t�)�FҚa�%^C�:V����ԇ��_y��}�C�:x�w��8�
av���k
l�kI�q+Zd%����O�#��IX�$}��Iӧ�N�z%������6�P�A0�J�\����x��&��Öct�q��FE��mG� ��ʡC�����E���(�W��`M��I�k�BH�'͝���k�y�(7:��
�zu�S�wuRY_�!�?�f����p��y@����C���C�����8��*�/����e���q��"����t�aH�4�QE��I�6����3�P\�����5��hw�����nۊ�>n(�!1q���T��Ӯ�4t�0F����J��vY�8ʂXI��6�@9�<�/E>����f�,�My��_������/���P��_P��_���/��Ѐ"�����_	��������:��_�m�������ؖn�����g?]�}:�*'rs	������_v�!�{�XLf��۟�(�:�yx�Y��;Q��:�"S�ä85�Iq���@NE׫Ē���nS�Ķ�V^I�)�j9h�.%4�j�۶X�����ɭ��.��`$�o��s� r=��X��8�7�%���>j�Ṉ@�b��#�/��z���j��y���X�-�8{:�����xO���ި
թ��~�l�36j��aV����������A�<"�ΘT�݁���&aJ�vP�~���|ϑ��S���^��� �=r�4�����������B���#��ܨ�b���@j������	���?k�'�+�O1�Ȕ��"��/����?s��o��@�O*Ȝ��M����G ��g������My�p�Li����?��O@�G �G����E.�~���_*�\������������!3��a��L�������Š�#|����(��?䰼���r�c[`�SzahW��0��-{O��X��V ?V��z��H~�3�I����i�]j;���K���^��w����y�^�z]]\��
�%'�Ƣ��۝&��Z��`ݹݰ4��7�����9�ecr�nĺi�^}���"?Z�{)�En��*�p����6;2�"?.2L�H�ñ:�5a����6��u��=Տ��TR�5�l�86ԧ��vx~kb�����jiH#�kK��=,�U�8G�ȵ^���D^�IT�[��e�Z�O�A.���g���߳I�������[���a�?3��?B/@��E������T �_���_���m�O��OF�\�}�<�Kq������_.���3B��������E�����[�����?��o'n�f���v���6�����͟>�E�y�h�M�m��K���  O��XP�[��?�d�i(��(�UECiƭ��}�3h�ʬMl�*S�����-�գ:�V�4�PB�u��@[Vd�9��^�$E � I� ����Q���Ic]�*���p��W����%ک#�-3��%����c���T6mi0��B�)v��ݥ�ZQ@�*MUc��ڑj9�|��ȅ��o���_� s��q��}����y��~��������d�d4���hJ������4��aV�����`�Ai���z��������+#�k�O��O?s��!3g6���l�1'd,a�!�V��?��~�n�D}V���?�ţ;%���,j��~d������z�H+J�,�,)J{�_��S�&��Ө[�$��:���a�,��.��S����C����!��?�*�p��C��_v��C�OfȜ��&����/�]"��_v���7٭'�RT�R�CREW�2Yrmg�n�b���P��찷���?R��pKx�W%͝C�Q>�	�x�q ��)V3j���c�9�JM߫�aGR5�a�>�]��w�D��������G���E%����G������"�_P����꿠�꿠��_��?��A�E�@�e�o�I��L���kZ�GO�}�@�"����-�\�t����S���?V�\&x^P\��NYt�U�^���X7��=8�w���,QW�x,�*�
-i�y�	�4=��CkS�ԋ��q��fC�Z���b{���K�[�>�yH��8��j�'��=��܈f���(�$�7���Y/��*�q���5G�\��p��˂̫��n)�,MI�*�EH���>��G�����Yͧ��fS��\��n�I/"_rr��R�~���=I㙱tr,gI׉{\��c�n$��}���<�W�V	���'{�1&�ڨ���b4#�xiV��r����r��Uw�z�^�f��12���?A�%
�?��sSw
��WB���q��yc�pT61�<�"��e�/J����mwRE�ۅ�dw�<�5�^�����Y*H��vPx��BorkW[>>_����5Y��{�-�q��eW��Ǉ��pxx�S��0~b��r�pY��$�/�+����㚇�������N�I�/%��##��O�/T�TUA�VvXp��a�AX�}���Y�|�	�z��1�YH���w�>�NUu-^�Fv�i����k���s�ML'��${�|E-��^�v����[�~���������?
ڢ���x�⛷�q��a��y�����M������-�O�^�ǯ����7�v���o����E8�+�3��G?���Y�_������Wx�H�>R��j�~�v�t�/L�/�_�B�߮x3�єx��q��A!�b��w�c;faӛ����`�N/|Nȃ!�~�-�3���Z�_rvU���5�-���ֶ�#�Z׽�����L���D��s��A�
���؃��� �q�e��v��;�p�?�_Fa1AI���F�PC�O���H>9غk;_;���?;�����]����+��A��EYzl�")`�	i��.��޼��,��}�~y�O�`�?<�w�F            �s��#ӑ � 