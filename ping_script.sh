#!/bin/bash

tempo_teste=($(zenity --list --text="Tempo Para Teste" --radiolist --column="SELECIONAR"  --column="OPÇÕES" \
  TRUE "60 Seg"\
  FALSE "5 Min"\
  FALSE "15 Min" \
  FALSE "30 Min" \
  FALSE "1 Hr" \
  FALSE "2 Hr" \
  FALSE "4 Hr" \
  FALSE "8 Hr" \
  FALSE "16 Hr" \
  FALSE "24 Hr"\
  FALSE "OUTRO"\
  --height="370"\
  --width="250"
  )
)

case $? in
  0)
    case $tempo_teste in
      5|15|30)
        timeout=$(expr "$tempo_teste" \* 60)
      ;;
      1|2|3|4|8|24)
        timeout=$(expr "$tempo_teste" \* 60 \* 60)
      ;;
      OUTRO)
        $(zenity --error --text="NÃO PROGRAMADO AINDA")
        exit 1
      ;;
    esac
  ;;
  1)
    $(zenity --error --text="OPERAÇÃO CANCELADA")
    exit 1
  ;;
  
  -1)
    $(zenity --error --text="ERRO INESPERADO")
    exit 1
  ;;
esac

# VALIDAÇAO DE COMO O S.O TRAZ O PING
output=$(ping -c 1 google.com)

# Verificando se a palavra "time" ou "tempo" aparece na saída
if [[ "$output" == *"time"* ]]; then
  nome="time"
elif [[ "$output" == *"tempo"* ]]; then
  nome="tempo"
else
  echo "Formato não esperado."
fi


start_time=$(date +%s)

  interface_name=$(arp -n | awk '{print $3"_"$NF}' | tail -n +2)
  data_inicio_arquivo=$(date "+%y-%m-%d-%H:%M")

ping_v4()
{
  arquivo_v4="p_v4_${interface_name}_${data_inicio_arquivo}.log"

  # Obtém a data e hora atual
  data_hora=$(date "+%Y-%m-%d %H:%M:%S")
  ssid=$(nmcli dev wifi | grep "* " | awk '{print $3}')

  for dominio in $(cat dominios.txt); do

  # Executa o ping e captura o resultado
  resultado_v4=$(ping -c 1 $dominio -4 2>&1 | grep "$nome=") 
  ip=$(echo "$resultado_v4" | head -n 1 | grep -oP '\(\K[^\)]+' || echo "$dominio")

  # Extrai os valores de icmp_seq, ttl e time do resultado
  if [ -n "$resultado_v4" ]; then
    icmp_seq=$(echo $resultado_v4 | awk -F'icmp_seq=' '{print $2}' | awk '{print $1}')
    ttl=$(echo $resultado_v4 | awk -F'ttl=' '{print $2}' | awk '{print $1}')
    tempo=$(echo $resultado_v4 | awk -F"$nome=" '{print $2}' | awk '{print $1}')

    
    # Salva o resultado formatado no arquivo de log
    echo "$data_hora,$dominio,$ip,$tempo,$ssid" >> "$arquivo_v4"
  else
    echo "$data_hora,$dominio,$ip,Falha no ping,$ssid" >> "$arquivo_v4"
  fi
  done
}

ping_v6()
{ 
  arquivo_v6="p_v6_${interface_name}_${data_inicio_arquivo}.log"

  # Obtém a data e hora atual
  data_hora=$(date "+%Y-%m-%d %H:%M:%S")
  ssid=$(nmcli dev wifi | grep "* " | awk '{print $3}')

  for dominio in $(cat dominios.txt); do
      
      # Verifica se o valor não é um IP (IPv4 ou IPv6)
      if [[ ! "$dominio" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && [[ ! "$dominio" =~ ^[0-9a-fA-F:]+$ ]]; then
          # Executa o ping e captura o resultado
          resultado_v6=$(ping -c 1 $dominio -6 2>&1 | grep "$nome=")
          
      fi

    ip=$(echo "$resultado_v6" | head -n 1 | grep -oP '\(\K[^\)]+' || echo "$dominio")

    # Extrai os valores de icmp_seq, ttl e time do resultado
    if [ -n "$resultado_v6" ]; then
      icmp_seq=$(echo $resultado_v6 | awk -F'icmp_seq=' '{print $2}' | awk '{print $1}')
      ttl=$(echo $resultado_v6 | awk -F'ttl=' '{print $2}' | awk '{print $1}')
      tempo=$(echo $resultado_v6 | awk -F"$nome=" '{print $2}' | awk '{print $1}')

      # Salva o resultado formatado no arquivo de log
      echo "$data_hora,$dominio,$ip,$tempo,$ssid" >> "$arquivo_v6"
    else
      echo "$data_hora,$dominio,$ip,Falha no ping,$ssid" >> "$arquivo_v6"
    fi
  done
}

#Gera loop conforme tempo especificado
while true; 
do
  ping_v4
  ping_v6
  
  sleep 1
    # Calcula o tempo passado
    current_time=$(date +%s)
    elapsed_time=$(($current_time - $start_time))

    if [[ $elapsed_time -ge $timeout ]]; then
        echo "Timeout atingido! O loop foi interrompido."
        break
    fi
done