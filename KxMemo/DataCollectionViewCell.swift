//
//  DataCollectionViewCell.swift
//  KxMemo
//
//  Created by 강명진 on 2020/02/21.
//  Copyright © 2020 myoungjin. All rights reserved.
//

import UIKit

protocol DataCollectionProtocol{
//    func passData(indx: Int)
    func deleteData(indx: Int)
}

class DataCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    var delegate : DataCollectionProtocol?
    var index: IndexPath?
    
    @IBAction func btnAction(_ sender: Any) {
        delegate?.deleteData(indx: (index?.row)!)
    }
    //    var delegate :  DataCollectionProtocol?
//    var index: IndexPath?
}
