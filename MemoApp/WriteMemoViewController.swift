//
//  WriteMemoViewController.swift
//  MemoApp
//
//  Created by yeop on 2021/11/11.
//

import UIKit

class WriteMemoViewController: UIViewController {
    
    @IBOutlet weak var memoTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var items: [UIBarButtonItem] = []

        let saveItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonClicked))

        let shareItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))

        items.append(saveItem)
        items.append(shareItem)

        items.forEach { (item) in
            item.tintColor = .orange
        }

        navigationItem.rightBarButtonItems = items
        
        self.navigationController?.navigationBar.tintColor = .orange

                
    }
    
    @objc func shareButtonClicked(){
        print(#function)
    }
    
    @objc func saveButtonClicked(){
        print(#function)
    }
    
    


}
