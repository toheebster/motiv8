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
    instructionStep.title = "Motiv8 Survey"
    instructionStep.text = "This survey helps us understand you better for the study"
    //maybe include image here
    steps += [instructionStep]
    
    // AGE
    let ageQuestion = "How old are you?"
    let ageFormat = ORKNumericAnswerFormat(style: ORKNumericAnswerStyle.Integer, unit: "years")
    let ageStep = ORKQuestionStep(identifier: "AgeQuestion", title: ageQuestion , answer: ageFormat)
    steps += [ageStep]
    
    // GENDER
    let genderQuestion = "What is your gender?"
    let genderChoices = [
        ORKTextChoice(text: "Female", value: 0),
        ORKTextChoice(text: "Male", value: 1),
        ORKTextChoice(text: "Other", value: 2)
    ]
    let genderFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: genderChoices)
    let genderStep = ORKQuestionStep(identifier: "GenderQuestion", title: genderQuestion, answer: genderFormat)
    steps += [genderStep]
    
    // RACE
    let raceQuestion = "What is your race?"
    let raceChoices = [
        ORKTextChoice(text: "White", value: 0),
        ORKTextChoice(text: "Black or African American", value: 1),
        ORKTextChoice(text: "American Indian/Alaska Native", value: 2),
        ORKTextChoice(text: "Asian", value: 3),
        ORKTextChoice(text: "Hawaiian Native and Pacific Islander", value: 4),
        ORKTextChoice(text: "Other", value: 5)
    ]
    let raceFormat: ORKValuePickerAnswerFormat = ORKAnswerFormat.valuePickerAnswerFormatWithTextChoices(raceChoices)
    let raceStep = ORKQuestionStep(identifier: "RaceQuestion", title: raceQuestion, answer: raceFormat)
    steps += [raceStep]
    
    // DIABETES
    let diabetesQuestion = "What type of diabetes do you have?"
    let diabetesChoices = [
        ORKTextChoice(text: "Type 1", value: 0),
        ORKTextChoice(text: "Type 2", value: 2)
    ]
    let diabetesFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: diabetesChoices)
    let diabetesStep = ORKQuestionStep(identifier: "DiabetesQuestion", title: diabetesQuestion, answer: diabetesFormat)
    steps += [diabetesStep]
    
//might want to change question format to one with preset answers
    // DIAGNOSIS
    let diagnosisQuestion = "How long ago were you diagnosed with diabetes? (0 if less than a month ago)"
    let diagnosisFormat = ORKNumericAnswerFormat(style: ORKNumericAnswerStyle.Integer, unit: "months")
    let diagnosisStep = ORKQuestionStep(identifier: "DiagnosisQuestion", title: diagnosisQuestion , answer: diagnosisFormat)
    steps += [diagnosisStep]
    
    // MEDICATION AND FREQUENCY (md)
    let mdQuestion = "What medications are you taking and with what frequency (Please enter all the medications you are taking and the frequency)"
    let mdFormat = ORKTextAnswerFormat()
    let mdStep = ORKQuestionStep(identifier: "MDQuestion", title: mdQuestion, answer: mdFormat)
    //add placeholder
    mdStep.placeholder = "add placeholder here detailing desired format"
    steps += [mdStep]
    
    

    // SUMMARY
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Survey Completed."
    summaryStep.text = "That was easy!"
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
