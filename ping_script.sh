#!/bin/bash

# Variáveis

arquivo_v4="ping_teste_v4.log"
arquivo_v6="ping_teste_v6.log"

# Loop de ping v4
while true; do
  # Obtém a data e hora atual
  data_hora=$(date "+%Y-%m-%d %H:%M:%S")
  ssid=$(nmcli dev wifi | grep "* " | awk '{print $3}')


  for dominio in $(cat dominios.txt); do

  # Executa o ping e captura o resultado
  resultado_v4=$(ping -c 1 $dominio -4 2>&1 | grep "tempo=") 
  
  ip=$(echo "$resultado_v4" | head -n 1 | grep -oP '\(\K[^\)]+' || echo "$dominio")

  # Extrai os valores de icmp_seq, ttl e time do resultado
  if [ -n "$resultado_v4" ]; then
    icmp_seq=$(echo $resultado_v4 | awk -F'icmp_seq=' '{print $2}' | awk '{print $1}')
    ttl=$(echo $resultado_v4 | awk -F'ttl=' '{print $2}' | awk '{print $1}')
    tempo=$(echo $resultado_v4 | awk -F'tempo=' '{print $2}' | awk '{print $1}')

    
    # Salva o resultado formatado no arquivo de log
    echo "$data_hora,$dominio,$ip,$tempo,$ssid" >> $arquivo_v4
  else
    echo "$data_hora,$dominio,$ip,Falha no ping,$ssid" >> $arquivo_v4
  fi
  done
  # Aguardar alguns segundos antes do próximo ping
  
  sleep 1
  
  # Obtém a data e hora atual
  data_hora=$(date "+%Y-%m-%d %H:%M:%S")
  ssid=$(nmcli dev wifi | grep "* " | awk '{print $3}')

  for dominio in $(cat dominios.txt); do
      
    # Verifica se o valor não é um IP (IPv4 ou IPv6)
    if [[ ! "$dominio" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && [[ ! "$dominio" =~ ^[0-9a-fA-F:]+$ ]]; then
        # Executa o ping e captura o resultado
        resultado_v6=$(ping -c 1 $dominio -6 2>&1 | grep "tempo=")
        
    fi

  ip=$(echo "$resultado_v6" | head -n 1 | grep -oP '\(\K[^\)]+' || echo "$dominio")

  # Extrai os valores de icmp_seq, ttl e time do resultado
  if [ -n "$resultado_v6" ]; then
    icmp_seq=$(echo $resultado_v6 | awk -F'icmp_seq=' '{print $2}' | awk '{print $1}')
    ttl=$(echo $resultado_v6 | awk -F'ttl=' '{print $2}' | awk '{print $1}')
    tempo=$(echo $resultado_v6 | awk -F'tempo=' '{print $2}' | awk '{print $1}')

    # Salva o resultado formatado no arquivo de log
    echo "$data_hora,$dominio,$ip,$tempo,$ssid" >> $arquivo_v6
  else
    echo "$data_hora,$dominio,$ip,Falha no ping,$ssid" >> $arquivo_v6
  fi
done
  sleep 5
done
