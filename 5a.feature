#Epic: SPD-161
#Story: SPD-162
@regression @nightly @SPD-161 @SPD-162
Feature: E_SPD-161 S_SPD-162 Create Account Creator Role - NACK

  @SPD-161_SPD-162_Precondition
  Scenario: PreCondition - Create required Entities, Actors & Roles
    Given the following "Feature" level precondition "inte904" are generated and published via adapter "ASXML"
      | PreconditionKey | EntityName                  | LEI                             | BAH_BizMsgIdr                       | MessageId                           | CreationDateTime                     | PartyIdValidFrom | OpeningDate | PartyNameValidFrom | PartyType |
      | Entity1         | CBA MARKETS LTD-${EXEC_UID} | #{ADD_NODE}549300FBHFW3O5LH5M59 | ${BizMsgIdr::format=00002\|Entity1} | ${MessageId::format=00002\|Entity1} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ${T}        | ${T}               | ENTY      |
    And read the number of outgoing messages "1" on queue "ASXML_OUT" for message type "inte905" and store in scenario context
    And the following precondition table are persisted to "Feature" properties file
      | PreconditionKey | EntityId                        |
      | Entity1         | ${EntityId::key=00002\|Entity1} |
    And the following "Feature" level precondition "inte904" are generated and published via adapter "ASXML"
      | PreconditionKey | BAH_BizMsgIdr                             | MessageId                                 | CreationDateTime                     | PartyIdValidFrom | PartyType | ActorId                    | OpeningDate | MessagePartyId_BIC                            | MessagePartyId_UIC | PartyNameValidFrom | MessagePartyIdType | EntityId                                | Designation                   |
      | Actor1_NoRole   | ${BizMsgIdr::format=00002\|Actor1_NoRole} | ${MessageId::format=00002\|Actor1_NoRole} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC8} | #{REMOVE_NODE}     | ${T}               | BIC8               | #{ADD_NODE}${#FEATURE#Entity1.EntityId} | #{ADD_NODE}MARGIN LENDING A/C |
      | Actor_CDRA      | ${BizMsgIdr::format=00002\|Actor_CDRA}    | ${MessageId::format=00002\|Actor_CDRA}    | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC8} | #{REMOVE_NODE}     | ${T}               | BIC8               | #{ADD_NODE}${#FEATURE#Entity1.EntityId} | #{ADD_NODE}MARGIN LENDING A/C |
      | Actor_CSPA      | ${BizMsgIdr::format=00002\|Actor_CSPA}    | ${MessageId::format=00002\|Actor_CSPA}    | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC8} | #{REMOVE_NODE}     | ${T}               | BIC8               | #{ADD_NODE}${#FEATURE#Entity1.EntityId} | #{ADD_NODE}MARGIN LENDING A/C |
      | Actor_CETA      | ${BizMsgIdr::format=00002\|Actor_CETA}    | ${MessageId::format=00002\|Actor_CETA}    | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC8} | #{REMOVE_NODE}     | ${T}               | BIC8               | #{ADD_NODE}${#FEATURE#Entity1.EntityId} | #{ADD_NODE}MARGIN LENDING A/C |
    And Verify the number of outgoing messages on outbound adapter "ASXML_OUT" recieved are "4"
    And the following "Feature" level precondition "inte904" are generated and published via adapter "ASXML"
      | PreconditionKey | BAH_BizMsgIdr                         | MessageId                             | CreationDateTime                     | PartyIdValidFrom | PartyType | ActorId                        | OpeningDate | RoleType        | PartyNameValidFrom | PermissionType1 |
      | ACCR_CDRA       | ${BizMsgIdr::format=00002\|ACCR_CDRA} | ${MessageId::format=00002\|ACCR_CDRA} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_CDRA.ActorId} | ${T}        | #{ADD_NODE}ACCR | ${T}               | #{ADD_NODE}CDRA |
      | ACCR_CSPA       | ${BizMsgIdr::format=00002\|ACCR_CSPA} | ${MessageId::format=00002\|ACCR_CSPA} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_CSPA.ActorId} | ${T}        | #{ADD_NODE}ACCR | ${T}               | #{ADD_NODE}CSPA |
      | ACCR_CETA       | ${BizMsgIdr::format=00002\|ACCR_CETA} | ${MessageId::format=00002\|ACCR_CETA} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_CETA.ActorId} | ${T}        | #{ADD_NODE}ACCR | ${T}               | #{ADD_NODE}CETA |
    And Verify the number of outgoing messages on outbound adapter "ASXML_OUT" recieved are "3"

  #########################################################################################################################
  #AC1 : Send a schema valid nack when Actor ID  is not provided.
  #########################################################################################################################
  Scenario Outline: AC1 Account Creator Role message - <Description>
    When I generate a message from template for "inte904" using datatable and publish on adapter "ASXML"
      | BAH_BizMsgIdr                    | MessageId                        | CreationDateTime                     | PartyIdValidFrom   | ActorId   | OpeningDate   | PartyNameValidFrom   | EntityName   | MessagePartyIdType   | PartyType   | MessagePartyId_UIC | RoleType              | PermissionType1              | SplmtryData   |
      | ${BizMsgIdr::format=00002\|ACCR} | ${MessageId::format=00002\|ACCR} | ${T::DateFormatter=ZuluWithMilliSec} | <PartyIdValidFrom> | <ActorId> | <OpeningDate> | <PartyNameValidFrom> | <EntityName> | <MessagePartyIdType> | <PartyType> | <TechAddr>         | #{ADD_NODE}<RoleType> | #{ADD_NODE}<PermissionType1> | <SplmtryData> |
    Then verify NACK with number of messages "1" on outbound queue of "ASXML_OUT" and on poison queue of inbound adapter "ASXML" with message type "comm807"
      | Validate_BAH | Validate_Rltd_BAH         | Nack_Rltd_RefId                        | RejectReasonCode | RejectReasonDescription   |
      | true         | true::IngressLink=inte904 | ${Nack_Rltd_RefId::format=00002\|ACCR} |             0099 | <RejectReasonDescription> |

    @REPORT_SPD-161_SPD-162_1
    Examples: 
      | Description                            | PartyIdValidFrom | ActorId | OpeningDate | PartyType | TechAddr | PartyNameValidFrom | EntityName   | MessagePartyIdType | RoleType | PermissionType1 | RejectReasonDescription                                                |
      | Actor Id is populated with blank value | ${T}             |         | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CSPA            | Value '' is not facet-valid with respect to pattern '[0-9]{5}\|NONREF' |

  ##########################################################################################################################
  #PAC1 : Schema Validation
  #########################################################################################################################
  #PAC3 : Technical Nacks & Business Nacks
  #########################################################################################################################
  #PAC8 : Validating Mandatory Message Elements
  #########################################################################################################################
  Scenario Outline: PAC1 PAC3 PAC8 Account Creator Role message - <Description>
    When I generate a message from template for "inte904" using datatable and publish on adapter "ASXML"
      | BAH_BizMsgIdr                    | MessageId                        | CreationDateTime                     | PartyIdValidFrom   | ActorId   | OpeningDate   | PartyNameValidFrom   | EntityName   | MessagePartyIdType   | PartyType   | MessagePartyId_UIC | RoleType              | PermissionType1              | SplmtryData   |
      | ${BizMsgIdr::format=00002\|ACCR} | ${MessageId::format=00002\|ACCR} | ${T::DateFormatter=ZuluWithMilliSec} | <PartyIdValidFrom> | <ActorId> | <OpeningDate> | <PartyNameValidFrom> | <EntityName> | <MessagePartyIdType> | <PartyType> | <TechAddr>         | #{ADD_NODE}<RoleType> | #{ADD_NODE}<PermissionType1> | <SplmtryData> |
    Then verify NACK with number of messages "1" on outbound queue of "ASXML_OUT" and on poison queue of inbound adapter "ASXML" with message type "comm807"
      | Validate_BAH | Validate_Rltd_BAH         | Nack_Rltd_RefId                        | RejectReasonCode | RejectReasonDescription   |
      | true         | true::IngressLink=inte904 | ${Nack_Rltd_RefId::format=00002\|ACCR} |             0099 | <RejectReasonDescription> |

    #Mandatory fields in Party Creation Request block missing
    @REPORT_SPD-161_SPD-162_2
    Examples: 
      | Description                                                | PartyIdValidFrom | ActorId                           | OpeningDate | PartyType      | TechAddr | PartyNameValidFrom | EntityName   | MessagePartyIdType | RoleType | PermissionType1 | RejectReasonDescription                 |
      | PartyId- Valid From field is populated with blank value    |                  | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE           | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CSPA            | is not a valid value for 'date'         |
      | Party- Opening Date is populated with blank value          | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} |             | ROLE           | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CSPA            | is not a valid value for 'date'         |
      | Party - Type is populated with blank value                 | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        |                | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CETA            | It must be a value from the enumeration |
      | Party- Technical Address is populated with blank value     | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE           |          | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CETA            | Value '' is not facet-valid             |
      | PartyName - Valid From field is populated with blank value | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE           | NONREF   |                    | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CDRA            | is not a valid value for 'date'         |
      | PartyName - Name is populated with blank value             | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE           | NONREF   | ${T}               |              | #{NO_ACTION}       | ACCR     | CDRA            | Value '' is not facet-valid             |
      | PartyName - ShortName is populated with blank value        | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE           | NONREF   | ${T}               | #{NO_ACTION} |                    | ACCR     | CDRA            | Value '' is not facet-valid             |
      | Payload with no party type element                         | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | #{REMOVE_NODE} | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CDRA            | Tp}' is expected                        |

  #Mandatory fields in supplementary data block missing
  #########################################################################################################################
  #AC2 : Send a schema valid nack when Role type is not provided.
  ##########################################################################################################################
  Scenario Outline: AC2 Account Creator Role message - <Description>
    When I generate a message from template for "inte904" using datatable and publish on adapter "ASXML"
      | BAH_BizMsgIdr                    | MessageId                        | CreationDateTime                     | PartyIdValidFrom   | ActorId   | OpeningDate   | PartyNameValidFrom   | EntityName   | MessagePartyIdType   | PartyType   | MessagePartyId_UIC | RoleType              | PermissionType1              | SplmtryData   |
      | ${BizMsgIdr::format=00002\|ACCR} | ${MessageId::format=00002\|ACCR} | ${T::DateFormatter=ZuluWithMilliSec} | <PartyIdValidFrom> | <ActorId> | <OpeningDate> | <PartyNameValidFrom> | <EntityName> | <MessagePartyIdType> | <PartyType> | <TechAddr>         | #{ADD_NODE}<RoleType> | #{ADD_NODE}<PermissionType1> | <SplmtryData> |
    Then verify NACK with number of messages "1" on outbound queue of "ASXML_OUT" and on poison queue of inbound adapter "ASXML" with message type "comm807"
      | Validate_BAH | Validate_Rltd_BAH         | Nack_Rltd_RefId                        | RejectReasonCode | RejectReasonDescription   |
      | true         | true::IngressLink=inte904 | ${Nack_Rltd_RefId::format=00002\|ACCR} |             0099 | <RejectReasonDescription> |

    @REPORT_SPD-161_SPD-162_3
    Examples: 
      | Description                                  | PartyIdValidFrom | ActorId                           | OpeningDate | PartyType | TechAddr | PartyNameValidFrom | EntityName   | MessagePartyIdType | SplmtryData    | RoleType     | PermissionType1 | RejectReasonDescription                       |
      | Role type is populated with blank value      | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | #{NO_ACTION}   |              | CDRA            | not facet-valid with respect to minLength '4' |
      | PermissionType is populated with blank value | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | #{NO_ACTION}   | ACCR         |                 | not facet-valid with respect to minLength '4' |
      | Payload with no supplementary data           | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | #{REMOVE_NODE} | #{NO_ACTION} | #{NO_ACTION}    | SplmtryData}' is expected                     |

  #Invalid date formats in payload
  Scenario Outline: PAC1 PAC3 Account Creator Role message - <Description>
    When I generate a message from template for "inte904" using datatable and publish on adapter "ASXML"
      | BAH_BizMsgIdr                    | MessageId                        | CreationDateTime                     | PartyIdValidFrom   | ActorId   | OpeningDate   | PartyNameValidFrom   | EntityName   | MessagePartyIdType   | PartyType   | MessagePartyId_UIC | RoleType              | PermissionType1              | SplmtryData   |
      | ${BizMsgIdr::format=00002\|ACCR} | ${MessageId::format=00002\|ACCR} | ${T::DateFormatter=ZuluWithMilliSec} | <PartyIdValidFrom> | <ActorId> | <OpeningDate> | <PartyNameValidFrom> | <EntityName> | <MessagePartyIdType> | <PartyType> | <TechAddr>         | #{ADD_NODE}<RoleType> | #{ADD_NODE}<PermissionType1> | <SplmtryData> |
    Then verify NACK with number of messages "1" on outbound queue of "ASXML_OUT" and on poison queue of inbound adapter "ASXML" with message type "comm807"
      | Validate_BAH | Validate_Rltd_BAH         | Nack_Rltd_RefId                        | RejectReasonCode | RejectReasonDescription   |
      | true         | true::IngressLink=inte904 | ${Nack_Rltd_RefId::format=00002\|ACCR} |             0099 | <RejectReasonDescription> |

    @REPORT_SPD-161_SPD-162_4
    Examples: 
      | Description                                                                          | PartyIdValidFrom               | ActorId                           | OpeningDate                  | PartyType | TechAddr | PartyNameValidFrom           | EntityName   | MessagePartyIdType | RoleType | PermissionType1 | RejectReasonDescription                      |
      | PartyId- Valid From date in ZULU format (which is not a valid format for xs-date)    | ${T+2::CalendarFormatter=ZULU} | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}                         | ROLE      | NONREF   | ${T}                         | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CSPA            | is not a valid value for 'date'              |
      | PartyId- Valid From date is provided as string instead of xs-date                    | ${T}ab                         | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}                         | ROLE      | NONREF   | ${T}                         | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CDRA            | is not a valid value for 'date'              |
      | PartyId- Valid From date is invalid - 2018-02-29                                     | 2018-02-29                     | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}                         | ROLE      | NONREF   | ${T}                         | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CETA            | '2018-02-29' is not a valid value for 'date' |
      | Party - Opening Date is invalid - 2018-02-29                                         | ${T}                           | ${#FEATURE#Actor1_NoRole.ActorId} | 2018-02-29                   | ROLE      | NONREF   | ${T}                         | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CSPA            | '2018-02-29' is not a valid value for 'date' |
      | Party - Opening Date in ZULU format (which is not a valid format for xs-date)        | ${T}                           | ${#FEATURE#Actor1_NoRole.ActorId} | ${T::CalendarFormatter=ZULU} | ROLE      | NONREF   | ${T}                         | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CSPA            | is not a valid value for 'date'              |
      | Party - Opening Date - is provided as string instead of xs-date                      | ${T}                           | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}fg                       | ROLE      | NONREF   | ${T}                         | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CSPA            | is not a valid value for 'date'              |
      | PartyName - Valid From date is invalid - 2018-02-29                                  | ${T}                           | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}                         | ROLE      | NONREF   | 2018-02-29                   | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CDRA            | '2018-02-29' is not a valid value for 'date' |
      | PartyName - Valid From date in ZULU format (which is not a valid format for xs-date) | ${T}                           | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}                         | ROLE      | NONREF   | ${T::CalendarFormatter=ZULU} | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CETA            | is not a valid value for 'date'              |
      | PartyName - Valid From date is provided as string instead of xs-date                 | ${T}                           | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}                         | ROLE      | NONREF   | ${T}ad                       | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CETA            | is not a valid value for 'date'              |

  #Length of supplementary data exceeding the schema max length limit
  Scenario Outline: PAC1 PAC3 Account Creator Role message - <Description>
    When I generate a message from template for "inte904" using datatable and publish on adapter "ASXML"
      | BAH_BizMsgIdr                    | MessageId                        | CreationDateTime                     | PartyIdValidFrom   | ActorId   | OpeningDate   | PartyNameValidFrom   | EntityName   | MessagePartyIdType   | PartyType   | MessagePartyId_UIC | RoleType   | PermissionType1   | SplmtryData   |
      | ${BizMsgIdr::format=00002\|ACCR} | ${MessageId::format=00002\|ACCR} | ${T::DateFormatter=ZuluWithMilliSec} | <PartyIdValidFrom> | <ActorId> | <OpeningDate> | <PartyNameValidFrom> | <EntityName> | <MessagePartyIdType> | <PartyType> | <TechAddr>         | <RoleType> | <PermissionType1> | <SplmtryData> |
    Then verify NACK with number of messages "1" on outbound queue of "ASXML_OUT" and on poison queue of inbound adapter "ASXML" with message type "comm807"
      | Validate_BAH | Validate_Rltd_BAH         | Nack_Rltd_RefId                        | RejectReasonCode | RejectReasonDescription   |
      | true         | true::IngressLink=inte904 | ${Nack_Rltd_RefId::format=00002\|ACCR} |             0099 | <RejectReasonDescription> |

    @REPORT_SPD-161_SPD-162_5
    Examples: 
      | Description                                                     | PartyIdValidFrom | ActorId                           | OpeningDate | PartyType | TechAddr | PartyNameValidFrom | EntityName   | MessagePartyIdType | RoleType         | PermissionType1  | RejectReasonDescription                       |
      | Length of role type exceeding the schema max length limit       | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | #{ADD_NODE} ACCR | #{ADD_NODE}CSPA  | not facet-valid with respect to maxLength '4' |
      | Length of permission type exceeding the schema max length limit | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | #{ADD_NODE}ACCR  | #{ADD_NODE} CDRA | not facet-valid with respect to maxLength '4' |

    #Invalid party types,actor ids,short name
    @REPORT_SPD-161_SPD-162_6
    Examples: 
      | Description                 | PartyIdValidFrom | ActorId                           | OpeningDate | PartyType | TechAddr                                                  | PartyNameValidFrom | EntityName   | MessagePartyIdType                                       | RoleType | PermissionType1 | RejectReasonDescription                                                  |
      | invalid party type          | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | RILE      | NONREF                                                    | ${T}               | #{NO_ACTION} | #{NO_ACTION}                                             | ACCR     | CETA            | It must be a value from the enumeration                                  |
      | invalid party type - ENTITY | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ENTITY    | NONREF                                                    | ${T}               | #{NO_ACTION} | #{NO_ACTION}                                             | ACCR     | CETA            | It must be a value from the enumeration                                  |
      | party type in lower case    | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | role      | NONREF                                                    | ${T}               | #{NO_ACTION} | #{NO_ACTION}                                             | ACCR     | CETA            | It must be a value from the enumeration                                  |
      | an invalid actor id         | ${T}             | IN999                             | ${T}        | ROLE      | NONREF                                                    | ${T}               | #{NO_ACTION} | #{NO_ACTION}                                             | ACCR     | CDRA            | not facet-valid with respect to pattern '[0-9]{5}\|NONREF'               |
      | entity id as actor id       | ${T}             | ${#FEATURE#Entity1.EntityId}      | ${T}        | ROLE      | NONREF                                                    | ${T}               | #{NO_ACTION} | #{NO_ACTION}                                             | ACCR     | CDRA            | not facet-valid with respect to pattern '[0-9]{5}\|NONREF'               |
      | invalid short name          | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE      | NONREF                                                    | ${T}               | #{NO_ACTION} | cdsgsgfdgsfdgsfdgsfgdfsgdfgsfdgsfdhgsfhdfshfdhsfdhshfhds | ACCR     | CDRA            | not facet-valid with respect to enumeration '[UIC, BIC8, BIC11, NONREF]' |
      | invalid technical address   | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE      | vasdfasdfsadsarwerqhfhasfdhgsfdhgsfdhafdhgsafdhgafdshgafd | ${T}               | #{NO_ACTION} | #{NO_ACTION}                                             | ACCR     | CDRA            | not facet-valid with respect to pattern '[0-9]{5}\|NONREF'               |

  ####################################################################################################################################
  #AC3: Send a schema valid nack when Role Type is already assigned to the Actor ID.
  ####################################################################################################################################
  Scenario Outline: AC3 Create Account Creator Role with - <Description>
    When I generate a message from template for "inte904" using datatable and publish on adapter "ASXML"
      | BAH_BizMsgIdr                    | MessageId                        | CreationDateTime                     | PartyIdValidFrom   | ActorId   | OpeningDate   | PartyNameValidFrom   | EntityName   | MessagePartyIdType   | PartyType   | MessagePartyId_UIC | RoleType              | PermissionType1              |
      | ${BizMsgIdr::format=00002\|ACCR} | ${MessageId::format=00002\|ACCR} | ${T::DateFormatter=ZuluWithMilliSec} | <PartyIdValidFrom> | <ActorId> | <OpeningDate> | <PartyNameValidFrom> | <EntityName> | <MessagePartyIdType> | <PartyType> | <TechAddr>         | #{ADD_NODE}<RoleType> | #{ADD_NODE}<PermissionType1> |
    Then verify NACK with number of messages "1" on outbound queue of "ASXML_OUT" and on poison queue of inbound adapter "ASXML" with message type "comm808"
      | Validate_BAH | Validate_Rltd_BAH         | Nack_Rltd_RefId                        | RejectReasonCode   | RejectReasonDescription   |
      | true         | true::IngressLink=inte904 | ${Nack_Rltd_RefId::format=00002\|ACCR} | <RejectReasonCode> | <RejectReasonDescription> |
    #Purpose: To be implemented when behaviour is available
    And Verify the "Role" report doesn't exist in ODS for the following attributes from the below table
      | ActorId   | RoleType |
      | <ActorId> | ACCR     |

    @REPORT_SPD-161_SPD-162_7
    Examples: 
      | Description                                                                         | PartyIdValidFrom | ActorId                        | OpeningDate | PartyType | TechAddr | PartyNameValidFrom | EntityName   | MessagePartyIdType | RoleType | PermissionType1 | RejectReasonCode | RejectReasonDescription                                                                                            |
      | sponsored permission type for an actor who already has sponsored account permission | ${T}             | ${#FEATURE#Actor_CSPA.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CSPA            |             1041 | Actor Pty/Id/Id '${#FEATURE#Actor_CSPA.ActorId}' already has Role Type SplmtryData/Envlp/EntyPtyDtls/RoleTp 'ACCR' |
      | sponsored permission type for an actor who already has direct account permission    | ${T}             | ${#FEATURE#Actor_CDRA.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CSPA            |             1041 | Actor Pty/Id/Id '${#FEATURE#Actor_CDRA.ActorId}' already has Role Type SplmtryData/Envlp/EntyPtyDtls/RoleTp 'ACCR' |
      | sponsored permission type for an actor who already has entrepot account permission  | ${T}             | ${#FEATURE#Actor_CETA.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CSPA            |             1041 | Actor Pty/Id/Id '${#FEATURE#Actor_CETA.ActorId}' already has Role Type SplmtryData/Envlp/EntyPtyDtls/RoleTp 'ACCR' |
      | direct permission type for an actor who already has direct account permission       | ${T}             | ${#FEATURE#Actor_CDRA.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CDRA            |             1041 | Actor Pty/Id/Id '${#FEATURE#Actor_CDRA.ActorId}' already has Role Type SplmtryData/Envlp/EntyPtyDtls/RoleTp 'ACCR' |
      | direct permission type for an actor who already has sponsored account permission    | ${T}             | ${#FEATURE#Actor_CSPA.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CDRA            |             1041 | Actor Pty/Id/Id '${#FEATURE#Actor_CSPA.ActorId}' already has Role Type SplmtryData/Envlp/EntyPtyDtls/RoleTp 'ACCR' |
      | direct permission type for an actor who already has entrepot account permission     | ${T}             | ${#FEATURE#Actor_CETA.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CDRA            |             1041 | Actor Pty/Id/Id '${#FEATURE#Actor_CETA.ActorId}' already has Role Type SplmtryData/Envlp/EntyPtyDtls/RoleTp 'ACCR' |
      | entrepot permission type for an actor who already has entrepot account permission   | ${T}             | ${#FEATURE#Actor_CETA.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CETA            |             1041 | Actor Pty/Id/Id '${#FEATURE#Actor_CETA.ActorId}' already has Role Type SplmtryData/Envlp/EntyPtyDtls/RoleTp 'ACCR' |
      | entrepot permission type for an actor who already has direct account permission     | ${T}             | ${#FEATURE#Actor_CDRA.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CETA            |             1041 | Actor Pty/Id/Id '${#FEATURE#Actor_CDRA.ActorId}' already has Role Type SplmtryData/Envlp/EntyPtyDtls/RoleTp 'ACCR' |
      | entrepot permission type for an actor who already has sponsored account permission  | ${T}             | ${#FEATURE#Actor_CSPA.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CETA            |             1041 | Actor Pty/Id/Id '${#FEATURE#Actor_CSPA.ActorId}' already has Role Type SplmtryData/Envlp/EntyPtyDtls/RoleTp 'ACCR' |

  ####################################################################################################################################
  #AC5: Send a nack when Permission type is invalid (Error Code 1002).
  ####################################################################################################################################
  Scenario Outline: AC5 Create Account Creator Role with - <Description>
    When I generate a message from template for "inte904" using datatable and publish on adapter "ASXML"
      | BAH_BizMsgIdr                    | MessageId                        | CreationDateTime                     | PartyIdValidFrom   | ActorId   | OpeningDate   | PartyNameValidFrom   | EntityName   | MessagePartyIdType   | PartyType   | MessagePartyId_UIC | RoleType              | PermissionType1              |
      | ${BizMsgIdr::format=00002\|ACCR} | ${MessageId::format=00002\|ACCR} | ${T::DateFormatter=ZuluWithMilliSec} | <PartyIdValidFrom> | <ActorId> | <OpeningDate> | <PartyNameValidFrom> | <EntityName> | <MessagePartyIdType> | <PartyType> | <TechAddr>         | #{ADD_NODE}<RoleType> | #{ADD_NODE}<PermissionType1> |
    Then verify NACK with number of messages "1" on outbound queue of "ASXML_OUT" and on poison queue of inbound adapter "ASXML" with message type "comm808"
      | Validate_BAH | Validate_Rltd_BAH         | Nack_Rltd_RefId                        | RejectReasonCode   | RejectReasonDescription   |
      | true         | true::IngressLink=inte904 | ${Nack_Rltd_RefId::format=00002\|ACCR} | <RejectReasonCode> | <RejectReasonDescription> |
    #Purpose: To be implemented when behaviour is available
    And Verify the "Role" report doesn't exist in ODS for the following attributes from the below table
      | ActorId   | RoleType |
      | <ActorId> | ACCR     |

    @REPORT_SPD-161_SPD-162_8
    Examples: 
      | Description                   | PartyIdValidFrom | ActorId                           | OpeningDate | PartyType | TechAddr | PartyNameValidFrom | EntityName   | MessagePartyIdType | RoleType | PermissionType1 | RejectReasonCode | RejectReasonDescription                                        |
      | invalid permission type       | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | SPAC            |             1002 | SplmtryData/Envlp/EntyPtyDtls/PrmssnTp 'SPAC' value is invalid |
      | permission type in lower case | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | cdra            |             1002 | SplmtryData/Envlp/EntyPtyDtls/PrmssnTp 'cdra' value is invalid |
      | invalid role type             | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | CCCA     | CETA            |             1002 | SplmtryData/Envlp/EntyPtyDtls/RoleTp 'CCCA' value is invalid   |
      | role type in lower case       | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | accr     | CSPA            |             1002 | SplmtryData/Envlp/EntyPtyDtls/RoleTp 'accr' value is invalid   |

  ####################################################################################################################################
  #AC6: Send a nack when Actor ID does not exist (Error Code 1006).
  ####################################################################################################################################
  Scenario Outline: AC6 Create Account Creator Role with - <Description>
    When I generate a message from template for "inte904" using datatable and publish on adapter "ASXML"
      | BAH_BizMsgIdr                    | MessageId                        | CreationDateTime                     | PartyIdValidFrom   | ActorId   | OpeningDate   | PartyNameValidFrom   | EntityName   | MessagePartyIdType   | PartyType   | MessagePartyId_UIC | RoleType              | PermissionType1              |
      | ${BizMsgIdr::format=00002\|ACCR} | ${MessageId::format=00002\|ACCR} | ${T::DateFormatter=ZuluWithMilliSec} | <PartyIdValidFrom> | <ActorId> | <OpeningDate> | <PartyNameValidFrom> | <EntityName> | <MessagePartyIdType> | <PartyType> | <TechAddr>         | #{ADD_NODE}<RoleType> | #{ADD_NODE}<PermissionType1> |
    Then verify NACK with number of messages "1" on outbound queue of "ASXML_OUT" and on poison queue of inbound adapter "ASXML" with message type "comm808"
      | Validate_BAH | Validate_Rltd_BAH         | Nack_Rltd_RefId                        | RejectReasonCode   | RejectReasonDescription   |
      | true         | true::IngressLink=inte904 | ${Nack_Rltd_RefId::format=00002\|ACCR} | <RejectReasonCode> | <RejectReasonDescription> |
    #Purpose: To be implemented when behaviour is available
    And Verify the "Role" report doesn't exist in ODS for the following attributes from the below table
      | ActorId   | RoleType |
      | <ActorId> | ACCR     |

    @REPORT_SPD-161_SPD-162_9
    Examples: 
      | Description                    | PartyIdValidFrom | ActorId | OpeningDate | PartyType | TechAddr | PartyNameValidFrom | EntityName   | MessagePartyIdType | RoleType | PermissionType1 | RejectReasonCode | RejectReasonDescription          |
      | an actor id that doesn't exist | ${T}             |   99999 | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     | CDRA            |             1006 | Pty/Id/Id '99999' does not exist |

  #####################################################################################################################################
  # AC4: Send a nack when Permission type has no attribute set (Error Code 1003).
  ####################################################################################################################################
  Scenario Outline: AC4 Create Account Creator Role with - <Description>
    When I generate a message from template for "inte904" using datatable and publish on adapter "ASXML"
      | BAH_BizMsgIdr                    | MessageId                        | CreationDateTime                     | PartyIdValidFrom   | ActorId   | OpeningDate   | PartyNameValidFrom   | EntityName   | MessagePartyIdType   | PartyType   | MessagePartyId_UIC | RoleType              | PermissionType1   |
      | ${BizMsgIdr::format=00002\|ACCR} | ${MessageId::format=00002\|ACCR} | ${T::DateFormatter=ZuluWithMilliSec} | <PartyIdValidFrom> | <ActorId> | <OpeningDate> | <PartyNameValidFrom> | <EntityName> | <MessagePartyIdType> | <PartyType> | <TechAddr>         | #{ADD_NODE}<RoleType> | <PermissionType1> |
    Then verify NACK with number of messages "1" on outbound queue of "ASXML_OUT" and on poison queue of inbound adapter "ASXML" with message type "comm808"
      | Validate_BAH | Validate_Rltd_BAH         | Nack_Rltd_RefId                        | RejectReasonCode   | RejectReasonDescription   |
      | true         | true::IngressLink=inte904 | ${Nack_Rltd_RefId::format=00002\|ACCR} | <RejectReasonCode> | <RejectReasonDescription> |
    #Purpose: To be implemented when behaviour is available
    And Verify the "Role" report doesn't exist in ODS for the following attributes from the below table
      | ActorId   | RoleType |
      | <ActorId> | ACCR     |

    @REPORT_SPD-161_SPD-162_10
    Examples: 
      | Description                                   | PartyIdValidFrom | ActorId                           | OpeningDate | PartyType | TechAddr | PartyNameValidFrom | EntityName   | MessagePartyIdType | RoleType | PermissionType1 | RejectReasonCode | RejectReasonDescription                                        |
      | no permission type (without PrmssnTp element) | ${T}             | ${#FEATURE#Actor1_NoRole.ActorId} | ${T}        | ROLE      | NONREF   | ${T}               | #{NO_ACTION} | #{NO_ACTION}       | ACCR     |                 |             1003 | SplmtryData/Envlp/EntyPtyDtls/PrmssnTp is required and missing |
