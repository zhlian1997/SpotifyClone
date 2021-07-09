//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Zhonghao Lian on 2021/7/1.
//

import UIKit
import UIImageColors

class AlbumViewController: UIViewController {
    
    var album: Album!
    var albumPrimaryColor: CGColor!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shuffleButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // album = CategoryService.shared.categories.first!.albums.randomElement()
        
        
        
        thumbnailImageView.image = UIImage(named: album.image)
        titleLabel.text = album.name
        descriptionLabel.text = "\(album.followers) followers - by \(album.artist)"
        
        if UserService.shared.isFollowingAlbum(album: album) {
            // Set button text to "following" with a green color
            followButton.setTitle("Following", for: .normal)
            followButton.layer.borderColor = UIColor(red: 42.0 / 255.0, green: 183.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0).cgColor
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.layer.borderColor = UIColor.white.cgColor
        }

        // Configure the buttons - rounderd corners and white border
        shuffleButton.layer.cornerRadius = 10.0
        followButton.layer.cornerRadius = 5.0
        followButton.layer.borderWidth = 1.0
        followButton.layer.borderColor = UIColor.white.cgColor
        
        
        // update background color based on thumbnail tune
        // using external library called UIImageColors
        thumbnailImageView.image?.getColors{ colors in
            self.albumPrimaryColor = colors!.primary.withAlphaComponent(0.8).cgColor
            self.updateBackground(with: self.albumPrimaryColor)
        }
    }
    
    // with: external label - improve legibility of our code - making it easier to read
    // if add an underline before external code, we can skip the parameter name when calling the function
    func updateBackground(with color: CGColor) {
        // view refers to the whole view controller
        let backgoundColor = view.backgroundColor!.cgColor
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.frame
        // gradient: from color to backgounrColor
        gradientLayer.colors = [backgoundColor, backgoundColor]
        // [0, 1] - the span of the gradient
        gradientLayer.locations = [0, 0.4]
        
        
        // create animation to make the transition smoothier
        let gradientChangeColor = CABasicAnimation(keyPath: "colors")
        gradientChangeColor.duration = 0.5
        gradientChangeColor.toValue = [color, backgoundColor]
        gradientChangeColor.isRemovedOnCompletion = false
        gradientChangeColor.fillMode = .forwards
        
        // add the animation to the gradientLayer
        gradientLayer.add(gradientChangeColor, forKey: "colorChange")
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    @IBAction func backButtonDidTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func followButtonDidTapped(_ sender: UIButton) {
        // Check to see if the user is following the album
        
        if UserService.shared.isFollowingAlbum(album: album) {
            // If user is, then unfollow the album
            
            UserService.shared.unfollowAlbum(album: album)
            followButton.setTitle("Follow", for: .normal)
            followButton.layer.borderColor = UIColor.white.cgColor
        } else {
            // If user is not, then follow the album
            
            UserService.shared.followAlbum(album: album)
            followButton.setTitle("Following", for: .normal)
            followButton.layer.borderColor = UIColor(red: 42.0 / 255.0, green: 183.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0).cgColor
        }
        
        // Follower count in desciption change after tapped the button
        descriptionLabel.text = "\(album.followers) followers - by \(album.artist)"
    }
    
    @IBAction func shuffleButtonDidTapped(_ sender: UIButton) {
        let randomIndex = Int(arc4random_uniform(UInt32(album.songs.count)))
        performSegue(withIdentifier: "SongSegue", sender: randomIndex)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // If the destination is SongViewController && sender is of Integer data type
        if let songViewController = segue.destination as? SongViewController, let selectedSongIndex = sender as? Int {
            songViewController.album = album
            songViewController.selectedSongIndex = selectedSongIndex
            songViewController.albumPrimaryColor = albumPrimaryColor
        }
    }
}

extension AlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as! SongCell
        let song = album.songs[indexPath.row]
        cell.update(song: song)
        return cell
    }
}

extension AlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SongSegue", sender: indexPath.row)
    }
}
