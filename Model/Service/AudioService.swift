//
//  AudioService.swift
//  Spotify
//
//  Created by Zhonghao Lian on 2021/7/1.
//

import Foundation
import AVFoundation

// Ultimately, SongViewController is the delegate of AudioService
protocol AudioServiceDelegate {
    func songIsPlaying(currentTime: Double, duration: Double)
}

class AudioService {
    static let shared = AudioService()
    
    var timer: Timer?
    var delegate: AudioServiceDelegate?
    var audioPlayer: AVAudioPlayer!
    let songs = ["song-0", "song-1", "song-2"]
    
    private init(){}
    
    func play(song: Song) {
        let randomSong = songs.randomElement()!
        let songUrl = Bundle.main.url(forResource: randomSong, withExtension: "mp3")!
        
        audioPlayer = try! AVAudioPlayer(contentsOf: songUrl)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        startTimer()
    }
    
    func play(atTime time: Double) {
        audioPlayer.currentTime = time
    }
    
    func pause() {
        audioPlayer.pause()
        stopTimer()
    }
    
    func resume() {
        audioPlayer.play()
        startTimer()
    }
    
    private func startTimer() {
        // run the code in block every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (time) in
            // invoking the method on the delegate property
            self.delegate?.songIsPlaying(currentTime: self.audioPlayer.currentTime,
                                         duration: self.audioPlayer.duration)
        })
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
