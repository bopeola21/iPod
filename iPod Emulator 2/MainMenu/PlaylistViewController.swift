//
//  PlaylistViewController.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/22/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistViewController: BaseViewController {
    
    enum ViewType: String {
        case playlist = "Playlist"
        case artist = "Artist"
        case album = "Album"
        case song = "Songs"
        case nowPlaying = "Now Playing"
    }
    
    var playList: [Playlist]?
    var names: [String]?
    var viewType: ViewType = .playlist

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Model.shared.requestPlaylist { [weak self] (list: [Playlist]?) in
//            guard let list = list else { return }
//            self?.playList = list
//            self?.names = [String](repeating: String(), count: list.count)
//            self?.names = list.compactMap({ String($0.name ?? "No Name") })
//            self?.menuSelection = self?.names ?? [String]()
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//                self?.selectTopCell()
//            }
//        }
        
        
        switch viewType {
        case .playlist:
            let collection = Model.shared.requestPlaylist()
            menuSelection = collection.compactMap({ $0.value(forKey: MPMediaPlaylistPropertyName) as? String })
        case .artist:
            let collection = Model.shared.requestArtists()
            menuSelection = collection.compactMap({ $0.items.first?.value(forKey: MPMediaItemPropertyArtist) as? String })
        case .album:
            let collection = Model.shared.requestAlbums()
            menuSelection = collection.compactMap({ $0.items.first?.value(forKey: MPMediaItemPropertyAlbumTitle) as? String })
        case .song:
            let collection = Model.shared.requestSongs()
            menuSelection = collection.compactMap({ $0.items.first?.value(forKey: MPMediaItemPropertyTitle) as? String })
        case .nowPlaying:
            break
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iPodNavigationBar.shared.navTitleLabel.text = viewType.rawValue
        ClickViewSingleton.shared.delegate = self
    }
    
    override func inButtonSelected() {
        if tableView.indexPathForSelectedRow?.row == nil { return }
        
        if viewType == .song {
            performSegue(withIdentifier: "nowPlaying", sender: nil)
            return
        }
        
        performSegue(withIdentifier: "playlistDetailVC", sender: nil)
    }
    
    override func menuSelected() {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        
        let selectedPlaylist = menuSelection[row]
        let destination = segue.destination as? PlaylistDetailViewController
        destination?.viewType = viewType
        
        switch viewType {
        case .playlist:
            destination?.playlistName = selectedPlaylist
        case .artist:
            destination?.artistName = selectedPlaylist
        case .album:
            destination?.albumName = selectedPlaylist
        case .song:
            let songDestination = segue.destination as? PlayerViewController
            songDestination?.viewType = viewType
            songDestination?.songName = menuSelection[row]
            Model.shared.musicPlayerManager.selectedRow = row //first song, only one in the queue
        case .nowPlaying:
            break
        }
    }
}
