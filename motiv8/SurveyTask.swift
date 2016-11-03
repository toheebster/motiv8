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
        
    // NAME
    let nameQuestion = "What is your name?"
    let nameFormat = ORKTextAnswerFormat()
    let nameStep = ORKQuestionStep(identifier: "NameQuestion", title: nameQuestion, answer: nameFormat)
    steps += [nameStep]
    
    
    // AGE
    let ageQuestion = "How old are you?"
    let ageFormat = ORKNumericAnswerFormat(style: ORKNumericAnswerStyle.integer, unit: "years")
    let ageStep = ORKQuestionStep(identifier: "AgeQuestion", title: ageQuestion , answer: ageFormat)
    steps += [ageStep]
    
    // GENDER
    let genderQuestion = "What is your gender?"
    let genderChoices = [
        ORKTextChoice(text: "Female", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: "Male", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: "Other", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
    ]
    let genderFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: genderChoices)
    let genderStep = ORKQuestionStep(identifier: "GenderQuestion", title: genderQuestion, answer: genderFormat)
    steps += [genderStep]
    
    // RACE
    let raceQuestion = "What is your race?"
    let raceChoices = [
        ORKTextChoice(text: "White", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: "Black or African American", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: "American Indian/Alaska Native", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: "Asian", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: "Hawaiian Native and Pacific Islander", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: "Other", value: 5 as NSCoding & NSCopying & NSObjectProtocol)
    ]
    let raceFormat: ORKValuePickerAnswerFormat = ORKAnswerFormat.valuePickerAnswerFormat(with: raceChoices)
    let raceStep = ORKQuestionStep(identifier: "RaceQuestion", title: raceQuestion, answer: raceFormat)
    steps += [raceStep]
    
    // DIABETES
    let diabetesQuestion = "What type of diabetes do you have?"
    let diabetesChoices = [
        ORKTextChoice(text: "Type 1", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
        ORKTextChoice(text: "Type 2", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
    ]
    let diabetesFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: diabetesChoices)
    let diabetesStep = ORKQuestionStep(identifier: "DiabetesQuestion", title: diabetesQuestion, answer: diabetesFormat)
    steps += [diabetesStep]
    
//might want to change question format to one with preset answers
    // DIAGNOSIS
    let diagnosisQuestion = "How long ago were you diagnosed with diabetes? (0 if less than a month ago)"
    let diagnosisFormat = ORKNumericAnswerFormat(style: ORKNumericAnswerStyle.integer, unit: "months")
    let diagnosisStep = ORKQuestionStep(identifier: "DiagnosisQuestion", title: diagnosisQuestion , answer: diagnosisFormat)
    steps += [diagnosisStep]
    
    // MEDICATION AND FREQUENCY (md)
    let mdQuestion = "What medications are you taking and with what frequency (Please enter all the medications you are taking and the frequency)"
    let mdFormat = ORKTextAnswerFormat()
    let mdStep = ORKQuestionStep(identifier: "MDQuestion", title: mdQuestion, answer: mdFormat)
//add placeholder
    mdStep.placeholder = "add placeholder here detailing desired format"
    steps += [mdStep]
    
    let insulinQuesstion = "Do you inject insulin?"
    let insulinFormat = ORKBooleanAnswerFormat()
    let insulinStep = ORKQuestionStep(identifier: "InsulinStep", title: insulinQuesstion, answer: insulinFormat)
    steps += [insulinStep]
    
    // WEIGHT
    let weightQuestion = "How much do you weigh?"
    let weightFormat = ORKNumericAnswerFormat(style: ORKNumericAnswerStyle.integer, unit: "lbs")
    let weightStep = ORKQuestionStep(identifier: "WeightQuestion", title: weightQuestion , answer: weightFormat)
    steps += [weightStep]
    
    // EXERCISE HABIT (eh)
    let ehQuestion = "How often do you exercise?"
    let ehFormat = ORKNumericAnswerFormat(style: ORKNumericAnswerStyle.integer, unit: "times per week")
    let ehStep = ORKQuestionStep(identifier: "EHQuestion", title: ehQuestion , answer: ehFormat)
    steps += [ehStep]
    
    

    // SUMMARY
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Survey Completed."
    summaryStep.text = "That was easy!"
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
    
}
