//
//  CustomTextField.swift
//  Closet
//
//  Created by 佐藤駿樹 on 2021/02/11.
//

import UIKit

class CustomTextField: UITextField {

    // カーソル非表示
    override func caretRect(for position: UITextPosition) -> CGRect {
            return .zero
        }

}
