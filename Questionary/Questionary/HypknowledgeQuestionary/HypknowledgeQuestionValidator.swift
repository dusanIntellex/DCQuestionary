//
//  HyperknowledgeQuestionValidator.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/27/21.
//

import Foundation

struct HypknowledgeQuestionValidator : DCQuestionValidator {
    
    var allQuestions: [DCQuestionModel]
    
    func reanalyzeQuestion(answers: [DCAnswerModel]) -> [DCQuestionModel] {
        
        var removeQuestionIds = [String]()
        
        return allQuestions.compactMap { question -> DCQuestionModel? in
            if let answer = answers.first(where: { $0.questionID == question.id }),
               let answerText = answer.answer as? String,
               answerText.lowercased() == "remove",
               question.id == "2" {
                removeQuestionIds.append("3")
                return question
            }
            return question
        }.filter{ !removeQuestionIds.contains($0.id) }
    }
    
    var question4aMaxValue : Int = 0
    
    func validateAnswer(answer: DCAnswerModel, allAnswers: [DCAnswerModel]) throws {
        guard let text = answer.answer as? String else {
            throw DCQuestionaryValidationError.invalidAnswerType
        }
        if text.isEmpty {
            throw DCQuestionaryValidationError.emptyTextAnswer
        }
        
        switch answer.questionID {
        
        case "3":
            guard let value = answer.answer as? String, let intValue = Int(value) else {
                throw DCQuestionaryValidationError.specificError("Answer must be number value!")
            }
            if intValue > 180 {
                throw DCQuestionaryValidationError.specificWarning("Are you sure this is correct value?")
            }
            
        case "4.a":
            guard let value = answer.answer as? String, let intValue = Int(value) else {
                throw DCQuestionaryValidationError.specificError("Answer must be number value!")
            }
            if intValue > 10 {
                throw DCQuestionaryValidationError.specificWarning("Are you sure this is correct value?")
            }
            
        case "4.b":
            guard let value = answer.answer as? String, let intValue = Int(value) else {
                throw DCQuestionaryValidationError.specificError("Answer must be number value!")
            }
            guard let previousAnswer = allAnswers.first(where: { $0.questionID == "4.a" }), let previousAnswerIntValue = Int(previousAnswer.answer as! String) else {
                throw DCQuestionaryValidationError.specificError("No previous mandatory answer")
            }
            if intValue > previousAnswerIntValue {
                throw DCQuestionaryValidationError.specificError("Can not enter value bigger than answer in previous question!")
            }
            
        case "6.a":
            guard let value = answer.answer as? String, let intValue = Int(value) else {
                throw DCQuestionaryValidationError.specificError("Answer must be number value!")
            }
            if intValue > 180 {
                throw DCQuestionaryValidationError.specificWarning("Are you sure this is correct value?")
            }
            
        case "10":
            guard let value = answer.answer as? String, let intValue = Int(value) else {
                throw DCQuestionaryValidationError.specificError("Answer must be number value!")
            }
            if intValue > 10 {
                throw DCQuestionaryValidationError.specificWarning("Are you sure this is correct value?")
            }
            
        case "10.a":
            guard let value = answer.answer as? String, let intValue = Int(value) else {
                throw DCQuestionaryValidationError.specificError("Answer must be number value!")
            }
            if intValue > 180 {
                throw DCQuestionaryValidationError.specificWarning("Are you sure this is correct value?")
            }
        default:
            break
        }
    }
    
    func validateAllAnswers(answers: [DCAnswerModel]) throws {
        
        let notMandatoryQuestion = ["4.a", "4.b", "10.a","11.a", "12.a"]
        var mandatoryQuestions = allQuestions.map{ $0.id }.filter{ !notMandatoryQuestion.contains($0) }
        answers.forEach{ answer in
            mandatoryQuestions.removeAll(where: { $0 == answer.questionID })
        }
        
        try mandatoryQuestions.forEach {
            throw DCQuestionaryValidationError.missingAnswerForQuestion($0)
        }
    }
}
