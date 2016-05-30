//
//  SurveyTask.swift
//  motiv8
//
//  Created by Okenla, Toheeb on 5/30/16.
//  Copyright © 2016 Okenla, Toheeb. All rights reserved.
//

import Foundation
import ResearchKit

public var SurveyTask: ORKOrderedTask {

    var steps = [ORKStep]()
    
    // instruction step
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Question Title"
    instructionStep.text = "Question text"
    //maybe include image here
    steps += [instructionStep]
    
    //add questions
    let ageFormat = ORKNumericAnswerFormat(style: ORKNumericAnswerStyle.Integer, unit: "years")
    let ageQuestion = "How old are you?"
    let ageQuestionStep = ORKQuestionStep(identifier: "AgeQuestion", title: ageQuestion , answer: ageFormat)
    steps += [ageQuestionStep]
    
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Survey Completed."
    summaryStep.text = "That was easy!"
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
