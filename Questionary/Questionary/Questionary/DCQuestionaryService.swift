//
//  DCQuestionaryService.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/25/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxBiBinding

struct DCQuestionaryService {
    
    // Output
    public var isAnimating = PublishRelay<Bool>()
    
    public var currentQuestion = BehaviorSubject<DCQuestionModel?>(value: nil)
    public var currentQuestionIndex = BehaviorSubject<Int>(value: 0)
    public var currentQuestionAnswerErrors = PublishSubject<[DCQuestionaryValidationError]>()
    
    public var questionsCount = BehaviorSubject<Int>(value: 0)
    
    public var questionaryValidationError = PublishSubject<DCQuestionaryValidationError>()
    
    public var questionAnswer = BehaviorRelay<DCAnswerModel?>(value: nil)
    
    public var hasNextQuestion = BehaviorRelay<Bool>(value: false)
    public var hasPreviousQuestion = BehaviorRelay<Bool>(value: false)
    
    // Managers
    fileprivate var questionsManager: DCQuestionsManager!
    fileprivate var answerStoreManager: DCAnswersStoreManager!
    
    fileprivate var questionaryId: String!
    
    fileprivate var dispose = DisposeBag()

    // MARK:- Constructor
    init(questionary: DCQuestionaryModelProtocol, storeManager: DCAnswersStoreManager) {
        self.questionaryId = questionary.id
        self.answerStoreManager = storeManager
        self.questionsManager = DCQuestionsManager(questionary: questionary, storeAnswersObserver: answerStoreManager.answers.asObservable())
        self.answerStoreManager.readAnswers(questionaryId: questionaryId)
        
        bindQuestionManager()
        bindAnswersStoreManager()
        bindQuestionsInforamtion()
    }
    
    // MARK:- Public 
    public func nextQuestion(answerObservable: BehaviorRelay<DCAnswerModel?>) {
        
        do {
            let answerValue = answerObservable.value
            try self.questionsManager.validateAnswer(currentQuestionAnswer: answerValue)
            
            if let answer = answerValue {
                answerStoreManager.storeAnswer(answer: answer, questionaryId: self.questionaryId)
            }
            self.questionsManager.nextQuestion()
            
        }
        catch {
            currentQuestionAnswerErrors.onNext([error as! DCQuestionaryValidationError])
        }
    }
    
    public func previousQuestion() {
        self.questionsManager.previousQuestion()
    }
    
    public func submit(submitHandler: (_ answersData: Data) -> Void) {
        self.answerStoreManager.saveAnswers(questionaryId: questionaryId)
        do {
            try self.questionsManager.validateQuestionary()
            
            let allAnswers = self.answerStoreManager.answers.value
            let answerData = self.questionsManager.encodeAnswers(answers: allAnswers)
            
            submitHandler(answerData)
        }
        catch {
            self.questionaryValidationError.onNext(error as! DCQuestionaryValidationError)
        }
    }
    
    public func goToFirstQuestion() {
        self.questionsManager.currentQuestionIndex.accept(0)
    }
    
    public func removeAllSavedAnswers() {
        self.answerStoreManager.clearAllAnswers(questionaryId: self.questionaryId)
    }
    
    // MARK:- Bind
    private func bindQuestionManager() {
        self.questionsManager.allUsingQuestions
            .map{ $0.count }
            .bind(to: self.questionsCount)
            .disposed(by: dispose)
        
        self.questionsManager.currentQuestion
            .bind(to: currentQuestion)
            .disposed(by: dispose)
        
        self.questionsManager.currentQuestionIndex
            .bind(to: self.currentQuestionIndex)
            .disposed(by: dispose)
        
        // Restart errors when question change
        self.questionsManager.currentQuestion
            .distinctUntilChanged()
            .subscribe(onNext:{ _ in
                self.currentQuestionAnswerErrors.onNext([])
            }).disposed(by: dispose)
    }
    
    private func bindAnswersStoreManager() {
        self.currentQuestion.withLatestFrom(self.answerStoreManager.answers) { (question, answers) -> DCAnswerModel? in
            return answers.first(where: { $0.questionID == question?.id })
        }.bind(to: self.questionAnswer).disposed(by: dispose)
    }
    
    private func bindQuestionsInforamtion() {
        
        Observable.combineLatest(self.currentQuestionIndex, self.questionsManager.allUsingQuestions)
            .map{ $0.0 < ($0.1.count - 1) }
            .bind(to: hasNextQuestion)
            .disposed(by: dispose)
        
        Observable.combineLatest(self.currentQuestionIndex, self.questionsManager.allUsingQuestions)
            .map{ $0.0 > 0 }
            .bind(to: hasPreviousQuestion)
            .disposed(by: dispose)
    }
}
