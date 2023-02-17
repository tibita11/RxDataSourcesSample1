//
//  TableHeaderView.swift
//  RxDataSourcesSample1
//
//  Created by 鈴木楓香 on 2023/02/17.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var swiftButton: UIButton!
    
    func setup(sectionName: String) {
        headerImage.image = UIImage(systemName: "swift")
        headerLabel.text = sectionName
        swiftButton.layer.cornerRadius = 5
        swiftButton.addTarget(self, action: #selector(tapSwift), for: .touchUpInside)
    }
    
    @objc private func tapSwift() {
        print("Swiftボタンをタップしました。")
    }

}
