//
//  UIViewController+Extension.swift
//  UIKit+MVVM
//
//  Created by Moon Jongseek on 2022/07/16.
//

import UIKit

extension UIViewController {
    /// Alert 표시 함수(addCancel: 취소 버튼 표시 여부 default = false, completion: 확인 버튼으로 실행 시킬 클로저 default = nil)
    func showAlertController(title: String, message: String = "", addCancel: Bool = false, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "확인", style: .default) { (alertAction) in
            if let completion = completion {
                completion()
            }
        }
        alertController.addAction(acceptAction)
        
        if addCancel {
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func startIndicatingActivity() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.startIndicatingActivity()
    }
    
    func stopIndicatingActivity() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.stopIndicatingActivity()
    }
}
