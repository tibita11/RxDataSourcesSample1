//
//  DataStorege.swift
//  RxDataSourcesSample1
//
//  Created by 鈴木楓香 on 2023/02/16.
//

import Foundation
import RxSwift
import RxCocoa


/// 通知処理
struct ViewModelInput {
    let addButton: Observable<Void>
    let itemDeleted: Observable<IndexPath>
    let itemMoved: Observable<ItemMovedEvent>
}

/// UI更新処理
protocol ViewModelOutput {
    var itemsObserver: Observable<[SectionModel]> { get }
}


protocol ViewModelType {
    var output: ViewModelOutput? { get }
    func setup(input: ViewModelInput)
}


class ViewModel: ViewModelType {
    
    var output: ViewModelOutput?
    /// DB操作をするModel
    var model = DataStorage()
    
    let disposeBag = DisposeBag()
    
    init() {
        // 初期設定
        output = self
    }
    
    /// データの変更通知をする
    private var items = BehaviorRelay<[SectionModel]>(value: [])
    
    /// 初期設定
    func setup(input: ViewModelInput) {
        // 新しいSampleDataを追加し、DBに保存する
        input.addButton
            .subscribe(onNext: { [weak self] in
                // 前回値を取得して新規SampleDataを配列に追加
                var section = self!.items.value
                if section.count == 0 {
                    // 登録がない場合
                    let newData = [SectionModel(header: "Section1", items: [SampleData(name: "Sample1")])]
                    section = newData
                } else {
                    // 登録がある場合
                    let index = section[0].items.count + 1
                    let newData = SampleData(name: "Sample\(index)")
                    section[0].items.append(newData)
                }
                // DBに保存
                self!.model.saveData(object: section, key: Const.userDefaulsKey)
                // プロパティを変更
                self!.items.accept(section)
            })
            .disposed(by: disposeBag)
        
        // Index番目を削除し、DBに保存する
        input.itemDeleted
            .subscribe(onNext: { [weak self] index in
                // 前回値を取得してindex番目を削除
                var section = self!.items.value
                section[index.section].items.remove(at: index.row)
                // DBに保存
                self!.model.saveData(object: section, key: Const.userDefaulsKey)
                // プロパティを変更
                self!.items.accept(section)
            })
            .disposed(by: disposeBag)
        
        // sourceIndex番目を削除し、destinationIndex番目に挿入する
        input.itemMoved
            .subscribe(onNext: { [weak self] move in
                let sourceIndex = move.sourceIndex
                let distinationIndex = move.destinationIndex
                // 削除・挿入
                var section = self!.items.value
                let sampleData = section[sourceIndex.section].items[sourceIndex.row]
                section[sourceIndex.section].items.remove(at: sourceIndex.row)
                section[distinationIndex.section].items.insert(sampleData, at: distinationIndex.row)
                // DBに保存
                self!.model.saveData(object: section, key: Const.userDefaulsKey)
                // プロパティを変更
                self!.items.accept(section)

            })
            .disposed(by: disposeBag)
    }
    
    /// DBにSwiftデータを保存する処理
    func addSwiftData() {
        var section = items.value
        let newData = SampleData(name: "Lets'Swift")
        section[0].items.append(newData)
        // DBに保存
        model.saveData(object: section, key: Const.userDefaulsKey)
        // プロパティを変更
        items.accept(section)
    }
    
    
    /// DBから取得する処理
    func getData() {
        model.getData(key: Const.userDefaulsKey)
            .materialize()
            .subscribe(onNext: { [weak self] event in
                // event毎に処理
                switch event {
                case .next:
                    self!.items.accept(event.element!)
                case let .error(error as DBError):
                    // Errorの場合は返さない
                    print(error.localizedDescription)
                case .error, .completed:
                    // Errorの場合は返さない
                    break
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}


// MARK: - DataStoregeOutput

extension ViewModel: ViewModelOutput {
    var itemsObserver: Observable<[SectionModel]> {
        return items.asObservable()
    }
    
    
}
