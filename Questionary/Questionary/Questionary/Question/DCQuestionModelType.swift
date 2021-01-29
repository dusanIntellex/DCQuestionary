//
//  QuestionModelType.swift
//  Questionary
//
//  Created by Dusan Cucurevic on 1/25/21.
//

import Foundation

enum DCQuestionModelType {
    case selectDateTime
    case selectDate
    case openText
    case numberClosedRange(ClosedRange<Int>)
    case enterNumber
    case enterCharacter
    case selectOption([DCQuestionAnswerOption])
}
