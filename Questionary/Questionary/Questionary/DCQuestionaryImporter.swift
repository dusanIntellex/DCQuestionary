//
//  DCQuestionaryImporter.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/28/21.
//

import Foundation

struct DCQuestionaryImporter {
    
    static func getQuestionary<T:DCQuestionaryModelProtocol>(fileName: String) -> T? {
        return readJSONFile(fileName: fileName)
    }
    
    static func getQuestionary<T:DCQuestionaryModelProtocol>(jsonData: Data) -> T? {
        return decode(data: jsonData)
    }
    
    private static func readJSONFile<T:DCQuestionaryModelProtocol>(fileName: String) ->  T? {
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                return decode(data: data)
            } catch {
                print("Error!! Unable to parse  \(fileName).json")
            }
        }
        
        return nil
    }
    
    private static func decode<T: DCQuestionaryModelProtocol>(data: Data) -> T?{
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
    

}
