//
//  BaseViewController.swift
//  iPod Emulator 2
//
//  Created by Jide Opeola on 12/21/19.
//  Copyright © 2019 Greetings With Crypto. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ClickWheelViewDelegate {
    enum ScrollDirection {
        case up
        case down
    }
    
    @IBOutlet weak var tableView: UITableView!
    var scrollDirection: ScrollDirection  = .down
    var lastScrollValue: Int = 0
    var selectedRow : Int = 0
    
    var menuSelection = [String]()
    var firstLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        ClickViewSingleton.shared.buttonIsEnabled = true
        
        if !menuSelection.isEmpty && firstLoad {
            firstLoad = false
            selectTopCell()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ClickViewSingleton.shared.buttonIsEnabled = false
    }
    
    func selectTopCell() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
    }
    
    func clickWheelBegan(value: Int) {
        
    }
    
    func clickWheelValue(value: Int) {
        scrollDirection = lastScrollValue < value ? .down : .up
        
        if lastScrollValue + 4 >= value && scrollDirection == .down  {
            let nextRow = selectedRow + 1
            if nextRow >= menuSelection.count {
                return
            }
            
            selectedRow = nextRow

        } else if lastScrollValue - 4 <= value && scrollDirection == .up  {
            let nextRow = selectedRow - 1
            if nextRow < 0 {
                return
            }
            
            selectedRow = nextRow
        }
        
        
        let indexPath = IndexPath(row: selectedRow, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.middle)
        
        lastScrollValue = value
    }
    
    func clickWheelEnded(value: Int) {
        
    }
    
    func playPauseSelected() {
        Model.shared.musicPlayerManager.togglePlayPause()
    }
    
    func fastForwardSelected() {
        Model.shared.musicPlayerManager.skipToNextItem()
    }
    
    func rewindSelected() {
        Model.shared.musicPlayerManager.skipBackToBeginningOrPreviousItem()
    }
    
    func menuSelected() {
        
    }
    
    func inButtonSelected() {
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        
        switch row {
        case 0:
            performSegue(withIdentifier: "musicMenuVC", sender: nil)
        default:
            break
        }
    }
}

extension BaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuSelection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainCell
        cell.titleLabel.text = menuSelection[indexPath.row]
        
        return cell
    }
}
