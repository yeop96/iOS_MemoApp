//
//  OnBoardingViewController.swift
//  MemoApp
//
//  Created by yeop on 2021/11/13.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 15
        startButton.layer.cornerRadius = 15
        
    }
    
    @IBAction func startButtonClicked(_ sender: UIButton) {
        UserDefaults.standard.set("No", forKey:"isFirstTime")
        dismiss(animated: true, completion: nil)
    }
    

}
