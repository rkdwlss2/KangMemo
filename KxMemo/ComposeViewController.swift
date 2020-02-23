//
//  ComposeViewController.swift
//  KxMemo
//
//  Created by 강명진 on 2020/02/16.
//  Copyright © 2020 myoungjin. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    let picker = UIImagePickerController()
    
    var imgArr : [UIImage] = []
    var editTarget: Memo?
    var originalMemoContent: String?
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
//    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func addAction(_ sender: Any) {
        let alert = UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default){
            (action) in self.openLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default){
            (action) in self.openCamera()
        }
        let url = UIAlertAction(title: "URL", style: .default){
            (action) in self.openURL()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        
        alert.addAction(camera)
        alert.addAction(url)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker,animated: false,completion: nil)
    }
    func openCamera(){
        if (UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker,animated: false,completion: nil)
        }
        else{
            print("Camera not available")
        }
        
    }
    func openURL(){
        var urlkey = "https://i.ibb.co/fN6VCxh/2020-02-23-8-18-16.png"
        let alert = UIAlertController(title: "alert", message: "textField", preferredStyle: .alert)
        alert.addTextField()
                let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
                    urlkey = (alert.textFields?[0].text)!
                if let url1 = URL(string: urlkey){
                            do {
                                let data = try Data(contentsOf: url1)
                                if let image = UIImage(data: data){
                                    self.imgArr.append(image)}
                //                picker.sourceType = UIImage(data
                //                present(picker,animated: false,completion: nil)
                                self.collectionView.reloadData()
                            }catch let err{
                                print(" Error : \(err.localizedDescription)")
                            }
                        }
        }
                let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in
                     //code
                }
                alert.addAction(cancel)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)

        
        
        
    }
   
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBAction func save(_ sender: Any) {
        guard let memo = memoTextView.text,
            memo.count > 0 else {
//                alert(message: "메모를 입력하세요");
//                return
                let alert = UIAlertController(title: "부탁드립니다", message: "메모를 입력하세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                present(alert,animated: true, completion: nil)
                return
        }
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        
        if let target = editTarget{
            target.content=memo

            DataManger.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange, object: nil)
        } else{
            var imageData : [Data] = []
            for i in 0..<imageData.count {
                imageData.append(imgArr[i].pngData()! as Data)
            }
//             let imageData:NSData = imgArr[0].pngData()! as NSData
            DataManger.shared.addNewMemo(memo,imageData)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert,object: nil)
        }
        
        
       
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo = editTarget{
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            originalMemoContent=memo.content
        }else{
            navigationItem.title = "새메모"
            memoTextView.text = ""
        }
        
        memoTextView.delegate=self
        picker.delegate=self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.presentationController?.delegate=self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.presentationController?.delegate=nil
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

extension ComposeViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text{
            if #available(iOS 13.0, *) {
                isModalInPresentation = original != edited
            } else {
                // Fallback on earlier versio ns
            }
        }
        
    }
}

extension ComposeViewController: UIAdaptivePresentationControllerDelegate{
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "알림", message: "편집한 내용을 저장할까요?", preferredStyle: .alert)
    
        let okAction = UIAlertAction(title: "확인", style: .default){
            [weak self] (action) in
            self?.save(action)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel){
            [weak self] (action) in
            self?.close(action)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}


extension ComposeViewController{
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidChange = Notification.Name(rawValue: "memoDidChange")
}

extension ComposeViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imgArr.append(image)
            if let png = image.pngData(){
                DatabaseHelper.instance.saveImageinCoredata(at: png)
            }
            
            
//            let imageData:NSDate = UIImagePNGRepresentation(image)! as NSDate
            
//            imageView.image = image
            //            imageView.image = image
            collectionView.reloadData()
//            print(info)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ComposeViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DataCollectionViewCell
        cell?.img.image = imgArr[indexPath.row]
        cell?.index=indexPath
        cell?.delegate = self
        return cell!
    }
    
}

extension ComposeViewController: DataCollectionProtocol{
    
    func deleteData(indx: Int){
        imgArr.remove(at: indx)
        collectionView.reloadData()
    }
}
