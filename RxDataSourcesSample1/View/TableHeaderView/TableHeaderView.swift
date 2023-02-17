//
//  TableHeaderView.swift
//  RxDataSourcesSample1
//
//  Created by 鈴木楓香 on 2023/02/17.
//

import UIKit
import RxSwift
import RxCocoa

class TableHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var swiftButton: UIButton!
    var viewModel: ViewModel!
    
    func setup(sectionName: String, viewModel: ViewModel) {
        headerImage.image = UIImage(systemName: "swift")
        headerLabel.text = sectionName
        swiftButton.layer.cornerRadius = 5
        // タップで新規データを保存する
        self.viewModel = viewModel
        swiftButton.addTarget(self, action: #selector(tapSwift), for: .touchUpInside)
    }
    
    @objc func tapSwift() {
        viewModel.addSwiftData()
    }
}
