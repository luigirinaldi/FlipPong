#include <stdlib.h>
#include <iostream>
#include <unistd.h>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vconway.h"

#define MAX_SIM_TIME 500
vluint64_t sim_time = 0;

bool readWide(VlWide<8> x, int index) {
    return (x[index / 32] >> index%32) & 1;
}

void insertWide(VlWide<8> x, int index, int val){
    val = val << index%32;
    x[index / 32] = val;
}

void printState(VlWide<8> state) {
    for (int i = 0; i < 256; i++) {
        if (i%16 == 0) printf("\n%d: \t",i);
        if (readWide(state, i)) printf("▓▓");
        else printf("░░");
    }
    printf("\n");
}

int main(int argc, char** argv, char** env) {
    Vconway *dut = new Vconway;

    // bool state[256];
    VlWide<8> state;

    // zero state
    for (int i = 0; i < 8; i++) state[i] = 0;
    state[0] = 0x7;

    state[2] = 0x7;

    state[4] = 15 | (15 << 16);



    // state[3] = -1;
    printf("initial state: \n");
    printState(state);

    // Verilated::traceEverOn(true);
    // VerilatedVcdC *m_trace = new VerilatedVcdC;
    // dut->trace(m_trace, 5);
    // m_trace->open("waveform.vcd");

    // LOAD VALUES
    dut->data = state;
    dut->clk = 0;
    dut->load = 1;
    dut->eval();
    usleep(10);
    dut->clk = 1;
    dut->eval();
    usleep(10);
    dut->load = 0;
    dut->eval();

    while (sim_time < MAX_SIM_TIME) {
        dut->clk ^= 1;
        dut->eval();
        // m_trace->dump(sim_time);
        sim_time++;
        
        if (!dut->clk) {
            printf("t=%li\n",sim_time);
            // printState(state);
            state = dut->q;
            printf("curr_state:");
            printState(state);
        } 
        usleep(200000);
    }

    // m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}