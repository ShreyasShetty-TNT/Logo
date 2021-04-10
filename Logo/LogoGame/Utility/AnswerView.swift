//
//  AnswerView.swift
//  LogoGame
//
//  Created by Shreyas S on 10/04/21.
//

import UIKit
protocol AnswerTextFieldDelegate: class {
    func didCompleteEnteringAnswering(_ answer: String)
}

class AnswerView: UIStackView {
    private var numberOfDigits: Int = 4
    private var fieldBackGroundColor: UIColor =  #colorLiteral(red: 0.9411764706, green: 0.9568627451, blue: 0.968627451, alpha: 1)
    private var successBorderColor: UIColor = #colorLiteral(red: 0, green: 0.7490196078, blue: 0.462745098, alpha: 1)
    private var successFillColor: UIColor = #colorLiteral(red: 0.8392156863, green: 1, blue: 0.937254902, alpha: 1)
    private var failureBorderColor: UIColor = #colorLiteral(red: 1, green: 0.462745098, blue: 0.462745098, alpha: 1)
    private var defaultBorderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    private var textColor: UIColor = #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1254901961, alpha: 1)
    private var textBoxWidth: CGFloat = 10
    private var font: UIFont = UIFont.boldSystemFont(ofSize: 10)
    private var textFields = [AnswerTextField]()
    weak var delegate: AnswerTextFieldDelegate?
    private var currentTextField: AnswerTextField?

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        addAnswerFields()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        addAnswerFields()
    }

    
    private final func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 5
    }

    private func addAnswerFields() {
        for index in 0..<numberOfDigits {
            let field = AnswerTextField()
            setupTextField(field)
            textFields.append(field)
            //Set previous textField
            index != 0 ? (field.previousTextField = textFields[index-1]) : (field.previousTextField = nil)
            //Set next textField
            index != 0 ? (textFields[index-1].nextTextField = field) : ()
            currentTextField = textFields[0]
        }
    }

    private func setupTextField(_ textField: AnswerTextField){
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: textBoxWidth).isActive = true
        textField.backgroundColor = fieldBackGroundColor
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = font
        textField.textColor = textColor
        textField.tintColor = .black
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 2
        textField.layer.borderColor = defaultBorderColor.cgColor
        textField.autocorrectionType = .no
    }

    //checks if all the textfields are filled
    private final func checkForValidity() {
        for fields in textFields   {
            if (fields.text == ""){
                return
            }
        }
        delegate?.didCompleteEnteringAnswering(getAnswer())
    }

      func getAnswer() -> String {
        var answer = ""
        for textField in textFields {
            answer += textField.text ?? ""
        }
        return answer
    }

    func fillAnswer(_ char: String) {
        currentTextField?.text = char
        currentTextField = currentTextField?.nextTextField
    }
    
     func showWaringColor(){
        for textField in textFields {
            textField.layer.borderColor = failureBorderColor.cgColor
        }
    }

     func showSuccessColor() {
        for textField in textFields {
            textField.backgroundColor = successFillColor
            textField.layer.borderColor = successBorderColor.cgColor
        }
    }
}






//MARK: - TextField Handling
extension AnswerView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
    }

}

class AnswerTextField: UITextField {
    weak var previousTextField: AnswerTextField?
    weak var nextTextField: AnswerTextField?
    
    override public func deleteBackward(){
        text = ""
        previousTextField?.becomeFirstResponder()
    }
}

