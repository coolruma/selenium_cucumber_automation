#Epic: SPD-161
#Story: SPD-166
@regression @nightly @SPD-161 @SPD-166
Feature: E_SPD_161 S_SPD-166 Create Account Creator Role - ACK

  @SPD-161_SPD-166_Precondition
  Scenario: PreCondition - Create required entities, actors & roles
    Given the following "Feature" level precondition "inte904" are generated and published via adapter "ASXML"
      | PreconditionKey | EntityName                          | LEI                             | BAH_BizMsgIdr                       | MessageId                           | CreationDateTime                     | PartyIdValidFrom | OpeningDate | PartyNameValidFrom | PartyType |
      | Entity1         | CBA MARKETS LTD-${EXEC_UID}         | #{ADD_NODE}549300FBHFW3O5LH5M59 | ${BizMsgIdr::format=00002\|Entity1} | ${MessageId::format=00002\|Entity1} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ${T}        | ${T}               | ENTY      |
      | Entity2         | COMMONWEALTH SECURITIES-${EXEC_UID} | #{ADD_NODE}549300FBHFW3O5LH5M69 | ${BizMsgIdr::format=00002\|Entity2} | ${MessageId::format=00002\|Entity2} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ${T}        | ${T}               | ENTY      |
      | Entity3         | ASX CLEAR-${EXEC_UID}               | #{ADD_NODE}549300FBHFW3O5LH5M19 | ${BizMsgIdr::format=00002\|Entity3} | ${MessageId::format=00002\|Entity3} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ${T}        | ${T}               | ENTY      |
    And read the number of outgoing messages "3" on queue "ASXML_OUT" for message type "inte905" and store in scenario context
    And the following precondition table are persisted to "Feature" properties file
      | PreconditionKey | EntityId                        |
      | Entity1         | ${EntityId::key=00002\|Entity1} |
      | Entity2         | ${EntityId::key=00002\|Entity2} |
      | Entity3         | ${EntityId::key=00002\|Entity3} |
    And the following "Feature" level precondition "inte904" are generated and published via adapter "ASXML"
      | PreconditionKey | BAH_BizMsgIdr                             | MessageId                                 | CreationDateTime                     | PartyIdValidFrom | PartyType | ActorId                    | OpeningDate | MessagePartyId_BIC                             | MessagePartyId_UIC            | PartyNameValidFrom | MessagePartyIdType | EntityId                                | Designation                   |
      | Actor1_NoRole   | ${BizMsgIdr::format=00002\|Actor1_NoRole} | ${MessageId::format=00002\|Actor1_NoRole} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC8}  | #{REMOVE_NODE}                | ${T}               | BIC8               | #{ADD_NODE}${#FEATURE#Entity1.EntityId} | #{ADD_NODE}MARGIN LENDING A/C |
      | Actor2_NoRole   | ${BizMsgIdr::format=00002\|Actor2_NoRole} | ${MessageId::format=00002\|Actor2_NoRole} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC11} | #{REMOVE_NODE}                | ${T}               | BIC11              | #{ADD_NODE}${#FEATURE#Entity2.EntityId} | #{ADD_NODE}MARGIN  A/C        |
      | Actor3_NoRole   | ${BizMsgIdr::format=00002\|Actor3_NoRole} | ${MessageId::format=00002\|Actor3_NoRole} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        |                                                | ${MessagePartyId::format=UIC} | ${T}               | UIC                | #{ADD_NODE}${#FEATURE#Entity3.EntityId} | #{ADD_NODE}LOAN  A/C          |
      | Actor4_NoRole   | ${BizMsgIdr::format=00002\|Actor4_NoRole} | ${MessageId::format=00002\|Actor4_NoRole} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        |                                                | ${MessagePartyId::format=UIC} | ${T}               | UIC                | #{ADD_NODE}${#FEATURE#Entity3.EntityId} | #{ADD_NODE}LOAN  A/C          |
      | Actor5_NoRole   | ${BizMsgIdr::format=00002\|Actor5_NoRole} | ${MessageId::format=00002\|Actor5_NoRole} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        |                                                | ${MessagePartyId::format=UIC} | ${T}               | UIC                | #{ADD_NODE}${#FEATURE#Entity3.EntityId} | #{ADD_NODE}LOAN  A/C          |
      | Actor6_NoRole   | ${BizMsgIdr::format=00002\|Actor6_NoRole} | ${MessageId::format=00002\|Actor6_NoRole} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        |                                                | ${MessagePartyId::format=UIC} | ${T}               | UIC                | #{ADD_NODE}${#FEATURE#Entity3.EntityId} | #{ADD_NODE}LOAN  A/C          |
      | Actor7_NoRole   | ${BizMsgIdr::format=00002\|Actor7_NoRole} | ${MessageId::format=00002\|Actor7_NoRole} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        |                                                | ${MessagePartyId::format=UIC} | ${T}               | UIC                | #{ADD_NODE}${#FEATURE#Entity3.EntityId} | #{ADD_NODE}LOAN  A/C          |
      | Actor_MKST1     | ${BizMsgIdr::format=00002\|Actor_MKST1}   | ${MessageId::format=00002\|Actor_MKST1}   | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC11} | #{REMOVE_NODE}                | ${T}               | BIC11              | #{ADD_NODE}${#FEATURE#Entity2.EntityId} | #{ADD_NODE}MARGIN  A/C        |
      | Actor_SFAC1     | ${BizMsgIdr::format=00002\|Actor_SFAC1}   | ${MessageId::format=00002\|Actor_SFAC1}   | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC11} | #{REMOVE_NODE}                | ${T}               | BIC11              | #{ADD_NODE}${#FEATURE#Entity2.EntityId} | #{ADD_NODE}MARGIN  A/C        |
      | Actor_MKST2     | ${BizMsgIdr::format=00002\|Actor_MKST2}   | ${MessageId::format=00002\|Actor_MKST2}   | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC11} | #{REMOVE_NODE}                | ${T}               | BIC11              | #{ADD_NODE}${#FEATURE#Entity3.EntityId} | #{ADD_NODE}MARGIN  A/C        |
      | Actor_SFAC2     | ${BizMsgIdr::format=00002\|Actor_SFAC2}   | ${MessageId::format=00002\|Actor_SFAC2}   | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ACTR      | ${ActorId::format=ActorId} | ${T}        | #{ADD_NODE}${MessagePartyId_BIC::format=BIC11} | #{REMOVE_NODE}                | ${T}               | BIC11              | #{ADD_NODE}${#FEATURE#Entity3.EntityId} | #{ADD_NODE}MARGIN  A/C        |
    And Verify the number of outgoing messages on outbound adapter "ASXML_OUT" recieved are "11"
    #Adding SFAC roles
    And the following "Feature" level precondition "inte904" are generated and published via adapter "ASXML"
      | PreconditionKey | BAH_BizMsgIdr                     | MessageId                         | CreationDateTime                     | PartyIdValidFrom | PartyType | ActorId                         | OpeningDate | RoleType        | PartyNameValidFrom |
      | SFAC1           | ${BizMsgIdr::format=00002\|SFAC1} | ${MessageId::format=00002\|SFAC1} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_SFAC1.ActorId} | ${T}        | #{ADD_NODE}SFAC | ${T}               |
      | SFAC2           | ${BizMsgIdr::format=00002\|SFAC2} | ${MessageId::format=00002\|SFAC2} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_SFAC2.ActorId} | ${T}        | #{ADD_NODE}SFAC | ${T}               |
    Then Verify the number of outgoing messages on outbound adapter "ASXML_OUT" recieved are "2"
    #Adding MKST roles
    And the following "Feature" level precondition "inte904_Role" are generated and published via adapter "ASXML"
      | PreconditionKey | BAH_BizMsgIdr                     | MessageId                         | CreationDateTime                     | PartyIdValidFrom | PartyType | ActorId                         | OpeningDate | RoleType        | MarketSpecificAttribute_Name1 | MarketSpecificAttribute_Value1       | PartyNameValidFrom | EntityName                         | MessagePartyIdType |
      | MKST1           | ${BizMsgIdr::format=00002\|MKST1} | ${MessageId::format=00002\|MKST1} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_MKST1.ActorId} | ${T}        | #{ADD_NODE}MKST | #{ADD_NODE}SFAC               | #{ADD_NODE}${#FEATURE#SFAC1.ActorId} | #{ADD_NODE}${T}    | #{ADD_NODE}COMMONWEALTH SECURITIES | #{ADD_NODE}NONREF  |
      | MKST2           | ${BizMsgIdr::format=00002\|MKST2} | ${MessageId::format=00002\|MKST2} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | ROLE      | ${#FEATURE#Actor_MKST2.ActorId} | ${T}        | #{ADD_NODE}MKST | #{ADD_NODE}SFAC               | #{ADD_NODE}${#FEATURE#SFAC2.ActorId} | #{ADD_NODE}${T}    | #{ADD_NODE}ASX CLEAR               | #{ADD_NODE}NONREF  |
    Then Verify the number of outgoing messages on outbound adapter "ASXML_OUT" recieved are "2"

  #################################################################################################################################################################
  #AC1 : Create an Account Creator role with a valid Actor ID and Role type and attribute settings, resulting in an ack message.
  #################################################################################################################################################################
  #AC2 : Send a schema valid acknowledgement message when an Account Creator role is successfully created containing a unique Actor Id and valid Creation Timestamp.
  #################################################################################################################################################################
  Scenario Outline: AC1 AC2 Create Account Creator Role with <Description>
    When I generate a message from template for "inte904" using datatable and publish on adapter "ASXML"
      | BAH_BizMsgIdr                    | MessageId                        | CreationDateTime                     | PartyIdValidFrom | ActorId   | OpeningDate | PartyNameValidFrom | PartyType | RoleType        | PermissionType1   | PermissionType2   | PermissionType3   |
      | ${BizMsgIdr::format=00002\|ACCR} | ${MessageId::format=00002\|ACCR} | ${T::DateFormatter=ZuluWithMilliSec} | ${T}             | <ActorId> | ${T}        | ${T}               | ROLE      | #{ADD_NODE}ACCR | <PermissionType1> | <PermissionType2> | <PermissionType3> |
    Then verify number of outgoing messages "1" on queue "ASXML_OUT" for message type "inte905" with the following datatable and validate the schema of the outgoing message
      | Validate_BAH | Validate_Rltd_BAH | OriginalMsgId                        | PartyType | Status   |
      | true         | true              | ${OriginalMsgId::format=00002\|ACCR} | ROLE      | <Status> |
    #Purpose: To be implemented when behaviour is available
    And Verify the "Role" report in ODS for the following attributes from the below table
      | ActorId   | RoleType |
      | <ActorId> | ACCR     |

    #Create account creator roles with only one permission type for actors with no other roles.
    @REPORT_SPD-161_SPD-166_1
    Examples: 
      | Description                    | ActorId                           | PermissionType1 | PermissionType2 | PermissionType3 | Status |
      | only sponsored permission type | ${#FEATURE#Actor1_NoRole.ActorId} | #{ADD_NODE}CSPA | #{NO_ACTION}    | #{NO_ACTION}    | COMP   |
      | only direct permission type    | ${#FEATURE#Actor2_NoRole.ActorId} | #{ADD_NODE}CDRA | #{NO_ACTION}    | #{NO_ACTION}    | COMP   |
      | only entrepot permission type  | ${#FEATURE#Actor3_NoRole.ActorId} | #{ADD_NODE}CETA | #{NO_ACTION}    | #{NO_ACTION}    | COMP   |

    #Create account creator roles with multiple permission types for actors with no other roles.
    @REPORT_SPD-161_SPD-166_2
    Examples: 
      | Description                                     | ActorId                           | PermissionType1 | PermissionType2 | PermissionType3 | Status |
      | direct and sponsored permission types           | ${#FEATURE#Actor4_NoRole.ActorId} | #{ADD_NODE}CDRA | #{ADD_NODE}CSPA | #{NO_ACTION}    | COMP   |
      | direct and entrepot permission types            | ${#FEATURE#Actor5_NoRole.ActorId} | #{ADD_NODE}CDRA | #{ADD_NODE}CETA | #{NO_ACTION}    | COMP   |
      | sponsored and entrepot permission types         | ${#FEATURE#Actor6_NoRole.ActorId} | #{ADD_NODE}CSPA | #{ADD_NODE}CETA | #{NO_ACTION}    | COMP   |
      | direct, sponsored and entrepot permission types | ${#FEATURE#Actor7_NoRole.ActorId} | #{ADD_NODE}CDRA | #{ADD_NODE}CSPA | #{ADD_NODE}CETA | COMP   |

    #create account creator role for an actor who already has other role(SFAC,MKST)
    @REPORT_SPD-161_SPD-166_3
    Examples: 
      | Description                                                      | ActorId                         | PermissionType1 | PermissionType2 | PermissionType3 | Status |
      | sponsored permission type for an actor who already has MKST role | ${#FEATURE#Actor_MKST1.ActorId} | #{ADD_NODE}CSPA | #{NO_ACTION}    | #{NO_ACTION}    | COMP   |
      | direct permission type for an actor who already has SFAC role    | ${#FEATURE#Actor_SFAC1.ActorId} | #{ADD_NODE}CDRA | #{NO_ACTION}    | #{NO_ACTION}    | COMP   |
      | entrepot permission type for an actor who already has MKST role  | ${#FEATURE#Actor_MKST2.ActorId} | #{ADD_NODE}CETA | #{NO_ACTION}    | #{NO_ACTION}    | COMP   |
      | entrepot permission type for an actor who already has SFAC role  | ${#FEATURE#Actor_SFAC2.ActorId} | #{ADD_NODE}CETA | #{NO_ACTION}    | #{NO_ACTION}    | COMP   |
