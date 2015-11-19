PROG_DURATION = 2.0

chords = [
  c1 = chord(:c, :major7),
  c2 = chord(:f, :major7),
  c3 = chord(:d, :minor7),
  c4 = c1,
]

live_loop :main do
  use_synth :subpulse
  chords.each do |chord|
    with_fx :reverb, room: 0.9 do
      with_fx :slicer, phase: 1.0/4 do
        play chord, sustain: 1, attack: 0.2, amp: 0.8, sustain: 1.35, pan: [-0.3, 0.3].ring.tick
        sleep PROG_DURATION
      end
    end
  end
end

live_loop :mel do
  use_synth :pretty_bell
  arps = [
    [nil,0,nil,3,nil,nil,2,nil].ring,
    [nil,1,nil,2,nil,1,  0,nil].ring,
    [nil,0,nil,3,nil,nil,0,1  ].ring,
    [nil,2,nil,3,nil,nil,2,3  ].ring,
    [nil,rrand_i(0,3),nil,rrand_i(0,3),nil,nil,rrand_i(0,3),nil].ring,
  ]
  chords.each do |chord|
    arps.choose.each do |deg|
      if deg
        with_fx :reverb, room: 0.9, mix: 0.7 do
          play chord[deg],
            amp: rrand(0.5,1.25),
            pan: -0.8 + rrand(0.0,0.4),
            release: 0.05 + rrand(0.1,0.2),
            env_curve: [1,2,3,4,6,7].choose
        end
      end
      sleep PROG_DURATION / 8
    end
  end
end

live_loop :drums do
  with_fx :echo, phase: 0.25, decay: 1.5 do
    sample :drum_cymbal_closed, amp: rrand(0.75, 1.25)
    sleep 1
  end
end

live_loop :bass do
  with_fx :reverb, room: 0.8, damp: 0.75, mix: 0.3 do
    with_fx :echo, phase: 0.5, decay: 1 do
      sample :drum_bass_hard, amp: 2
      sleep 1
    end
    sample :drum_snare_hard
    sleep 0.75
    sample :drum_bass_hard, amp: 1.5 if tick.even?
    sleep 0.25
  end
end