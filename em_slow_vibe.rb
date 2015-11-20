@sc = scale(:a, :minor_pentatonic, num_octaves: 5).map{|n| n - 24}
use_bpm 90

live_loop :bassline do

  @bass_line = [nil,3,nil,2,nil,1,0,1]

  with_synth :fm do
    with_fx :reverb, room: 0.2 do
      @bass_line.each do |b|
        if b
          play @sc[b], release: 0.6
        end
        sleep 0.5
      end
    end
  end
end

live_loop :longs do
  melody = [[4,0.5],[5,5],[6,2.5],[4,0.5],[3,4.5],[2,3]].ring
  if (total = melody.map{|e| e[1]}.sum) != 16
    raise "#{total} isn't 16"
  end
  melody.each do |note, duration|
    with_synth :tri do
      with_fx :slicer, phase: 0.25, release: 0.5 do
        play [@sc[note], @sc[note + 2]], {
          release: duration - 0.05,
          cutoff: rrand(60,90)
        }
      end
    end
    sleep duration
  end
end

live_loop :kick do
  with_fx :echo, phase: 0.5, decay: 0.6 do
    sample :drum_bass_hard
  end

  sleep 1.0
  sample :drum_snare_hard, amp: 0.5
  sleep 1.0
end

live_loop :hihat do
  sleep 0.5
  with_fx :echo, phase: 0.25, decay: 0.3 do
    sample :drum_cymbal_pedal, amp: 0.6;
  end
  sleep 0.5
end







# something down here