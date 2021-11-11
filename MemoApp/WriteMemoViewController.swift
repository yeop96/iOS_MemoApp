//
//  WriteMemoViewController.swift
//  MemoApp
//
//  Created by yeop on 2021/11/11.
//

import UIKit
import RealmSwift
import MobileCoreServices

class WriteMemoViewController: UIViewController {
    let localRealm = try! Realm()
    var tasks: Results<MemoList>!
    
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
        //text 파일을 저장 하고 뿌리기
        //파일 경로 가져오기
//        let fileName = (documentDirectoryPath()! as NSString).appendingPathComponent("MemoAppText.txt")
//        let fileURL = URL(fileURLWithPath: fileName)
//        let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
//
//        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func saveButtonClicked(){
        var title = ""
        var content = ""
        //공백일 경우
        if memoTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            print("sadasd")
            return
        }
        // 한줄일 경우
        else if !memoTextView.text!.contains("\n"){
            title = memoTextView.text!
        }
        // 개행 있을 경우
        else{
            title = String(memoTextView.text!.split(separator: "\n").first!) //첫번째 줄만
            content = String(memoTextView.text!.dropFirst(title.count+1)) // 제목 자르고 넣어야함 추후 수정
        }
        
        let task = MemoList(memoTitle: title, memoContent: content, memoAll: memoTextView.text, favorite: false, regDate: Date())
                    
        try! localRealm.write {
            localRealm.add(task)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //도큐먼트 폴더 위치
    func documentDirectoryPath() -> String?{
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first{
            return directoryPath
        }
        else{
            return nil
        }
    }


}


extension WriteMemoViewController: UITextFieldDelegate{
    
}
