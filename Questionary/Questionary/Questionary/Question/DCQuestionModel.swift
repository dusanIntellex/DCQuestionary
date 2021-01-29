//
//  QuestionModel.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/25/21.
//

import Foundation

struct DCQuestionModel {
    var text: String
    var type: DCQuestionModelType
    var id: String
}

extension DCQuestionModel : Equatable {
    static func == (lhs: DCQuestionModel, rhs: DCQuestionModel) -> Bool {
        return lhs.id == rhs.id
    }
}
