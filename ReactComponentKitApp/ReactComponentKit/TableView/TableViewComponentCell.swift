//
//  ComponentTableViewCell.swift
//  ReactComponentKitApp
//
//  Created by burt on 2018. 7. 29..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit

internal class TableViewComponentCell: UITableViewCell {
    
    var rootComponentView: UIViewComponent? {
        didSet {
            guard rootComponentView != nil else { return }
            rootComponentView?.removeFromSuperview()
            installRootComponentView()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return rootComponentView?.contentSize ?? .zero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rootComponentView?.prepareForReuse()
    }

    private func installRootComponentView() {
        guard let rootComponentView = rootComponentView else { return }
        self.addSubview(rootComponentView)
        rootComponentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rootComponentView.topAnchor.constraint(equalTo: self.topAnchor),
            rootComponentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rootComponentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            rootComponentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
