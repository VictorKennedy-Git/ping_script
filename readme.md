# Script de Teste de Ping (IPv4 e IPv6)

## Para que Serve

Este script realiza testes de conectividade (ping) em uma lista de domínios (no arquivo `dominios.txt`) usando IPv4 e IPv6. Ele registra os resultados em dois arquivos de log separados: um para IPv4 e outro para IPv6.

## Como Usar

1. **Crie o arquivo `dominios.txt`** com uma lista de domínios:
   ```
   google.com
   facebook.com
   _gateway
   (linha em branco, para leitura completa do arquivo)
   ```

2. **Torne o script executável**:
   ```bash
   chmod +x script_ping.sh
   ```
3. **Execute o script tempo padrão 1 minuto**:
   ```bash
   ./script_ping.sh
   ```
## Exemplo de Log

```
2024-12-27 12:30:01,google.com,8.8.8.8,32.123 ms,MyWiFi
2024-12-27 12:30:02,facebook.com,2a03:2880:f12f:83:face:b00c::25,15.234 ms,MyWiFi
2024-12-27 12:30:03,example.com,Falha no ping,MyWiFi
```
