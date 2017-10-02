//
//  TableViewCell.swift
//  TagsView
//
//  Created by Tomoki Koga on 2017/03/08.
//  Copyright © 2017年 tomoponzoo. All rights reserved.
//

import UIKit
import TagsView

protocol TableViewCellDelegate: class {
    func tableViewCell(_ cell: TableViewCell, tagsView: TagsView, didSelectItemAt index: Int)
    func tableViewCell(_ cell: TableViewCell, didSelectSupplymentaryItemInTagsView tagsView: TagsView)
}

class TableViewCell: UITableViewCell {
    @IBOutlet weak var tagsView: TagsView! {
        didSet {
            tagsView.registerTagView(nib: UINib(nibName: "TagViewEx", bundle: nil))
            tagsView.registerSupplymentaryTagView(nib: UINib(nibName: "SupplymentaryTagViewEx", bundle: nil))
            tagsView.dataSource = self
            tagsView.delegate = self
            tagsView.allowsMultipleSelection = true
        }
    }
    
    weak var delegate: TableViewCellDelegate?
    var viewModel: ViewModel?
    
    func updateCell(viewModel: ViewModel) {
        self.viewModel = viewModel
        tagsView.reloadData(identifier: viewModel.identifier)
    }
}

extension TableViewCell: TagsViewDataSource {
    func numberOfRows(in tagsView: TagsView) -> Rows {
        return viewModel?.rows ?? .infinite
    }
    
    func numberOfTags(in tagsView: TagsView) -> Int {
        return viewModel?.strings.count ?? 0
    }
    
    func alignment(in tagsView: TagsView) -> Alignment {
        return .left
    }
    
    func padding(in tagsView: TagsView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func spacer(in tagsView: TagsView) -> Spacer {
        return Spacer(vertical: 4, horizontal: 4)
    }
    
    func isVisibleSupplymentaryTagView(in tagsView: TagsView, rows: Rows, row: Int, hasNextRow: Bool) -> Bool {
        switch rows {
        case .infinite:
            return row > 0
            
        case .rows(_):
            return hasNextRow
        }
    }
   
    func tagsView(_ tagsView: TagsView, viewForIndexAt index: Int) -> TagView? {
        let tagView = tagsView.dequeueReusableTagView(for: index) as? TagViewEx
        tagView?.string = viewModel!.strings[index]
        tagView?.label.text = viewModel!.strings[index]        
        return tagView ?? TagViewEx()
    }
    
    func supplymentaryTagView(in tagsView: TagsView) -> SupplymentaryTagView? {
        let supplymentaryTagView = tagsView.dequeueReusableSupplymentaryTagView() as? SupplymentaryTagViewEx
        return supplymentaryTagView
    }
}

extension TableViewCell: TagsViewDelegate {
    func tagsView(_ tagsView: TagsView, didSelectItemAt index: Int) {
        print("Select:\(index)")
        delegate?.tableViewCell(self, tagsView: tagsView, didSelectItemAt: index)
    }
    
    func didSelectSupplymentaryItem(_ tagsView: TagsView) {
        print("Supplymentary select")
        delegate?.tableViewCell(self, didSelectSupplymentaryItemInTagsView: tagsView)
    }
}
