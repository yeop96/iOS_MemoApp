//
//  MemoModel.swift
//  MemoApp
//
//  Created by yeop on 2021/11/11.
//

import Foundation
import RealmSwift // 10.18.0 exact version

//https://docs.mongodb.com/realm/sdk/ios/quick-start 문서

class MemoList: Object {
    @Persisted var memoTitle: String
    @Persisted var memoContent: String
    @Persisted var favorite: Bool
    @Persisted var regDate = Date()
    @Persisted(primaryKey: true) var _pk: ObjectId
    
    convenience init(memoTitle: String, memoContent: String, favorite: Bool, regDate: Date) {
        self.init()
        
        self.memoTitle = memoTitle
        self.memoContent = memoContent
        self.favorite = favorite
        self.regDate = regDate
    }
}
