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
    
    var sendSMSCallback: Result.Callback?
    var pickContactCallback: Result.Callback?
    var getContactsCallback: Result.Callback?
    
    // 打开外部浏览器
    static func openBrowser(_ url: String) {
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
    
    // 打电话
    static func callPhone(_ phone: String) {
        UIApplication.shared.open(URL(string: "tel://" + phone)!, options: [:], completionHandler: nil)
    }
    
    // 发短信
    func sendSMS(from: UIViewController, recipients: Array<String>, content: String, callback: Result.Callback? = nil) {
        sendSMSCallback = callback
        let messageController = MFMessageComposeViewController()
        messageController.messageComposeDelegate = self
        messageController.recipients = recipients
        messageController.body = content
        from.present(messageController, animated: true, completion: nil)
    }
    
    // 打开通讯录选择联系人
    func pickContact(from: UIViewController, callback: Result.Callback? = nil) {
        pickContactCallback = callback
        let pickerController = CNContactPickerViewController()
        pickerController.delegate = self
        from.present(pickerController, animated: true, completion: nil)
    }
    
    // 获取所有联系人
    func getContacts() {
        
    }
    
    // 拍照
    func openCamera() {
        
    }
    
    // 选择图片
    func openPhoto(from: UIViewController, maxImagesCount: Int = 9) {
        let imagePickerVc = TZImagePickerController(maxImagesCount: maxImagesCount, columnNumber: 4, delegate: self)!
        imagePickerVc.didFinishPickingPhotosWithInfosHandle = { photos, assets, isSelectOriginalPhoto, infos in
            
        }
        from.present(imagePickerVc, animated: true, completion: nil)
    }
    
    // MARK: - MFMessageComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        var callbackResult = Result()
        if result == .cancelled {
            callbackResult.code = Result.error
            callbackResult.error = "cancelled"
        } else if result == .failed {
            callbackResult.code = Result.error
            callbackResult.error = "failed"
        }
        sendSMSCallback?(callbackResult)
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - CNContactPickerDelegate
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        var result = Result()
        result.code = Result.error
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
