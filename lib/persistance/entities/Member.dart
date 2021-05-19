import 'package:gbanker/persistance/entities/MemberAddress.dart';

class Member{
  final int id;
  final int centerId;
  final int groupId;
  final int memberCategoryId;
  String memberCode;
  String memberId;
  final int memberPassBookRegisterId;
  final int memberPassBookNo;
  final String firstName;
  final String middleName;
  final String lastName;
  final String fatherName;
  final String motherName;
  final String maritalStatus;
  final String spouseName;
  final MemberAddress memberAddress;
  final String nid;
  final String smartCardNo;
  final int identityTypeId;
  final String issueDate;
  final String otherIdNo;
  final String expireDate;
  final int cardProviderCountry;

  final String dateOfBirth;
  final String age;
  final int birthPlaceId;
  final String citizenshipId;
  final String gender;
  final String admissionDate;
  final String homeType;
  final String groupType;
  final String educationId;
  final int familyMember;
  final String email;
  final String contactNo;
  final String familyMemberContactNo;
  final String referenceName;
  final String coApplicantName;
  final String economicActivityId;
  final String totalWealth;
  final String memberTypeId;
  final String tin;
  final double taxAmount;
  final bool isAnyFs;
  final String fServiceName;
  final int finServiceChoiceId;
  final int transactionChoiceId;
  final String imgPath;
  final bool imgSync;
  final String sigImgPath;
  final bool sigImgSync;
  final int officeId;
  final int orgId;
  final String createdUser;
  final String createdDate;
  final String memberStatus;

  Member({this.id,
    this.centerId,
    this.memberCode,
    this.groupId,
    this.memberCategoryId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.fatherName,
    this.motherName,
    this.maritalStatus,
    this.spouseName,
    this.memberAddress,
    this.nid,
    this.smartCardNo,
    this.identityTypeId,
    this.issueDate,
    this.otherIdNo,
    this.expireDate,
    this.cardProviderCountry,

    this.dateOfBirth,
    this.age,
    this.birthPlaceId,
    this.citizenshipId,
    this.gender,
    this.admissionDate,
    this.homeType,
    this.groupType,
    this.educationId,
    this.familyMember,
    this.email,
    this.contactNo,
    this.familyMemberContactNo,
    this.referenceName,
    this.coApplicantName,
    this.economicActivityId,
    this.totalWealth,
    this.memberTypeId,
    this.tin,
    this.taxAmount,
    this.isAnyFs,
    this.fServiceName,
    this.finServiceChoiceId,
    this.transactionChoiceId,
    this.imgPath,
    this.imgSync,
    this.sigImgPath,
    this.sigImgSync,
    this.officeId,
    this.orgId,
    this.createdUser,
    this.createdDate,
    this.memberId,
    this.memberPassBookNo,
    this.memberPassBookRegisterId,
    this.memberStatus
  });

  factory Member.fromJson(Map<String,dynamic> json){
    return Member(
      id: int.parse(json['id']),
        centerId: int.parse(json['center_id']),
        groupId: int.parse(json['group_id']),
        memberCategoryId: int.parse(json['member_category_id']),
        firstName: json['first_name'],
        middleName: json['middle_name'],
        lastName: json['last_name'],
        fatherName: json['father_name'],
        motherName: json['mother_name'],
        maritalStatus: json['marital_status'],
        spouseName: json['spouse_name'],
        nid: json['nid'],
        smartCardNo: json['smart_card_no'],
        identityTypeId: int.parse(json['identity_type_id']),
        issueDate: json['issue_date'],
        otherIdNo: json['other_id_no'],
        expireDate: json['expire_date'],
        cardProviderCountry: int.parse(json['provider_country_id']),

        dateOfBirth: json['date_of_birth'],
        age: json['age'],
        birthPlaceId: int.parse(json['birth_place_id']),
        citizenshipId: json['citizenship_id'],
        gender: json['gender'],
        admissionDate: json['admission_date'],
        homeType: json['home_type'],
        groupType: json['group_type'],
        educationId: json['education_id'],

        familyMember: int.parse(json['family_member']),
        email: json['email'],
        contactNo: json['contact_no'],
        familyMemberContactNo: json['family_contact_no'],
        referenceName: json['reference_name'],

        coApplicantName: json['co_applicant_name'],
        economicActivityId: json['economic_activity_id'],
        totalWealth: json['total_wealth'],
        memberTypeId: json['member_id'],

        tin:json['tin'],
        taxAmount: json['tax_amount'],
        isAnyFs: (json['is_any_fs']==1)? true: false,
        fServiceName: json['f_service_name'],
        finServiceChoiceId: int.parse(json['fin_service_choice_id']),
        transactionChoiceId: int.parse(json['transaction_choice_id']),


        imgPath: json['img_path'],
        imgSync: (json['img_sync']==1)? true : false,
        sigImgPath: json['sig_img_path'],
        sigImgSync: (json['sig_img_sync']==1)? true : false,

        orgId: int.parse(json['org_id']),
        officeId: int.parse(json['office_id']),
        createdUser: json['created_user'],
        createdDate: json['created_date'],
        memberStatus: json['member_status']

    );
  }

  Map<String,dynamic> toMap(){

    var obj = {
      'id':id,
      'center_id':centerId,
      'group_id':groupId,
      'member_code':memberCode,
      'member_id':memberId,
      'member_pass_book_no':memberPassBookNo,
      'member_pass_book_register_id':memberPassBookRegisterId,
      'member_category_id':memberCategoryId,
      'first_name':firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'father_name': fatherName,
      'mother_name':motherName,
      'marital_status':maritalStatus,
      'spouse_name': spouseName,

      'nid': nid,
      'smart_card_no':smartCardNo,

      'identity_type_id':identityTypeId,
      'issue_date':issueDate,
      'other_id_no':otherIdNo,
      'expire_date':expireDate,
      'provider_country_id':cardProviderCountry,

      'date_of_birth': dateOfBirth,
      'age':age,
      'birth_place_id': birthPlaceId,
      'citizenship_id': citizenshipId,
      'gender': gender,
      'admission_date': admissionDate,
      'home_type': homeType,
      'group_type':groupType,
      'education_id': educationId,
      'family_member':familyMember,
      'email': email,
      'contact_no': contactNo,
      'family_contact_no':familyMemberContactNo,
      'reference_name':referenceName,
      'co_applicant_name': coApplicantName,
      'economic_activity_id': economicActivityId,
      'total_wealth':totalWealth,
      'member_type_id':memberTypeId,

      'tin':tin,
      'tax_amount': taxAmount,
      'is_any_fs':isAnyFs,
      'f_service_name':fServiceName,
      'fin_service_choice_id':finServiceChoiceId,
      'transaction_choice_id':transactionChoiceId,

      'img_path': imgPath,
      'img_sync': imgSync,
      'sig_img_path': sigImgPath,
      'sig_img_sync': sigImgSync,

      'office_id':officeId,
      'org_id':orgId,
      'created_user': createdUser.toString(),
      'created_date': createdDate.toString(),
      'member_status': memberStatus
    };

    return obj;
  }
}