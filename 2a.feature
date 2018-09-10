#Epic: SPD-161
#Story: SPD-163, SPD-1723, SPD-1722
@regression @nightly @SPD-161_SPD-163_SPD-1723_SPD-1722 @SPD-161
Feature: E_SPD-161 S_SPD-163 S_SPD-1723 S_SPD-1722 Create Account - Business Validations

  @SPD-161_SPD-163_Precondition
  Scenario: PreCondition - Create required Entities, Actors & Roles
    Given the following "Feature" level precondition "inte904" are generated and published via adapter "ASXML"
      | PreconditionKey | EntityName                          | LEI                             | BAH_BizMsgIdr                       | MessageId                           | CreationDateTime                     | PartyIdValidFrom | OpeningDate | PartyNameValidFrom | PartyType |
      | Entity1         | CBA MARKETS LTD-${EXEC_UID}         | #{ADD_NODE}549300FBHFW3O5LH5M59 | ${BizMsgIdr::format=00002\|Entity1} | ${MessageId::format=00002\|Entity1} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ${T}        | ${T}               | ENTY      |
      | Entity2         | COMMONWEALTH SECURITIES-${EXEC_UID} | #{ADD_NODE}549300FBHFW3O5LH5M69 | ${BizMsgIdr::format=00002\|Entity2} | ${MessageId::format=00002\|Entity2} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ${T}        | ${T}               | ENTY      |
    And read the number of outgoing messages "2" on queue "ASXML_OUT" for message type "inte905" and store in scenario context
    And the following precondition table are persisted to "Feature" properties file
      | PreconditionKey | EntityId                        |
      | Entity1         | ${EntityId::key=00002\|Entity1} |
      | Entity2         | ${EntityId::key=00002\|Entity2} |
    And the following "Feature" level precondition "inte904" are generated and published via adapter "ASXML"
      | PreconditionKey | BAH_BizMsgIdr                               | MessageId                                   | CreationDateTime                     | PartyIdValidFrom | PartyType | ActorId                    | OpeningDate | MessagePartyId_BIC                            | MessagePartyId_UIC | PartyNameValidFrom | MessagePartyIdType | EntityId                                | Designation                   |
      | Actor_CDRA      | ${BizMsgIdr::format=00002\|Actor_CDRA}      | ${MessageId::format=00002\|Actor_CDRA}      | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC8} | #{REMOVE_NODE}     | ${T}               | BIC8               | #{ADD_NODE}${#FEATURE#Entity1.EntityId} | #{ADD_NODE}LOAN A/C           |
      | Actor_CSPA      | ${BizMsgIdr::format=00002\|Actor_CSPA}      | ${MessageId::format=00002\|Actor_CSPA}      | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC8} | #{REMOVE_NODE}     | ${T}               | BIC8               | #{ADD_NODE}${#FEATURE#Entity2.EntityId} | #{ADD_NODE}MARGIN  A/C        |
      | Actor_CETA      | ${BizMsgIdr::format=00002\|Actor_CETA}      | ${MessageId::format=00002\|Actor_CETA}      | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC8} | #{REMOVE_NODE}     | ${T}               | BIC8               | #{ADD_NODE}${#FEATURE#Entity2.EntityId} | #{ADD_NODE}MARGIN LENDING A/C |
      | Actor_CETA1     | ${BizMsgIdr::format=00002\|Actor_CETA1}     | ${MessageId::format=00002\|Actor_CETA1}     | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC8} | #{REMOVE_NODE}     | ${T}               | BIC8               | #{ADD_NODE}${#FEATURE#Entity1.EntityId} | #{ADD_NODE}MARGIN LENDING A/C |
      | Actor_CETA2     | ${BizMsgIdr::format=00002\|Actor_CETA2}     | ${MessageId::format=00002\|Actor_CETA2}     | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC8} | #{REMOVE_NODE}     | ${T}               | BIC8               | #{ADD_NODE}${#FEATURE#Entity2.EntityId} | #{ADD_NODE}MARGIN LENDING A/C |
      | Actor_CDRA_CSPA | ${BizMsgIdr::format=00002\|Actor_CDRA_CSPA} | ${MessageId::format=00002\|Actor_CDRA_CSPA} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC8} | #{REMOVE_NODE}     | ${T}               | BIC8               | #{ADD_NODE}${#FEATURE#Entity2.EntityId} | #{ADD_NODE}MARGIN LENDING A/C |
      | Actor_CDRA_CETA | ${BizMsgIdr::format=00002\|Actor_CDRA_CETA} | ${MessageId::format=00002\|Actor_CDRA_CETA} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC8} | #{REMOVE_NODE}     | ${T}               | BIC8               | #{ADD_NODE}${#FEATURE#Entity1.EntityId} | #{ADD_NODE}MARGIN LENDING A/C |
      | Actor_CSPA_CETA | ${BizMsgIdr::format=00002\|Actor_CSPA_CETA} | ${MessageId::format=00002\|Actor_CSPA_CETA} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC8} | #{REMOVE_NODE}     | ${T}               | BIC8               | #{ADD_NODE}${#FEATURE#Entity2.EntityId} | #{ADD_NODE}MARGIN LENDING A/C |
    And Verify the number of outgoing messages on outbound adapter "ASXML_OUT" recieved are "8"
    And the following "Feature" level precondition "inte904" are generated and published via adapter "ASXML"
      | PreconditionKey | BAH_BizMsgIdr                              | MessageId                                  | CreationDateTime                     | PartyIdValidFrom | PartyType | ActorId                             | OpeningDate | RoleType        | PartyNameValidFrom | PermissionType1 | PermissionType2 |
      | ACCR_CDRA       | ${BizMsgIdr::format=00002\|ACCR_CDRA}      | ${MessageId::format=00002\|ACCR_CDRA}      | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_CDRA.ActorId}      | ${T}        | #{ADD_NODE}ACCR | ${T}               | #{ADD_NODE}CDRA | #{NO_ACTION}    |
      | ACCR_CSPA       | ${BizMsgIdr::format=00002\|ACCR_CSPA}      | ${MessageId::format=00002\|ACCR_CSPA}      | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_CSPA.ActorId}      | ${T}        | #{ADD_NODE}ACCR | ${T}               | #{ADD_NODE}CSPA | #{NO_ACTION}    |
      | ACCR_CETA       | ${BizMsgIdr::format=00002\|ACCR_CETA}      | ${MessageId::format=00002\|ACCR_CETA}      | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_CETA.ActorId}      | ${T}        | #{ADD_NODE}ACCR | ${T}               | #{ADD_NODE}CETA | #{NO_ACTION}    |
      | ACCR_CETA1      | ${BizMsgIdr::format=00002\|ACCR_CETA1}     | ${MessageId::format=00002\|ACCR_CETA1}     | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_CETA1.ActorId}     | ${T}        | #{ADD_NODE}ACCR | ${T}               | #{ADD_NODE}CETA | #{NO_ACTION}    |
      | ACCR_CETA2      | ${BizMsgIdr::format=00002\|ACCR_CETA2}     | ${MessageId::format=00002\|ACCR_CETA2}     | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_CETA2.ActorId}     | ${T}        | #{ADD_NODE}ACCR | ${T}               | #{ADD_NODE}CETA | #{NO_ACTION}    |
      | ACCR_CDRA_CSPA  | ${BizMsgIdr::format=00002\|ACCR_CDRA_CSPA} | ${MessageId::format=00002\|ACCR_CDRA_CSPA} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_CDRA_CSPA.ActorId} | ${T}        | #{ADD_NODE}ACCR | ${T}               | #{ADD_NODE}CDRA | #{ADD_NODE}CSPA |
      | ACCR_CDRA_CETA  | ${BizMsgIdr::format=00002\|ACCR_CDRA_CETA} | ${MessageId::format=00002\|ACCR_CDRA_CETA} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_CDRA_CETA.ActorId} | ${T}        | #{ADD_NODE}ACCR | ${T}               | #{ADD_NODE}CDRA | #{ADD_NODE}CETA |
      | ACCR_CSPA_CETA  | ${BizMsgIdr::format=00002\|ACCR_CSPA_CETA} | ${MessageId::format=00002\|ACCR_CSPA_CETA} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_CSPA_CETA.ActorId} | ${T}        | #{ADD_NODE}ACCR | ${T}               | #{ADD_NODE}CSPA | #{ADD_NODE}CETA |
    And Verify the number of outgoing messages on outbound adapter "ASXML_OUT" recieved are "8"

  Scenario Outline: <AC> Create <Description>
    When I generate a message from template for "acct001" using datatable and publish on adapter "ISO"
      | BAH_From  | BAH_BizMsgIdr                               | MessageId                               | BAH_CreDt                            | SctiesAcct_OpngDt | Sup_AcctType   | Sup_Name   | Sup_AdrLine1              | Sup_PstCd              | Sup_TwnNm              | Sup_CtrySubDvsn              | Sup_Ctry              | Sup_ResInd              | Sup_ComMtdCd   |
      | <ActorId> | <ActorId>${BAH_BizMsgIdr::format=\|Account} | <ActorId>${MessageId::format=\|Account} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}              | <Sup_AcctType> | <Sup_Name> | #{ADD_NODE}<Sup_AdrLine1> | #{ADD_NODE}<Sup_PstCd> | #{ADD_NODE}<Sup_TwnNm> | #{ADD_NODE}<Sup_CtrySubDvsn> | #{ADD_NODE}<Sup_Ctry> | #{ADD_NODE}<Sup_ResInd> | <Sup_ComMtdCd> |
    Then verify number of outgoing messages "1" on queue "ISO_OUT" for message type "acct002" with the following datatable and validate the schema of the outgoing message
      | Validate_BAH | Validate_Rltd_BAH | BAH_To    | OriginalMsgId                               | Status |
      | true         | true              | <ActorId> | <ActorId>${OriginalMsgId::format=\|Account} | COMP   |
    And Verify the "Account" report in ODS for the following attributes from the below table
      | ActorId   | AccountType    | ResidencyIndicator |
      | <ActorId> | <Sup_AcctType> | <Sup_ResInd>       |

    #####################################################################################################################################################
    #AC1: Create a Sponsored ,Direct Account or Entrepot where all mandatory fields are provided (refer to the table below), resulting in an ack message.
    #####################################################################################################################################################
    #AC3: Account Creator has permission to create an account of account type Sponsored, Direct, or Entrepot resulting in an account created.
    #####################################################################################################################################################
    # SPD-1723 - AC2: C&S System successfully validates Country Sub-Division and Postal Code based on the Country Code being AU.
    #####################################################################################################################################################
    @REPORT_SPD-161_SPD-163_1
    Examples: 
      | AC                               | Description                                                    | ActorId                             | Sup_AcctType | Sup_Name                  | Sup_AdrLine1          | Sup_PstCd | Sup_TwnNm     | Sup_CtrySubDvsn | Sup_Ctry | Sup_ResInd | Sup_ComMtdCd    |
      | SPD-163 - AC1,AC3 SPD-1723 - AC2 | Direct account with domestic residency indicator               | ${#FEATURE#Actor_CDRA.ActorId}      | DRCT         | RICHARD PTY LTD           | 3/240 CARRINGTON ROAD |      2031 | COOGEE        | NSW             | AU       | DMST       |                 |
      | AC1 AC3                          | Sponsored account with mixed residency indicator               | ${#FEATURE#Actor_CDRA_CSPA.ActorId} | SPSD         | Target Ltd                | 33 West Vernon Circle |    689000 | West New York | New York        | US       | MIXD       | #{ADD_NODE}POST |
      | SPD-163 - AC1,AC3 SPD-1723 - AC2 | Settlement entrepot account with domestic residency indicator  | ${#FEATURE#Actor_CETA.ActorId}      | SETT         | Ausgrid                   | 2 Invermay Road       |      7250 | Launceston    | TAS             | AU       | DMST       |                 |
      | SPD-163 - AC1,AC3 SPD-1723 - AC2 | Accumulation entrepot account with foreign residency indicator | ${#FEATURE#Actor_CETA.ActorId}      | ACCU         | Pangaea Resources Pty Ltd | GPO Box 1680          |      0801 | Darwin        | NT              | AU       | FRGN       |                 |

    #####################################################################################################################################################
    #AC5: If the Account Type is Direct or Sponsored and the Residency Indicator is Domestic, Foreign or Mixed, resulting in an account is created.
    #####################################################################################################################################################
    #AC9: If the Account Type is Sponsored and the Communication Preference is Post, resulting an account  is created.
    #####################################################################################################################################################
    #AC11: If the Account Type is Direct and the Communication Preference is not provided, resulting in an account is created.
    ####################################################################################################################################################
    #SPD-1723 - AC1: C&S System successfully validates International Country Code, Country Sub-Division and Postal Code.
    #####################################################################################################################################################
    @REPORT_SPD-161_SPD-163_2
    Examples: 
      | AC                                 | Description                                         | ActorId                             | Sup_AcctType | Sup_Name        | Sup_AdrLine1             | Sup_PstCd | Sup_TwnNm | Sup_CtrySubDvsn | Sup_Ctry | Sup_ResInd | Sup_ComMtdCd    |
      | AC5 AC11                           | Direct account with domestic residency indicator    | ${#FEATURE#Actor_CDRA.ActorId}      | DRCT         | RICHARD PTY LTD | 30 GREAT WESTERN HIGHWAY |      2031 | COOGEE    | NSW             | AU       | DMST       |                 |
      | SPD-163 - AC5,AC11, SPD-1723 - AC1 | Direct account with foreign residency indicator     | ${#FEATURE#Actor_CDRA.ActorId}      | DRCT         | William PTY LTD | 24 CARRINGTON ROAD       |    700089 | Detroit   | Michigan        | US       | FRGN       |                 |
      | AC5 AC11                           | Direct account with mixed residency indicator       | ${#FEATURE#Actor_CDRA.ActorId}      | DRCT         | P&J PTY LTD     | 240 PYE ROAD             |      2051 | Richmond  | VIC             | AU       | MIXD       |                 |
      | AC5 AC9                            | Sponsored account with domestic residency indicator | ${#FEATURE#Actor_CSPA.ActorId}      | SPSD         | Target Ltd      | 43 West Vernon Circle    |      5043 | Richmond  | TAS             | AU       | DMST       | #{ADD_NODE}POST |
      | AC5 AC9                            | Sponsored account with foreign residency indicator  | ${#FEATURE#Actor_CDRA_CSPA.ActorId} | SPSD         | Coles Ltd       | 33 Dunnway               |      2091 | Pymble    | NT              | AU       | FRGN       | #{ADD_NODE}POST |
      | SPD-163 - AC5 AC9, SPD-1723 - AC1  | Sponsored account with mixed residency indicator    | ${#FEATURE#Actor_CSPA.ActorId}      | SPSD         | Ford Ltd        | 57 Sunnyvale road        |    709978 | Ryde      | Berlin          | DE       | MIXD       | #{ADD_NODE}POST |

    #####################################################################################################################################################
    #AC7: If Account Type is Settlement or Accumulation Entrepot and the Residency Indicator stipulated as Foreign or Domestic, resulting in an account is created.
    #####################################################################################################################################################
    #AC8: If Account Type is Settlement or Accumulation Entrepot and the Communication Preference is not provided, resulting in an account is created.
    #####################################################################################################################################################
    @REPORT_SPD-161_SPD-163_3
    Examples: 
      | AC      | Description                                                     | ActorId                             | Sup_AcctType | Sup_Name                  | Sup_AdrLine1    | Sup_PstCd | Sup_TwnNm  | Sup_CtrySubDvsn | Sup_Ctry | Sup_ResInd | Sup_ComMtdCd |
      | AC7 AC8 | Settlement entrepot account with domestic residency indicator   | ${#FEATURE#Actor_CETA.ActorId}      | SETT         | Ausgrid                   | 2 Invermay Road |      7250 | Launceston | TAS             | AU       | DMST       |              |
      | AC7 AC8 | Settlement entrepot account with foreign residency indicator    | ${#FEATURE#Actor_CETA.ActorId}      | SETT         | Energy Australia          | GPO Box 1680    |      2980 | Brunswick  | WA              | AU       | FRGN       |              |
      | AC7 AC8 | Accumulation entrepot account with domestic residency indicator | ${#FEATURE#Actor_CETA.ActorId}      | ACCU         | Pangaea Resources Pty Ltd | GPO Box 1256    |      0801 | Adelaide   | SA              | AU       | DMST       |              |
      | AC7 AC8 | Accumulation entrepot account with foreign residency indicator  | ${#FEATURE#Actor_CSPA_CETA.ActorId} | ACCU         | NDM Resources Pty Ltd     | 40 Harry Avenue |       122 | Wellington | Wellington      | NZ       | FRGN       |              |

  Scenario Outline: <AC> <Description>
    When I generate a message from template for "acct001" using datatable and publish on adapter "ISO"
      | BAH_From  | BAH_BizMsgIdr                               | MessageId                               | BAH_CreDt                            | SctiesAcct_OpngDt | Sup_AcctType   | Sup_Name   | Sup_AdrLine1              | Sup_PstCd              | Sup_TwnNm              | Sup_CtrySubDvsn              | Sup_Ctry              | Sup_ResInd              | Sup_ComMtdCd   |
      | <ActorId> | <ActorId>${BAH_BizMsgIdr::format=\|Account} | <ActorId>${MessageId::format=\|Account} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}              | <Sup_AcctType> | <Sup_Name> | #{ADD_NODE}<Sup_AdrLine1> | #{ADD_NODE}<Sup_PstCd> | #{ADD_NODE}<Sup_TwnNm> | #{ADD_NODE}<Sup_CtrySubDvsn> | #{ADD_NODE}<Sup_Ctry> | #{ADD_NODE}<Sup_ResInd> | <Sup_ComMtdCd> |
    Then verify NACK with number of messages "1" on outbound queue of "ISO_OUT" and on poison queue of inbound adapter "ISO" with message type "comm808"
      | Validate_BAH | Validate_Rltd_BAH         | BAH_To    | Nack_Rltd_RefId                             | RejectReasonCode   | RejectReasonDescription   |
      | true         | true::IngressLink=acct001 | <ActorId> | <ActorId>${OriginalMsgId::format=\|Account} | <RejectReasonCode> | <RejectReasonDescription> |
    And Verify the "Account" report doesn't exist in ODS for the following attributes from the below table
      | ActorId   | AccountType    | ResidencyIndicator |
      | <ActorId> | <Sup_AcctType> | <Sup_ResInd>       |

    ##############################################################################################################################################
    #AC4: Account Creator does not have permission to create an account of account type Sponsored, Direct or Entrepot, resulting in a nack message
    ##############################################################################################################################################
    @REPORT_SPD-161_SPD-163_4
    Examples: 
      | AC  | Description                                                                                      | ActorId                             | Sup_AcctType | Sup_Name           | Sup_AdrLine1                     | Sup_PstCd | Sup_TwnNm     | Sup_CtrySubDvsn | Sup_Ctry | Sup_ResInd | Sup_ComMtdCd    | RejectReasonCode | RejectReasonDescription             |
      | AC4 | Actor with direct account permission requesting to add sponsored account                         | ${#FEATURE#Actor_CDRA.ActorId}      | SPSD         | RICHARD PTY LTD    | 3/240 CARRINGTON ROAD            |      2031 | COOGEE        | NSW             | AU       | MIXD       | #{ADD_NODE}POST |             1008 | Actor Id not allowed to create HINs |
      | AC4 | Actor with sponsored account permission requesting to add direct account                         | ${#FEATURE#Actor_CSPA.ActorId}      | DRCT         | Bayer Ltd          | 51368 Leverkusen                 |    500045 | Berlin        | Berlin          | DE       | FRGN       |                 |             1008 | Actor Id not allowed to create HINs |
      | AC4 | Actor with direct account permission requesting to add settlement entrepot account               | ${#FEATURE#Actor_CDRA.ActorId}      | SETT         | BCG Group Ltd      | Level 6, 16 Marcus Clarke Street |      2601 | Canberra      | ACT             | AU       | DMST       |                 |             1008 | Actor Id not allowed to create HINs |
      | AC4 | Actor with sponsored account permission requesting to add accumulation entrepot account          | ${#FEATURE#Actor_CSPA.ActorId}      | ACCU         | Schneider Electric | PO Box 5068                      |      4500 | Brendale      | QLD             | AU       | FRGN       |                 |             1008 | Actor Id not allowed to create HINs |
      | AC4 | Actor with entrepot account permission requesting to add sponsored account                       | ${#FEATURE#Actor_CETA.ActorId}      | SPSD         | Woolworths Ltd     | Barkly Square                    |      5000 | Brunswick     | VIC             | AU       | FRGN       | #{ADD_NODE}POST |             1008 | Actor Id not allowed to create HINs |
      | AC4 | Actor with entrepot account permission requesting to add direct account                          | ${#FEATURE#Actor_CETA.ActorId}      | DRCT         | Target Ltd         | 33 West Vernon Circle            |     07093 | West New York | NJ              | US       | MIXD       |                 |             1008 | Actor Id not allowed to create HINs |
      | AC4 | Actor with direct and sponsored account permission requesting to add settlement entrepot account | ${#FEATURE#Actor_CDRA_CSPA.ActorId} | SETT         | Ausgrid            | 2 Invermay Road                  |      7250 | Launceston    | TAS             | AU       | DMST       |                 |             1008 | Actor Id not allowed to create HINs |
      | AC4 | Actor with direct and entrepot account permission requesting to add sponsored account            | ${#FEATURE#Actor_CDRA_CETA.ActorId} | SPSD         | Energy Australia   | 35 Stirling Highway              |      6009 | Perth         | WA              | AU       | FRGN       | #{ADD_NODE}POST |             1008 | Actor Id not allowed to create HINs |
      | AC4 | Actor with sponsored and entrepot account permission requesting to add direct account            | ${#FEATURE#Actor_CSPA_CETA.ActorId} | DRCT         | Ford Group Ltd     | P.O. Box 2000                    |     48002 | Michigan      | DET             | US       | DMST       |                 |             1008 | Actor Id not allowed to create HINs |

    ##########################################################################################################################################################
    # AC6: If Account Type is Settlement or Accumulation Entrepot and the Residency Indicator stipulated as Mixed, resulting in nack message. (Error Code 1004)
    ##########################################################################################################################################################
    @REPORT_SPD-161_SPD-163_5
    Examples: 
      | AC  | Description                                                         | ActorId                        | Sup_AcctType | Sup_Name        | Sup_AdrLine1          | Sup_PstCd | Sup_TwnNm | Sup_CtrySubDvsn | Sup_Ctry | Sup_ResInd | Sup_ComMtdCd | RejectReasonCode | RejectReasonDescription                                                                               |
      | AC6 | Create accumulation entrepot account with mixed residency indicator | ${#FEATURE#Actor_CETA.ActorId} | ACCU         | RICHARD PTY LTD | 3/240 CARRINGTON ROAD |      2031 | COOGEE    | NSW             | AU       | MIXD       |              |             1004 | SplmtryData/Envlp/AcctDtls/AcctTp 'ACCU' is not allowed with SplmtryData/Envlp/AcctDtls/ResInd 'MIXD' |
      | AC6 | Create settlement entrepot account with mixed residency indicator   | ${#FEATURE#Actor_CETA.ActorId} | SETT         | Bayer Ltd       | 51368 Leverkusen      |     50020 | Berlin    | Berlin          | DE       | MIXD       |              |             1004 | SplmtryData/Envlp/AcctDtls/AcctTp 'SETT' is not allowed with SplmtryData/Envlp/AcctDtls/ResInd 'MIXD' |

    ##########################################################################################################################################################
    # AC10: If the Account Type is Sponsored and the Communication Preference is not provided, resulting in a nack message
    ##########################################################################################################################################################
    @REPORT_SPD-161_SPD-163_6
    Examples: 
      | AC   | Description                                                       | ActorId                        | Sup_AcctType | Sup_Name  | Sup_AdrLine1     | Sup_PstCd | Sup_TwnNm | Sup_CtrySubDvsn | Sup_Ctry | Sup_ResInd | Sup_ComMtdCd | RejectReasonCode | RejectReasonDescription                                                                             |
      | AC10 | Create sponsored account with no communication preference element | ${#FEATURE#Actor_CSPA.ActorId} | SPSD         | Bayer Ltd | 51368 Leverkusen |     70056 | Chatswood | Berlin          | DE       | MIXD       | #{NO_ACTION} |             1004 | SplmtryData/Envlp/AcctDtls/AcctTp 'SPSD' is not allowed with SplmtryData/Envlp/AcctDtls/ComMtdCd '' |

    ##########################################################################################################################################################
    # AC13: If Account Type is Settlement or Accumulation Entrepot and the Communication Preference is provided, resulting in nack message. (Error Code 1004)
    ##########################################################################################################################################################
    @REPORT_SPD-161_SPD-163_7
    Examples: 
      | AC   | Description                                                               | ActorId                        | Sup_AcctType | Sup_Name        | Sup_AdrLine1          | Sup_PstCd | Sup_TwnNm | Sup_CtrySubDvsn | Sup_Ctry | Sup_ResInd | Sup_ComMtdCd    | RejectReasonCode | RejectReasonDescription                                                                                 |
      | AC13 | Create accumulation entrepot account with communication Preference - POST | ${#FEATURE#Actor_CETA.ActorId} | ACCU         | RICHARD PTY LTD | 3/240 CARRINGTON ROAD |      2031 | COOGEE    | NSW             | AU       | DMST       | #{ADD_NODE}POST |             1004 | SplmtryData/Envlp/AcctDtls/AcctTp 'ACCU' is not allowed with SplmtryData/Envlp/AcctDtls/ComMtdCd 'POST' |
      | AC13 | Create accumulation entrepot account with communication Preference - EMAL | ${#FEATURE#Actor_CETA.ActorId} | ACCU         | Bayer Ltd       | 31 Leverkusen road    |     70078 | Brunswick | Berlin          | DE       | FRGN       | #{ADD_NODE}EMAL |             1004 | SplmtryData/Envlp/AcctDtls/AcctTp 'ACCU' is not allowed with SplmtryData/Envlp/AcctDtls/ComMtdCd 'EMAL' |
      | AC13 | Create settlement entrepot account with communication Preference - POST   | ${#FEATURE#Actor_CETA.ActorId} | SETT         | Taylor Ltd      | 17 Waterloo road      |    900777 | NewCastle | Amsterdam       | NL       | FRGN       | #{ADD_NODE}POST |             1004 | SplmtryData/Envlp/AcctDtls/AcctTp 'SETT' is not allowed with SplmtryData/Envlp/AcctDtls/ComMtdCd 'POST' |
      | AC13 | Create settlement entrepot account with communication Preference - EMAL   | ${#FEATURE#Actor_CETA.ActorId} | SETT         | Peterson Ltd    | 23 Civic Avenue       |      8900 | Liverpool | NSW             | AU       | DMST       | #{ADD_NODE}EMAL |             1004 | SplmtryData/Envlp/AcctDtls/AcctTp 'SETT' is not allowed with SplmtryData/Envlp/AcctDtls/ComMtdCd 'EMAL' |

    #If the Account Type is stipulated as Sponsored, the Communication Preference must be Post.
    @REPORT_SPD-161_SPD-163_8
    Examples: 
      | AC     | Description                                                   | ActorId                        | Sup_AcctType | Sup_Name  | Sup_AdrLine1     | Sup_PstCd | Sup_TwnNm    | Sup_CtrySubDvsn | Sup_Ctry | Sup_ResInd | Sup_ComMtdCd    | RejectReasonCode | RejectReasonDescription                                                                                 |
      | AC-TBD | Create sponsored account with communication Preference - EMAL | ${#FEATURE#Actor_CSPA.ActorId} | SPSD         | Bayer Ltd | 51 Leverkusen St |     79223 | ChristChurch | Berlin          | DE       | FRGN       | #{ADD_NODE}EMAL |             1004 | SplmtryData/Envlp/AcctDtls/AcctTp 'SPSD' is not allowed with SplmtryData/Envlp/AcctDtls/ComMtdCd 'EMAL' |

    ###############################################################################################################
    #AC12: If the Account Type is Direct and the Communication Preference is provided , resulting in an Nack message
    ###############################################################################################################
    @REPORT_SPD-161_SPD-163_9
    Examples: 
      | AC   | Description                                                     | ActorId                        | Sup_AcctType | Sup_Name        | Sup_AdrLine1          | Sup_PstCd | Sup_TwnNm | Sup_CtrySubDvsn | Sup_Ctry | Sup_ResInd | Sup_ComMtdCd    | RejectReasonCode | RejectReasonDescription                                                                                 |
      | AC12 | AC12 Create direct account with communication Preference - POST | ${#FEATURE#Actor_CDRA.ActorId} | DRCT         | RICHARD PTY LTD | 3/240 CARRINGTON ROAD |      2031 | COOGEE    | NSW             | AU       | DMST       | #{ADD_NODE}POST |             1004 | SplmtryData/Envlp/AcctDtls/AcctTp 'DRCT' is not allowed with SplmtryData/Envlp/AcctDtls/ComMtdCd 'POST' |
      | AC12 | AC12 Create direct account with communication Preference - EMAL | ${#FEATURE#Actor_CDRA.ActorId} | DRCT         | Graigner Ltd    | 34 Pittwater road     |     78999 | Kingston  | Newyork         | US       | FRGN       | #{ADD_NODE}EMAL |             1004 | SplmtryData/Envlp/AcctDtls/AcctTp 'DRCT' is not allowed with SplmtryData/Envlp/AcctDtls/ComMtdCd 'EMAL' |

  Scenario Outline: SPD-163- AC14 SPD-1722- AC1 <Description>  - <Sup_Dsgnt>
    When I generate a message from template for "acct001" using datatable and publish on adapter "ISO"
      | BAH_From  | BAH_BizMsgIdr                               | MessageId                               | BAH_CreDt                            | SctiesAcct_OpngDt | Sup_AcctType   | Sup_Name   | Sup_AdrLine1              | Sup_PstCd              | Sup_TwnNm              | Sup_CtrySubDvsn              | Sup_Ctry              | Sup_Dsgnt              | Sup_ResInd              | Sup_ComMtdCd   |
      | <ActorId> | <ActorId>${BAH_BizMsgIdr::format=\|Account} | <ActorId>${MessageId::format=\|Account} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}              | <Sup_AcctType> | <Sup_Name> | #{ADD_NODE}<Sup_AdrLine1> | #{ADD_NODE}<Sup_PstCd> | #{ADD_NODE}<Sup_TwnNm> | #{ADD_NODE}<Sup_CtrySubDvsn> | #{ADD_NODE}<Sup_Ctry> | #{ADD_NODE}<Sup_Dsgnt> | #{ADD_NODE}<Sup_ResInd> | <Sup_ComMtdCd> |
    Then verify number of outgoing messages "1" on queue "ISO_OUT" for message type "acct002" with the following datatable and validate the schema of the outgoing message
      | Validate_BAH | Validate_Rltd_BAH | BAH_To    | OriginalMsgId                               | Status |
      | true         | true              | <ActorId> | <ActorId>${OriginalMsgId::format=\|Account} | COMP   |
    And Verify the "Account" report in ODS for the following attributes from the below table
      | ActorId   | AccountType    | ResidencyIndicator |
      | <ActorId> | <Sup_AcctType> | <Sup_ResInd>       |

    ##########################################################################################################################################################
    # AC14: If the Designation is populated and does not contain any of the invalid words or phrases, resulting an account is created.
    ##########################################################################################################################################################
    # SPD-1722 - AC1: C&S System successfully validates Registered Holder Name, Designation, Registered Holder Address.
    ##########################################################################################################################################################
    @REPORT_SPD-161_SPD-163_10
    Examples: 
      | Description                                           | ActorId                        | Sup_AcctType | Sup_Name           | Sup_AdrLine1                     | Sup_PstCd | Sup_TwnNm | Sup_CtrySubDvsn | Sup_Ctry | Sup_ResInd | Sup_Dsgnt            | Sup_ComMtdCd    |
      | Create sponsored account with designation             | ${#FEATURE#Actor_CSPA.ActorId} | SPSD         | RICHARD PTY LTD    | 3/240 CARRINGTON ROAD            |      2031 | COOGEE    | NSW             | AU       | MIXD       | RICHARDCustod Fund   | #{ADD_NODE}POST |
      | Create direct account with designation                | ${#FEATURE#Actor_CDRA.ActorId} | DRCT         | Bayer Ltd          | 51368 Leverkusen                 |    700986 | Amsterdam | AMSD            | NL       | FRGN       | Arthtest Super Fund  |                 |
      | Create settlement entrepot account with designation   | ${#FEATURE#Actor_CETA.ActorId} | SETT         | BCG Group Ltd      | Level 6, 16 Marcus Clarke Street |      2601 | Canberra  | ACT             | AU       | DMST       | BCG Fund             |                 |
      | Create accumulation entrepot account with designation | ${#FEATURE#Actor_CETA.ActorId} | ACCU         | Schneider Electric | PO Box 5068                      |      4500 | Brendale  | QLD             | AU       | FRGN       | Schneider Super Fund |                 |

  Scenario Outline: AC15 <Description>  - <Sup_Dsgnt>
    When I generate a message from template for "acct001" using datatable and publish on adapter "ISO"
      | BAH_From  | BAH_BizMsgIdr                               | MessageId                               | BAH_CreDt                            | SctiesAcct_OpngDt | Sup_AcctType   | Sup_Name   | Sup_AdrLine1              | Sup_PstCd              | Sup_TwnNm              | Sup_CtrySubDvsn              | Sup_Ctry              | Sup_Dsgnt              | Sup_ResInd              | Sup_ComMtdCd   |
      | <ActorId> | <ActorId>${BAH_BizMsgIdr::format=\|Account} | <ActorId>${MessageId::format=\|Account} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}              | <Sup_AcctType> | <Sup_Name> | #{ADD_NODE}<Sup_AdrLine1> | #{ADD_NODE}<Sup_PstCd> | #{ADD_NODE}<Sup_TwnNm> | #{ADD_NODE}<Sup_CtrySubDvsn> | #{ADD_NODE}<Sup_Ctry> | #{ADD_NODE}<Sup_Dsgnt> | #{ADD_NODE}<Sup_ResInd> | <Sup_ComMtdCd> |
    Then verify NACK with number of messages "1" on outbound queue of "ISO_OUT" and on poison queue of inbound adapter "ISO" with message type "comm808"
      | Validate_BAH | Validate_Rltd_BAH         | BAH_To    | Nack_Rltd_RefId                             | RejectReasonCode   | RejectReasonDescription   |
      | true         | true::IngressLink=acct001 | <ActorId> | <ActorId>${OriginalMsgId::format=\|Account} | <RejectReasonCode> | <RejectReasonDescription> |
    And Verify the "Account" report doesn't exist in ODS for the following attributes from the below table
      | ActorId   | AccountType    | ResidencyIndicator |
      | <ActorId> | <Sup_AcctType> | <Sup_ResInd>       |

    ##########################################################################################################################################################
    # AC15: If the Designation is populated and contains any of the invalid words or phrases , resulting in a nack message, (Error Code 1002).
    ##########################################################################################################################################################
    @REPORT_SPD-161_SPD-163_11
    Examples: 
      | Description                                           | ActorId                        | Sup_AcctType | Sup_Name           | Sup_AdrLine1          | Sup_PstCd | Sup_TwnNm     | Sup_CtrySubDvsn | Sup_Ctry | Sup_ResInd | Sup_Dsgnt                      | Sup_ComMtdCd    | RejectReasonCode | RejectReasonDescription                                                            |
      | Create sponsored account with designation             | ${#FEATURE#Actor_CSPA.ActorId} | SPSD         | RICHARD PTY LTD    | 3/240 CARRINGTON ROAD |      2031 | COOGEE        | NSW             | AU       | MIXD       | AS TRUSTEE FOR RICHARD PTY LTD | #{ADD_NODE}POST |             1002 | SplmtryData/Envlp/AcctDtls/Dsgnt 'AS TRUSTEE FOR RICHARD PTY LTD' value is invalid |
      | Create direct account with designation                | ${#FEATURE#Actor_CDRA.ActorId} | DRCT         | Bayer Ltd          | 11 Leverkusen Avenue  |    700677 | Kingston      | Berlin          | DE       | FRGN       | AS CUSTODIAN FOR               |                 |             1002 | SplmtryData/Envlp/AcctDtls/Dsgnt 'AS CUSTODIAN FOR' value is invalid               |
      | Create accumulation entrepot account with designation | ${#FEATURE#Actor_CETA.ActorId} | ACCU         | Schneider Electric | PO Box 5068           |      4500 | Brendale      | QLD             | AU       | FRGN       | Schneider TRUST Fund           |                 |             1002 | SplmtryData/Envlp/AcctDtls/Dsgnt 'Schneider TRUST Fund' value is invalid           |
      | Create sponsored account with designation             | ${#FEATURE#Actor_CSPA.ActorId} | SPSD         | Woolworths Ltd     | Barkly Square         |      6778 | Brunswick     | VIC             | AU       | FRGN       | Woolworths TESTAMENTARY        | #{ADD_NODE}POST |             1002 | SplmtryData/Envlp/AcctDtls/Dsgnt 'Woolworths TESTAMENTARY' value is invalid        |
      | Create direct account with designation                | ${#FEATURE#Actor_CDRA.ActorId} | DRCT         | Target Ltd         | 33 West Vernon Circle |     07093 | West New York | NJ              | US       | MIXD       | ATF Fund Ltd                   |                 |             1002 | SplmtryData/Envlp/AcctDtls/Dsgnt 'ATF Fund Ltd' value is invalid                   |
      | Create settlement entrepot account with designation   | ${#FEATURE#Actor_CETA.ActorId} | SETT         | Ausgrid            | 2 Invermay Road       |      7250 | Launceston    | TAS             | AU       | DMST       | acf super fund                 |                 |             1002 | SplmtryData/Envlp/AcctDtls/Dsgnt 'acf super fund' value is invalid                 |
      | Create accumulation entrepot account with designation | ${#FEATURE#Actor_CETA.ActorId} | ACCU         | Energy Australia   | 35 Stirling Highway   |      6009 | Perth         | WA              | AU       | FRGN       | Super TeST Fund                |                 |             1002 | SplmtryData/Envlp/AcctDtls/Dsgnt 'Super TeST Fund' value is invalid                |
      | Create sponsored account with designation             | ${#FEATURE#Actor_CSPA.ActorId} | SPSD         | Ford Group Ltd     | P.O. Box 2000         |     48002 | Michigan      | DET             | US       | DMST       | Trstee                         | #{ADD_NODE}POST |             1002 | SplmtryData/Envlp/AcctDtls/Dsgnt 'Trstee' value is invalid                         |
      | Create direct account with designation                | ${#FEATURE#Actor_CDRA.ActorId} | DRCT         | Graigner Group Ltd | P.O. Box 2000         |     48002 | Michigan      | DET             | US       | DMST       | TRUSTEE                        |                 |             1002 | SplmtryData/Envlp/AcctDtls/Dsgnt 'TRUSTEE' value is invalid                        |

  #############################################################################################################################################################################
  # AC16: If Account Type is Settlement Entreport with Residency Indicator of Domestic or Foreign, and it its the first Settlement Entrepot created by the Account Creator role
  # with Residency Indicator of Domestic or Foreign,resulting in the Settlement Entrepot account being created as the "Nominated Market Trade and NBO Settlement Entrepot".
  ############################################################################################################################################################################
  Scenario Outline: AC16 <Description>
    When I generate a message from template for "acct001" using datatable and publish on adapter "ISO"
      | BAH_From  | BAH_BizMsgIdr                               | MessageId                               | BAH_CreDt                            | SctiesAcct_OpngDt | Sup_AcctType   | Sup_Name   | Sup_AdrLine1              | Sup_PstCd              | Sup_TwnNm              | Sup_CtrySubDvsn              | Sup_Ctry              | Sup_ResInd              |
      | <ActorId> | <ActorId>${BAH_BizMsgIdr::format=\|Account} | <ActorId>${MessageId::format=\|Account} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}              | <Sup_AcctType> | <Sup_Name> | #{ADD_NODE}<Sup_AdrLine1> | #{ADD_NODE}<Sup_PstCd> | #{ADD_NODE}<Sup_TwnNm> | #{ADD_NODE}<Sup_CtrySubDvsn> | #{ADD_NODE}<Sup_Ctry> | #{ADD_NODE}<Sup_ResInd> |
    Then verify number of outgoing messages "1" on queue "ISO_OUT" for message type "acct002" with the following datatable and validate the schema of the outgoing message
      | Validate_BAH | Validate_Rltd_BAH | BAH_To    | OriginalMsgId                               | Status |
      | true         | true              | <ActorId> | <ActorId>${OriginalMsgId::format=\|Account} | COMP   |
    #And settlement entrepot account should be created as the "Nominated Market Trade and NBO Settlement Entrepot".
    And Verify the "Account" report in ODS for the following attributes from the below table
      | ActorId   | AccountType    | ResidencyIndicator |
      | <ActorId> | <Sup_AcctType> | <Sup_ResInd>       |

    @REPORT_SPD-161_SPD-163_12
    Examples: 
      | Description                                                      | ActorId                         | Sup_AcctType | Sup_Name        | Sup_AdrLine1          | Sup_PstCd | Sup_TwnNm | Sup_CtrySubDvsn | Sup_Ctry | Sup_ResInd |
      | Create first settlement entrepot account with domestic indicator | ${#FEATURE#Actor_CETA1.ActorId} | SETT         | RICHARD PTY LTD | 3/240 CARRINGTON ROAD |      2031 | COOGEE    | NSW             | AU       | DMST       |
      | Create first settlement entrepot account with foreign indicator  | ${#FEATURE#Actor_CETA2.ActorId} | SETT         | Bayer Ltd       | 51368 Leverkusen      |       111 | Richmond  | Berlin          | DE       | FRGN       |

  #############################################################################################################################################################################
  # AC17: If Account Type is Settlement Entreport and the Account Creator role has previously created a Settlement Entrepot with Residency Indicator of Domestic or Foreign
  # resulting in the Settlement Entrepot being created with Residency Indicator of Domestic or Foreign where the account isn't a "Nominated Market Trade and NBO Settlement Entrepot"
  ############################################################################################################################################################################
  Scenario Outline: AC17 <Description>
    When I generate a message from template for "acct001" using datatable and publish on adapter "ISO"
      | BAH_From  | BAH_BizMsgIdr                               | MessageId                               | BAH_CreDt                            | SctiesAcct_OpngDt | Sup_AcctType   | Sup_Name   | Sup_AdrLine1              | Sup_PstCd              | Sup_TwnNm              | Sup_CtrySubDvsn              | Sup_Ctry              | Sup_ResInd              |
      | <ActorId> | <ActorId>${BAH_BizMsgIdr::format=\|Account} | <ActorId>${MessageId::format=\|Account} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}              | <Sup_AcctType> | <Sup_Name> | #{ADD_NODE}<Sup_AdrLine1> | #{ADD_NODE}<Sup_PstCd> | #{ADD_NODE}<Sup_TwnNm> | #{ADD_NODE}<Sup_CtrySubDvsn> | #{ADD_NODE}<Sup_Ctry> | #{ADD_NODE}<Sup_ResInd> |
    Then verify number of outgoing messages "1" on queue "ISO_OUT" for message type "acct002" with the following datatable and validate the schema of the outgoing message
      | Validate_BAH | Validate_Rltd_BAH | BAH_To    | OriginalMsgId                               | Status |
      | true         | true              | <ActorId> | <ActorId>${OriginalMsgId::format=\|Account} | COMP   |
    #And settlement entrepot account should not be created as the "Nominated Market Trade and NBO Settlement Entrepot".
    And Verify the "Account" report in ODS for the following attributes from the below table
      | ActorId   | AccountType    | ResidencyIndicator |
      | <ActorId> | <Sup_AcctType> | <Sup_ResInd>       |

    @REPORT_SPD-161_SPD-163_13
    Examples: 
      | Description                                                           | ActorId                         | Sup_AcctType | Sup_Name        | Sup_AdrLine1          | Sup_PstCd | Sup_TwnNm | Sup_CtrySubDvsn | Sup_Ctry | Sup_ResInd |
      | Create subsequent settlement entrepot account with domestic indicator | ${#FEATURE#Actor_CETA1.ActorId} | SETT         | William PTY LTD | 3/245 CARRINGTON ROAD |      2031 | COOGEE    | NSW             | AU       | DMST       |
      | Create subsequent settlement entrepot account with foreign indicator  | ${#FEATURE#Actor_CETA2.ActorId} | SETT         | Schneider Ltd   | 50042 Leverkusen      |    678899 | Dowton    | Berlin          | DE       | FRGN       |
