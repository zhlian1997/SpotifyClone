//
//  SongViewController.swift
//  Spotify
//
//  Created by Zhonghao Lian on 2021/7/1.
//

import UIKit

class SongViewController: UIViewController {
    
    var album: Album!
    var selectedSongIndex: Int!
    var albumPrimaryColor: CGColor!
    var userStartedSliding = false
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackSlider: UISlider!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func favoriteButtonDidTapped(_ sender: UIButton) {
        let songSelected = album.songs[selectedSongIndex]
        
        if UserService.shared.isFavoritedSong(song: songSelected) {
            UserService.shared.unfavoriteSong(song: songSelected)
            favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
        } else {
            UserService.shared.favoriteSong(song: songSelected)
            favoriteButton.setImage(UIImage(named: "heart-filled"), for: .normal)
        }
    }
    
    @IBAction func sliderValueDidChange(_ sender: UISlider) {
        if sender.isContinuous {
            userStartedSliding = true
            sender.isContinuous = false
        } else {
            // happens only when the user releases the slider's thumb control
            userStartedSliding = false
            AudioService.shared.play(atTime: Double(sender.value))
            sender.isContinuous = true
        }
    }
    
    @IBAction func playButtonDidTapped(_ sender: UIButton) {
        // tag of a button: an Integer space, to keep track of whatever info
        let TAG_PAUSE = 0
        let TAG_PLAY = 1
        
        // if tag == 0, plause the music
        if sender.tag == TAG_PAUSE {
            AudioService.shared.pause()
            sender.setImage(UIImage(named: "play"), for: .normal)
            sender.tag = TAG_PLAY
        } else if sender.tag == TAG_PLAY {
            AudioService.shared.resume()
            sender.setImage(UIImage(named: "pause"), for: .normal)
            sender.tag = TAG_PAUSE
        }
    }
    
    @IBAction func previousButtonDidTapped(_ sender: UIButton) {
        selectedSongIndex = max(selectedSongIndex - 1, 0)
        updateFavoriteButton()
        playSelectedSong()
    }
    
    @IBAction func nextButtonDidTapped(_ sender: UIButton) {
        selectedSongIndex = (selectedSongIndex + 1) % album.songs.count
        updateFavoriteButton() 
        playSelectedSong()
    }
    
    @IBAction func dismissButtonDidTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        AudioService.shared.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Seeded the data for testing purposes
//        album = CategoryService.shared.categories.randomElement()!.albums.randomElement()
//        albumPrimaryColor = UIColor.blue.cgColor
//        selectedSongIndex = 0
        
        // Add gradient to background
        let background = view.backgroundColor!.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        gradientLayer.colors = [albumPrimaryColor, background]
        gradientLayer.locations = [0.0, 0.4]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Initizalize elements
        thumbnailImageView.image = UIImage(named: "\(album.image)-lg")
        trackSlider.value = 0
        currentTimeLabel.text = "00:00"
        
        // to create a round button
        playButton.layer.cornerRadius = playButton.frame.size.width / 2.0
        playButton.tag = 0
        
        // set SongViewController (self) to be the delegate of AudioService
        // in order for the AudioService pass on current time & duration
        AudioService.shared.delegate = self
        
        // Initialize like button
        updateFavoriteButton()
        
        playSelectedSong()
    }
    
    private func playSelectedSong() {
        let songSelected = album.songs[selectedSongIndex]
        
        titleLabel.text = songSelected.title
        artistLabel.text = songSelected.artist
        AudioService.shared.play(song: songSelected)
    }
    
    func updateFavoriteButton() {
        let songSelected = album.songs[selectedSongIndex]
        
        if UserService.shared.isFavoritedSong(song: songSelected) {
            favoriteButton.setImage(UIImage(named: "heart-filled"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension SongViewController: AudioServiceDelegate {
    
    // Being passed time/duration of the song every second (from AudioService)
    func songIsPlaying(currentTime: Double, duration: Double) {
        trackSlider.maximumValue = Float(duration)
        
        // Without checking userStartedSliding, using sliding to adjust time will not work
        if !userStartedSliding {
            trackSlider.value = Float(currentTime)
        }
        
        // Update current time + duration labels
        currentTimeLabel.text = stringFromTime(time: currentTime)
        durationLabel.text = stringFromTime(time: duration)
    }
    
    func stringFromTime(time: Double) -> String {
        let seconds = Int(time) % 60
        let minutes = (Int(time) / 60) % 60
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
}
