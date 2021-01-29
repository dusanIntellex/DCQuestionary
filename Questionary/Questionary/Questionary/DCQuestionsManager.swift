//
//  DCQuestionaryManager.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/25/21.
//

import Foundation
import RxSwift
import RxCocoa

struct DCQuestionsManager {
    
    public var currentQuestion = BehaviorRelay<DCQuestionModel?>(value: nil)
    public var allUsingQuestions = BehaviorRelay<[DCQuestionModel]>(value: [])
    public var currentQuestionIndex = BehaviorRelay<Int>(value: 0)
    
    fileprivate var questionary: DCQuestionaryModelProtocol!
    fileprivate var allAnswers = BehaviorRelay<[DCAnswerModel]>(value: [])
    
    fileprivate var dispose = DisposeBag()
    
    init(questionary: DCQuestionaryModelProtocol, storeAnswersObserver: Observable<[DCAnswerModel]>) {
        self.questionary = questionary
        storeAnswersObserver.bind(to: self.allAnswers).disposed(by: dispose)
        
        observeAnswersAndGetUsableQuestions()
        observeSetCurrentQuestion()
    }
    
    public func validateAnswer(currentQuestionAnswer: DCAnswerModel?) throws {
        if currentQuestionAnswer != nil {
            try self.questionary.validator.validateAnswer(answer: currentQuestionAnswer!, allAnswers: allAnswers.value)
        }
    }
    
    public func validateQuestionary() throws {
        try self.questionary.validator.validateAllAnswers(answers: allAnswers.value)
    }
    
    public func encodeAnswers(answers: [DCAnswerModel]) -> Data {
        return self.questionary.encodeAnswers(answers: answers)
    }
    
    public func nextQuestion() {
        guard self.currentQuestionIndex.value < (self.allUsingQuestions.value.count - 1) else { return }
        self.currentQuestionIndex.accept(self.currentQuestionIndex.value + 1)
    }
    
    public func previousQuestion(){
        guard self.currentQuestionIndex.value > 0 else { return }
        self.currentQuestionIndex.accept(self.currentQuestionIndex.value - 1)
    }
    
    private func observeAnswersAndGetUsableQuestions() {
        allAnswers.compactMap{ self.questionary.validator.reanalyzeQuestion(answers: $0) }
            .bind(to: self.allUsingQuestions)
            .disposed(by: dispose)
    }
    
    private func observeSetCurrentQuestion() {
        self.currentQuestionIndex.withLatestFrom(self.allUsingQuestions) { (index, questions) -> DCQuestionModel? in
            return questions[safe: index]
        }
        .compactMap{ $0 }
        .bind(to: self.currentQuestion)
        .disposed(by: dispose)
    }
}

// MARK: Collection
extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
