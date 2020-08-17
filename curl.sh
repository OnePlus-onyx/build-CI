filename="B2G.tar.zst"

file_id="1WO40RS1dkMgncexmJg81aMZsVv40UKx2"

query=`curl -c ./cookie.txt -s -L "https://drive.google.com/uc?export=download&id=${file_id}" \
| perl -nE'say/uc-download-link.*? href="(.*?)\">/' \
| sed -e 's/amp;//g' | sed -n 2p`

url="https://drive.google.com$query"

curl -b ./cookie.txt -L -o ${filename} $url
