//
//  DCAnswerModel.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/25/21.
//

import Foundation

struct DCAnswerModel : Codable {
    
    var questionID: String
    var answer: Any?
    
    init(id: String, answer: Any?) {
        self.questionID = id
        self.answer = answer
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case answer
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        questionID = try values.decode(String.self, forKey: .id)
        
        if let answerDecoded = try? values.decode(String.self, forKey: .answer) {
            answer = answerDecoded
        }
        else if let answerDecoded = try? values.decode(DCQuestionAnswerOption.self, forKey: .answer) {
            answer = answerDecoded
        }
        else if let answerDecoded = try? values.decode(Int.self, forKey: .answer) {
            answer = answerDecoded
        }
        else if let answerDecoded = try? values.decode(Double.self, forKey: .answer) {
            answer = answerDecoded
        }
        else if let answerDecoded = try? values.decode(Date.self, forKey: .answer) {
            answer = answerDecoded
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(questionID, forKey: .id)
        
        if let answerEncode = answer as? DCQuestionAnswerOption {
            try container.encode(answerEncode, forKey: .answer)
        }
        else if let answerEncode = answer as? String {
            try container.encode(answerEncode, forKey: .answer)
        }
        else if let answerEncode = answer as? Int {
            try container.encode(answerEncode, forKey: .answer)
        }
        else if let answerEncode = answer as? Double {
            try container.encode(answerEncode, forKey: .answer)
        }
        else if let answerEncode = answer as? Date {
            try container.encode(answerEncode, forKey: .answer)
        }
    }
}

extension DCAnswerModel : Equatable {
    static func == (lhs: DCAnswerModel, rhs: DCAnswerModel) -> Bool {
        return lhs.questionID == rhs.questionID
    }
}
