/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The `MusicPlayerManager` manages the media playback using the `MPMusicPlayerController` APIs.
*/

import UIKit
import MediaPlayer

@objcMembers
class MusicPlayerManager: NSObject {
    
    // MARK: Types
    
    /// Notification that is fired when there is an update to the playback state or currently playing asset in `MPMusicPlayerController`.
    static let didUpdateState = NSNotification.Name("didUpdateState")
    
    static let didUpdateNowPlaying = NSNotification.Name("didUpdateNowPlaying")
    var queue: [MPMediaItem]?
    var selectedRow: Int?

    
    // MARK: Properties
    
    /**
     The instance of `MPMusicPlayerController` that is used for playing back titles from either the device media library
     or from the Apple Music Catalog.
     */
    let musicPlayerController = MPMusicPlayerController.systemMusicPlayer
    
    override init() {
        super.init()
        
        /*
         It is important to call `MPMusicPlayerController.beginGeneratingPlaybackNotifications()` so that
         playback notifications are generated and other parts of the can update their state if needed.
         */
        musicPlayerController.beginGeneratingPlaybackNotifications()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(handleMusicPlayerControllerNowPlayingItemDidChange),
                                       name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                       object: musicPlayerController)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(handleMusicPlayerControllerPlaybackStateDidChange),
                                       name: .MPMusicPlayerControllerPlaybackStateDidChange,
                                       object: musicPlayerController)
        
        MPMusicPlayerController.systemMusicPlayer.shuffleMode = MPMusicShuffleMode.off
    }
    
    deinit {
        /*
         It is important to call `MPMusicPlayerController.endGeneratingPlaybackNotifications()` so that
         playback notifications are no longer generated.
         */
        musicPlayerController.endGeneratingPlaybackNotifications()
        
        // Remove all notification observers.
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.removeObserver(self,
                                          name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                          object: musicPlayerController)
        notificationCenter.removeObserver(self,
                                          name: .MPMusicPlayerControllerPlaybackStateDidChange,
                                          object: musicPlayerController)
    }
    
    // MARK: Playback Loading Methods
    
    func beginPlayback(itemCollection: MPMediaItemCollection) {
        musicPlayerController.setQueue(with: itemCollection)
        musicPlayerController.play()
    }
    
    func beginPlayback(itemID: String) {
        musicPlayerController.setQueue(with: [itemID])
        musicPlayerController.play()
        
    }
    
    func beginPlayback(mediaQuery: MPMediaQuery) {
        musicPlayerController.setQueue(with: mediaQuery)
        musicPlayerController.play()
    }
    
    func beginPlayback(queueDescriptor: MPMusicPlayerQueueDescriptor) {
        musicPlayerController.setQueue(with: queueDescriptor)
        
        musicPlayerController.play()
    }
    
    func beginPlayback(_ mediaQuery: MPMediaQuery, withIndex index: Int) {
        musicPlayerController.setQueue(with: mediaQuery)
        playSongWithIndex(index)
        musicPlayerController.play()
    }
    
    // MARK: Playback Control Methods
    
    func togglePlayPause() {
        if musicPlayerController.playbackState == .playing {
            musicPlayerController.pause()
        } else {
            musicPlayerController.play()
        }
    }
    
    func skipToNextItem() {
        musicPlayerController.skipToNextItem()
    }
    
    func skipBackToBeginningOrPreviousItem() {
        if musicPlayerController.currentPlaybackTime < 5 {
            // If the currently playing `MPMediaItem` is less than 5 seconds into playback then skip to the previous item.
            musicPlayerController.skipToPreviousItem()
        } else {
            // Otherwise skip back to the beginning of the currently playing `MPMediaItem`.
            musicPlayerController.skipToBeginning()
        }
    }
    
    func playSongWithIndex(_ index: Int) {
        guard let queue = queue else {
            return
        }
        if index < queue.count {
            selectedRow = index
            musicPlayerController.nowPlayingItem = currentMediaItem
        }
    }
    
    var currentMediaItem: MPMediaItem? {
        if let queue = queue,
            let selectedRow = selectedRow,
            selectedRow < queue.count {
            return queue[selectedRow]
        }
        
        if overrideCurrentMediaItem != nil {
            return overrideCurrentMediaItem
        }
        
        return nil
    }
    
    var overrideCurrentMediaItem: MPMediaItem?
        
    // MARK: Notification Observing Methods
    
    func handleMusicPlayerControllerNowPlayingItemDidChange() {
        NotificationCenter.default.post(name: MusicPlayerManager.didUpdateNowPlaying, object: nil)
    }
    
    func handleMusicPlayerControllerPlaybackStateDidChange() {
        NotificationCenter.default.post(name: MusicPlayerManager.didUpdateState, object: nil)
    }
}
