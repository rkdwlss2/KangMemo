//
//  UIViewController+Alert.swift
//  KxMemo
//
//  Created by 강명진 on 2020/02/16.
//  Copyright © 2020 myoungjin. All rights reserved.
//

import UIKit

extension UIViewController{
    func alert(title: String = "알림", message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction =  UIAlertAction(title: "확인", style: .default, handler: nil)
    
        present(alert, animated: true, completion: nil)
    }
}
