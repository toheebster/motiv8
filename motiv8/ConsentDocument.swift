//
//  ConsentDocument.swift
//  motiv8
//
//  Created by Okenla, Toheeb on 5/12/16.
//  Copyright © 2016 Okenla, Toheeb. All rights reserved.
//

import ResearchKit

public var ConsentDocument: ORKConsentDocument {

    let consentDocument = ORKConsentDocument()
    consentDocument.title = "Motiv8 Consent"
    
    //Consent sections
        //maybe add .Custom .. will have no default content, can customize as needed
    let consentSectionTypes: [ORKConsentSectionType] = [
        .Overview,
        .DataGathering,
        .Privacy,
        .DataUse,
        .TimeCommitment,
        .StudySurvey,
        .StudyTasks,
        .Withdrawing
    ]
    
    let consentSections: [ORKConsentSection] = consentSectionTypes.map { contentSectionType in
        let consentSection = ORKConsentSection(type: contentSectionType)
        //change implementation to have different title & text on each page
        //ok for now
        consentSection.summary = "Summary should go here"
        consentSection.content = "Content should go here"
        return consentSection
    }
    consentDocument.sections = consentSections
    
    //Signature
    consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))
    
    return consentDocument
}
