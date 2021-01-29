//
//  HypknowledgeQuestionModel.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/29/21.
//

import Foundation


struct HypknowledgeQuestionModel: Codable {
    
    var id: String?
    var type: String?
    var text: String?
    var options: [DCQuestionAnswerOption]?
}

extension HypknowledgeQuestionModel {
    func convertTypeToDCQuestionaryType() -> DCQuestionModelType {
        switch self.type {
        case "date_time":
            return .selectDateTime
        case "number":
            return .enterNumber
        case "one_option":
            return .selectOption(options!)
        case "range(1,5)":
            return .numberClosedRange(1...5)
        case "open_text":
            return .openText
        default:
            return .openText
        }
    }
}
