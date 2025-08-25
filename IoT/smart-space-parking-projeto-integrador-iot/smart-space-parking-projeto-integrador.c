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
    
    // Configurações para broker laica
    
    char mqtt_buffer[100];
    const char *broker_ip = "192.168.10.3";
    const char *client_id = "sspVaga01";
    const char *topic_status = "ha/ssp/vaga/01/status";
    const char *user_mqtt = "ha";
    const char *pass_mqtt = "ha.laica.cnat";
    const char *wifi_ssid = "Laica-IoT";
    const char *wifi_pass = "Laica321";
    

    // Configurações para broker publico
    /*
    char mqtt_buffer[100];
    const char *broker_ip = "test.mosquitto.org";
    const char *client_id = "sspVaga01";
    const char *topic_status = "ha/ssp/vaga/01/status";
    const char *user_mqtt = "";
    const char *pass_mqtt = "";
    const char *wifi_ssid = "YCA";
    const char *wifi_pass = "00000000";
    */

    // Estados de controle
    bool wifi_connected = false;
    bool mqtt_connected = false;
    bool last_state = false;

    printf("=== INICIANDO SISTEMA SMART PARKING ===\n");

    while (1) {
        // PASSO 1: CONECTAR AO WIFI
        if (!wifi_connected) {
            printf("1️⃣ Conectando ao WiFi '%s'...\n", wifi_ssid);
            print_oled("Conectando", "WiFi...", wifi_ssid);
            
            connect_to_wifi(wifi_ssid, wifi_pass, NULL);
            sleep_ms(3000); // Aguarda 3 segundos
            
            if (is_connected()) {
                printf("✅ WiFi conectado com sucesso!\n");
                wifi_connected = true;
                print_oled("WiFi", "Conectado!", "");
                sleep_ms(2000);
            } else {
                printf("❌ Falha na conexão WiFi. Tentando novamente...\n");
                print_oled("WiFi", "Erro!", "Tentando novamente");
                sleep_ms(5000);
                continue;
            }
        }
        
        // PASSO 2: CONECTAR AO BROKER MQTT
        if (wifi_connected && !mqtt_connected) {
            printf("2️⃣ Conectando ao broker MQTT %s...\n", broker_ip);
            
            mqtt_setup("bitdog5", "192.168.10.3", "ha", "ha.laica.cnat", mqtt_buffer);
            printf("Status MQTT: %s\n", mqtt_buffer);
            sleep_ms(10000); // Aguarda 10 segundos
           
            while (!mqtt_is_connected()) {
                printf("Tentando conectar ao MQTT...\n");
                print_oled("Conectando", "MQTT...", broker_ip);
                mqtt_setup(client_id, broker_ip, user_mqtt, pass_mqtt, mqtt_buffer);
            }
            if (mqtt_is_connected()) {
                printf("✅ MQTT conectado com sucesso!\n");
                mqtt_connected = true;
                print_oled("MQTT", "Conectado!", "Pronto para uso");
                sleep_ms(2000);
            } else {
                printf("❌ Falha na conexão MQTT. Tentando novamente...\n");
                print_oled("MQTT", "Erro!", "Tentando novamente");
                sleep_ms(5000);
                continue; // Ignora o restante do loop e tenta novamente
            }
        }
        
        // PASSO 3: LEITURA E ENVIO DO STATUS DA VAGA
        if (wifi_connected && mqtt_connected) {
            bool current_state = verifica_estado();
            
            // Se o estado mudou, envia para o broker
            if (current_state != last_state) {
                printf("3️⃣ Estado da vaga mudou: %s\n", current_state ? "LIVRE" : "OCUPADA");
                
                const char *status_msg = current_state ? "LIVRE" : "OCUPADA";
                
                printf("Enviando para broker: tópico='%s', mensagem='%s'\n", topic_status, status_msg);
                mqtt_comm_publish(topic_status, (const uint8_t*)status_msg, strlen(status_msg));
                
                // Atualiza display
                print_oled(status_msg, "Enviado MQTT", "");
                
                last_state = current_state;
                printf("✅ Status enviado com sucesso!\n");
            }
            
            // Verifica se as conexões ainda estão ativas
            if (!is_connected()) {
                printf("⚠️ WiFi desconectado!\n");
                wifi_connected = false;
                mqtt_connected = false;
            } else if (!mqtt_is_connected()) {
                printf("⚠️ MQTT desconectado!\n");
                mqtt_connected = false;
            }
        }
        
        sleep_ms(1000); // Aguarda 1 segundo
    }

    return 0;
}