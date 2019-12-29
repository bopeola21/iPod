//
//  MainMenuVC.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/21/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import UIKit
import MediaPlayer

class MainMenuVC: BaseViewController {
    enum ScrollDirection {
        case up
        case down
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuSelection = [
               "Music",
               "Settings",
               "Shuffle Songs",
               "Now Playing"
           ]
        
        
        
//        NSString *playlistName = @"MyPlaylist";
//        MPMediaPropertyPredicate *playlistPredicate = [MPMediaPropertyPredicate predicateWithValue:playlistName
//                                                                                       forProperty:MPMediaPlaylistPropertyName];
//
//        NSNumber *mediaTypeNumber = [NSNumber numberWithInteger:MPMediaTypeMusic]; // == 1
//        MPMediaPropertyPredicate *mediaTypePredicate = [MPMediaPropertyPredicate predicateWithValue:mediaTypeNumber
//                                                                                        forProperty:MPMediaItemPropertyMediaType];
//
//        NSSet *predicateSet = [NSSet setWithObjects:playlistPredicate, mediaTypePredicate, nil];
//        MPMediaQuery *mediaTypeQuery = [[MPMediaQuery alloc] initWithFilterPredicates:predicateSet];
//        [mediaTypeQuery setGroupingType:MPMediaGroupingPlaylist];
//
//
//        let playlistPredicate = MPMediaPropertyPredicate(value: <#T##Any?#>, forProperty: <#T##String#>)
        
        
        
//        let albumsQuery = MPMediaQuery.playlists()
//
//        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
//
//        po albumItems[3]?.value(forKey: MPMediaPlaylistPropertyName)
        
        
//        //  var album: MPMediaItemCollection
//
//          for album in albumItems {
//
//
//
////              let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
////             // var song: MPMediaItem
////
////              var songs: [SongInfo] = []
////
////              var albumTitle: String = ""
////
////              for song in albumItems {
////                  if songCategory == "Artist" {
////                      albumTitle = song.value( forProperty: MPMediaItemPropertyArtist ) as! String
////
////                  } else if songCategory == "Album" {
////                      albumTitle = song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String
////
////
////                  } else {
////                      albumTitle = song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String
////                  }
////
////                  let songInfo: SongInfo = SongInfo(
////                      albumTitle: song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String,
////                      artistName: song.value( forProperty: MPMediaItemPropertyArtist ) as! String,
////                      songTitle:  song.value( forProperty: MPMediaItemPropertyTitle ) as! String,
////                      songId:     song.value( forProperty: MPMediaItemPropertyPersistentID ) as! NSNumber
////                  )
////                  songs.append( songInfo )
////              }
////
////              let albumInfo: AlbumInfo = AlbumInfo(
////
////                  albumTitle: albumTitle,
////                  songs: songs
////              )
////
////              albums.append( albumInfo )
//          }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iPodNavigationBar.shared.navTitleLabel.text = "iPod"
        ClickViewSingleton.shared.delegate = self
    }
    
    override func inButtonSelected() {
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        
        switch row {
        case 0:
            performSegue(withIdentifier: "musicMenuVC", sender: nil)
        case 1,2:
            ClickViewSingleton.shared.buttonIsEnabled = true
        case 3:
            performSegue(withIdentifier: "nowPlaying", sender: nil)
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nowPlaying", let destination = segue.destination as? PlayerViewController {
            destination.viewType = .nowPlaying
        }
    }
}
