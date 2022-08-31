//
//  TableViewCell.swift
//  vc
//
//  Created by Zhaojie CHEN(陳昭潔) on 2022/8/2.
//

import UIKit

class TableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var textfield = UITextField()
    var textChanged: ((String) -> Void)?
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textfield.delegate = self
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "enter"
        
        // Set any attributes of your UI components here.
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the UI components
        contentView.addSubview(textfield)
        NSLayoutConstraint.activate([
            textfield.widthAnchor.constraint(equalToConstant: 100),
            textfield.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            textfield.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textfield.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(range)
        if let currentText = textField.text, let range = Range(range, in: currentText) {
            print(range)
            let newText = currentText.replacingCharacters(in: range, with: string)
            textChanged?(newText)
        }
        return true
    }
  
    override func prepareForReuse() {
        super.prepareForReuse()
        textChanged = nil
    }
}
