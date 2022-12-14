// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// - - Piano960 | VST3, AU - - - - - - - - - - - - - - - - - - - -
// - - Created by Tyler Perin  - - - - - - - - - - - - - - - - - -
// - - Copyright © 2022 Sound Voyager. All rights reserved.- - - -
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//   piano.h
//   ~~~~~~~
//
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

#pragma once

namespace piano {

    enum Semitone { C, Db, D, Eb, E, F, Gb, G, Ab, A, Bb, B };

    constexpr Semitone Csharp = Db;
    constexpr Semitone Dsharp = Eb;
    constexpr Semitone Fsharp = Gb;
    constexpr Semitone Gsharp = Ab;
    constexpr Semitone Asharp = Bb;

    const int OCTAVE_SIZE = 12;
    
    const int C0 = 12;
    
    const int G0 = C0 + 7;

    const int C1 = C0 + 1*OCTAVE_SIZE;

    const int C2 = C0 + 2*OCTAVE_SIZE;

    const int C3 = C0 + 3*OCTAVE_SIZE;
    
    const int C7 = C0 + 6*OCTAVE_SIZE;

    const int B8 = C0 + 7*OCTAVE_SIZE - 1;

    const int C8 = C0 + 7*OCTAVE_SIZE;

    const int G8 = G0 + 7*OCTAVE_SIZE;

    Semitone get_semitone(float frequency);

    float getFrequency(int keyNumber);

    int getKeyNumber(float frequency);

} // piano namespace
