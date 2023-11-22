//
//  ViewController.swift
//  ChatGPTStreaming
//
//  Created by Berserk on 22/11/2023.
//

import UIKit

protocol ViewInterface: AnyObject {
    func get(chunk:String)
}

class ViewController: UIViewController, UITextFieldDelegate, ViewInterface {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputTextView: UITextView!
    
    let socketInteractor = SocketInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        inputTextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text else { return false }
        
        outputTextView.text = ""
        
        socketInteractor.sendRequest(with: text)
        socketInteractor.viewController = self
        return true
    }
    
    
    func get(chunk: String) {
        DispatchQueue.main.async {
            self.outputTextView.text.append(chunk)
        }
    }
}

