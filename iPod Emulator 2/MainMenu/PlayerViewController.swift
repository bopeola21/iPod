//
//  PlayerViewController.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/22/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import UIKit
import SDWebImage
import MediaPlayer

class PlayerViewController: UIViewController {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var startSeekLabel: UILabel!
    @IBOutlet weak var endSeekLabel: UILabel!
    var viewType: PlaylistViewController.ViewType = .playlist
    var artistName: String!
    var albumName: String!
    var songName: String!
    var playlistName: String!
    var ableToUpdate = true
    var query: MPMediaQuery!
    var musicPlayerManager = Model.shared.musicPlayerManager
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch viewType {
        case .playlist:
            query = Model.shared.playlistQuery(playlistName: playlistName)
            musicPlayerManager.queue = Model.shared.requestPlaylistSongs(playlistName: playlistName)
        case .artist:
            query = Model.shared.artistQuery(playlistName: artistName)
            musicPlayerManager.queue = Model.shared.requestArtistSongs(playlistName: artistName)
        case .album:
            query = Model.shared.albumQuery(playlistName: albumName)
            musicPlayerManager.queue = Model.shared.requestAlbumSongs(playlistName: albumName)
        case .song:
            query = Model.shared.allSongQuery()
            musicPlayerManager.queue = Model.shared.requestAllSong()
        case .nowPlaying:
            if musicPlayerManager.queue == nil {
                musicPlayerManager.overrideCurrentMediaItem = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem
                musicPlayerManager.selectedRow = 0
            }
        }

        if viewType != .nowPlaying {
            musicPlayerManager.beginPlayback(query, withIndex: musicPlayerManager.selectedRow ?? 0)
            
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMusicPlayerManagerDidUpdateState),
                                               name: MusicPlayerManager.didUpdateNowPlaying,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iPodNavigationBar.shared.navTitleLabel.text = "Now Playing"
        ClickViewSingleton.shared.delegate = self
        ClickViewSingleton.shared.buttonIsEnabled = true
        updateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProgressView()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateViewRepeat), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ClickViewSingleton.shared.buttonIsEnabled = false
    }

    func updateView() {
        DispatchQueue.main.async {
            guard let currentMediaItem = self.musicPlayerManager.currentMediaItem,
                let selectedRow = self.musicPlayerManager.selectedRow else { return }

            self.totalLabel.text = "\(selectedRow + 1) of \(Model.shared.musicPlayerManager.queue?.count ?? 1)"
            self.nameLabel.text = self.musicPlayerManager.currentMediaItem?.title
            self.artistLabel.text = self.musicPlayerManager.currentMediaItem?.artist
            self.albumLabel.text = self.musicPlayerManager.currentMediaItem?.albumTitle
            self.imageView.image = self.musicPlayerManager.currentMediaItem?.artwork?.image(at: CGSize(width: 150, height: 150))
            let formattedString = self.stringForTime(time: currentMediaItem.playbackDuration)
            self.endSeekLabel.text = formattedString
        }
    }
    
    @objc func updateViewRepeat() {
        if musicPlayerManager.currentMediaItem == nil { return }

       // DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.updateProgressView()
            self.updateView()
            //self.updateViewRepeat()
       // }
    }
    
    func updateProgressView() {
        guard let currentMediaItem = musicPlayerManager.currentMediaItem else { return }
        let time = Model.shared.musicPlayerManager.musicPlayerController.currentPlaybackTime
        let ratio = time / currentMediaItem.playbackDuration
        let progressVal = 0.5 * ratio // 0.5 is the max value for the progress bar
        let difference = currentMediaItem.playbackDuration - time
        self.endSeekLabel.text = "- \(self.stringForTime(time: difference))"
        self.startSeekLabel.text = self.stringForTime(time: time)
        self.progressView.animateToPosition(CGFloat(progressVal), animate: false)
    }
    
    func setMedia(index: Int) {
        musicPlayerManager.playSongWithIndex(index)
        updateView()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        
        // Remove all notification observers.
        NotificationCenter.default.removeObserver(self,
                                                  name: MusicPlayerManager.didUpdateState,
                                                  object: nil)
    }
    
    @objc func handleMusicPlayerManagerDidUpdateState() {
        ableToUpdate = true
        let nowPlayingItem = musicPlayerManager.musicPlayerController.nowPlayingItem
        progressView.reset()
        
        if musicPlayerManager.currentMediaItem?.title != nowPlayingItem?.title,
            musicPlayerManager.currentMediaItem?.artist != nowPlayingItem?.artist,
            musicPlayerManager.currentMediaItem?.playbackDuration != nowPlayingItem?.playbackDuration {
            
//            let index = musicPlayerManager.musicPlayerController.indexOfNowPlayingItem
//            setMedia(index: index)

            if let index = musicPlayerManager.queue?.firstIndex(where: { (item: MPMediaItem) -> Bool in
                if nowPlayingItem?.title == item.title &&
                    nowPlayingItem?.artist == item.artist &&
                    nowPlayingItem?.playbackDuration == item.playbackDuration {
                    return true
                }
                return false
            }) {
                //setMedia(index: index)
                musicPlayerManager.selectedRow = index
                //updateView()
            } else {
                musicPlayerManager.overrideCurrentMediaItem = nowPlayingItem
                musicPlayerManager.selectedRow = 0
                //updateView()
            }
            
            updateView()
        }
    }
    
    func stringForTime(time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        let str = formatter.string(from: TimeInterval(time))!
        let arr = str.components(separatedBy: "00:")
        let newStr = arr.count > 1 ? "0:\(arr[1])" : str
        
        return newStr
    }
}

extension PlayerViewController: ClickWheelViewDelegate {
    func clickWheelBegan(value: Int) {
        
    }
    
    func clickWheelValue(value: Int) {
        
    }
    
    func clickWheelEnded(value: Int) {
        
    }
    
    func playPauseSelected() {
        Model.shared.musicPlayerManager.togglePlayPause()
    }
    
    func inButtonSelected() {
        
    }
    
    func fastForwardSelected() {
        guard ableToUpdate,
            let selectedRow = musicPlayerManager.selectedRow else { return }
        
        let newRow = selectedRow + 1
        setMedia(index: newRow)
        
        ableToUpdate = false
    }
    
    func rewindSelected() {
                guard ableToUpdate,
            let selectedRow = musicPlayerManager.selectedRow else { return }

        let newRow = selectedRow - 1
        if newRow <= 0 { return }
        setMedia(index: newRow)

        ableToUpdate = false
    }
    
    func menuSelected() {
        navigationController?.popViewController(animated: true)
    }
}
