//
//  DetailViewController.swift
//  KxMemo
//
//  Created by 강명진 on 2020/02/17.
//  Copyright © 2020 myoungjin. All rights reserved.
//

import UIKit
import CoreData

class imageCell: UITableViewCell{

    @IBOutlet weak var myImage: UIImageView!
    
}

class DetailViewController: UIViewController{
    
    @IBOutlet weak var memoTableView: UITableView!
    
    var memoarr = [Memo]()
    var memo: Memo?

    let formatter: DateFormatter={
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "삭제확인", message: "메모를 삭제할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "삭제", style: .destructive){
            [weak self] (action) in
            DataManger.shared.deleteMemo(self?.memo)
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert,animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as?
        ComposeViewController {
            vc.editTarget = memo
        }
    }
    
    var token: NSObjectProtocol?
    
    deinit {
        if let token = token{
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self as? UITableViewDelegate
//        tableView.dataSource = self
        memoTableView.dataSource = self;
        memoTableView.delegate = self as? UITableViewDelegate
        token=NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChange, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            self?.memoTableView.reloadData()
        })
        func numberOfSections(in tableView: UITableView) -> Int{
            return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return memo?.imag?.count ?? 0
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let num : Int = memo?.imag?.count else { return 0 }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            
            cell.textLabel?.text = memo?.content
            
            return cell
        case 1:
             let arr = DatabaseHelper.instance.getAllImages()
//            let arr1 = DataManger.shared.getAllImages()
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            cell.textLabel?.text = formatter.string(for: memo?.insertDate) //되는것
//            cell.imageView?.image = UIImage(data: arr1[0].imag!)
//            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
                       
//            cell.imageView?.image = UIImage(data: arr1[0].imag!)
             cell.imageView?.image = UIImage(data: arr[0].img!) //되는것

            
            
//            var imgArr : [Data] = []
//            imgArr.append((memo?.imag?[0])!)
//            cell.imageView?.image = UIImage(data: memo!.imag?[indexPath.row])
//            cell.imageView?.image = UIImage(data : ((memo?.imag?[indexPath.row])!))
            return cell
       
        default:
            fatalError()
        }
    }
}

