## Uso do Script

### Pré-requisitos
- **zenity**: Para a interface gráfica que permite a interação com o usuário. 🎨
- **nmcli**: Para obter o nome da rede Wi-Fi (SSID) atual. 📶
- **ping**: Para realizar os testes de conectividade com os domínios selecionados. 🌐

Certifique-se de que esses pacotes estão instalados no seu sistema antes de executar o script.

### Execução

1. **Baixe o script** e torne-o executável:
   ```bash
   chmod +x nome_do_script.sh
   ```

2. **Execute o script** no terminal:
   ```bash
   ./ping_script.sh
   ```

3. **Escolher o tempo do teste:**
   O script exibe uma janela gráfica onde você pode escolher o tempo para o teste, entre as opções:
   - 60 segundos ⏱️
   - 5, 15, 30 minutos 🕒
   - 1, 2, 4, 8, 16, 24 horas 🕙
   - "Outro" para personalizar o tempo.

4. **Escolher os domínios para monitoramento:**
   O script apresentará uma lista de domínios (como youtube.com, google.com, facebook.com) para o qual você pode realizar o teste de conectividade. Você pode selecionar um ou mais domínios. Caso não queira usar os domínios padrões, pode adicionar novos.

5. **Monitoramento de Conexão:**
   O script irá realizar pings para os domínios selecionados durante o tempo determinado. Os resultados de cada ping, incluindo:
   - **IP** do domínio (ou o próprio nome do domínio, se o IP não for resolvido), 🌍
   - **Tempo de resposta** (em milissegundos), ⚡
   - **ICMP sequence** (icmp_seq), 🔢
   - **TTL** (time-to-live), ⏳
   - **SSID** da rede Wi-Fi utilizada. 📶

   Esses dados são salvos em arquivos de log, com um formato baseado na data e hora.

6. **Progresso e Status:**
   O script exibe uma barra de progresso através do Zenity, informando o tempo restante até a conclusão do teste. Quando o tempo definido for alcançado, o script finaliza o monitoramento. ⏳

7. **Conclusão:**
   Ao fim do processo, o script mostra uma mensagem informando que os arquivos de log estão disponíveis, com o progresso indicado na interface gráfica. Os logs serão salvos com os nomes `p_v4_...` para IPv4 e `p_v6_...` para IPv6. 📂

### Exemplo de Log
Cada entrada no log conterá as informações formatadas da seguinte maneira:
```
data_hora,dominio,ip,tempo,ssid
2025-01-06 12:34:56,youtube.com,142.250.183.174,12.345ms,Minha_Rede_WiFi
2025-01-06 12:34:57,google.com,172.217.4.206,9.876ms,Minha_Rede_WiFi
```

### Observações

- **Falha no ping**: Se o ping para um domínio falhar, o log será registrado como "Falha no ping" ao invés de um tempo de resposta. 🚫
- **Tempo Personalizado**: A opção "Outro" ainda não está implementada para tempo personalizado, mas a estrutura do script está preparada para isso. 🔧
- O script irá gerar os logs conforme a conectividade com os domínios escolhidos em ambos os protocolos (IPv4 e IPv6). 🌍

### Futuras Implementações

- [ ] **Monitoramento de Velocidade**: Adicionar funcionalidade para medir a velocidade de download/upload durante os testes. 🚀
- [ ] **Exportação de Logs (CSV/JSON)**: Permitir salvar os logs em formatos CSV ou JSON. 📊
- [ ] **Alertas de Conectividade**: Implementar notificações para falhas repetidas de ping ou tempos de resposta elevados. ⚠️
- [ ] **Agendamento de Testes**: Integrar com `cron` para agendar testes automáticos. 📅
- [ ] **Detecção e Teste de Redes Wi-Fi**: Detectar redes Wi-Fi disponíveis e permitir escolher em qual rede realizar os testes. 📡
- [ ] **Relatórios Gráficos**: Gerar gráficos visuais de desempenho durante os testes. 📈
- [ ] **Suporte a Outros Protocolos**: Adicionar suporte para testar conectividade via HTTP(S), TCP, etc. 🌐
- [ ] **Detecção Automática de IPv6**: Detectar e realizar testes automáticos para IPv6, se disponível. 🌍
- [ ] **Integração com Cloud**: Permitir o upload automático dos logs para serviços de nuvem (Google Drive, Dropbox, etc.). ☁️
- [ ] **Interface Web Remota**: Criar interface web para controlar o script remotamente. 🌐
- [ ] **Logs de Diagnóstico e Debug**: Adicionar logs detalhados de diagnóstico para ajudar a resolver problemas. 🔍
- [ ] **Logs Separados por Domínio**: Armazenar logs separados por domínio para facilitar a análise. 🗂️
- [ ] **Verificação de DNS**: Realizar teste de resolução de DNS antes de iniciar os pings e registrar falhas. 🌐
- [ ] **Melhorias na Interface de Usuário**: Melhorar a interface gráfica com mais opções e layout intuitivo. 🎨