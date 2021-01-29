//
//  DCQuestionaryModel.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/26/21.
//

import Foundation


protocol DCQuestionaryModelProtocol : Codable {
    var id: String { get set }
    var created: Date { get set }
    var updated: Date? { get set }
    var title: String { get set }
    var subtitle: String? { get set }
    var questions: [DCQuestionModel] { get set }
    var validator: DCQuestionValidator { get set }
    
    func encodeAnswers(answers: [DCAnswerModel]) -> Data
}
