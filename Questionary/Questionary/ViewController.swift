//
//  ViewController.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/25/21.
//

import UIKit
import RxCocoa
import RxBiBinding
import RxSwift

class ViewController: UIViewController {
    
    var questionaryService: DCQuestionaryService!

    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var questionNext: UIButton!
    @IBOutlet weak var questionPrevious: UIButton!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var questionStatsLabel: UILabel!
    @IBOutlet weak var submit: UIButton!
    
    fileprivate var answerObserver = BehaviorRelay<DCAnswerModel?>(value: nil)
    fileprivate var dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createQuestionary()
        observe()
    }
    
    private func createQuestionary() {
        if let questionary : HypknowledgeQuestionary = DCQuestionaryImporter.getQuestionary(fileName: "HypknowledgeDiary") {
            let store = HypknowledgeAnswersStoreManager()
            self.questionaryService = DCQuestionaryService(questionary: questionary, storeManager: store)
        }
    }

    @IBAction func previousQuestionButton(_ sender: UIButton) {
        self.view.endEditing(true)
        self.questionaryService?.previousQuestion()
    }
    
    @IBAction func nextQuestionButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.questionaryService?.nextQuestion(answerObservable: answerObserver)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        self.questionaryService.submit { (answerData) in
            let jsonString = String(data: answerData, encoding: String.Encoding.utf8)!
            print("JSON string: \(jsonString)")
        }
    }
    
    @IBAction func clearAllData(_ sender: UIButton) {
        self.questionaryService.removeAllSavedAnswers()
    }
    
    private func observe() {
        self.answerTextView.rx.didEndEditing.withLatestFrom(self.answerTextView.rx.text)
            .withLatestFrom(self.questionaryService.currentQuestion) { (answerText, question) -> DCAnswerModel in
                return DCAnswerModel(id: question!.id, answer: answerText)
            }
            .bind(to: self.answerObserver)
            .disposed(by: dispose)
        
        self.questionaryService.currentQuestion
            .map{ $0?.text }
            .bind(to: self.questionText.rx.text)
            .disposed(by: dispose)
        
        self.questionaryService.questionAnswer
            .debug("Question answer", trimOutput: false)
            .map{ $0?.answer as? String }
            .bind(to: self.answerTextView.rx.text)
            .disposed(by: dispose)
        
        self.questionaryService.currentQuestionAnswerErrors.subscribe(onNext:{
            print($0)
        }).disposed(by: dispose)
        
        // Buttons
        self.questionaryService.hasNextQuestion.map{ !$0 }.bind(to: self.questionNext.rx.isHidden).disposed(by: dispose)
        self.questionaryService.hasPreviousQuestion.map{ !$0 }.bind(to: self.questionPrevious.rx.isHidden).disposed(by: dispose)
        self.questionaryService.hasNextQuestion.bind(to: self.submit.rx.isHidden).disposed(by: dispose)
        
        Observable.combineLatest(self.questionaryService.currentQuestionIndex, self.questionaryService.questionsCount)
            .map{ "\($0.0 + 1)/\($0.1)" }
            .bind(to: self.questionStatsLabel.rx.text)
            .disposed(by: dispose)
    }
}

