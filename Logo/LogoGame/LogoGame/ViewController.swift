//
//  ViewController.swift
//  LogoGame
//
//  Created by Shreyas S on 10/04/21.
//

import UIKit

class ViewController: UIViewController {
  
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerStackView: AnswerView!
    @IBOutlet weak var answerKeyStackView: UIStackView!
    var viewModel: ViewControllerViewModel = ViewControllerViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.answerStackView.delegate = self
        setupAnswerKeys()
        updateLogo()
    }


    private func updateLogo() {
        let logo = viewModel.logoData[viewModel.currentState]
        imageView.downloaded(from: logo.imageUrl)
    }

    private func setupAnswerKeys() {
        if viewModel.logoData.count > viewModel.currentState {
            let logo = viewModel.logoData[viewModel.currentState]
            let chars = logo.name.map( { Character($0.uppercased())})
            var answerSets = randomString(keysToIgnore: chars, length: 10)
            answerSets.removeSubrange(0..<chars.count)
            answerSets.append(contentsOf: chars)
            answerSets.shuffle()
            
            for char in answerSets {
                let button = UIButton()
                button.setTitle(String(char), for: .normal)
                button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                button.backgroundColor = .lightGray
                button.addTarget(self, action: #selector(onButtonClick(_ :)), for: .touchUpInside)
                answerKeyStackView.addSubview(button)
            }
            
        }
    }

    @objc func onButtonClick(_ button: UIButton) {
        guard let text = button.titleLabel?.text else { return }
        answerStackView.fillAnswer(text)
    }

    func randomString(keysToIgnore: [Character], length: Int) -> [Character] {
       
        let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let filteredCharacters = letters.filter { !keysToIgnore.contains($0) }
      
      return Array(String((0..<length).map{ _ in filteredCharacters.randomElement()! }))
    }
}

extension ViewController: AnswerTextFieldDelegate {
    func didCompleteEnteringAnswering(_ answer: String) {
        let currentAnswer = answer
        let correctAnswer = viewModel.logoData[viewModel.currentState].name
        if currentAnswer.uppercased() == correctAnswer.uppercased() {
            viewModel.updateProgress()
        }
    }
}

class ViewControllerViewModel {
    private(set) var currentState: Int = 0
    private(set) var logoData: [LogoModel] = []

    init(_ currentState: Int = 0,logoData: [LogoModel] = []) {
        self.currentState = currentState
        self.logoData = logoData
        parseLogoData()
    }

    private func parseLogoData() {
        guard let logoData = [LogoModel].parse(jsonFile: "logo") else {
         return
        }
        self.logoData = logoData
    }

    func updateProgress() {
        currentState += 1
    }
}
