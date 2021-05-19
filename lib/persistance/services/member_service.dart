import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/helpers/messages.dart';
import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/HomeType.dart';
import 'package:gbanker/persistance/entities/Member.dart';
import 'package:gbanker/persistance/entities/MemberAddress.dart';
import 'package:gbanker/persistance/entities/MemberProduct.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/entities/User.dart';
import 'package:gbanker/persistance/services/member_product_service.dart';
import 'package:gbanker/persistance/services/network_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/persistance/tables/centers_table.dart';
import 'package:gbanker/persistance/tables/citizenships_table.dart';
import 'package:gbanker/persistance/tables/countries_table.dart';
import 'package:gbanker/persistance/tables/districts_table.dart';
import 'package:gbanker/persistance/tables/divisions_table.dart';
import 'package:gbanker/persistance/tables/economic_activities_table.dart';
import 'package:gbanker/persistance/tables/educations_table.dart';
import 'package:gbanker/persistance/tables/genders_table.dart';
import 'package:gbanker/persistance/tables/hometypes_table.dart';
import 'package:gbanker/persistance/tables/marital_status_table.dart';
import 'package:gbanker/persistance/tables/member_address_table.dart';
import 'package:gbanker/persistance/tables/member_categories_table.dart';
import 'package:gbanker/persistance/tables/members_table.dart';
import 'package:gbanker/persistance/tables/sub_districts_table.dart';
import 'package:gbanker/persistance/tables/unions_table.dart';
import 'package:gbanker/persistance/tables/villages_table.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class MemberService{

  static const String CHECK_IDENTITY_ROUTE = "api/member/check-identity";
  static const String ADD_MEMBER_ROUTE = "api/member/new";
  static const String MEMBER_LIST_ROUTE = "api/member/list";
  static const String MEMBER_APPROVAL_PRODUCT_LIST = "api/member/get-approval-products";
  static const String MEMBER_APPROVE = "api/member/approve";
  static const String IMG_SYNC = "api/member/sync-img";

  static Future<void> truncateMembers() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+MembersTable().tableName);
  }

  static Future<List<dynamic>> getMembersByCenter(int centerId,{int trxType,bool isWithdrawal}) async{

    var _trxType = (trxType != null)? trxType : null;
    var members;
    if(_trxType == null && isWithdrawal == null){
      members = await _getMembersByCenter(centerId);
    }else{
      members = await MemberProductService.getMembers(centerId:centerId,
          trxType: _trxType, isWithdrawal: isWithdrawal);
    }
    return members;
  }

  static Future<List<Member>> _getMembersByCenter(int centerId) async {

    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = List<Map<String,dynamic>>();
    List<Member> members=List<Member>();



    String sql = "Select m.id, m.member_id,m.office_id,m.center_id,m.org_id,"
        "m.created_user, m.first_name,m.member_code,m.co_applicant_name,m.member_pass_book_register_id,"
        "m.member_pass_book_no From members m "
        " WHERE m.center_id = "+centerId.toString()+ " AND m.member_status = 1"
        " ORDER BY m.id ASC";


    maps = await db.rawQuery(sql);

    maps.forEach((map){
      members.add(Member(
        id: map['id'],
        officeId: map['office_id'],
        centerId: map['center_id'],
        orgId: map['org_id'],
        createdUser: map['created_user'],
        firstName: map['first_name'],
        memberId: map['member_id'].toString(),
        memberPassBookNo: map['member_pass_book_no'],
        memberPassBookRegisterId: map['member_pass_book_register_id'],
        coApplicantName: map['co_applicant_name'].toString(),
        memberCode: map['member_code']
      ));
    });

    return members;

  }

  static Future<List<MemberProduct>> getMemberCollections(int centerId, int memberId,{int trxType,bool onlySavings}) async {
    var _trxType = (trxType != null)? trxType : null;
    var collections = await MemberProductService.getCollections(centerId:centerId,
      memberId: memberId,trxType: _trxType, onlySavings:onlySavings);
    return collections;
  }

  static Future<Map<String,dynamic>> findMemberByCode(String memberCode) async {
      final Database db = await DbProvider.db.database;
      //String maritalStatus = "(SELECT ms.text from ${MaritalStatusTable().tableName} ms WHERE ms.value = m.marital_status) as maritalStatus";
      String perCountrySql = "(SELECT country_name as per_country_name from ${CountriesTable().tableName} co WHERE co.id = madr.per_country_id) as per_country_name";
      String countrySql = "(SELECT country_name from ${CountriesTable().tableName} co WHERE co.id = madr.country_id) as country_name";
      String divisionSql = "(SELECT division.division_name from ${DivisionsTable().tableName} division WHERE division.id = madr.division_id) as division_name";
      String perDivisionSql = "(SELECT division.division_name from ${DivisionsTable().tableName} division WHERE division.id = madr.per_division_id) as per_division_name";

      String districSql = "(SELECT ds.district_name from ${DistrictsTable().tableName} ds WHERE ds.district_code = madr.district_id) as district_name";
      String perDistricSql = "(SELECT ds.district_name from ${DistrictsTable().tableName} ds WHERE ds.district_code = madr.per_district_id) as per_district_name";

      String subDistrictSql = "(SELECT subdist.sub_district_name from ${SubDistrictsTable().tableName} subdist WHERE subdist.sub_district_code = madr.sub_district_id) as sub_district_name";
      String unionSql = "(SELECT u.union_name from ${UnionsTable().tableName} as u WHERE u.union_code = madr.union_id) as union_name";
      String villageSql = "(SELECT village.village_name from ${VillagesTable().tableName} village WHERE village.village_code = madr.village_id) as village_name";

      String perSubDistrictSql = "(SELECT subdist.sub_district_name from ${SubDistrictsTable().tableName} subdist WHERE subdist.sub_district_code = madr.per_sub_district_id) as per_sub_district_name";
      String perUnionSql = "(SELECT u.union_name from ${UnionsTable().tableName} as u WHERE u.union_code = madr.per_union_id) as per_union_name";
      String perVillageSql = "(SELECT village.village_name from ${VillagesTable().tableName} village WHERE village.village_code = madr.per_village_id) as per_village_name";

      String citizenshipSql = "(SELECT cz.text from ${CitizenshipTable().tableName} cz WHERE cz.value = m.citizenship_id) as citizenship";
      String genderSql = "(SELECT g.text from ${GendersTable().tableName} g WHERE g.value = m.gender) as Gender";
      String homeTypeSql = "(SELECT ht.text from ${HomeTypeTable().tableName} ht WHERE ht.value = m.home_type) as homeType";
      String educationSql = "(SELECT ed.text from ${EducationsTable().tableName} ed WHERE ed.value = m.education_id) as Education";
      String occupationSql = "(SELECT oc.text from ${EconomicActivitiesTable().tableName} oc WHERE oc.value = m.economic_activity_id) as occupation";

      String sql = "SELECT c.center_name, mc.category_name,${countrySql},${perCountrySql},${divisionSql},${districSql},${subDistrictSql},"
          "${unionSql},${villageSql},${perDivisionSql},${perDistricSql},${perSubDistrictSql},${perUnionSql},${perVillageSql},"
          "${citizenshipSql},${genderSql},${homeTypeSql},${educationSql},${occupationSql},"
          " m.member_id as memberRemoteId, madr.present_address,madr.permanent_address,madr.zip_code,madr.per_zip_code"
          ",m.* FROM ${MembersTable().tableName} m "
          " INNER JOIN ${CentersTable().tableName} c ON c.id = m.center_id"
          " INNER JOIN ${MemberAddressTable().tableName} madr ON madr.member_id = m.id"
          " INNER JOIN ${MemberCategoriesTable().tableName} mc ON mc.id = m.member_category_id"

          " WHERE m.member_code='${memberCode}'";
      List<Map<String,dynamic>> maps = await db.rawQuery(sql);

      Map<String,dynamic> memberMap;
      Map<String,dynamic> memberAddrMap;

      for(dynamic m in maps){
        memberMap = m;
        List<Map<String,dynamic>> adrMaps = await db.query(MemberAddressTable().tableName,where:"member_id=?",
        whereArgs: [m['id']]);
        adrMaps.forEach((_adrMap){
          if(m['id'] == _adrMap['member_id']){
            memberAddrMap = _adrMap;

          }
        });
      }
      Map<String,dynamic> result = {};
      if(memberMap != null) {
        result.addAll(memberMap);
        result.addAll(memberAddrMap);
      }
      return result;
  }

  static Future<int> addNewMember(Member member) async {
    final Database db = await DbProvider.db.database;

    bool checkStatus = await NetworkService.check();
    if(!checkStatus) {
      return throw CustomException("Please make sure you have internet connection",500);
    }

    Setting settingGuid = await SettingService.getSetting("guid");
    Setting setting = await SettingService.getSetting("orgUrl");
    User user = await UserService.getUserByGuid(settingGuid.value);

    Map<String,dynamic> postData = {};
    postData.addAll(member.toMap());
    postData.addAll(member.memberAddress.toMap());

    postData.addAll({
      "org_id":user.orgId,
      "office_id":user.officeId,
      "created_user":user.username,
      "created_date": DateTime.now().toString().substring(0,19)
    });


    Map<String,dynamic> result = await NetworkService.post(setting.value+ADD_MEMBER_ROUTE, postData,
        header: {"Content-Type":"application/json"});

    int inserted =0;
    if(result['status']=="true"){
      member.memberId = result['member']['MemberID'].toString();
      member.memberCode = result['member']['MemberCode'];
      inserted = await db.insert(MembersTable().tableName, member.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);

      var memberAddress = member.memberAddress;
      if(memberAddress != null) {
        memberAddress.memberId = inserted;
        db.insert(MemberAddressTable().tableName, memberAddress.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    return inserted;
  }

  static Future<int> saveMemberFromApi(dynamic map) async {

    final Database db = await DbProvider.db.database;
    int inserted = await db.insert(MembersTable().tableName, Member(


      centerId: map['CenterID'],
      groupId: map['GroupID'],
      memberCategoryId: map['MemberCategoryID'],
      memberCode: map['MemberCode'],
      memberId: map['MemberID'].toString(),
      memberPassBookNo: (map['MemberPassBookNo'] != null )? map['MemberPassBookNo'] : 0,
      memberPassBookRegisterId: (map['MemberPassBookRegisterID'] != null)? map['MemberPassBookRegisterID'] : 0,
      firstName: (map['FirstName'] != null)? map['FirstName'] : map['MiddleName'],
      fatherName: map['FatherName'],
      motherName: map['MotherName'],
      maritalStatus: map['MaritalStatus'],
      spouseName: map['SpouseName'],

      nid: map['NationalID'],
      smartCardNo: map['SmartCard'],
      issueDate: map['CardIssueDate'],
      identityTypeId: (map['IdentTypeID'] != null)? int.parse(map['IdentTypeID'].toString()) : null,
      otherIdNo: map['OtherIdNo'],
      expireDate: map['ExpireDate'],
      cardProviderCountry: map['ProvidedByCountryID'],
      dateOfBirth: map['BirthDate'],
      age: map['AsOnDateAge'],
      birthPlaceId: (map['PlaceOfBirth'] != null && map['PlaceOfBirth']!=""&&
          map['PlaceOfBirth'] != "N/A") ? int.parse(map['PlaceOfBirth']) : null,
      citizenshipId: map['Cityzenship'],
      gender: map['Gender'],
      admissionDate: map['JoinDate'],
      homeType: map['HomeType'],
      groupType: map['GroupType'],
      educationId: map['Education'],
      familyMember: map['FamilyMember'],
      email: map['Email'],
      contactNo: map['PhoneNo'],
      familyMemberContactNo: map['FamilyContactNo'],
      referenceName: map['RefereeName'],
      coApplicantName: map['CoApplicantName'],
      economicActivityId: map['EconomicActivity'],
      totalWealth: map['TotalWealth'],
      memberTypeId: map['MemberType'].toString(),

      tin: map['TIN'],
      taxAmount: map['TaxAmount'],
      isAnyFs: map['IsAnyFS'],
      fServiceName: map['FServiceName'],
      finServiceChoiceId:   map['FinServiceChoiceId'],
      transactionChoiceId: map['TransactionChoiceId'],

      officeId: map['OfficeID'],
      orgId: map['OrgID'],
      imgSync: map['ImgSync'],
      sigImgSync: map['SigImgSync'],
      createdUser: map['CreateUser'],
      createdDate: map['CreateDate'],
      memberStatus: map['MemberStatus']


    ).toMap(),conflictAlgorithm:
    ConflictAlgorithm.replace);
    if(inserted>0){
      try {
        await db.insert(MemberAddressTable().tableName, MemberAddress(
          memberId: inserted,
          countryId: map['CountryID'],
          divisionId: (map['DivisionCode'] != null && map['DivisionCode'] != "")
              ? int.parse(map['DivisionCode'].toString())
              : null,
          districtId: (map['DistrictCode'] != null && map['DistrictCode'] != "")
              ? int.parse(map['DistrictCode'].toString())
              : null,
          subDistrictId: map['UpozillaCode'],
          unionId: map['UnionCode'],
          villageId: map['VillageCode'],
          presentAddress: map['AddressLine1'],
          zipCode: map['ZipCode'],

          perCountryId: map['PerCountryID'],
          perDivisionId: (map['PerDivisionCode'] != null) ? int.parse(
              map['PerDivisionCode']) : null,
          perDistrictId: (map['PerDistrictCode'] != null) ? int.parse(
              map['PerDistrictCode']) : null,
          perSubDistrictId: map['PerUpozillaCode'],
          perUnionId: map['PerUnionCode'],
          perVillageId: map['PerVillageCode'],
          permanentAddress: map['PerAddressLine1'],
          perZipCode: map['PerZipCode'],

        ).toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      } on Exception catch(ex){
//        print(map);
      }
      //save member address information
    }
    return inserted;
  }

  static Future<dynamic> fetchMembers({int limit}) async {
    bool networkStatus = await NetworkService.check();
    if(!networkStatus){
      return null;
    }
    Setting setting = await SettingService.getSetting("orgUrl");
    Setting settingGuid = await SettingService.getSetting("guid");
    var user = await UserService.getUserByGuid(settingGuid.value);

    Map<String,dynamic> map = await NetworkService.post(setting.value+MEMBER_LIST_ROUTE, {
      "offset":0,
      "limit":limit,
      "createUser":user.username,
      "officeId": user.officeId
    }, header: {
      "Access-Control-Request-Method":"GET",
      "Content-Type":"application/json"});

    return map;
  }

  static Future<dynamic> getApprovalProductsFromServer(int memberId) async {
    Setting setting = await SettingService.getSetting("orgUrl");
    Setting settingGuid = await SettingService.getSetting("guid");
    var user = await UserService.getUserByGuid(settingGuid.value);
    dynamic fetchResult = await NetworkService.post(setting.value + MEMBER_APPROVAL_PRODUCT_LIST, {
      "orgId": user.orgId,
      "memberId": memberId
    }, header: {
      "Access-Control-Request-Method":"GET",
      "Content-Type":"application/json"
    });

    return fetchResult;
  }

  static Future<dynamic> approveMember(dynamic postData) async{
    bool netStatus = await NetworkService.check();
    Setting setting = await SettingService.getSetting("orgUrl");
    if(netStatus){
      dynamic fetchResult = await NetworkService.post(setting.value + MEMBER_APPROVE, postData, header: {
        "Content-Type":"application/json"
      });
      if(fetchResult['status']=="true"){
        updateMemberStatus(1, postData['memberId']);
        return true;
      }else{
        return throw CustomException("Sorry! Unable to approve member", 500);
      }
    }else{
      return throw CustomException("Internet Connection not available", 500);
    }
  }

  static Future<List<Map<String,dynamic>>> getMemberList({int memberStatus}) async {
    final Database db = await DbProvider.db.database;
    String memberCategory = "(SELECT category_name from ${MemberCategoriesTable().tableName} as mc WHERE mc.id == m.member_category_id) as category_name";
    String center = "(SELECT c.center_code || '-' || c.center_name as cname from ${CentersTable().tableName} as c WHERE c.id = m.center_id) as center_name";
    String sql = "SELECT ${center},${memberCategory},m.member_status,m.* FROM ${MembersTable().tableName} as m";
    if(memberStatus != null){
      sql += " WHERE member_status="+memberStatus.toString();
    }
    sql+=" ORDER BY id DESC";
    return db.rawQuery(sql);
  }

  static Future<Map<String,dynamic>> checkUniqueContact(String contactNo) async{
    bool checkStatus = await NetworkService.check();
    if(checkStatus){

      Setting setting = await SettingService.getSetting("orgUrl");

      Map<String,dynamic> map = await NetworkService.post(setting.value+CHECK_IDENTITY_ROUTE, {
        "keyword": contactNo,
        "identityType":"phone"
      }, header: {"Content-Type":"application/json"});

      return map;
    }else{
      throw CustomException("Please Check Internet Connection",500);
    }
  }

  static Future<bool> hasMember({String memberCode}) async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.query(MembersTable().tableName,where:"member_code=?",
    whereArgs: [memberCode]);
    return (maps.length>0)? true:false;
  }

  static Future<int> updateImg(String imgPath, int id, {bool sync}) async {
    final Database db = await DbProvider.db.database;
    int updated = await db.update(MembersTable().tableName,{
        "img_path":imgPath,
        "img_sync":(sync != null && sync == true) ? 1 : 0
      },
      where: "id=?",whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace);
    return updated;
  }

  static Future<int> updateImgSync(bool imgSync, String memberId) async {
    final Database db = await DbProvider.db.database;
    int updated = await db.update(MembersTable().tableName,{
      "img_sync":imgSync
    },
        where: "member_id=?",whereArgs: [memberId],
        conflictAlgorithm: ConflictAlgorithm.replace);
    return updated;
  }

  static Future<int> updateMemberStatus(int status, int id) async {
    final Database db = await DbProvider.db.database;
    int updated = await db.update(MembersTable().tableName,{
      "member_status":status
    },
        where: "member_id=?",whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
    return updated;
  }

  static Future<int> updateSigImg(String sigImgPath, int id, {bool sync}) async {
    final Database db = await DbProvider.db.database;
    int updated = await db.update(MembersTable().tableName,{
      "sig_img_path":sigImgPath,
      "sig_img_sync":(sync != null && sync == true) ? 1 :0
    },
        where: "id=?",whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
    return updated;
  }

  static Future<int> updateSigImgSync(bool sigImgSync, String memberId) async {
    final Database db = await DbProvider.db.database;
    int updated = await db.update(MembersTable().tableName,{
      "sig_img_sync":sigImgSync
    },
        where: "member_id=?",whereArgs: [memberId],
        conflictAlgorithm: ConflictAlgorithm.replace);
    return updated;
  }

  static Future<bool> syncImages() async{
    final Database db = await DbProvider.db.database;
    try {
      List<Map<String, dynamic>> maps = await db.query(
          MembersTable().tableName, columns: ['id','member_code','member_id', 'img_path', 'sig_img_path'],
          where: "((img_sync=0 OR img_sync IS NULL) AND img_path IS NOT NULL) OR"
              "((sig_img_sync=0 OR sig_img_sync IS NULL) AND sig_img_path IS NOT NULL)");
      if(maps.length<=0){
        return false;
      }

      for (dynamic m in maps) {


        File imgFile;
        File sigImgFile;

        if(m['img_path'] != null && m['img_path'] != "") {
          imgFile = File(m['img_path']);
        }
        if(m['sig_img_path'] != null && m['sig_img_path'] != "") {

          sigImgFile = File(m['sig_img_path']);
        }
        Uint8List imgContent;
        if(imgFile != null && imgFile.existsSync()) {
          imgContent = imgFile.readAsBytesSync();
        }
        Uint8List sigImgContent;
        if(sigImgFile != null && sigImgFile.existsSync()) {
          sigImgContent = sigImgFile.readAsBytesSync();
        }

        Setting setting = await SettingService.getSetting("orgUrl");

        var postData = {
          'img':(imgContent!=null)?base64Encode(imgContent):null,
          'sigImg':(sigImgContent!=null)?base64Encode(sigImgContent):null,
          'memberId':m['member_id']
        };
        bool netStatus = await NetworkService.check();
        if(netStatus == false){
          return throw CustomException("Internet not available",500);
        }
        dynamic map = await NetworkService.post(setting.value+IMG_SYNC, postData,header: {'Content-Type':'application/json'});

        if(map['status']=="true"){
          if(map['imgSync']){
            MemberService.updateImgSync(true, m['member_id']);
          }

          if(map['sigImgSync']){
            MemberService.updateSigImgSync(true, m['member_id']);
          }

          return true;
        }else{
          return false;
        }
      }
    } on Exception catch(ex){

      return false;
    }
  }

  static Future<List<Map<String,dynamic>>> searchMemberByCode(String memberCode)  async{
    final Database db = await DbProvider.db.database;
    String memberCategory = "(SELECT category_name from ${MemberCategoriesTable().tableName} as mc WHERE mc.id == m.member_category_id) as category_name";
    String center = "(SELECT c.center_code || '-' || c.center_name as cname from ${CentersTable().tableName} as c WHERE c.id = m.center_id) as center_name";
    String sql = "SELECT ${center},${memberCategory}, ma.present_address, m.* FROM ${MembersTable().tableName} as m"
        " JOIN ${MemberAddressTable().tableName} ma ON m.id = ma.member_id"
        " WHERE m.member_code LIKE '%${memberCode}%' ";

    List<Map<String,dynamic>> maps = await db.rawQuery(sql);
    return (maps != null)? maps : [];
  }


}