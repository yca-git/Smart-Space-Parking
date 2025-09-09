#include "ultrassonico.h"

// Array com as configurações dos 5 sensores
sensor_ultrassonico_t sensores[NUM_SENSORES] = {
    {TRIGGER_PIN_1, ECHO_PIN_1, true, 0.0f},   // Sensor 1
    {TRIGGER_PIN_2, ECHO_PIN_2, true, 0.0f},   // Sensor 2
    {TRIGGER_PIN_3, ECHO_PIN_3, true, 0.0f},   // Sensor 3
    {TRIGGER_PIN_4, ECHO_PIN_4, true, 0.0f},   // Sensor 4
    {TRIGGER_PIN_5, ECHO_PIN_5, true, 0.0f}    // Sensor 5
};

bool estados_vagas[NUM_SENSORES];  // Array para armazenar o estado das vagas
int distancia_minima = 20; // Distância mínima em cm para considerar a vaga livre

// Função para inicializar todos os sensores ultrassônicos
void inicializar_ultrassonico() {
    printf("Inicializando %d sensores ultrassônicos...\n", NUM_SENSORES);
    
    for (int i = 0; i < NUM_SENSORES; i++) {
        // Inicializar pino Trigger
        gpio_init(sensores[i].trigger_pin);
        gpio_set_dir(sensores[i].trigger_pin, GPIO_OUT);
        gpio_put(sensores[i].trigger_pin, 0);

        // Inicializar pino Echo
        gpio_init(sensores[i].echo_pin);
        gpio_set_dir(sensores[i].echo_pin, GPIO_IN);
        
        // Inicializar estado da vaga como livre
        sensores[i].estado_vaga = true;
        estados_vagas[i] = true;
        
        printf("Sensor %d inicializado - Trigger: GP%d, Echo: GP%d\n", 
               i+1, sensores[i].trigger_pin, sensores[i].echo_pin);
    }
    
    printf("Todos os sensores inicializados com sucesso!\n");
}


// Função para medir a distância em centímetros de um sensor específico
float obter_distancia(int sensor_id) {
    if (sensor_id < 0 || sensor_id >= NUM_SENSORES) {
        printf("Erro: ID do sensor inválido (%d)\n", sensor_id);
        return -1.0f;
    }
    
    printf("Sensor %d - Obtendo distância...\n", sensor_id + 1);

    uint trigger_pin = sensores[sensor_id].trigger_pin;
    uint echo_pin = sensores[sensor_id].echo_pin;

    // Enviar um pulso de 10us para ativar o sensor
    gpio_put(trigger_pin, 1);
    sleep_us(10);
    gpio_put(trigger_pin, 0);

    //printf("Sensor %d - Pulso enviado...\n", sensor_id + 1);

    absolute_time_t start_wait = get_absolute_time(); // Inicia a contagem do tempo de espera

    // Esperar o sinal HIGH no pino ECHO (com timeout)
    while (gpio_get(echo_pin) == 0) {
        if (absolute_time_diff_us(start_wait, get_absolute_time()) > TIMEOUT_US) {
            printf("Sensor %d - Pulso não recebido (timeout)\n", sensor_id + 1);
            return -1.0f;  // Retorna -1 indicando erro (nenhum retorno)
        }
    }

    // Medir o tempo do pulso HIGH
    absolute_time_t start = get_absolute_time();
    while (gpio_get(echo_pin) == 1) {
        if (absolute_time_diff_us(start, get_absolute_time()) > TIMEOUT_US) {
            printf("Sensor %d - Pulso muito longo (timeout)\n", sensor_id + 1);
            return -1.0f;  // Retorna -1 indicando erro (pulso muito longo)
        }
    }
    absolute_time_t end = get_absolute_time();

    printf("Sensor %d - Pulso recebido!\n", sensor_id + 1);

    // Calcular a diferença de tempo em microssegundos
    int64_t tempo_us = absolute_time_diff_us(start, end);

    // Converter para distância (velocidade do som = 34300 cm/s)
    float distancia_cm = (tempo_us * 0.0343f) / 2.0f;

    //printf("Sensor %d - Distância: %.2f cm\n", sensor_id + 1, distancia_cm); 

    // Atualizar a última distância lida
    sensores[sensor_id].ultima_distancia = distancia_cm;

    return distancia_cm;
}
 
// Função para verificar o estado de uma vaga específica
bool verifica_estado(int sensor_id) {
    if (sensor_id < 0 || sensor_id >= NUM_SENSORES) {
        printf("Erro: ID do sensor inválido (%d)\n", sensor_id);
        return true; // Retorna livre em caso de erro
    }
    
    printf("Verificando estado da vaga %d...\n", sensor_id + 1);
    float distancia = obter_distancia(sensor_id);

    bool estado_atual;
    
    // Verifica se houve erro na obtenção da distância
    if (distancia == -1.0f) {
        estado_atual = true; // Considera a vaga disponível em caso de erro
        printf("Sensor %d - Erro na leitura, considerando vaga LIVRE\n", sensor_id + 1);
    } else {
        // retorna true se distancia >= distancia_minima (LIVRE), false caso contrário (OCUPADA)
        estado_atual = distancia >= distancia_minima;
        printf("Sensor %d - Distância: %.2f cm, Estado: %s\n", 
               sensor_id + 1, distancia, estado_atual ? "LIVRE" : "OCUPADA");
    }

    // Atualizar o estado no array de sensores e no array de estados
    sensores[sensor_id].estado_vaga = estado_atual;
    estados_vagas[sensor_id] = estado_atual;

    return estado_atual;  
}

// Função para verificar o estado de todos os sensores
void verificar_todos_sensores() {
    printf("=== Verificando estado de todas as %d vagas ===\n", NUM_SENSORES);
    
    for (int i = 0; i < NUM_SENSORES; i++) {
        verifica_estado(i);
        sleep_ms(100); // Pequeno delay entre as leituras para evitar interferência
    }
    
    printf("=== Verificação completa ===\n");
}
