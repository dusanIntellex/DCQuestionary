//
//  DCQuestionStoreManager.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/25/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol DCAnswersStoreManager {
    
    var answers : BehaviorRelay<[DCAnswerModel]> { get set }
    
    /// This function must update answers and save in appropriate store and update answers value
    func storeAnswer(answer: DCAnswerModel, questionaryId: String)
    
    /// Read answers from appropriate store for questionaryID and set answers value
    func readAnswers(questionaryId: String)
    
    /// Save all answers in appropriate store
    func saveAnswers(questionaryId: String)
    
    /// Reamove all saved answers
    /// - Parameter questionaryId: Id of questionary
    func clearAllAnswers(questionaryId: String)
}
