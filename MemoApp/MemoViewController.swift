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
        
        toolbarSetting()
        
        let backBarButtonItem = UIBarButtonItem(title: "메모", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .systemOrange
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func toolbarSetting(){
        // warning을 막기 위해 임의로 위치와 크기를 잡아준다.
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: 100, height: 100))
        view.addSubview(toolbar)

        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 0).isActive = true
        toolbar.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 0).isActive = true
        toolbar.trailingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.trailingAnchor, multiplier: 0).isActive = true

        var items: [UIBarButtonItem] = []

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        let toolbarItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(writeMemoButtonClicked))

        items.append(flexibleSpace)
        items.append(toolbarItem)

        items.forEach { (item) in
            item.tintColor = .orange
        }

        toolbar.setItems(items, animated: true)
        
    }
    
    @objc func writeMemoButtonClicked(){
        let storyboard = UIStoryboard(name: "WriteMemo", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WriteMemoViewController") as! WriteMemoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}




extension MemoViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else if section == 1{
            return 5
        }
        else{
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return " 개의 메모"
        }
        else if section == 1{
            return "고정된 메모"
        }
        else if section == 2{
            return "메모"
        }
        return nil
    }
    
    //헤더뷰 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let myLabel = UILabel()
//
//        myLabel.frame = section == 0 ? CGRect(x: 20, y: 18, width: UIScreen.main.bounds.width, height: 27) : CGRect(x: 20, y: -4, width: UIScreen.main.bounds.width, height: 37)
//
//        myLabel.font = section == 0 ?  UIFont.boldSystemFont(ofSize: 30) : UIFont.boldSystemFont(ofSize: 23)
//
//        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
//
//        let headerView = UIView()
//        headerView.backgroundColor = .systemBackground
//        headerView.addSubview(myLabel)
//        tableView.addSubview(headerView)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as? HeaderTableViewCell else{
                        return UITableViewCell()
                    }
        cell.headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        cell.headerLabel.font = section == 0 ?  UIFont.boldSystemFont(ofSize: 30) : UIFont.boldSystemFont(ofSize: 23)

        return cell.contentView
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
            if indexPath.row == 0{
                cell.memoView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner ])
            }
            else if indexPath.row == 4{
                cell.memoView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ])
            }
            
            
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell") as? MemoTableViewCell else{
                            return UITableViewCell()
                        }
            
            if indexPath.row == 0{
                cell.memoView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner ])
            }
            else if indexPath.row == 19{
                cell.memoView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ])
            }
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 58 : 67
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 47 : 37
    }
    
}


class HeaderTableViewCell: UITableViewCell{
    
    @IBOutlet weak var headerLabel: UILabel!
    
}

class SearchTableViewCell: UITableViewCell{
    
    @IBOutlet weak var memoSearchBar: UISearchBar!
    
}

class MemoTableViewCell: UITableViewCell{
    @IBOutlet weak var memoTitleLabel: UILabel!
    
    @IBOutlet weak var memoDateLabel: UILabel!
    
    @IBOutlet weak var memoContentLabel: UILabel!
    
    @IBOutlet weak var memoView: UIView!
    
    //dequeueReusableCell로 인한 셀 초기화
    override func prepareForReuse() {
        super.prepareForReuse()
        memoView.layer.cornerRadius = 0
    }
}




