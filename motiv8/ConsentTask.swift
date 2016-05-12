//
//  ConsentTask.swift
//  motiv8
//
//  Created by Okenla, Toheeb on 5/12/16.
//  Copyright © 2016 Okenla, Toheeb. All rights reserved.
//

import ResearchKit

public var ConsentTask: ORKOrderedTask {

    var steps = [ORKStep]()
    
    //VisualConsentStep
    var consentDocument = ConsentDocument
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
    steps += [visualConsentStep]
    
    //ConsentReviewStep
    let signature = (consentDocument.signatures?.first)! as ORKConsentSignature
    
    let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, inDocument: consentDocument)
    
    reviewConsentStep.text = "Review Consent"
    reviewConsentStep.reasonForConsent = "Consent to join study"
    
    steps += [reviewConsentStep]

    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}
