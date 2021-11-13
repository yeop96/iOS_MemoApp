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
        saveTextFile()
        presentActivityViewController()
        //text 파일을 저장 하고 뿌리기
    }
    
    @objc func saveButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveTextFile() {
        let filename = getDocumentsDirectory().appendingPathComponent("memo.txt")
        do {
            try memoTextView.text!.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("error")
        }
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
    func presentActivityViewController() {
        let fileName = (documentDirectoryPath()! as NSString).appendingPathComponent("memo.txt")
        let fileURL = URL(fileURLWithPath: fileName)
        let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }


}


