//
//  HyperknowledgeQuestionary.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/27/21.
//

import Foundation

struct HypknowledgeQuestionary : DCQuestionaryModelProtocol {
    
    var id: String
    
    var created: Date
    
    var updated: Date?
    
    var title: String
    
    var subtitle: String?
    
    var questions: [DCQuestionModel]
    
    var validator: DCQuestionValidator
    
    func encodeAnswers(answers: [DCAnswerModel]) -> Data {
        var dict = [String : Any]()
        answers.forEach {
            convertAnswers(sendingDict: &dict, answer: $0)
        }
        
        do {
            return try JSONSerialization.data(withJSONObject: dict, options: [])
        } catch {
            print("error writing JSON: \(error)")
        }
        
        return Data()
    }
    
    func convertAnswers( sendingDict: inout [String : Any], answer: DCAnswerModel) {
        guard let keyValue = keys[answer.questionID] else { return }
        sendingDict[keyValue] = answer.answer
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case questions
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = Self.getDailyTimestamp()
        created = Date()
        title = try values.decode(String.self, forKey: .title)
        subtitle = try values.decode(String.self, forKey: .subtitle)
        
        let hypknowledgeQuestions = try values.decode([HypknowledgeQuestionModel].self, forKey: .questions)
        questions = hypknowledgeQuestions.filter{ $0.text != nil && $0.id != nil }
            .compactMap{ DCQuestionModel(text: $0.text!, type: $0.convertTypeToDCQuestionaryType(), id: $0.id!) }
        validator = HypknowledgeQuestionValidator(allQuestions: questions)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    let keys : [String : String] = {
        ["1" : "ttb",
         "2" :  "tts",
         "3" :  "sl",
         "4" :  "nwak",
         "4.a" :   "waso",
         "4.b" :   "waso_in",
         "5" :  "tfa",
         "6.a" :   "ema",
         "7" :  "tob",
         "8" :  "sq",
         "9" :  "rest",
         "10" :   "naps",
         "10.a" :  "napdur",
         "11" :   "dozing",
         "11.a" :   "dozing_time",
         "12" :  "atypical_sleep",
         "12.a" :   "atypical_sleep_description",
         "13" :  "bad_night"]
    }()
    
    let boolValues = ["atypical_sleep",
                      "dozing",
                      "te"]
    
    let stringValues = ["atypical_sleep_description",
                        "bad_night",
                        
                        "dozing_time",
                        "ema",
                        "napdur",
                        "naps",
                        "nwak",
                        "tfa",//"07:00 AM"
                        "tob",//"08:00 AM"
                        "ttb",//"09:00 PM"
                        "tts",//"10:00 PM"
                        "waso",
                        "waso_in",
                        "sl"]
    
    let integerValues = ["rest",
                         "sq"]
    
    static private func getDailyTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: Date())
    }
}
