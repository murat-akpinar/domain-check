#!/bin/bash

echo "Sorgulamak İstediğiniz Domaini girin..:"
read domain


uzanti=('.com' '.com.tr' '.net' '.org' '.info' '.name' '.me' '.pro' '.tv' '.cc' ) # Daha fazla uzantı ekleyebilirsiniz
uzantilar=${#uzanti[@]}


  for (( i=0;i<$uzantilar;i++)); do
      whois ${domain,,}${uzanti[${i}]} | egrep -q '^No match|^NOT FOUND|^Not fo|AVAILABLE|^No Data Fou|has not been regi|No entri|DOMAIN NOT FOUND'
          if [ $? -eq 0 ]; then
              echo "${domain,,}${uzanti[${i}]} : Alıma Müsait"
              whois ${domain,,}${uzanti[${i}]} | grep 'Expir' | awk -F ':' '{print $2}'
          else
                echo "${domain,,}${uzanti[${i}]} : Alıma Müsait Değil"
               echo "Bitiş Tarihi.: " && whois ${domain,,}${uzanti[${i}]} | grep 'Expir' | awk -F ':' '{print $2}'
          fi
 done
