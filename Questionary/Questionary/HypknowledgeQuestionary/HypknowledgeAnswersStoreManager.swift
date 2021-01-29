//
//  HyperknowledgeAnswersStoreManager.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/27/21.
//

import Foundation
import RxSwift
import RxCocoa

struct HypknowledgeAnswersStoreManager : DCAnswersStoreManager {

    var answers = BehaviorRelay<[DCAnswerModel]>(value: [])
    
    func storeAnswer(answer: DCAnswerModel, questionaryId: String) {
        let all = answers.value
        var filtered = all.filter{ $0 != answer }
        filtered.append(answer)
        answers.accept(filtered)
        saveAnswers(questionaryId: questionaryId)
    }
    
    func readAnswers(questionaryId: String) {
        
        if let dataValue = UserDefaults.standard.value(forKey: questionaryId) as? Data {
            let decoder = JSONDecoder()
            if let storeModel = try? decoder.decode(HypknowledgeCodableStoreModel.self, from: dataValue) {
                self.answers.accept(storeModel.answers)
            }
        }
    }
    
    func saveAnswers(questionaryId: String) {
        let storeModel = HypknowledgeCodableStoreModel(id: questionaryId, answers: answers.value)
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(storeModel) {
            UserDefaults.standard.setValue(data, forKey: questionaryId)
        }
    }
    
    func clearAllAnswers(questionaryId: String) {
        answers.accept([])
        UserDefaults.standard.setValue(nil, forKey: questionaryId)
    }
}

struct HypknowledgeCodableStoreModel : Codable {
    var id: String
    var answers: [DCAnswerModel]
    
    init(id: String, answers: [DCAnswerModel]) {
        self.id = id
        self.answers = answers
    }
    
    enum CodingKeys: String, CodingKey {
            case id
            case answers
        }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        answers = try values.decode([DCAnswerModel].self, forKey: .answers)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(answers, forKey: .answers)
    }
}
