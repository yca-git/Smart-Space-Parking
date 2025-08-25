// By YCA para bitdoglab - embarcatech 2025
//Conectar no wifi, conecta no broker mqtt através de ip e envia estado da vaga quando ha mudanças
//Usa sensor ultrassonico para verificar estado da vaga, pino trigger no GPIO 16 e echo no GPIO 17

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ultrassonico/ultrassonico.h"
#include "display/display.h"
#include "rede/wifi/include/wifi.h"
#include "rede/mqtt/include/mqtt.h"
#include "library/library.h"

int main() {
    // Inicializa o sensor ultrassônico e o display OLED
    inicializar_ultrassonico();
    inicializa_oled();
    init_wifi(NULL);
    clear_display();
    print_apresentacao();
    
    char mqtt_buffer[100];
    
    // const char *wifi_ssid = "brisa-4299178"; //Coloque aqui o SSID do wifi
    // const char *wifi_pass = "dkjwjo48"; //Coloque aqui a senha do wifi
    
    const char *wifi_ssid = "YCA"; //Coloque aqui o SSID do wifi
    const char *wifi_pass = "00000000"; //Coloque aqui a senha do wifi
    
    // Configurações para o broker laica

    // const char *broker_ip = "192.168.10.3";
    // const char *client_id = "sspVaga01";
    // const char *topic_status = "ha/ssp/vaga/01/status";
    // const char *user_mqtt = "ha";
    // const char *pass_mqtt = "ha.laica.cnat";
    // const char *wifi_ssid = "Laica-IoT";
    // const char *wifi_pass = "Laica321";
    
    //configurações para broker laica dns
    const char *broker_ip = "mqtt.iot.natal.br"; // Broker externo Laica
    const char *client_id = "ssp";
    const char *user_mqtt = "desafio09"; // Coloque aqui o usuário do MQTT
    const char *pass_mqtt = "desafio09.laica"; // Coloque aqui a senha do MQTT
   

    /* Configuraçções para broker yuri*/
    // const char *broker_ip = "179.156.10.22";
    // const char *client_id = "sspVaga01";
    // const char *user_mqtt = "yuri";
    // const char *pass_mqtt = "yurimb01";  
   
    // Configurações para broker publico
    // char mqtt_buffer[100];
    // const char *broker_ip = "test.mosquitto.org"; // Broker público
    // const char *client_id = "sspVaga01";
    // const char *topic_status = "ssp/vaga/01/status";
    // const char *user_mqtt = NULL;  // Sem autenticação para broker público
    // const char *pass_mqtt = NULL;  // Sem autenticação para broker público
    // const char *wifi_ssid = "YCA";
    // const char *wifi_pass = "00000000";
    
    // Tópicos para as 5 vagas
    const char *topics_status[NUM_SENSORES] = {
        "ha/desafio09/yuri.aquino/ssp/vaga01",
        "ha/desafio09/yuri.aquino/ssp/vaga02",
        "ha/desafio09/yuri.aquino/ssp/vaga03",
        "ha/desafio09/yuri.aquino/ssp/vaga04",
        "ha/desafio09/yuri.aquino/ssp/vaga05"
    };

    // Estados de controle
    bool wifi_connected = false;
    bool mqtt_connected = false;
    //bool last_states[NUM_SENSORES] = {false, false, false, false, false}; // Estados anteriores das 5 vagas
    bool last_states[NUM_SENSORES] = {false, false, false}; // Estados anteriores das 3 vagas


    printf("=== INICIANDO SISTEMA SMART PARKING ===\n");

    while (1) {
        // PASSO 1: CONECTAR AO WIFI
        if (!wifi_connected) {
            printf("1️⃣ Conectando ao WiFi '%s'...\n", wifi_ssid);
            print_oled("Conectando", "WiFi...", wifi_ssid);
            
            connect_to_wifi(wifi_ssid, wifi_pass, NULL);
            sleep_ms(5000); // Aumentar de 3000 para 5000
            
            if (is_connected()) {
                printf("✅ WiFi conectado com sucesso!\n");
                wifi_connected = true;
                print_oled("WiFi", "Conectado!", "");
                sleep_ms(2000);
            } else {
                printf("❌ Falha na conexão WiFi. Tentando novamente...\n");
                print_oled("WiFi", "Erro!", "Tentando novamente");
                sleep_ms(10000); // Aumentar de 5000 para 10000
                continue;
            }
        }
        
        // PASSO 2: CONECTAR AO BROKER MQTT
        while (wifi_connected && !mqtt_connected) {
            printf("2️⃣ Conectando ao broker MQTT %s...\n", broker_ip);
            print_oled("Conectando", "MQTT...", broker_ip);
            
            mqtt_setup(client_id, broker_ip, user_mqtt, pass_mqtt, mqtt_buffer);
            printf("Status MQTT: %s\n", mqtt_buffer);
            sleep_ms(15000); 
            
            if (mqtt_is_connected()) {
                printf("✅ MQTT conectado com sucesso!\n");
                mqtt_connected = true;
                print_oled("MQTT", "Conectado!", "Pronto para uso");
                sleep_ms(2000);
            } else {
                printf("❌ Falha na conexão MQTT. Tentando novamente...\n");
                print_oled("MQTT", "Erro!", "Tentando novamente");
                sleep_ms(15000); // Aumentar de 5000 para 15000
                continue; // Tentar novamente a conexão MQTT
            }
        }
        
        // PASSO 3: LEITURA E ENVIO DO STATUS DAS VAGAS
        if (wifi_connected && mqtt_connected) {
            printf("3️⃣ Verificando estado de todas as vagas...\n");
            
            // Verificar o estado de todos os sensores
            verificar_todos_sensores();
            
            // Verificar cada vaga individualmente
            for (int i = 0; i < NUM_SENSORES; i++) {
                bool current_state = estados_vagas[i];
                
                // Se o estado da vaga mudou, envia para o broker
                if (current_state != last_states[i]) {
                    printf("📍 Vaga %d mudou de estado: %s\n", i+1, current_state ? "LIVRE" : "OCUPADA");
                    
                    const char *status_msg = current_state ? "LIVRE" : "OCUPADA";
                    
                    printf("Enviando para broker: tópico='%s', mensagem='%s'\n", topics_status[i], status_msg);
                    
                    // Enviar mensagem MQTT
                    mqtt_comm_publish(topics_status[i], (const uint8_t*)status_msg, strlen(status_msg));
                    printf("Status da vaga %d enviado para o broker!\n", i+1);
                    
                    // Mostrar no display a última mudança
                    char vaga_info[20];
                    snprintf(vaga_info, sizeof(vaga_info), "Vaga %d: %s", i+1, status_msg);
                    print_oled("Status Enviado", vaga_info, "MQTT OK");
                    
                    // Aguardar um pouco após o envio
                    sleep_ms(500);
                    
                    last_states[i] = current_state;
                }
            }
            
            // Mostrar resumo no display e verificar conexões
            static uint32_t last_display_update = 0;
            static uint32_t last_check = 0;
            uint32_t now = to_ms_since_boot(get_absolute_time());
            
            // Atualizar display a cada 10 segundos
            if (now - last_display_update > 10000) {
                int vagas_livres = 0;
                for (int i = 0; i < NUM_SENSORES; i++) {
                    if (estados_vagas[i]) vagas_livres++;
                }
                
                char resumo[20];
                snprintf(resumo, sizeof(resumo), "%d/%d Livres", vagas_livres, NUM_SENSORES);
                print_oled("Smart Parking", resumo, "Sistema Ativo");
                
                last_display_update = now;
            }
            
            // Verificações de conexão com timeouts a cada 60 segundos
            if (now - last_check > 60000) {
                if (!is_connected()) {
                    printf("⚠️ WiFi desconectado!\n");
                    wifi_connected = false;
                    mqtt_connected = false;
                } else if (!mqtt_is_connected()) {
                    printf("⚠️ MQTT desconectado!\n");
                    mqtt_connected = false;
                }
                last_check = now;
            }
        }
        
        sleep_ms(5000); // Aguardar 5 segundos antes da próxima iteração
    }

    return 0;
}
// O codigo aceita endereço de ip e dns 
