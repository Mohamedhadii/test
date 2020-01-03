//
//  ViewController.swift
//  HangMan_Game
//
//  Created by Hady on 12/21/19.
//  Copyright © 2019 gadou. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var newWordRoundBotton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var wordToGuessLabel: UILabel!
    @IBOutlet weak var remaningGuessLabel: UILabel!
    @IBOutlet weak var leftBankLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    var list_Of_Words = ["cat","hello","coffe","logo","goodbye", "swift","Football","gold", "horse","apple"]
    var list_Of_Hint =
        ["small animal ","greeting","way to wakeup","design","farewell", "language for Ios developer","game played between two teams ","is yellow metal","animal used by people for transportation","fruit with red color"]
    var wordToGuess: String!
    var underScoreWord: String = ""
    var remaningGuess: Int!
    var maxNum = 5
    var oldRandomNumber: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newWordRoundBotton.layer.cornerRadius = newWordRoundBotton.frame.height / 2
        inputTextField.isEnabled = false
        self.inputTextField.delegate = self
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) // hide keyboard
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         
        let allowedCharacters = NSCharacterSet.letters
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        if string.isEmpty {
            return true
        } else if newLength == 1 {
            if  let _ = string.rangeOfCharacter(from: allowedCharacters, options: .caseInsensitive){
                return true
            }
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text!)
        guard let letterCheck = textField.text else {return}
        inputTextField.text?.removeAll() // to remove char from text after write and checing it
        let currentWordBank: String = leftBankLabel.text ?? " "
        if currentWordBank.contains(letterCheck) {
            return
        } else {
        if wordToGuess.contains(letterCheck) {
            return processCorrect(letterCheck: letterCheck)
            
        }else {
            processInCorrect()
        }
            leftBankLabel.text?.append("\(letterCheck), ")
        }
    }
    
    
    func processCorrect(letterCheck: String) {
        let characterGuess = Character(letterCheck)
        for index in wordToGuess.indices {
            if wordToGuess[index] == characterGuess {
                let endindex = wordToGuess.index(after: index)
                let charRange = index..<endindex
                underScoreWord = underScoreWord.replacingCharacters(in: charRange, with: letterCheck)
                wordToGuessLabel.text = underScoreWord
            }
        }
             if !(underScoreWord.contains("_")){
                remaningGuessLabel.text = "you win 😄😄"
                inputTextField.isEnabled = false
            }
       }
    
    func processInCorrect() {
      maxNum -= 1
        if maxNum == 0 {
            remaningGuessLabel.text = "you Lose! 😔😔"
            inputTextField.isEnabled = false
        }else {
            remaningGuessLabel.text = "\(maxNum) letter Guess Left"
        }
    }

    
    
    @IBAction func newWordAction_Btn(_ sender: Any) {
        inputTextField.becomeFirstResponder()
        reset()
        getRandomWord()
    }
    
    
    func chooseRandomWord()->Int {
        var randomNumber = Int(arc4random_uniform(UInt32 (list_Of_Words.count)))
        if randomNumber == oldRandomNumber {
            randomNumber = chooseRandomWord()
        }else {
            oldRandomNumber = randomNumber
        }
        return randomNumber
    }
    
    
    func getRandomWord() {
        let index = chooseRandomWord()
        wordToGuess = list_Of_Words[index]
        for _ in 1...wordToGuess.count{
            underScoreWord.append("_")
        }
        print(underScoreWord.count)
         wordToGuessLabel.text! = underScoreWord
        hintLabel.text = "hint:- \(list_Of_Hint[index]), \(wordToGuess.count) Letters"
    }
    
    
    func reset(){
        maxNum = 5
        remaningGuessLabel.text! = " \(maxNum) Letter Left"
        underScoreWord = ""
        inputTextField.text?.removeAll()
        leftBankLabel.text?.removeAll()
        inputTextField.isEnabled = true
    }
    
}

