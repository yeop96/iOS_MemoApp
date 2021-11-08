//
//  MemoViewController.swift
//  MemoApp
//
//  Created by yeop on 2021/11/08.
//

import UIKit

class MemoViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

}


extension MemoViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell else{
                            return UITableViewCell()
                        }
            return cell
        }
        else if indexPath.section == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell") as? MemoTableViewCell else{
                            return UITableViewCell()
                        }
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell") as? MemoTableViewCell else{
                            return UITableViewCell()
                        }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
}


class SearchTableViewCell: UITableViewCell{
    
    @IBOutlet weak var memoCountingLabel: UILabel!
    
    @IBOutlet weak var memoSearchBar: UISearchBar!
    
}

class MemoTableViewCell: UITableViewCell{
    @IBOutlet weak var memoTitleLabel: UILabel!
    
    @IBOutlet weak var memoDateLabel: UILabel!
    
    @IBOutlet weak var memoContentLabel: UILabel!
    
}
