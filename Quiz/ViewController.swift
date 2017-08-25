//
//  ViewController.swift
//  Quiz
//
//  Created by Benjamin Dagg on 8/24/17.
//  Copyright (c) 2017 Benjamin Dagg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //link the views in main storyboard to memory locations
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    //array of questions
    let questions: [String] = [
        "What is 7 + 7?",
        "What is the capital of Vermont?",
        "What is a cognac made from?"
    ]
    
    //array of answers
    let answers: [String] = [
        "14",
        "Montpelier",
        "Grapes"
    ]
    //tracks current question
    var currentQuestionIndex: Int = 0
    
    //overloads viewDidLoad to change question label on startup to first question
    override func viewDidLoad(){
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIndex]
    }
    
    //this function is called when question label is pressed
    @IBAction func showNextQuestion(_ sender: UIButton){
        
        currentQuestionIndex = (currentQuestionIndex + 1) % 3
        let question: String = questions[currentQuestionIndex]
        questionLabel.text = question
        answerLabel.text = "???"
        
    }
    
    //this function is called when show answer button is presssed
    @IBAction func showAnswer(_ sender: UIButton){
        
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
        
    }


}

