#include <stdio.h>
#include <stdlib.h>
#include "ultrassonico/ultrassonico.h"
#include "display/display.h"
#include "rede/wifi/include/wifi.h"
#include "library/library.h"

int main() {
    // Inicializa o sensor ultrassônico e o display OLED
    inicializar_ultrassonico();
    inicializa_oled();
    init_wifi(NULL); // Inicializa o Wi-Fi (pode ser necessário passar um buffer de texto)
    clear_display();
    print_apresentacao();
    
    bool last_state = !verifica_estado(); // Inicializa o estado da vaga como diferente do atual
    bool wifi_display_updated = false; // Controla se o display foi atualizado para o status WiFi

    while (1) {

        // Verifica o estado da vaga a cada segundo
        bool current_state = verifica_estado();
        
        // DEBUG: Verifica status WiFi detalhado
        printf("--- Debug WiFi ---\n");
        wifi_status_debug();
        
        // Gerencia conexão WiFi e reconexão automática
        if(!is_connected()) {
            printf("WiFi desconectado. Tentando reconectar...\n");
            
            // Atualiza display para mostrar WiFi desconectado
            if(wifi_display_updated) {
                print_oled(current_state ? "Livre" : "Ocupada", "WiFi Desconectado", "Tentando reconectar...");
                wifi_display_updated = false;
            }
            
            connect_to_wifi("YCA", "00000000", NULL);
        }
        else {
            printf("WiFi está conectado\n");
        }
        
        // Se o estado da vaga mudou, atualiza o display
        if (current_state != last_state) {
            if(is_connected()) {
                print_oled(current_state ? "Livre" : "Ocupada", "WiFi Conectado", "");
            } else {
                print_oled(current_state ? "Livre" : "Ocupada", "WiFi Desconectado", "");
            }
            last_state = current_state; // Atualiza o estado anterior
            wifi_display_updated = true;
        }
        // Se o WiFi conectou mas o display não foi atualizado
        else if(is_connected() && !wifi_display_updated) {
            print_oled(last_state ? "Livre" : "Ocupada", "WiFi Conectado", "");
            wifi_display_updated = true;
        }
        
        sleep_ms(1000); // Aguarda 1 segundo antes da próxima verificação

    }


    return 0;
}