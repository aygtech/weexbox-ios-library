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

class External: NSObject, MFMessageComposeViewControllerDelegate, CNContactPickerDelegate, TZImagePickerControllerDelegate {
    
    var sendSMSCallback: Result.Callback!
    var pickContactCallback: Result.Callback!
    var getContactsCallback: Result.Callback!
    var openCameraCallback: Result.Callback!
    var openPhotoCallback: Result.Callback!
    
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
    func openCamera(callback: @escaping Result.Callback) {
        openCameraCallback = callback
    }
    
    // 选择图片
    func openPhoto(from: UIViewController, maxImagesCount: Int, callback: @escaping Result.Callback) {
        openPhotoCallback = callback
        let imagePickerVc = TZImagePickerController(maxImagesCount: maxImagesCount, columnNumber: 4, delegate: self)!
        imagePickerVc.didFinishPickingPhotosWithInfosHandle = { photos, assets, isSelectOriginalPhoto, infos in
            var result = Result()
            if assets != nil{
                result.status = Result.success
                result.error = ""
                var index = 0
                let count = assets!.count
                let urls = NSMutableArray()
                var result = Result()
                //没有图片。
                if count == 0{
                    result.data = ["urls":[]]
                    callback(result)
                    return;
                }
                for model in assets!{
                    let asset = model as? PHAsset
                    asset!.getURL(completionHandler: { (url) in
                        index = index+1
                        let urlStr = url?.absoluteString
                        urls.add(urlStr ?? "")
                        if index == count{
                            result.data = ["urls":urls]
                            callback(result)
                        }
                    })
                }
            }
            else{
                result.status = Result.error
                result.error = "无法获取图片路径"
                result.data = ["urls":[]]
                callback(result)
            }
        }
        from.present(imagePickerVc, animated: true, completion: nil)
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
extension PHAsset {
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
