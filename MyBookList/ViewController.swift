//
//  ViewController.swift
//  MyBookList
//
//  Created by Kio on 28/01/2019.
//  Copyright © 2019 geronimo.software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var topStackView: UIStackView!
    
    fileprivate var masterTableViewController: MasterTableViewController?
    fileprivate var displayViewController: DetailDisplayViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let navigationController = destination as? UINavigationController {
            let tableController = navigationController.viewControllers[0] as! MasterTableViewController
       //     tableController.delegate = self
            masterTableViewController = tableController
        }
        
        if let displayController = destination as? DetailDisplayViewController {
            displayViewController = displayController
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        topStackView.axis = axisForSize(size)
    }
    
    private func axisForSize(_ size: CGSize) -> NSLayoutConstraint.Axis {
        return size.width > size.height ? .horizontal : .vertical
    }
}
