//
//  PlaylistDetailViewController.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/22/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistDetailViewController: BaseViewController {

    var playlist: Playlist!
    var songNumber: String?
    var songs: [Song]?
    var names: [String]?
    var mediaItems: [MPMediaItem]?
    
    var playlistName: String!
    var artistName: String!
    var albumName: String!
    var songName: String!
    var viewType: PlaylistViewController.ViewType = .playlist

    override func viewDidLoad() {
        super.viewDidLoad()

        switch viewType {
        case .playlist:
            mediaItems = Model.shared.requestPlaylistSongs(playlistName: playlistName)
        case .artist:
            mediaItems = Model.shared.requestArtistSongs(playlistName: artistName)
        case .album:
            mediaItems = Model.shared.requestAlbumSongs(playlistName: albumName)
        case .song:
            let collection = Model.shared.requestSongs()
            menuSelection = collection.compactMap({ $0.items.first?.value(forKey: MPMediaItemPropertyTitle) as? String })
            case .nowPlaying:
                break
        }        
        
        if let mediaItems = mediaItems {
            menuSelection = mediaItems.compactMap({ $0.title })
        }
        
//        if let id = playlist.id {
//            Model.shared.requestPlaylistSongs(id: id) { [weak self] (songs: [Song]?) in
//                guard let songs = songs else { return }
//                self?.songs = songs
//                self?.names = [String](repeating: String(), count: songs.count)
//                self?.names = songs.compactMap({ String($0.name ?? "No Name") })
//                self?.menuSelection = self?.names ?? [String]()
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                    self?.selectTopCell()
//                }
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iPodNavigationBar.shared.navTitleLabel.text = playlistName ?? artistName ?? albumName
        ClickViewSingleton.shared.delegate = self
    }
    
    override func inButtonSelected() {
        if tableView.indexPathForSelectedRow?.row == nil { return }
        performSegue(withIdentifier: "playerVC", sender: nil)
    }
    
    override func menuSelected() {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let row = tableView.indexPathForSelectedRow?.row,
            mediaItems != nil else { return }
        
        let destination = segue.destination as? PlayerViewController
        Model.shared.musicPlayerManager.selectedRow = row
        
        switch viewType {
        case .playlist:
            destination?.playlistName = playlistName
            destination?.viewType = .playlist
        case .artist:
            destination?.artistName = artistName
            destination?.viewType = .artist
        case .album:
            destination?.albumName = albumName
            destination?.viewType = .album
        case .song, .nowPlaying:
            break
        }
    }
}
