#!/bin/bash 

entradas(){
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
    --width="250"))

  case $? in
    0)
      case $tempo_teste in
        60)
          timeout=$tempo_teste
        ;;
        5|15|30)
          timeout=$(expr "$tempo_teste" \* 60)
        ;;
        1|2|3|4|8|24)
          timeout=$(expr "$tempo_teste" \* 60 \* 60)
        ;;
        OUTRO)
          tempofuncao(){
              valor=$(zenity --forms --add-entry="Valor tempo" --add-combo="Tipo" --combo-values="Horas|Minutos|Segundos")    
              case $? in
                  0)
                      data=($(echo $valor | tr "|" " "))
                      if [[ ! ${data[0]} =~ ^[0-9]+$ ]]; then
                          repeat=$(zenity --question --icon-name=dialog-error --text="Informações incorretas\n<b>\nDeseja continuar?</b>")
                              case $? in
                                  0)
                                      data=()
                                      tempofuncao
                                  ;;
                                  1)
                                      zenity --info --text="Cancelado Execução"
                                      sleep 4
                                      exit 1
                                  ;;
                                  -1)
                                      zenity --info --text="Erro inesperado"
                                  ;;
                              esac
                          exit 1
                      fi
                  ;;
                  1)
                      zenity --info --text="Cancelado"
                      exit 1
                  ;;
                  -1)
                      validador="Erro"
                  ;;
              esac    
              if [[ $validador -eq 0 ]] && [[ ${#data[@]} -eq 2 ]]; then  
                  zenity --info --text="Preenchido Corretamente"
              elif [[ $valioador -eq 1 ]]; then
                  zenity --info --text="Cancelado Execução"
              else
                  while [[ ${#data[@]} -lt 2 ]]; do
                      
                      valor=$(zenity --forms --text="Por favor preencha os campos" --add-entry="Valor tempo" --add-combo="Tipo" --combo-values="Horas|Minutos|Segundos")
                  
                      case $? in
                          0)
                              data=($(echo $valor | tr "|" " "))
                              if [[ ! ${data[0]} =~ ^[0-9]+$ ]]; then
                                  repeat=$(zenity --question --icon-name=dialog-error --text="Informações incorretas\n<b>\nDeseja continuar?</b>")
                                      case $? in
                                          0)
                                              data=()
                                              tempofuncao
                                          ;;
                                          1)
                                              zenity --info --text="Cancelado Execução"
                                              sleep 4
                                              exit 1
                                          ;;
                                          -1)
                                              zenity --info --text="Erro inesperado"
                                          ;;
                                      esac
                                  exit 1
                              fi
                          ;;
                          1)
                              zenity --info --text="Cancelado"
                              exit 1
                          ;;
                          -1)
                              zenity --info --text="Erro inesperado"
                          ;;
                      esac
                  done
              fi    
          }

          tempofuncao

          case ${data[1]} in
              "Horas")
                  timeout=$(expr ${data[0]} \* 60 \* 60)
              ;;
              "Minutos")
                  timeout=$(expr ${data[0]} \* 60)
              ;;
              "Segundos")
                  timeout=$(expr ${data[0]})
            ;;
            esac
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

  dominios=$(zenity --list \
      --title="Escolha os Domínios"\
      --text="Selecione uma ou mais opções:"\
      --checklist\
      --height="480"\
      --width="300"\
      --column="Selecionado"\
      --column="Domínios"\
          TRUE "youtube.com" \
          TRUE "facebook.com" \
          TRUE "google.com" \
          FALSE "_gateway" \
          FALSE "177.37.220.17" \
          FALSE "177.37.220.18" \
          FALSE "twitter.com" \
          FALSE "instagram.com" \
          FALSE "linkedin.com" \
          FALSE "wikipedia.org" \
          FALSE "amazon.com" \
          FALSE "yahoo.com" \
          FALSE "reddit.com" \
          FALSE "github.com" \
          FALSE "bing.com" \
          FALSE "microsoft.com")
  
  case $? in
      0)
          case "$tempo_teste" in
              60)
                  t="60 Segundos"
              ;;
              5)
                  t="5 Minutos"
              ;;
              15)
                  t="15 Minutos"
              ;;
              30)
                  t="30 Minutos"
              ;;
              1)
                  t="1 Hora"
              ;;
              2)
                  t="2 Horas"
              ;;
              4) 
                  t="4 Horas"
              ;;
              8)
                  t="8 Horas"
              ;;
              16)
                  t="16 Horas"
              ;;
              24)
                  t="24 Horas"
              ;;
              OUTRO)
                  t=$(echo ${data[@]})
              ;;
          esac

          $(zenity --info --text="Os dados informados foram:\n<b>Domínios:</b>\n$(echo "$dominios" | tr "|" "\n")\n\n<b>Tempo</b>\n$t")
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
}

# VALIDAÇAO DE COMO O S.O TRAZ O PING
output=$(ping -c 1 "_gateway" | head -n 2)

# Verificando se a palavra "time" ou "tempo" aparece na saída
if [[ "$output" == *"time"* ]]; then
  nome="time="

elif [[ "$output" == *"tempo"* ]]; then
  nome="tempo="

else
  echo "Formato não esperado."
fi

ping_v4(){
  arquivo_v4="p_v4_${interface_name}_${data_inicio_arquivo}.log"

  # Obtém a data e hora atual
  data_hora=$(date "+%Y-%m-%d %H:%M:%S")
  ssid=$(nmcli dev wifi | grep "* " | awk '{print $3}')

  for dominio in $(echo $dominios | tr "|" "\n"); do

  # Executa o ping e captura o resultado
  resultado_v4=$(ping -c 1 $dominio -4 2>&1 | grep "$nome*") 
  ip=$(echo "$resultado_v4" | head -n 1 | grep -oP '\(\K[^\)]+' || echo "$dominio")

  # Extrai os valores de icmp_seq, ttl e time do resultado
  if [ -n "$resultado_v4" ]; then
    icmp_seq=$(echo $resultado_v4 | awk -F'icmp_seq=' '{print $2}' | awk '{print $1}')
    ttl=$(echo $resultado_v4 | awk -F'ttl=' '{print $2}' | awk '{print $1}')
    tempo=$(echo $resultado_v4 | awk -F"$nome" '{print $2}' | awk '{print $1}')

    
    # Salva o resultado formatado no arquivo de log
    echo "$data_hora,$dominio,$ip,$tempo,$ssid" >> "$arquivo_v4"
  else
    echo "$data_hora,$dominio,$ip,Falha no ping,$ssid" >> "$arquivo_v4"
  fi
  done
}

ping_v6(){ 
  arquivo_v6="p_v6_${interface_name}_${data_inicio_arquivo}.log"

  # Obtém a data e hora atual
  data_hora=$(date "+%Y-%m-%d %H:%M:%S")
  ssid=$(nmcli dev wifi | grep "* " | awk '{print $3}')

  for dominio in $(echo $dominios | tr "|" "\n"); do
      
      # Verifica se o valor não é um IP (IPv4 ou IPv6)
      if [[ "$dominio" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
          # Executa o ping e captura o resultado
          resultado_v6=$(ping -c 1 $dominio -6 2>&1 | grep "$nome" )
      else
          resultado_v6=$(ping -c 1 $dominio -6 2>&1 | grep "$nome" )

      fi

    ip=$(echo "$resultado_v6" | head -n 1 | grep -oP '\(\K[^\)]+' || echo "$dominio")

    # Extrai os valores de icmp_seq, ttl e time do resultado
    if [ -n "$resultado_v6" ]; then
      icmp_seq=$(echo $resultado_v6 | awk -F'icmp_seq=' '{print $2}' | awk '{print $1}')
      ttl=$(echo $resultado_v6 | awk -F'ttl=' '{print $2}' | awk '{print $1}')
      tempo=$(echo $resultado_v6 | awk -F"$nome" '{print $2}' | awk '{print $1}')

      # Salva o resultado formatado no arquivo de log
      echo "$data_hora,$dominio,$ip,$tempo,$ssid" >> "$arquivo_v6"
    else
      echo "$data_hora,$dominio,$ip,Falha no ping,$ssid" >> "$arquivo_v6"
    fi
  done
}

entradas

start_time=$(date +%s)

  interface_name=$(arp -n | awk '{print $3"_"$NF}' | tail -n +2)
  data_inicio_arquivo=$(date "+%y-%m-%d-%H:%M")

#Gera loop conforme tempo especificado

(
while true; 
do
  ping_v4
  ping_v6
  
  sleep 1
    # Calcula o tempo passado
    current_time=$(date +%s)
    elapsed_time=$(($current_time - $start_time))

    # Atualiza o progresso no Zenity
    percent=$(( (elapsed_time * 100) / $timeout ))
    echo $percent
    
    txtprogress=$(echo "Finalizado")

    if [[ $elapsed_time -ge $timeout ]]; then
        zenity --info --text="Arquivos Disponíveis"
        break
    fi
done 

) | zenity --progress --title="Progresso" --text="Aguardando..." --percentage=0 --time-remaining --auto-close --auto-kill

