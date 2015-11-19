# Welcome to Sonic Pi v2.

use_bpm 54

s = (scale :g, :minor_pentatonic, num_octaves: 4).ring
pat = 8.times.map {|i| i + rrand_i(i, 2)}
start_points = [0,4,3,2]

live_loop :thing do
  with_synth :tri do
    pat = pat.reverse if one_in(2)
    start_points.each do |start|
      all_notes = one_in(4)
      pat.each do |degree|
        with_fx :reverb do
          if all_notes || !one_in(2)
            play s[degree + start] - 12,
              sustain: 0.125 / 8,
              release: 0.25,
              cutoff: rrand(40,80),
              amp: 0.6,
              pan: -0.5 + degree * 0.1
          end

          sleep 0.125
        end
      end
    end
  end
end

live_loop :drums do
  sample :loop_amen, beat_stretch: 2
  sample :bd_boom, amp: 4; sleep 0.25
  sample :bd_boom, amp: 4

  sample :bd_boom, amp: 3, rate: -1; sleep 0.25
  sleep 1.5
end


live_loop :bass do
  with_synth :mod_pulse do
    with_fx :echo, phase: 0.4, mix: 0.5 do
      start_points.each do |start|
        play [s[start] - 12, s[start] - [7,5].choose - 12],
          release: 0.01,
          sustain: 0.3,
          amp: 0.8
        sleep 1
      end
    end
  end
end