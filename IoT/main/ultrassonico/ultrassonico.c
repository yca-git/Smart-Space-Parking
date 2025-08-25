#include "ultrassonico.h"

bool estado_da_vaga;  // Variável para armazenar o estado da vaga
int distancia_minima = 30; // Distância mínima em cm para considerar a vaga livre
// Função para inicializar o sensor ultrassônico
void inicializar_ultrassonico() {
    gpio_init(TRIGGER_PIN);
    gpio_set_dir(TRIGGER_PIN, GPIO_OUT);
    gpio_put(TRIGGER_PIN, 0);

    gpio_init(ECHO_PIN);
    gpio_set_dir(ECHO_PIN, GPIO_IN);
    

}


// Função para medir a distância em centímetros
float obter_distancia() {
    
    printf("2.Obtendo distância...\n");

    // Enviar um pulso de 10us para ativar o sensor
    gpio_put(TRIGGER_PIN, 1);
    sleep_us(10);
    gpio_put(TRIGGER_PIN, 0);

    printf("3.pulso enviado...\n");

    absolute_time_t start_wait = get_absolute_time(); // Inicia a contagem do tempo de espera

    // Esperar o sinal HIGH no pino ECHO (com timeout)
    while (gpio_get(ECHO_PIN) == 0) {
        if (absolute_time_diff_us(start_wait, get_absolute_time()) > TIMEOUT_US) {
            printf("4.pulso não recebido...\n");

            return -1.0f;  // Retorna -1 indicando erro (nenhum retorno)
            
        }
    }

    // Medir o tempo do pulso HIGH
    absolute_time_t start = get_absolute_time();
    while (gpio_get(ECHO_PIN) == 1) {
        if (absolute_time_diff_us(start, get_absolute_time()) > TIMEOUT_US) {
            printf("4.pulso muito longo...\n");

            return -1.0f;  // Retorna -1 indicando erro (pulso muito longo)
           
        }
    }
    absolute_time_t end = get_absolute_time();

    printf("4.pulso recebido...\n");

    // Calcular a diferença de tempo em microssegundos
    int64_t tempo_us = absolute_time_diff_us(start, end);

    // Converter para distância (velocidade do som = 34300 cm/s)
    float distancia_cm = (tempo_us * 0.0343f) / 2.0f;

    printf("Distância: %.2f cm\n", distancia_cm); 

    return distancia_cm;
}
 
// Função para verificar o estado da vaga
bool verifica_estado() {
    printf("1.Verificando estado da vaga...\n");
    float distancia = obter_distancia();

    // Verifica se houve erro na obtenção da distância
    if (distancia == -1.0f) {
        estado_da_vaga = true; // Considera a vaga disponível em caso de erro
    } else {
        // retorna false se distancia < 50 cm, true caso contrário
        estado_da_vaga = distancia >= distancia_minima; // Define a distância mínima para considerar a vaga livre
    }

    // 1 para vaga disponivel, 0 para vaga ocupada
    return estado_da_vaga;  
}
