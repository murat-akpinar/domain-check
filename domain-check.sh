#!/bin/bash


REQUIRED_PKG="whois"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG | grep --color=always "install ok installed")
echo "Kontrol ediliyor.." $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "Whois yüklü değil değil"
  echo -e "\033[31msudo apt-get --yes install\033[0m" $REQUIRED_PKG
exit

fi

echo "Sorgulamak İstediğiniz Domaini girin..:"
read domain


uzanti=('.com' '.com.tr' )
uzantilar=${#uzanti[@]}


  for (( i=0;i<$uzantilar;i++)); do
      whois ${domain,,}${uzanti[${i}]} | egrep -q '^No match|^NOT FOUND|^Not fo|AVAILABLE|^No Data Fou|has not been regi|No entri|DOMAIN NOT FOUND'
          if [ $? -eq 0 ]; then
              echo -e "\033[32mAlıma Müsait :\033[0m" ${domain,,}${uzanti[${i}]}
              whois ${domain,,}${uzanti[${i}]} | grep 'Expir' | awk -F ':' '{print $2}'
          else
                echo -e "\033[31mAlıma Müsait Değil :\033[0m" ${domain,,}${uzanti[${i}]}
               echo "Bitiş Tarihi.: " && whois ${domain,,}${uzanti[${i}]} | grep 'Expir' | awk -F ':' '{print $2}'
          fi
 done

