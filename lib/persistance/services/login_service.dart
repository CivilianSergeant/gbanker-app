import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbanker/config/app_config.dart';
import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/persistance/entities/Office.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/entities/Center.dart' as Samity;
import 'package:gbanker/persistance/entities/User.dart';
import 'package:gbanker/persistance/services/bank_service.dart';
import 'package:gbanker/persistance/services/birth_place_service.dart';
import 'package:gbanker/persistance/services/center_service.dart';
import 'package:gbanker/persistance/services/citizenship_service.dart';
import 'package:gbanker/persistance/services/country_service.dart';
import 'package:gbanker/persistance/services/district_service.dart';
import 'package:gbanker/persistance/services/division_service.dart';
import 'package:gbanker/persistance/services/economic_activity_service.dart';
import 'package:gbanker/persistance/services/education_service.dart';
import 'package:gbanker/persistance/services/gender_service.dart';
import 'package:gbanker/persistance/services/group_service.dart';
import 'package:gbanker/persistance/services/group_type_service.dart';
import 'package:gbanker/persistance/services/guarantor_service.dart';
import 'package:gbanker/persistance/services/home_type_service.dart';
import 'package:gbanker/persistance/services/investor_service.dart';
import 'package:gbanker/persistance/services/loan_collection_service.dart';
import 'package:gbanker/persistance/services/loan_proposal_service.dart';
import 'package:gbanker/persistance/services/marital_status_service.dart';
import 'package:gbanker/persistance/services/member_address_service.dart';
import 'package:gbanker/persistance/services/member_category_service.dart';
import 'package:gbanker/persistance/services/member_product_service.dart';
import 'package:gbanker/persistance/services/member_service.dart';
import 'package:gbanker/persistance/services/member_type_service.dart';
import 'package:gbanker/persistance/services/menu_permission_service.dart';
import 'package:gbanker/persistance/services/menu_service.dart';
import 'package:gbanker/persistance/services/network_service.dart';
import 'package:gbanker/persistance/services/office_service.dart';
import 'package:gbanker/persistance/services/product_service.dart';
import 'package:gbanker/persistance/services/purpose_service.dart';
import 'package:gbanker/persistance/services/savings_account_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/sub_district_service.dart';
import 'package:gbanker/persistance/services/union_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/persistance/services/village_service.dart';
import 'package:gbanker/persistance/services/withdrawal_service.dart';
import 'package:gbanker/screens/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class LoginService{

  static const String LOGIN_ROUTE = "api/login/";
  static const String SYNC_ROUTE = "api/syncdata";

  static Future<void> setDownloadSettings(String option, String value) async {
    Setting isDownload = await SettingService.getSetting(option);
    if(isDownload != null){
      await SettingService.updateSetting({"value":value},"id=?", [isDownload.id]);
    }
  }

  static Future<void> login(BuildContext ctx, username, String password,{Function callback,Function updateState}) async{
    if(username == null || username == "" ||
        password == null || password == ""){
      Toast.show("Username or Password missing", ctx,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white
      );
      callback(isSuccess:true);
      return;
    }

    Setting setting = await SettingService.getSetting("orgUrl");
    Setting isDownload = await SettingService.getSetting("isDownload");
    Setting isDownloadSavings = await SettingService.getSetting("isDownloadSavings");
    if(setting != null){
      // try login from local db
      User user;

      if(isDownload != null && isDownloadSavings != null) {
        if (isDownload.value != "true" && isDownloadSavings.value != "true") {
          user =
          await UserService.getUserByUsernamePassword(username, password);
        }
      }


      if(user != null){
        Setting settingGuid = await SettingService.getSetting("guid");
        int loggedInStatus;
        if(settingGuid != null){
          // print("Updated L");
          loggedInStatus = await SettingService.updateSetting({
            "value":user.guid
          }, "id=?", [settingGuid.id]);
        }else{
          // print("Inserted L");
          loggedInStatus = await SettingService.addSetting(Setting(
              option: "guid",
              value: user.guid
          ));
        }
        if(loggedInStatus != null){
          FocusScope.of(ctx).requestFocus(
              FocusNode());
          Navigator.of(ctx).pushReplacementNamed("/home");
        }

      }else{
        // if no user found then try from server ,
        // so check internet connectivity

        bool hasNetwork = await NetworkService.check();
        if(hasNetwork){
          try{

            Setting settingVersion = await SettingService.getSetting("version");

            updateState("Downloading initial settings");

            Map<String,dynamic> map = await NetworkService.post(setting.value+LOGIN_ROUTE, {"username": username, "password": password},
                header: {"Content-Type":"application/x-www-form-urlencoded"});
            if(map['status']==200){

              var officeCode = map['data']['office']['Text'].toString().split("-")[0];

              var syncDataUrl = setting.value+SYNC_ROUTE+
                  "?officeID="+map['data']['office']['Value']
                  +"&loginID="+map['guid'];

              print(syncDataUrl);
              updateState("Downloading member accounts information");
              var _map = await NetworkService.fetch(syncDataUrl);
              if(_map['status'] == 200) {

                if(settingVersion != null){
                  if(int.parse(settingVersion.value.toString()) < int.parse(_map['apiVersion'].toString())){

                    throw new CustomException("New Version Available. Please Update App",111);
                  }
                }
                if(settingVersion != null){
                  await SettingService.updateSetting({
                    "value":_map['apiVersion']
                  }, "id=?", [settingVersion.id]);
                }else{
                  await SettingService.addSetting(Setting(
                      option: "version",
                      value: _map['apiVersion']
                  ));
                }

                if(isDownload.value=="true" && isDownloadSavings.value == "false") {
                  updateState("Removing system information");
                  await UserService.truncateUsers();
                  await OfficeService.truncateOffice();
                  await BankService.truncateCenters();
                  await CenterService.truncateCenters();
                  await GroupService.truncateGroups();
                  await MemberCategoryService.truncateMemberCategories();
                  await CountryService.truncateCountries();
                  await DivisionService.truncateDivisions();
                  await DistrictService.truncateDistricts();
                  await SubDistrictService.truncateSubDistricts();
                  await UnionService.truncateUnions();
                  await VillageService.truncateVillages();
                  await BirthPlaceService.truncateBirthPlaces();
                  await CitizenshipService.truncateCitizenship();
                  await GenderService.truncateGenders();
                  await HomeTypeService.truncateHomeTypes();
                  await GroupTypeService.truncateGroupTypes();
                  await EducationService.truncateEducations();
                  await EconomicActivityService.truncateEconomicActivities();
                  await MaritalStatusService.truncateMaritalStatus();
                  await MemberTypeService.truncateMemberTypes();
                  await LoanCollectionService.truncateLoanCollections();
                  await WithdrawalService.truncateWithdrawals();
                  await MemberProductService.truncateMemberProducts();
                  await MemberAddressService.truncateMemberAddress();
                  await SavingsAccountService.truncateSavingAccounts();
                  await GuarantorService.truncateGuarantors();
                  await LoanProposalService.truncateLoanProposals();
                  await MemberService.truncateMembers();
                  await ProductService.truncateProducts();
                  await InvestorService.truncateInvestors();
                  await PurposeService.truncatePurposes();
                  await MenuService.truncateMenus();
                  await MenuPermissionService.truncateMenuPermissinos();
                  await AppConfig.removeImages();
                }


                if(isDownload.value=="true") {

                  updateState("Copying products information");
                  int productInserted = await ProductService.addProducts(map['data']['products']);

                  updateState("Copying member accounts information");
                  int memberProductInserted = await MemberProductService
                      .addMemberProducts(_map['data']);

                  updateState("Copying investors information");
                  int investorInserted = await InvestorService.addInvestors(map['data']['investors']);

                  updateState("Copying purposes information");
                  int purposeInserted = await PurposeService.addPurposes(map['data']['purposes']);


                }

                if(isDownloadSavings.value == "true"){
                  updateState("Copying member accounts information");
                  int memberProductInserted = await MemberProductService
                      .addMemberProducts(_map['data'],isDownloadSavings: true);
                }
              }

              if(isDownload.value != "false") {

                setupTrxDate(map['data']['trxDate']);

                int userInserted = await UserService.addUser(User(
                    username: username,
                    firstname: map['userName'],
                    password: password,
                    guid: map['guid'],
                    orgId: map['orgId'],
                    officeId: int.parse(map['data']['office']['Value']),
                    officeName: map['data']['office']['Text']
                ));

                int officeInserted = await OfficeService.addOffice(Office(
                    officeName: map['data']['office']['Text'],
                    officeId: map['data']['office']['Value'],
                    officeCode: officeCode.trim()
                ));

                int bankAdded = await BankService.addBanks(map['data']['banks']);
                if (bankAdded > 0) {

                  updateState("Copying ... " + bankAdded.toString() +
                      " Bank info added");
                }

                int centerAdded = await CenterService.addCenters(
                    map['data']['centers']);
                if (centerAdded > 0) {

                  updateState("Copying ... " + centerAdded.toString() +
                      " Center info added");
                }

                int groupAdded = await GroupService.addGroups(
                    map['data']['groups']);
                if (centerAdded > 0) {
                  updateState("Copying ... " + groupAdded.toString() +
                      " Group info added");
                }

                int memberCategoryAdded = await MemberCategoryService
                    .addMemberCategories(map['data']['memberCategorys']);
                if (memberCategoryAdded > 0) {
                  updateState(
                      "Copying ... " + memberCategoryAdded.toString() +
                          " Member Category info");
                }

                int countryAdded = await CountryService.addCountries(
                    map['data']['countrys']);


                int divisionAdded = await DivisionService.addDivisions(
                    map['data']['divisions']);
                if (divisionAdded > 0) {
                  updateState("Copying... " + divisionAdded.toString() +
                      " Division info");
                }

                int districtAdded = await DistrictService.addDistricts(
                    map['data']['districts']);
                if (districtAdded > 0) {
                  updateState("Copying... " + districtAdded.toString() +
                      " District info");
                }

                int subDistrictAdded = await SubDistrictService
                    .addSubDistricts(map['data']['subDistricts']);
                if (subDistrictAdded > 0) {
                  updateState("Copying... " + subDistrictAdded.toString() +
                      " Sub-district info");
                }

                int unionAdded = await UnionService.addUnions(
                    map['data']['unions']);
                if (unionAdded > 0) {
                  updateState(
                      "Copying... " + unionAdded.toString() + " Union info");
                }

                int villageAdded = await VillageService.addVillages(
                    map['data']['villages']);
                if (villageAdded > 0) {
                  updateState("Copying... " + villageAdded.toString() +
                      " village info");
                }

                int birthPlaceAdded = await BirthPlaceService.addBirthPlaces(
                    map['data']['placeOfBirths']);
                if (birthPlaceAdded > 0) {
                  updateState("Copying... " + birthPlaceAdded.toString() +
                      " Birth place info");
                }

                int citizenshipAdded = await CitizenshipService
                    .addCitizenships(map['data']['citizenships']);
                if (citizenshipAdded > 0) {
                  updateState("Copying... " + citizenshipAdded.toString() +
                      " Citizenship info");
                }

                int genderAdded = await GenderService.addGenders(
                    map['data']['genders']);
                if (genderAdded > 0) {
                  updateState("Copying... " + genderAdded.toString() +
                      " Gender info");
                }

                int homeTypeAdded = await HomeTypeService.addHomeTypes(
                    map['data']['homeTypes']);
                if (homeTypeAdded > 0) {
                  updateState("Copying... " + homeTypeAdded.toString() +
                      " Home Type info");
                }

                int groupTypeAdded = await GroupTypeService.addGroupTypes(
                    map['data']['groupTypes']);
                if (groupTypeAdded > 0) {
                  updateState("Copying... " + groupTypeAdded.toString() +
                      " Group Type info");
                }

                int educationAdded = await EducationService.addEducations(
                    map['data']['educations']);
                if (educationAdded > 0) {
                  updateState("Copying... " + educationAdded.toString() +
                      " Education info");
                }

                int economicActivityAdded = await EconomicActivityService
                    .addEconomicActivities(map['data']['economicActivities']);
                if (economicActivityAdded > 0) {
                  updateState(
                      "Copying... " + economicActivityAdded.toString() +
                          " Economic Activity info");
                }

                int maritalStatusAdded = await MaritalStatusService
                    .addMaritalStatuses(map['data']['maritalStatuses']);
                if (maritalStatusAdded > 0) {
                  updateState("Copying... " + maritalStatusAdded.toString() +
                      " Marital Status info");
                }

                int memberTypeAdded = await MemberTypeService.addMemberTypes(
                    map['data']['memberTypes']);
                if (memberTypeAdded > 0) {
                  updateState("Copying... " + memberTypeAdded.toString() +
                      " Member  type info");
                }

                int menuAdded = await MenuService.addMenu(
                    map['data']['menus']);
                if (menuAdded > 0) {
                  updateState("Copying... " + menuAdded.toString() +
                      " Menu info");
                }

                int menuPermissionAdded = await MenuPermissionService.addMenuPermissions(
                    map['data']['permissions']);
                if (menuAdded > 0) {
                  updateState("Copying... " + menuAdded.toString() +
                      " Menu Permission info");
                }

              }

              Setting settingGuid = await SettingService.getSetting("guid");

              setDownloadSettings("isDownload","false");
              setDownloadSettings("isDownloadSavings","false");

              int loggedInStatus;

              if(settingGuid != null){
                loggedInStatus = await SettingService.updateSetting({
                  "value":map['guid']
                }, "id=?", [settingGuid.id]);
              }else{
                loggedInStatus = await SettingService.addSetting(Setting(
                    option: "guid",
                    value: map['guid']
                ));
              }



              if(loggedInStatus != null){
                FocusScope.of(ctx).requestFocus(
                    FocusNode());
                Navigator.of(ctx).pushReplacementNamed("/home");
              }


            }else{
              var warningMsg = (map['message'] != null)? map['message']: 'Sorry! try again';
              Toast.show(warningMsg, ctx,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.TOP,
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white);
              callback(isSuccess:true);
            }


          }
          on CustomException catch(ex){

            Toast.show(ex.message, ctx,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.TOP,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            callback(isSuccess:false,isUpdate:true);

          }catch(ex){
//            print(ex);

            updateState("Something wrong please \r\n check app configuration");
            //Toast.show(,ctx,duration: Toast.LENGTH_LONG,gravity:Toast.TOP);
            callback(isSuccess:false);
          }
        }else{
          Toast.show("Internet not available", ctx,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          callback(isSuccess:true,isFromSplash:true);
        }
      }

    }else{

      Toast.show("Please setup organization url", ctx,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        backgroundColor: Colors.white,
        textColor: Colors.red,
      );

      callback(isSuccess:false);
    }

  }

  static Future<void> setupTrxDate(String info) async{

    Setting trxDateSetting = await SettingService.getSetting("transactionDate");

    if(trxDateSetting == null){

      SettingService.addSetting(Setting(
          option: "transactionDate",
          value: info
      ));

    }else{
      SettingService.updateSetting({"value": info},
          "id=?", [trxDateSetting.id]);
    }
  }
}