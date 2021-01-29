//
//  DCQuestionaryValidationError.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/26/21.
//

import Foundation


enum DCQuestionaryValidationError : Error {
    
    
    // Answer validation
    case invalidAnswerType
    case emptyTextAnswer
    case specificError(String)
    case specificWarning(String)
    
    // Questionary
    case missingAnswerForQuestion(String)
}
