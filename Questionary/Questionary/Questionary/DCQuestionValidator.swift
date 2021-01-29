//
//  DCQuestionValidator.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/26/21.
//

import Foundation

protocol DCQuestionValidator {
    
    var allQuestions: [DCQuestionModel] { get set }
    
    
    /// Reanalyse qeustions based on answers. If there si need change questions number or specific question
    /// - Parameter answers: <#answers description#>
    func reanalyzeQuestion(answers: [DCAnswerModel]) -> [DCQuestionModel]
    
    /// Validate answer. If conditions are not match, return DCQuestionaryValidationError
    /// - Parameter answer: answer to be validate
    func validateAnswer(answer: DCAnswerModel, allAnswers: [DCAnswerModel]) throws
    
    /// Validate all answers and if conditions are not matched, return DCQuestionaryValidationError
    func validateAllAnswers(answers: [DCAnswerModel]) throws
}
