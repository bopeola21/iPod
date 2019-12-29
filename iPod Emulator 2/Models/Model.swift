//
//  Model.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/22/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import Foundation
import StoreKit
import MediaPlayer

private let _shared: Model = Model()

class Model {
    
    public class var shared: Model {
      return _shared
    }
    
    let developerToken = ""
    let controller = SKCloudServiceController()
    let network = Network()
    let devToken = Helper.contentsForFile("devToken")
    var userToken: String?
    var storeFront: String?
    let musicPlayerManager = MusicPlayerManager()

    func getUserToken(_ completion: ((String?) -> Void)?) {
        let status = SKCloudServiceController.authorizationStatus()
        let saveKey = "userMusicToken"
        
        if status == .authorized {
            Model.shared.userToken = UserDefaults.standard.object(forKey: saveKey) as? String
            completion?(Model.shared.userToken)
            return
        }
        
        SKCloudServiceController.requestAuthorization { [weak self] (status: SKCloudServiceAuthorizationStatus) in
            if status == .authorized {
                self?.controller.requestUserToken(forDeveloperToken: Model.shared.devToken) { (token: String?, error: Error?) in
                    Model.shared.userToken = token
                    UserDefaults.standard.set(token, forKey: saveKey)
                    completion?(token)
                }
            }
        }
    }
    
    func getStoreFront(_ completion: ((String?) -> Void)?) {
        controller.requestStorefrontCountryCode { (code: String?, error: Error?) in
            Model.shared.storeFront = code
            completion?(code)
        }
    }
    
    func requestPlaylist() -> [MPMediaItemCollection] {
        let playlistQuery = MPMediaQuery.playlists()
        let playlistItems: [MPMediaItemCollection] = playlistQuery.collections! as [MPMediaItemCollection]
        return playlistItems
    }
    
    func requestArtists() -> [MPMediaItemCollection] {
        let artistQuery = MPMediaQuery.artists()
        let artistItems: [MPMediaItemCollection] = artistQuery.collections! as [MPMediaItemCollection]
        return artistItems
    }
    
    func requestAlbums() -> [MPMediaItemCollection] {
        let query = MPMediaQuery.albums()
        let items: [MPMediaItemCollection] = query.collections! as [MPMediaItemCollection]
        return items
    }
    
    func requestSongs() -> [MPMediaItemCollection] {
        let query = MPMediaQuery.songs()
        let items: [MPMediaItemCollection] = query.collections! as [MPMediaItemCollection]
        return items
    }
    
    func requestPlaylistSongs(playlistName: String) -> [MPMediaItem] {
        let playlistPred = MPMediaPropertyPredicate(value: playlistName, forProperty: MPMediaPlaylistPropertyName)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate( playlistPred )
        let items: [MPMediaItem] = query.items! as [MPMediaItem]
        return items
    }
    
    func requestArtistSongs(playlistName: String) -> [MPMediaItem] {
        let playlistPred = MPMediaPropertyPredicate(value: playlistName, forProperty: MPMediaItemPropertyArtist)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate( playlistPred )
        let items: [MPMediaItem] = query.items! as [MPMediaItem]
        return items
    }
    
    func requestAlbumSongs(playlistName: String) -> [MPMediaItem] {
        let playlistPred = MPMediaPropertyPredicate(value: playlistName, forProperty: MPMediaItemPropertyAlbumTitle)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate( playlistPred )
        let items: [MPMediaItem] = query.items! as [MPMediaItem]
        return items
    }
    
    func requestAllSong() -> [MPMediaItem] {
        let query = MPMediaQuery.songs()
        let items: [MPMediaItem] = query.items! as [MPMediaItem]
        return items
    }
    
    func requestSong(playlistName: String) -> [MPMediaItem] {
        let pred = MPMediaPropertyPredicate(value: playlistName, forProperty: MPMediaItemPropertyTitle)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate( pred )
        let items: [MPMediaItem] = query.items! as [MPMediaItem]
        return items
    }
    
    func playlistQuery(playlistName: String) -> MPMediaQuery {
        let pred = MPMediaPropertyPredicate(value: playlistName, forProperty: MPMediaPlaylistPropertyName)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(pred)
        
        return query
    }
    
    func artistQuery(playlistName: String) -> MPMediaQuery {
        let pred = MPMediaPropertyPredicate(value: playlistName, forProperty: MPMediaItemPropertyArtist)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(pred)
        
        return query
    }
    
    func albumQuery(playlistName: String) -> MPMediaQuery {
        let pred = MPMediaPropertyPredicate(value: playlistName, forProperty: MPMediaItemPropertyAlbumTitle)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(pred)
        
        return query
    }
    
    func songQuery(name: String) -> MPMediaQuery {
        let pred = MPMediaPropertyPredicate(value: name, forProperty: MPMediaItemPropertyTitle)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(pred)
        
        return query
    }
    
    func allSongQuery() -> MPMediaQuery {
        let query = MPMediaQuery.songs()
        return query
    }
    
    func requesCloudPlaylist(completion: @escaping ([Playlist]?) -> Void) {
        if let token = Model.shared.userToken {
            let request = Request(urlString: "me/library/playlists", authHeader: Model.shared.devToken, userTokenHeader: token)
            network.request(request: request) { (dict: [String : Any]?, error: Error?) in
                if let data = dict?["data"] as? [[String : Any]] {
                    let playlist = data.map({Playlist($0)})
                    completion(playlist)
                }
            }
        }
    }
    
    func requesCloudtPlaylistSongs(id: String, completion: @escaping ([Song]?) -> Void) {
        if let token = Model.shared.userToken {
            let request = Request(urlString: "me/library/playlists/\(id)/tracks", authHeader: Model.shared.devToken, userTokenHeader: token)
            network.request(request: request) { (dict: [String : Any]?, error: Error?) in
                if let data = dict?["data"] as? [[String : Any]] {
                    let songs = data.map({Song($0)})
                    completion(songs)
                }
            }
        }
    }
    
    func requesCloudLibrarySong(id: String, completion: @escaping ([Song]?) -> Void) {
        if let token = Model.shared.userToken {
            let request = Request(urlString: "me/library/songs/\(id)", authHeader: Model.shared.devToken, userTokenHeader: token)
            network.request(request: request) { (dict: [String : Any]?, error: Error?) in
                if let data = dict?["data"] as? [[String : Any]] {
                    let songs = data.map({Song($0)})
                    completion(songs)
                }
            }
        }
    }
}

