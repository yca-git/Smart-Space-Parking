#ifndef ULTRASSONICO_H
#define ULTRASSONICO_H

#include "library/library.h"

// Definições para 5 sensores ultrassônicos
#define NUM_SENSORES 5
#define TIMEOUT_US 20000  // Tempo máximo de espera (20ms = ~600cm)

// Pinos para os 5 sensores (Trigger e Echo)
#define TRIGGER_PIN_1 16
#define ECHO_PIN_1 18

#define TRIGGER_PIN_2 17
#define ECHO_PIN_2 19

#define TRIGGER_PIN_3 16
#define ECHO_PIN_3 20

#define TRIGGER_PIN_4 17
#define ECHO_PIN_4 4

#define TRIGGER_PIN_5 16
#define ECHO_PIN_5 8

// Estrutura para armazenar informações de cada sensor
typedef struct {
    uint trigger_pin;
    uint echo_pin;
    bool estado_vaga;  // true = livre, false = ocupada
    float ultima_distancia;
} sensor_ultrassonico_t;

// Array com as configurações dos sensores
extern sensor_ultrassonico_t sensores[NUM_SENSORES];

// Declaração das funções
void inicializar_ultrassonico();
float obter_distancia(int sensor_id);
bool verifica_estado(int sensor_id);
void verificar_todos_sensores();

// Variáveis para armazenar o estado das vagas 
extern bool estados_vagas[NUM_SENSORES];

#endif