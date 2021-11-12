//
//  MemoViewController.swift
//  MemoApp
//
//  Created by yeop on 2021/11/08.
//

import UIKit
import RealmSwift
import Toast

class MemoViewController: UIViewController {
    let localRealm = try! Realm()
    var tasks: Results<MemoList>!
    var favoriteTasks: Results<MemoList>!
    var allTasks: Results<MemoList>!
    var searchController:  UISearchController!
    var searchText = ""
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .systemOrange
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
    
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let memoCount = numberFormatter.string(for: localRealm.objects(MemoList.self).count)!
        navigationItem.title = "\(memoCount)개의 메모"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 할 때 서치부분은 남겨두기
        
        toolbarSetting()
        
        let backBarButtonItem = UIBarButtonItem(title: "메모", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .systemOrange
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        //memo 데이터 가져오기
        favoriteTasks = localRealm.objects(MemoList.self).filter("favorite == true").sorted(byKeyPath: "regDate", ascending: false)
        tasks = localRealm.objects(MemoList.self).filter("favorite == false").sorted(byKeyPath: "regDate", ascending: false) // 최근 등록일 순
        allTasks = localRealm.objects(MemoList.self).sorted(byKeyPath: "regDate", ascending: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let memoCount = numberFormatter.string(for: localRealm.objects(MemoList.self).count)!
        navigationItem.title = "\(memoCount)개의 메모"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.reloadData()
    }
    
    //밑에 툴바 만들기
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
    
    
    // 메모 버튼 클릭시 메모 작성 화면으로
    @objc func writeMemoButtonClicked(){
        let storyboard = UIStoryboard(name: "WriteMemo", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WriteMemoViewController") as! WriteMemoViewController
        
        //뒤로 왔을 시 저장
        vc.backActionHandler = {
            var title = ""
            var content = ""
            //공백일 경우
            if vc.memoTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                return
            }
            // 한줄일 경우
            else if !vc.memoTextView.text!.contains("\n"){
                title = vc.memoTextView.text!
            }
            // 개행 있을 경우
            else{
                title = String(vc.memoTextView.text!.split(separator: "\n").first!) //첫번째 줄만
                content = String(vc.memoTextView.text!.dropFirst(title.count+1)) // 제목 자르고 넣음
            }
            
            let task = MemoList(memoTitle: title, memoContent: content, memoAll: vc.memoTextView.text, favorite: false, regDate: Date())
                        
            try! self.localRealm.write {
                self.localRealm.add(task)
                self.tableView.reloadData()
            }
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

}


extension MemoViewController: UISearchBarDelegate, UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        allTasks = localRealm.objects(MemoList.self).filter("memoAll CONTAINS '\(searchController.searchBar.text!)'").sorted(byKeyPath: "regDate", ascending: false)
        searchText  = searchController.searchBar.text!
        tableView.reloadData()
    }
    
    //검색 버튼(키보드 리턴키)을 눌렀을 때 실행
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    //취소 버튼 눌렀을 때 실행
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //서치바에 커서 깜빡이기 시작할 때
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
    
}

extension MemoViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering() ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return isFiltering() ? allTasks.count : favoriteTasks.count
        }
        else{
            return tasks.count
        }
    }
    
    //헤더 제목
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       if section == 0{
           return isFiltering() ? "\(allTasks.count)개 찾음" : "고정된 메모"
        }
        else if section == 1{
            return "메모"
        }
        return nil
    }
    
    //헤더뷰 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as? HeaderTableViewCell else{
            return UITableViewCell()
        }
        cell.headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        cell.headerLabel.font = UIFont.boldSystemFont(ofSize: 23)

        return cell.contentView
    }
    
    
    //셀 row 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let row = isFiltering() ? allTasks[indexPath.row] : favoriteTasks[indexPath.row]

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell") as? MemoTableViewCell else{
                return UITableViewCell()
            }
            let format = DateFormatter()
            format.dateFormat = "yyyy. MM. dd. a hh:mm"
            
            //calendar
            let calendarDate = Calendar.current
            //월요일 구하기
            var component = calendarDate.dateComponents([.weekOfYear, .yearForWeekOfYear, .weekday], from: Date())
            component.weekday = 2
            let mondayWeek = calendarDate.date(from: component)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            formatter.locale = Locale(identifier:"ko_KR")
            let tempRegDate = formatter.string(from: row.regDate)
            
            for i in 0...6{
                let week = calendarDate.date(byAdding: .day , value: i, to: mondayWeek!)
                let weekStr = formatter.string(from: week!)
                
                if tempRegDate == weekStr{
                    format.dateFormat = "EEEE"
                }
            }
            
            format.locale = Locale(identifier:"ko_KR")
            let regDate = format.string(from: row.regDate)
            
            cell.memoTitleLabel.text = row.memoTitle
            cell.memoDateLabel.text = regDate
            cell.memoContentLabel.text = row.memoContent
            if isFiltering() && !searchBarIsEmpty() {
                cell.memoTitleLabel.highlight(searchText: searchText, color: .systemOrange)
                cell.memoContentLabel.highlight(searchText: searchText, color: .systemOrange)
            } else if !isFiltering() {
                cell.memoTitleLabel.nohighlight(color: .label)
                cell.memoContentLabel.nohighlight(color: .lightGray)
            }
            let cnt = isFiltering() ? allTasks.count : favoriteTasks.count
            if cnt == 1{
                cell.memoView.layer.cornerRadius = 15
            }
            else if indexPath.row == 0{
                cell.memoView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner ])
            }
            else if indexPath.row == cnt - 1{
                cell.memoView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ])
            }
            
            
            return cell
        }
        else{
            let row = tasks[indexPath.row]
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell") as? MemoTableViewCell else{
                return UITableViewCell()
            }
            
            let format = DateFormatter()
            format.dateFormat = "yyyy. MM. dd. a hh:mm"
            
            //calendar
            let calendarDate = Calendar.current
            //월요일 구하기
            var component = calendarDate.dateComponents([.weekOfYear, .yearForWeekOfYear, .weekday], from: Date())
            component.weekday = 2
            let mondayWeek = calendarDate.date(from: component)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            formatter.locale = Locale(identifier:"ko_KR")
            let tempRegDate = formatter.string(from: row.regDate)
            
            for i in 0...6{
                let week = calendarDate.date(byAdding: .day , value: i, to: mondayWeek!)
                let weekStr = formatter.string(from: week!)
                
                if tempRegDate == weekStr{
                    format.dateFormat = "EEEE"
                }
            }
            
            format.locale = Locale(identifier:"ko_KR")
            let regDate = format.string(from: row.regDate)
            
            cell.memoTitleLabel.text = row.memoTitle
            cell.memoDateLabel.text = regDate
            cell.memoContentLabel.text = row.memoContent
            
            if tasks.count == 1{
                cell.memoView.layer.cornerRadius = 15
            }
            else if indexPath.row == 0{
                cell.memoView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner ])
            }
            else if indexPath.row == tasks.count - 1{
                cell.memoView.roundCorners(cornerRadius: 15, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner ])
            }
            
            
            return cell
        }
    }
    
    //셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    //헤더 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //셀 선택시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "WriteMemo", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WriteMemoViewController") as! WriteMemoViewController
        
        var taskUpdate = tasks[indexPath.row]
        if indexPath.section == 0{
            taskUpdate = isFiltering() ? allTasks[indexPath.row] : favoriteTasks[indexPath.row]
        }
        
        vc.memoContentAll = taskUpdate.memoAll
        
        //뒤로 왔을 시 수정
        vc.backActionHandler = {
            var title = ""
            var content = ""
            
            //공백일 경우
            if vc.memoTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                try! self.localRealm.write{
                    self.localRealm.delete(taskUpdate)
                    tableView.reloadData()
                }
                return
            }
            //수정했는데 같을 경우
            else if taskUpdate.memoAll == vc.memoTextView.text{
                return
            }
            // 한줄일 경우
            else if !vc.memoTextView.text!.contains("\n"){
                title = vc.memoTextView.text!
            }
            // 개행 있을 경우
            else{
                title = String(vc.memoTextView.text!.split(separator: "\n").first!) //첫번째 줄만
                content = String(vc.memoTextView.text!.dropFirst(title.count+1)) // 제목 자르고 넣음
            }
                        
            try! self.localRealm.write {
                taskUpdate.memoTitle = title
                taskUpdate.memoContent = content
                taskUpdate.memoAll = vc.memoTextView.text
                taskUpdate.regDate = Date()
            
                self.tableView.reloadData()
            }
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //삭제 스와이프
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        var row = indexPath.section == 0 ? favoriteTasks[indexPath.row] : tasks[indexPath.row]
        if isFiltering(){
            row = allTasks[indexPath.row]
        }
        
        let alert = UIAlertController(title: row.memoTitle, message: "메모를 삭제해도 되나요?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "예", style: .default){ (action) in
            
            try! self.localRealm.write{
                self.localRealm.delete(row)
                tableView.reloadData()
            }
            
            return
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel){ (action) in
            return
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    //즐겨찾기
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        //고정되어있는 섹션
        if indexPath.section == 0 && !searchController.isActive{
            let favoriteAction = UIContextualAction(style: .normal, title: "", handler: { action, view, completionHaldler in
                completionHaldler(true)
                let taskUpdate = self.favoriteTasks[indexPath.row]
                try! self.localRealm.write{
                    taskUpdate.favorite = !taskUpdate.favorite
                    tableView.reloadData()
                }
            })
            favoriteAction.backgroundColor = .systemOrange
            favoriteAction.image = UIImage(systemName: "pin.slash.fill")
            
            return UISwipeActionsConfiguration(actions: [favoriteAction])
            
        }
        
        //고정되지 않은 섹션
        else if indexPath.section == 1{
            let favoriteAction = UIContextualAction(style: .normal, title: "", handler: { action, view, completionHaldler in
                completionHaldler(true)
                //5개까지 가능
                if self.favoriteTasks.count >= 5{
                    self.view.makeToast("고정된 메모는 5개까지 가능합니다.", duration: 3.0, position: .top)
                    return
                }
                let taskUpdate = self.tasks[indexPath.row]
                try! self.localRealm.write{
                    taskUpdate.favorite = !taskUpdate.favorite
                    tableView.reloadData()
                }
            })
            favoriteAction.backgroundColor = .systemOrange
            favoriteAction.image = UIImage(systemName: "pin.fill")
            
            return UISwipeActionsConfiguration(actions: [favoriteAction])
        }
        else{
            let row = allTasks[indexPath.row]
            let favoriteAction = UIContextualAction(style: .normal, title: "", handler: { action, view, completionHaldler in
                completionHaldler(true)
                
                if row.favorite{
                    try! self.localRealm.write{
                        row.favorite = !row.favorite
                        tableView.reloadData()
                    }
                }
                else{
                    if self.favoriteTasks.count >= 5{
                        self.view.makeToast("고정된 메모는 5개까지 가능합니다.", duration: 3.0, position: .top)
                        return
                    }
                    try! self.localRealm.write{
                        row.favorite = !row.favorite
                        tableView.reloadData()
                    }
                }
                
            })
            favoriteAction.backgroundColor = .systemOrange
            favoriteAction.image = row.favorite ? UIImage(systemName: "pin.slash.fill") : UIImage(systemName: "pin.fill")
            
            return UISwipeActionsConfiguration(actions: [favoriteAction])
        }
        
    }
    
}


//헤더로 사용할 셀
class HeaderTableViewCell: UITableViewCell{
    
    @IBOutlet weak var headerLabel: UILabel!
    
}



//메모 미리보기 셀
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




