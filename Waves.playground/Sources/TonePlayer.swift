import Foundation
import AVFoundation

public class TonePlayer {
    
    private let player = AVAudioPlayerNode()
    private let pitchEffect = AVAudioUnitTimePitch()
    private let audioBuffer: AVAudioPCMBuffer?
    
    public init(withEngine engine: AVAudioEngine, instrument: Instrument, note: Note) {
        let timbre = instrument.getTimbre()!
        let timbreFrameCount = UInt32(timbre.length)
        self.audioBuffer = AVAudioPCMBuffer(pcmFormat: timbre.processingFormat, frameCapacity: timbreFrameCount)
        try! timbre.read(into: self.audioBuffer!)
        
        self.pitchEffect.pitch = note.rawValue
        
        engine.attach(self.player)
        engine.attach(self.pitchEffect)
        
        engine.connect(self.player, to: self.pitchEffect, format: self.audioBuffer?.format)
        engine.connect(self.pitchEffect, to: engine.mainMixerNode, format: self.audioBuffer?.format)
    }
    
    public func play(didFinish: (() -> Void)?) {
        self.player.scheduleBuffer(self.audioBuffer!, at: nil, options: [], completionHandler: {
            didFinish?()
        })
        self.player.play()
    }
    
    public func stop() {
        self.player.stop()
    }
    
}
