#ifndef ULTRASSONICO_H
#define ULTRASSONICO_H

#include "library/library.h"

#define TRIGGER_PIN 16
#define ECHO_PIN 17
#define TIMEOUT_US 20000  // Tempo máximo de espera (20ms = ~600cm)

// Declaração das funções para inicializar e obter a distância do sensor ultrassônico e verificar estado da vaga
void inicializar_ultrassonico();
float obter_distancia();
bool verifica_estado();

// Variável para armazenar o estado da vaga 
extern bool estado_da_vaga;  

#endif