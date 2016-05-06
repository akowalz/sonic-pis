# Welcome to Sonic Pi v2.7

PROG_DURATION = 2.0


BASS_AMP = 1.8
MELODY_AMP = 1.2
CHORD_AMP = 1.4
DRUM_AMP = 1.0


chords = [
  c1 = chord(:c, :major7),
  c2 = chord(:f, :major7),
  c3 = chord(:d, :minor7),
  c4 = chord(:c, :maj9)
]

comment do
  chords = [
    chord(:e, :minor7),
    chord(:d, :dom7),
    chord(:f, :major7),
    chord(:c, :major),
  ]
end


live_loop :main do
  with_fx :level, amp: CHORD_AMP do
    sync :bass
    with_fx :ixi_techno, mix: 0.2, phase: 8 do
      use_synth :pulse
      chords.each do |chord|
        with_fx :reverb, room: 0.9 do
          with_fx :slicer, phase: 1.0/[4,4,8].choose do
            play chord, sustain: 1, attack: 0.2, amp: 0.9, sustain: 1.35, pan: [-0.7, 0.7].ring.tick
            sleep PROG_DURATION
          end
        end
      end
    end
  end
end

live_loop :mel do
  with_fx :level, amp: MELODY_AMP do
    sync :main
    use_synth :pretty_bell
    arps = [
      [nil,0,nil,3,nil,nil,2,nil].ring,
      [nil,1,nil,2,nil,1,  0,nil].ring,
      [nil,0,nil,3,nil,nil,0,1  ].ring,
      [nil,2,nil,3,nil,nil,2,3  ].ring,
      [nil,0,nil,3,nil,nil,1,nil].ring,
    ]
    chords.each do |chord|
      arps.choose.each do |deg|
        if deg
          with_fx :reverb, room: 0.9, mix: 0.8 do
            play chord[deg],
              amp: rrand(0.5,1.25),
              pan: -0.8 + rrand(0.0,0.4),
              release: 0.05 + rrand(0.1,0.2),
              env_curve: [1,2,3,4,6,7].choose,
              attack: 0.001
          end
        end
        sleep PROG_DURATION / 8
      end
    end
  end
end


live_loop :drums do
  with_fx :level, amp: DRUM_AMP do
    with_fx :echo, phase: 0.25, decay: 1.5 do
      sample :drum_cymbal_closed, amp: rrand(0.75, 1.25)
      sleep 1
    end
  end
end

live_loop :perc do
  sync :drums
  with_fx :level, amp: DRUM_AMP do
    with_fx :slicer, phase: 0.25, wave: 0, mix: 0.8 do
      with_fx :flanger, pitch: 0 do
        sample :perc_bell, rate: 1, attack: 0.2, sustain: 1 if tick % 4 == 1
      end
    end
  end
end

live_loop :bass do
  sync :drums
  with_fx :level, amp: DRUM_AMP do
    with_fx :reverb, room: 0.8, damp: 0.75, mix: 0.3 do
      with_fx :echo, phase: 0.5, decay: 1 do
        sample :drum_bass_hard, amp: 0.8
        sleep 1
      end

      sample :drum_snare_hard
      sleep 0.75
      sample :drum_bass_hard, amp: 1.5 if tick.even?
      sleep 0.25
    end
  end
end

live_loop :bass_note do
  with_fx :level, amp: BASS_AMP do
    bass1 = [:c2, :a1, :d2, :c2]
    bass2 = [:c2, :a1, :d2, :g2]
    bass3 = Proc.new { (0...4).map { scale(:C, :major_pentatonic).choose - 24 } }
    bass4 = -> { bass1.map { |b| b + [0, ].choose } }

    bassline = [bass1, bass1, bass4.call, bass4.call].ring.tick

    sync :bass
    bassline.each do |c|
      with_fx :lpf, cutoff: rrand(110,120) do
        with_synth :subpulse do
          play c, amp: 1, sub_amp: 1.1, sustain: 0.4, release: 1.8, env_curve: 2, cutoff: 110
          sleep PROG_DURATION
        end
      end
    end
  end
end


#end
