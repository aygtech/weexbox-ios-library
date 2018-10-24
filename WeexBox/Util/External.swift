//
//  External.swift
//  WeexBox
//
//  Created by Mario on 2018/8/22.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import MessageUI
import ContactsUI
import TZImagePickerController
import HandyJSON

struct PhotoOption:HandyJSON {
    var count:Int?//张数
    var enableCrop:Bool?//能否剪裁
    var isCircle:Bool?//true为圆
    var width:CGFloat?
    var height:CGFloat?
}
class External: NSObject, MFMessageComposeViewControllerDelegate, CNContactPickerDelegate, TZImagePickerControllerDelegate {
    
    var sendSMSCallback: Result.Callback!
    var pickContactCallback: Result.Callback!
    var getContactsCallback: Result.Callback!
    var openCameraCallback: Result.Callback!
    var openPhotoCallback: Result.Callback!
    var imagePicker:UIImagePickerController = UIImagePickerController();
    // 打开外部浏览器
    static func openBrowser(_ url: String) {
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    
    // 打电话
    static func callPhone(_ phone: String) {
        UIApplication.shared.open(URL(string: "tel://" + phone)!, options: [:], completionHandler: nil)
    }
    
    // 发短信
    func sendSMS(from: UIViewController, recipients: Array<String>, content: String, callback: @escaping Result.Callback) {
        sendSMSCallback = callback
        let messageController = MFMessageComposeViewController()
        messageController.messageComposeDelegate = self
        messageController.recipients = recipients
        messageController.body = content
        from.present(messageController, animated: true, completion: nil)
    }
    
    // 打开通讯录选择联系人
    func pickContact(from: UIViewController, callback: @escaping Result.Callback) {
        pickContactCallback = callback
        let pickerController = CNContactPickerViewController()
        pickerController.delegate = self
        from.present(pickerController, animated: true, completion: nil)
    }
    
    // 获取所有联系人
    func getContacts() {
        
    }
    
    // 拍照
    func openCamera(from: UIViewController,options:Dictionary<String, Any>?,callback: @escaping Result.Callback) {
        openCameraCallback = callback
        let option = PhotoOption.deserialize(from: options)
        let imagePickerVc = TZImagePickerController(maxImagesCount: 1, columnNumber: 4, delegate: self)!
        //圆形裁剪
        imagePickerVc.needCircleCrop = option?.isCircle ?? false
        
        //允许裁剪
        imagePickerVc.allowCrop = option?.enableCrop ?? true
        //把宽度转为半径，不设置尺寸。eg:/2是换算半径。再次/2是px转pt
        if(option?.width != nil){
            imagePickerVc.circleCropRadius = Int(option?.width ?? 60.0)/4
        }
        imagePickerVc.didFinishPickingPhotosWithInfosHandle = { photos, assets, isSelectOriginalPhoto, infos in
            var result = Result()
            let urls = NSMutableArray();
            if(photos != nil && (photos?.count)!>0){
                result.status = Result.success
                result.error = ""
                
                for image in photos!{
                    let path = self.saveImageToSandBox(image: image, fileName: self.getFileName())
                    urls.add(path)
                }
                result.data = ["urls":urls]
                callback(result)
            }
            else{
                result.status = Result.error
                result.error = "无法获取图片路径"
                result.data = ["urls":urls]
                callback(result)
            }
        }
        from.present(imagePickerVc, animated: true, completion: nil)
    }
    
    // 选择图片
    func openPhoto(from: UIViewController, options:Dictionary<String, Any>?, callback: @escaping Result.Callback) {
        openPhotoCallback = callback
        let option = PhotoOption.deserialize(from: options)
        let imagePickerVc = TZImagePickerController(maxImagesCount: option?.count ?? 1, columnNumber: 4, delegate: self)!
        //圆形裁剪
        imagePickerVc.needCircleCrop = option?.isCircle ?? false
        //允许裁剪
        imagePickerVc.allowCrop = option?.enableCrop ?? true
        //把宽度转为半径，不设置尺寸。eg:/2是换算半径。再次/2是px转pt
        if(option?.width != nil){
            imagePickerVc.circleCropRadius = Int(option?.width ?? 60.0)/4
        }
        imagePickerVc.didFinishPickingPhotosWithInfosHandle = { photos, assets, isSelectOriginalPhoto, infos in
            var result = Result()
            let urls = NSMutableArray();
            if(photos != nil && (photos?.count)!>0){
                result.status = Result.success
                result.error = ""
                
                for image in photos!{
                    let path = self.saveImageToSandBox(image: image, fileName: self.getFileName())
                    urls.add(path)
                }
                result.data = ["urls":urls]
                callback(result)
            }
            else{
                result.status = Result.error
                result.error = "无法获取图片路径"
                result.data = ["urls":urls]
                callback(result)
            }
        }
        from.present(imagePickerVc, animated: true, completion: nil)
    }
    func getFileName() -> String {
        let time  = NSDate().timeIntervalSince1970*1000;
        return String(format: "temple_%.f.png", time);
    }
    //保存图片到沙盒
    func saveImageToSandBox(image:UIImage,fileName:String)->String{
        let tmpDirectory = NSTemporaryDirectory();
        let imageData = image.pngData() as NSData?;
        let path = String(format:"%@%@",tmpDirectory,fileName)
        imageData?.write(toFile: path, atomically: true)
        return String(format:"file://%@",fileName);
    }
    // MARK: - MFMessageComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        var callbackResult = Result()
        if result == .cancelled {
            callbackResult.status = Result.error
            callbackResult.error = "cancelled"
        } else if result == .failed {
            callbackResult.status = Result.error
            callbackResult.error = "failed"
        }
        sendSMSCallback?(callbackResult)
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - CNContactPickerDelegate
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        var result = Result()
        result.status = Result.error
        result.error = "cancelled"
        pickContactCallback?(result)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        var result = Result()
        result.data = contactInfo(contact)
        pickContactCallback?(result)
    }
    
    func contactInfo(_ contact: CNContact) -> Dictionary<String, Any> {
        var info = Dictionary<String, Any>()
        info["name"] = CNContactFormatter.string(from: contact, style: .fullName)
        var phones = Array<String>()
        for phoneNumber in contact.phoneNumbers {
            phones.append(phoneNumber.value.stringValue)
        }
        info["phones"] = phones
        return info
    }
}
