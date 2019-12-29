//
//  MainMenu2VC.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/21/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import UIKit

class MusicMenuVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuSelection = [
               "Playlists",
               "Artists",
               "Albums",
               "Songs"
           ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iPodNavigationBar.shared.navTitleLabel.text = "Music"
        ClickViewSingleton.shared.delegate = self
    }
    
    override func inButtonSelected() {
        guard tableView.indexPathForSelectedRow?.row != nil else { return }
        performSegue(withIdentifier: "playlistVC", sender: nil)
    }
    
    override func menuSelected() {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? PlaylistViewController
        
        switch tableView.indexPathForSelectedRow!.row {
        case 0:
            destination?.viewType = .playlist
        case 1:
            destination?.viewType = .artist
        case 2:
            destination?.viewType = .album
        case 3:
            destination?.viewType = .song
        default:
            break
        }
        
    }

}
