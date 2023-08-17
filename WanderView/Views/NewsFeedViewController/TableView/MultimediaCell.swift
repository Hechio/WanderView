//
//  MultiMediaCell.swift
//  WanderView
//
//  Created by Steve Hechio on 17/08/2023.
//

import UIKit
import AVKit

class MultimediaCell: UICollectionViewCell {
    static let reuseIdentifier = "MultimediaCellReuseIdentifier"
    
    var mediaItem: MediaItem? {
           didSet {
               updateUI()
           }
       }
       
       private var player: AVPlayer?
       private var playerLayer: AVPlayerLayer?
       
       private let imageView: UIImageView = {
           let imageView = UIImageView()
           imageView.contentMode = .scaleAspectFill
           imageView.layer.cornerRadius = 10
           imageView.clipsToBounds = true
           return imageView
       }()
       
       private let videoPlayerView: UIView = {
           let view = UIView()
           return view
       }()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           
           contentView.addSubview(imageView)
           contentView.addSubview(videoPlayerView)
           
           setupConstraints()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       private func updateUI() {
           if let mediaItem = mediaItem {
               switch mediaItem.type {
               case .image(let image):
                   imageView.loadImage(from: image.absoluteString)
                   imageView.isHidden = false
                   removeVideoPlayer()
               case .video(let videoURL):
                   imageView.isHidden = true
                   setupVideoPlayer(videoURL)
               }
           }
       }
       
       private func setupVideoPlayer(_ videoURL: URL) {
           player = AVPlayer(url: videoURL)
           playerLayer = AVPlayerLayer(player: player)
           playerLayer?.frame = videoPlayerView.bounds
           videoPlayerView.layer.addSublayer(playerLayer!)
           player?.play()
       }
       
       private func removeVideoPlayer() {
           player?.pause()
           player = nil
           playerLayer?.removeFromSuperlayer()
           playerLayer = nil
       }
       
       override func prepareForReuse() {
           super.prepareForReuse()
           removeVideoPlayer()
           imageView.image = nil
       }
    
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            videoPlayerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            videoPlayerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            videoPlayerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            videoPlayerView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
