//
//  WriteMemoViewController.swift
//  MemoApp
//
//  Created by yeop on 2021/11/11.
//

import UIKit
import RealmSwift
import MobileCoreServices

class WriteMemoViewController: UIViewController, UITextViewDelegate {
    let localRealm = try! Realm()
    var tasks: Results<MemoList>!
    var memoContentAll = ""
    
    @IBOutlet weak var memoTextView: UITextView!
    
    var backActionHandler: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        memoTextView.delegate = self
        memoTextView.text = memoContentAll
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.memoTextView.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        backActionHandler?()
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
        let alert = UIAlertController(title: "공유", message: "공유는 추후 업데이트 예정입니다.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "확인", style: .default){ (action) in
            return
        }
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func saveButtonClicked(){
        
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


