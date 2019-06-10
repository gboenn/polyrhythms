#include "MidiFile.h"
#include <random>
#include <iostream>

using namespace std;
using namespace smf;

#define MY_PPQ 960


void cycle_track_writer2 (string name, int key, int start, int length, int f) {
    // start: start cycle count, first cycle starts at n=0
    // length: length
    // f: length factor. The beat length equals to f*PPQ
    // calculates a cycle of length pulses
    // where the length of the note is given by f as an integer multiple of the pulse
    // all notes are aligned to a quarter note pulse grid with 960 PPQ
    // Time starts at start=0 but note that the output file is aligned to start immediately at any given start.
    // The outputfile will be length quarter notes long
    // This enables us to write polyrhythmic music where cycles can be extracted from anywhere within a polyrhythmic cycle
    // Polyrhythmic cycles can become long very quickly if one uses prime number ratios
    
    MidiFile midifile;
    int track   = 0;
    int channel = 0;
    int instr   = 0;
    midifile.addTimbre(track, 0, channel, instr);
    int tpq     = MY_PPQ;
    midifile.setTPQ(tpq);
    int total = start + length;
    int cutoff = length * tpq;
    int count = 0;
    // to have the modulo operation correct and have the length of the file correct
    // two separate counters, i and count, have to be employed
    for (int i = start; i < total; i++, count++) {
        if (i % f == 0) {
            int starttick = count * tpq;
            int endtick   = starttick + f * tpq;
            if (endtick > cutoff)
                endtick = cutoff;
            midifile.addNoteOn (track, starttick, channel, key, 100);
            midifile.addNoteOff(track, endtick,   channel, key);
        }
    }
    midifile.write(name);
}

void cycle_track_writer (string name, int key, int n, int m, int f) {
    // n: start cycle count, first cycle starts at n=0
    // m: end cycle count (exclusive)
    // f: length of beat
    // calculates a cycle of m-n pulses
    // where the length of the note is given by f as an integer multiple of the pulse
    // all notes are aligned to a quarter note pulse grid with 960 PPQ
    // Time starts at n=0 but note that the output file is aligned to start immediately at any given n.
    // The outputfile will be m-n quarter notes long
    // This enables us to write polyrhythmic music where cycles can be extracted from anywhere within a polyrhythmic cycle
    // Polyrhythmic cycles can become long very quickly if one uses prime number ratios

    MidiFile midifile;
    int track   = 0;
    int channel = 0;
    int instr   = 0;
    midifile.addTimbre(track, 0, channel, instr);
    int tpq     = MY_PPQ;
    midifile.setTPQ(tpq);
    int firstbeat = n;
    if (n % f)
        firstbeat = n - (n % f) + f;
    int lastbeat = m - f;
    if (m % f)
        lastbeat = m - (m % f);
    int deltacycle = m-n;
    for (int i = 0, counter=n; i < deltacycle; i++, counter++) {
        if (counter == firstbeat) {
            int starttick = i * tpq;
            int endtick   = starttick + f * tpq;
            if (counter == lastbeat)
                endtick = deltacycle * tpq;
            midifile.addNoteOn (track, starttick, channel, key, 100);
            midifile.addNoteOff(track, endtick,   channel, key);
            firstbeat += f;
        }
    }
    midifile.write(name);
}

void midi_writer (string name, int key, int count, int factor) {
    MidiFile midifile;
    int track   = 0;
    int channel = 0;
    int instr   = 0;
    midifile.addTimbre(track, 0, channel, instr);
    int tpq     = MY_PPQ;
    midifile.setTPQ(tpq);
    tpq *= factor;
    for (int i=0; i<count; i++) {
        int starttick = i * tpq;
        int endtick   = i * tpq + tpq;
        midifile.addNoteOn (track, starttick, channel, key, 100);
        midifile.addNoteOff(track, endtick,   channel, key);
    }
    midifile.write(name);
}

int main(int argc, char** argv) {
    
    if (argc < 5) {
        cout << "Usage: " << argv[0] << " filename start_n stop_n factor_1 ..." << endl;
        cout << argv[0] << " needs at least one integer factor, or a list of factors: factor_1 factor_2 factor_3 ..." << endl;
        return 0;
    }
    
    cout << argv[0] << " " << argv[1] << " " << argv[2] << " " << argv[3] << " " << argv[4] << " ";
    if (argc > 5) {
        int a = 5;
        for (; a != argc; ++a) {
            cout << argv[a] << " ";
        }
    }
    cout << endl;
    
    string globalname = string(argv[1]);
    int start_n = atoi(argv[2]);
    //int stop_n = atoi(argv[3]);
    int length = atoi(argv[3]);
    
#if 0
    if (stop_n < start_n) {
        cout << "Error: start_n must be smaller than stop_n." << endl;
        return 0;
    }
#endif
    
    if (length < 1) {
        cout << "Error: length must be > 0." << endl;
        return 0;
    }
    if (start_n < 0) {
        cout << "Error: start_n must be >= 0." << endl;
        return 0;
    }
    
    vector<int> factors;
    if (argc > 4) {
        int a = 4;
        for (; a != argc; ++a) {
            factors.push_back(atoi(argv[a]));
        }
    }
    
    int i = 0;
    for (; i < factors.size(); i++) {
        string zero = "";
        if (i < 10) zero = "0";
        string localname = globalname + "_" + zero + to_string(i) + ".midi";
        int factor = factors[i];
        //cycle_track_writer (localname, 60, start_n, stop_n, factor);
        cycle_track_writer2 (localname, 60, start_n, length, factor);
    }
    return 0;
}
