import 'dart:io' as io;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gbanker/helpers/exceptions/custom_exception.dart';
import 'package:gbanker/helpers/file_helper.dart';
import 'package:gbanker/helpers/messages.dart';
import 'package:gbanker/persistance/entities/BirthPlace.dart';
import 'package:gbanker/persistance/entities/Citizenship.dart';
import 'package:gbanker/persistance/entities/District.dart';
import 'package:gbanker/persistance/entities/Division.dart';
import 'package:gbanker/persistance/entities/EconomicActivity.dart';
import 'package:gbanker/persistance/entities/Education.dart';
import 'package:gbanker/persistance/entities/Gender.dart';
import 'package:gbanker/persistance/entities/GroupType.dart';
import 'package:gbanker/persistance/entities/HomeType.dart';
import 'package:gbanker/persistance/entities/Member.dart';
import 'package:gbanker/persistance/entities/MemberAddress.dart';
import 'package:gbanker/persistance/entities/MemberType.dart';
import 'package:gbanker/persistance/entities/Setting.dart';
import 'package:gbanker/persistance/entities/SubDistrict.dart';
import 'package:gbanker/persistance/entities/Union.dart';
import 'package:gbanker/persistance/entities/User.dart';
import 'package:gbanker/persistance/entities/Village.dart';
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
import 'package:gbanker/persistance/services/home_type_service.dart';
import 'package:gbanker/persistance/services/member_category_service.dart';
import 'package:gbanker/persistance/services/member_service.dart';
import 'package:gbanker/persistance/services/member_type_service.dart';
import 'package:gbanker/persistance/services/network_service.dart';
import 'package:gbanker/persistance/services/setting_service.dart';
import 'package:gbanker/persistance/services/sub_district_service.dart';
import 'package:gbanker/persistance/services/union_service.dart';
import 'package:gbanker/persistance/services/user_service.dart';
import 'package:gbanker/persistance/services/village_service.dart';
import 'package:gbanker/screens/camera/camera_screen.dart';
import 'package:gbanker/widgets/Colors.dart' as ColorList;
import 'package:gbanker/widgets/app_bar.dart';
import 'package:gbanker/widgets/custom_dialog.dart';
import 'package:gbanker/widgets/form/badge.dart';
import 'package:gbanker/widgets/group_caption.dart';
import 'package:gbanker/widgets/members/member_list_tile.dart';
import 'package:gbanker/widgets/members/member_search_list_title.dart';
import 'package:gbanker/widgets/navigation_drawer/navigation_drawer.dart';
import 'package:intl/intl.dart';

class MemberScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MemberScreenState();

}

class MemberScreenState  extends State<MemberScreen>{
  bool listViewFlag = true;
  bool loading = false;
  int phoneNoUniqueStatus = 0;

  TextEditingController searchField = TextEditingController();


  List<DropdownMenuItem<int>> centerList = [];
  List<DropdownMenuItem<int>> groupList = [];
  List<DropdownMenuItem<int>> memberCategoryList = [];
  List<DropdownMenuItem<int>> countryList = [];
  List<DropdownMenuItem<int>> divisionList = [];
  List<DropdownMenuItem<String>> districtList = [];
  List<DropdownMenuItem<String>> subDistrictList = [];
  List<DropdownMenuItem<String>> unionList = [];
  List<DropdownMenuItem<String>> villageList = [];
  List<DropdownMenuItem<String>> citizenshipList = [];
  List<DropdownMenuItem<int>> birthPlaceList = [];
  List<DropdownMenuItem<String>> genderList = [];
  List<DropdownMenuItem<String>> homeTypeList = [];
  List<DropdownMenuItem<String>> groupTypeList = [];
  List<DropdownMenuItem<String>> educationList = [];
  List<DropdownMenuItem<String>> economicActivitiesList = [];
  List<DropdownMenuItem<String>> maritalStatusList = [];
  List<DropdownMenuItem<String>> memberTypeList = [];
  List<DropdownMenuItem<int>> identityTypes = [];
  List<DropdownMenuItem<int>> mobileFinancialServices = [];
  List<DropdownMenuItem<int>> transactionMediums = [];
  List<DropdownMenuItem<int>> reasons = [];


  String pageTitle="Members";
  int _selectedCenter;
  int _selectedGroup;
  int _selectedMemberCategory;
  int _selectedCountry;
  int _selectedDivision;
  String _selectedDistrict;
  String _selectedSubDistrict;
  String _selectedUnion;
  String _selectedVillage;
  int _pselectedCountry;
  int _pselectedDivision;
  String _pselectedDistrict;
  String _pselectedSubDistrict;
  String _pselectedUnion;
  String _pselectedVillage;
  int _selectedBirthPlace;
  String _selectedMemberType;
  String _selectedGender;
  String _selectedHomeType;
  String _selectedGroupType;
  String _selectedEducationType;
  String _selectedEconomicActivity;
  String _selectedMaritalStatus;
  String _selectedCitizen;
  int _selectedMobileFinancialServiceAns;
  int _selectedReason;
  int _selectedTransactionMedium;
  bool _selectPermanentAddress;
  int _selectedIdentityType;
  int _selectedIdentityProviderCountry;

  TextEditingController fullNameController  = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController pzipCodeController = TextEditingController();
  TextEditingController presentAddressController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController nidController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController familyMemberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController spouseController = TextEditingController();
  TextEditingController coApplicantController = TextEditingController();
  TextEditingController totalWealthController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController smartCardNoController = TextEditingController();
  TextEditingController admitDateController = TextEditingController();
  TextEditingController issueDateController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expireDateController = TextEditingController();
  TextEditingController tinController = TextEditingController();
  TextEditingController taxAmountController = TextEditingController();
  TextEditingController fServiceNameController = TextEditingController();
  TextEditingController referenceNameController = TextEditingController();
  TextEditingController familyContactNoController = TextEditingController();
  TextEditingController contactNoUniqueCheckController = TextEditingController();

  String identityCheckStatusMsg = "";
  Color identityCheckStatusColor;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  DateTime today;

  int dobStartYear;
  int dobEndYear;
  DateTime dobInitial;

  int itemCount=0;

  List<Map<String,dynamic>> members = [];
  List<Map<String,dynamic>> tempMembers = [];


  List<CameraDescription> cameras = [];

  String imgSyncText;
  String sigImgSyncText;
  Color imgSyncColor;
  Color sigImgSyncColor;

  bool isDownloading = false;

  int downloadingState = 0;
  String downloadingInfo= "Downloading";

  User user;

  @override
  void initState() {

    loadLookUpData();
    today = DateTime.now();
    dobStartYear = (today.year-100);
    dobEndYear = (today.year-18);
    dobInitial = DateTime(dobEndYear);
    _selectPermanentAddress = false;
    _selectedMobileFinancialServiceAns = 2;
    listViewFlag=true;
    _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

    super.initState();
  }

  Widget showListView(){

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      child: Container(
        child: (itemCount == 0 && isDownloading==false)? Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width-150,
            child: RaisedButton(

                color: Colors.blue,
                onPressed: () async {
                  setState(() {
                    isDownloading = true;
                  });
                  _refreshIndicatorKey.currentState?.show();

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.cloud_download,
                    color: Colors.white,),
                    Padding(
                        padding: EdgeInsets.only(right: 10),
                        child:Text("Download Members",style:TextStyle(
                            color:Colors.white
                        ),)
                    )
                  ],
                )
            ),
          )
        ):Stack(
          children: <Widget>[
            ListView.builder(
                itemCount: itemCount,

                itemBuilder: (context,i){
                  var member = members[i];
                  if(tempMembers != null && tempMembers.length>0){
                    return searchResultListView(i, member);
                  }
                  return generalListView(i, member);

                }),
                showLoader()
          ],
        ),
      ),
      onRefresh: () async {


         await getMemberfromServer();

         return true;
      },
    );
  }

  Widget showLoader(){
    return (isDownloading)? Container(
        color: Colors.black54,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:Center(
      child:CustomDialog(showProgress: true,
            progressCallback: this.downLoadProgressUi,))
    ):Container();
  }

  Widget generalListView(int i, dynamic member){

    imgSyncText = (member['img_path'] == null || member['img_path'] == "")?  "No Photo" :
    (member['img_sync']==1)? "Photo sync" : "Photo not sync";

    sigImgSyncText = (member['sig_img_path'] == null
        || member['sig_img_path'] == "")? "No Signature" :
    (member['sig_img_sync']==1)?
    "Signature Sync": "Signature not sync";

    imgSyncColor = (member['img_sync']==1)? Colors.green : Colors.red;
    sigImgSyncColor = (member['sig_img_sync']==1)? Colors.green : Colors.red;

    List<Map<String,dynamic>> options = [];
    if(user!= null && user.orgId != 1){
      options.add({"text":"Camera","icon":Icons.camera,"route":"#camera"});
    }

    return MemberListTile(
      index: i,
      member: member,
      imgSyncText: imgSyncText,
      imgSyncColor: imgSyncColor,
      sigImgSyncText: sigImgSyncText,
      sigImgSyncColor: sigImgSyncColor,
      menus: options,
      callback: handleListOption,
    );
  }

  Widget searchResultListView(int i, dynamic member){

    imgSyncText = (member['img_path'] == null || member['img_path'] == "")?  "No Photo" :
    (member['img_sync']==1)? "Photo sync" : "Photo not sync";

    sigImgSyncText = (member['sig_img_path'] == null
        || member['sig_img_path'] == "")? "No Signature" :
    (member['sig_img_sync']==1)?
    "Signature Sync": "Signature not sync";

    imgSyncColor = (member['img_sync']==1)? Colors.green : Colors.red;
    sigImgSyncColor = (member['sig_img_sync']==1)? Colors.green : Colors.red;

    return MemberSearchListTile(
      index: i,
      member: member,
      imgSyncText: imgSyncText,
      imgSyncColor: imgSyncColor,
      sigImgSyncText: sigImgSyncText,
      sigImgSyncColor: sigImgSyncColor,
      menus: [
        {"text":"Camera","icon":Icons.camera,"route":"#camera"},
      ],
      callback: handleListOption,
    );
  }

  void handleListOption(value,member){
    if(value.toString().contains("#camera")) {
      Navigator.pushReplacementNamed(context,
          "/camera", arguments: member);
    }
  }
  Widget downLoadProgressUi(){
    return Center(
          child:Padding(
              padding:EdgeInsets.all(0),
              child:Padding(
                  padding:EdgeInsets.only(top: 15,left:5,right: 5),
                  child:Column(
                    children: <Widget>[
                      Text(downloadingInfo,style:TextStyle(
                          fontWeight: FontWeight.bold
                      )),
                    ],
                  )
              )
          )

    );
  }
  Future<void> getMemberfromServer() async {
    setState(() {
      downloadingInfo="Downloading Members";
    });
//    showDialog(
//        context: context,
//
//        builder: (BuildContext context) {
//          return CustomDialog(showProgress: true,
//            progressCallback: this.downLoadProgressUi,);
//        });

    var memberFetchResult =  await MemberService.fetchMembers(limit: 1000);
//    print(memberFetchResult);


    if(memberFetchResult !=null && memberFetchResult['totalCount'] != null ){
      if(memberFetchResult['totalCount'] <=0){
        showErrorMessage("No Member found",context);
        setState(() {
          isDownloading = false;
        });
        return;
      }
      if(mounted) {
        setState(() {
          downloadingInfo = "Copying Members : 0/${memberFetchResult['totalCount']}";
        });
      }
      List<dynamic> fetchedMembers = memberFetchResult['members'];
      fetchedMembers = fetchedMembers.reversed.toList();
      int i=0;
      for(dynamic map in fetchedMembers) {

        var exist = await MemberService.hasMember(memberCode: map['MemberCode']);
        if(!exist){

          String imgContent = map['MemberImg'];
          String sigImgContent = map['ThumbImg'];

          map['MemberImg'] = null;
          map['ThumbImg'] = null;

          //print(imgContent.length);
          int inserted = await MemberService.saveMemberFromApi(map);

          if(inserted> 0 && imgContent !=null && imgContent.length>0){
            await FileHelper.writeImage(FileHelper.PHOTO, imgContent,
                callback: MemberService.updateImg,
                memberId: inserted
            );
          }

          if(inserted>0 && sigImgContent != null && sigImgContent.length>0){
            await FileHelper.writeImage(FileHelper.SIG, sigImgContent,
                callback: MemberService.updateSigImg,
                memberId: inserted
            );
          }

        }
        i++;
        if(mounted) {
          setState(() {
            downloadingInfo =
            "Copying Members : ${i}/${memberFetchResult['totalCount']}";
          });
        }
      }
    }else{
      showErrorMessage("Sorry! Please try again later", context);
    }

    await loadMemberList();
    setState(() {
      isDownloading = false;
      //Navigator.of(context).pop();
    });
  }

  Future<void> loadLookUpData() async{
    loadMemberList();
    Setting guid = await SettingService.getSetting('guid');
    var _user = await UserService.getUserByGuid(guid.value);
    cameras = await availableCameras();

    // Center/Samity lookup data load
    CenterService.getCenters().then((_centerList){
      if(_centerList.length>0){
        _centerList.forEach((_center){
          centerList.add(DropdownMenuItem(
            child: Text('${_center.centerCode} - ${_center.centerName}'),
            value: _center.id,
          ));
        });
      }
    });

    // Group lookup data load
    GroupService.getGroups().then((_groupList){
      if(_groupList.length > 0){
        _groupList.forEach((_group){
          groupList.add(DropdownMenuItem(
            child: Text(_group.groupCode),
            value: _group.id,
          ));
        });
      }
    });

    // Member Category lookup data load
    MemberCategoryService.getMemberCategories().then((_memberCategoryList){
      if(_memberCategoryList.length>0){
        _memberCategoryList.forEach((_memberCategory){
          memberCategoryList.add(DropdownMenuItem(
            child: Text('${_memberCategory.categoryCode} - ${_memberCategory.categoryName}'),
            value: _memberCategory.id,
          ));
        });
      }
    });

    // Country lookup data load
    CountryService.getCountries().then((_countryList){
      if(_countryList.length>0){
        _countryList.forEach((_country) async{
          if(_countryList.length==1){
            if(mounted) {
              setState(() {
                _selectedCountry = _country.id;
                _pselectedCountry = _country.id;
              });
            }
          }

          countryList.add(DropdownMenuItem (
            child: Text('${_country.countryName}'),
            value: _country.id,
          ));

          List<Division> divisions = await DivisionService.getDivisions(countryId:  this._selectedCountry);
          divisions.forEach((division){
            divisionList.add(DropdownMenuItem(
              child: Text('${division.divisionName}'),
              value: division.id,
            ));
          });
        });
      }
    });

    var _maritalStatusList = await loadMaritalStatus();
    var _identityTypes = await loadIdentityTypes();
    var _mobileFinanceSourceAns = await loadMobileFinancialServiceAns();
    var _reasons = await loadReasons();
    var _transactionMediums = await loadTransactionMediums();

    if(mounted){
      setState(() {
        user = _user;
        mobileFinancialServices = _mobileFinanceSourceAns;
        maritalStatusList = _maritalStatusList;
        identityTypes = _identityTypes;
        reasons = _reasons;
        transactionMediums = _transactionMediums;
      });
    }


  }

  Future<List<DropdownMenuItem<String>>> loadGenderList() async {
    var _genderList = List<DropdownMenuItem<String>>();
    var genders = await GenderService.getGenders();
    for(Gender gender in genders){
      _genderList.add(DropdownMenuItem(
        child: Text('${gender.text}'),
        value: gender.value,
      ));
    }


    return _genderList;
  }

  Future<List<DropdownMenuItem<String>>> loadHomeType() async{
    var _homeTypeList = List<DropdownMenuItem<String>>();
    var homeTypes = await HomeTypeService.getHomeTypes();
    for(HomeType homeType in homeTypes){
      _homeTypeList.add(DropdownMenuItem(
        child: Text('${homeType.text}'),
        value: homeType.value,
      ));
    }

    return _homeTypeList;
  }

  Future<List<DropdownMenuItem<String>>> loadGroupType() async {
    var _groupTypeList = List<DropdownMenuItem<String>>();
    var groupTypes = await GroupTypeService.getGroupTypes();
    for(GroupType groupType in groupTypes){
      _groupTypeList.add(DropdownMenuItem(
        child: Text('${groupType.text}'),
        value: groupType.value,
      ));
    }
    return _groupTypeList;
  }

  Future<List<DropdownMenuItem<String>>> loadCitizenships() async{
    var _citizenshipList = List<DropdownMenuItem<String>>();
    var citizenships = await CitizenshipService.getCitizenships();
    for(Citizenship citizenship in citizenships){
      _citizenshipList.add(DropdownMenuItem(
        child: Text('${citizenship.text}'),
        value: citizenship.value,
      ));
    }
    return _citizenshipList;
  }

  Future<List<DropdownMenuItem<String>>> loadEducation() async{
    var _educationList = List<DropdownMenuItem<String>>();
    var educations = await EducationService.getEducations();
    for(Education education in educations){
      _educationList.add(DropdownMenuItem(
        child: Text('${education.text}'),
        value: education.value,
      ));
    }
    return _educationList;
  }

  Future<List<DropdownMenuItem<String>>> loadEconomicActivities() async{
    var _economicActivitiesList = List<DropdownMenuItem<String>>();
    var economicActivities = await EconomicActivityService.getEconomicActivities();
    for(EconomicActivity economicActivity in economicActivities){
      _economicActivitiesList.add(DropdownMenuItem(
        child: Text('${economicActivity.text}'),
        value: economicActivity.value,
      ));
    }
    return _economicActivitiesList;
  }

  Future<List<DropdownMenuItem<String>>> loadMaritalStatus() async{
    var _maritalStatusList = List<DropdownMenuItem<String>>();
//    var maritalStatuses = await MaritalStatusService.getMaritalStatuses();
//    for(MaritalStatus maritalStatus in maritalStatuses){
//      _maritalStatusList.add(DropdownMenuItem(
//        child: Text('${maritalStatus.text}'),
//        value: maritalStatus.value,
//      ));
//    }
    _maritalStatusList.add(DropdownMenuItem(
      child: Text("Married"),value: "married",
    ));
    _maritalStatusList.add(DropdownMenuItem(
      child: Text("Un Married"),value: "un-married",
    ));
    _maritalStatusList.add(DropdownMenuItem(
      child: Text("Single"),value: "single",
    ));

    return _maritalStatusList;
  }

  Future<List<DropdownMenuItem<int>>> loadIdentityTypes() async {
    var _identityTypes = List<DropdownMenuItem<int>>();
    _identityTypes.add(DropdownMenuItem(
      child: Text("Passport"),value: 1,
    ));
    _identityTypes.add(DropdownMenuItem(
      child: Text("Driving License"),value: 2,
    ));
    _identityTypes.add(DropdownMenuItem(
      child: Text("Birth Certificate"),value: 3,
    ));


    return _identityTypes;
  }

  Future<List<DropdownMenuItem<int>>> loadMobileFinancialServiceAns() async {
    var _lists = List<DropdownMenuItem<int>>();
    _lists.add(DropdownMenuItem(
      child: Text("YES"), value: 1,
    ));
    _lists.add(DropdownMenuItem(
      child: Text("NO"), value: 2,
    ));

    return _lists;
  }

  Future<List<DropdownMenuItem<int>>> loadReasons() async{
    var _lists = List<DropdownMenuItem<int>>();
    _lists.add(DropdownMenuItem(
      child: Text("Personal"), value: 1,
    ));
    _lists.add(DropdownMenuItem(
      child: Text("Business"), value: 2,
    ));
    _lists.add(DropdownMenuItem(
      child: Text("Remitance"), value: 3,
    ));
    _lists.add(DropdownMenuItem(
      child: Text("Others"), value: 4,
    ));
    return _lists;
  }

  Future<List<DropdownMenuItem<int>>> loadTransactionMediums () async {

    var _lists = List<DropdownMenuItem<int>>();

    _lists.add(DropdownMenuItem(
      child: Text("Cash"), value: 1,
    ));
    _lists.add(DropdownMenuItem(
      child: Text("Cheque"), value: 2,
    ));
    _lists.add(DropdownMenuItem(
      child: Text("Mobile Financial Service"), value: 3,
    ));
    _lists.add(DropdownMenuItem(
      child: Text("Direct Transfer"), value: 4,
    ));
    _lists.add(DropdownMenuItem(
      child: Text("Multiple"), value: 5,
    ));
    _lists.add(DropdownMenuItem(
      child: Text("Other"), value: 6,
    ));
    return _lists;
  }

  Future<List<DropdownMenuItem<String>>> loadMemberTypes() async {
    var _memberTypeList = List<DropdownMenuItem<String>>();
    var memberTypes = await MemberTypeService.getMemberTypes();
    for(MemberType memberType in memberTypes){
      _memberTypeList.add(DropdownMenuItem(
        child: Text('${memberType.text}'),
        value: memberType.value,
      ));
    }
    return _memberTypeList;
  }

  Future<List<DropdownMenuItem<String>>> loadDistrict(int id) async {


    var _districtList = List<DropdownMenuItem<String>>();
    var  districts = await DistrictService.getDistricts(divisionId: id);

    for(District district in districts){
      _districtList.add(DropdownMenuItem(
         child: Text('${district.districtName}'),
         value: district.districtCode,
       ));
     }

    var _citizenshipList = await loadCitizenships();
    var _genderList = await loadGenderList();
    var _homeTypeList = await loadHomeType();
    var _groupTypeList = await loadGroupType();
    var _educationList = await loadEducation();
    var _economicActivities = await loadEconomicActivities();
    //var _maritalStatusList = await loadMaritalStatus();
    var _memberTypeList = await loadMemberTypes();
    var _birthPlaceList = await loadBirthPlace(id);


    setState(() {
      citizenshipList = _citizenshipList;
      genderList = _genderList;
      homeTypeList = _homeTypeList;
      groupTypeList = _groupTypeList;
      educationList = _educationList;
      economicActivitiesList = _economicActivities;
      memberTypeList = _memberTypeList;
      birthPlaceList = _birthPlaceList;
    });

    return _districtList;

  }

  Future<List<DropdownMenuItem<String>>> loadUpozilla(String id) async {
    var _subDistrictList = List<DropdownMenuItem<String>>();
    var subDistricts = await SubDistrictService.getSubDistricts(districtId: int.parse(id));

    for(SubDistrict subDistrict in subDistricts){

      _subDistrictList.add(DropdownMenuItem(
        child: Text('${subDistrict.subDistrictName}'),
        value: subDistrict.subDistrictCode,
      ));
    }

    return _subDistrictList;

  }

  Future<List<DropdownMenuItem<String>>> loadUnion(String upozillaId) async {
    var _unionList = List<DropdownMenuItem<String>>();
    var unions = await UnionService.getUnions(subDistrictId: upozillaId);

    for(Union union in unions){
      _unionList.add(DropdownMenuItem(
        child: Text('${union.unionName}'),
        value: union.unionCode,
      ));
    }

    return _unionList;
  }

  Future <List<DropdownMenuItem<String>>> loadVillage(String unionId) async {
    var _villageList = List<DropdownMenuItem<String>>();
    var villages = await VillageService.getVillages(unionId:unionId);

    for(Village village in villages){
      _villageList.add(DropdownMenuItem(
        child: Text('${village.villageName}'),
        value: village.villageCode,
      ));
    }

    return _villageList;
  }

  Future <List<DropdownMenuItem<int>>> loadBirthPlace(int divisionId) async {
    var _birthPlaceList = List<DropdownMenuItem<int>>();
    var birthPlaces = await BirthPlaceService.getBirthPlaces(divisionId: divisionId);
    for(BirthPlace birthPlace in birthPlaces){
      _birthPlaceList.add(DropdownMenuItem(
        child: Text('${birthPlace.districtName}'),
        value: int.parse(birthPlace.districtCode),
      ));
    }
    return _birthPlaceList;
  }

  Widget showCreateView(){

    return Card(
      margin:EdgeInsets.all(5),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: ListView(
          children: <Widget>[
            GroupCaption(caption: "Samity",size:11),
            DropdownButton(
              hint: Text('Select Samity'),
              items: centerList,
              value: _selectedCenter,
              isExpanded: true,
              onChanged: (value){
                setState(() {
                  _selectedCenter = value;
                });
              },
            ),
            GroupCaption(caption: "Member Category",size:11,),
            DropdownButton(
              hint: Text("Select Member Category"),
              isExpanded: true,
              items: memberCategoryList,
              value: _selectedMemberCategory,
              onChanged: (value){
                setState(() {
                  _selectedMemberCategory = value;
                });
              },
            ),
            GroupCaption(caption:"Applicant's Name",size:15,),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                  hintText: 'Full Name (In English)'
              ),
            ),
            GroupCaption(caption:"Father's Name",size:15,),
            TextField(
              controller: fatherNameController,
              decoration: InputDecoration(
                  hintText: 'In English'
              ),
            ),
            GroupCaption(caption:"Mother's Name",size: 15,),
            TextField(
              controller: motherNameController,
              decoration: InputDecoration(
                  hintText: 'In English'
              ),
            ),
            GroupCaption(caption:"Marital Status",size: 11,),
            DropdownButton(
              hint: Text('Marital Status'),
              items: maritalStatusList,
              value: _selectedMaritalStatus,
              isExpanded: true,
              onChanged: (value){
                setState((){
                  _selectedMaritalStatus = value;
                });
              },
            ),
            showSpouse(),
            GroupCaption(caption:"Present Address", size: 15,),
            GroupCaption(caption:"Country",size: 11,),
            DropdownButton(
              hint: Text('Select Country'),
              items: countryList,
              value: _selectedCountry,
              isExpanded: true,
              onChanged: (value){
                setState((){
                  _selectedCountry = value;
                });
              },
            ),
            GroupCaption(caption:"Division",size: 11,),
            DropdownButton(
              hint: Text('Select Division'),
              items: divisionList,
              value: _selectedDivision,
              isExpanded: true,
              onChanged: (value) async {
                var _districtList = await loadDistrict(value);
                setState(() {
                  _selectedDistrict=null;
                  _selectedSubDistrict=null;
                  _selectedUnion = null;
                  _selectedVillage = null;

                  _selectedDivision = value;
                  districtList = _districtList;
                  subDistrictList = [];
                  unionList = [];
                  villageList = [];
                });
              },
            ),
            GroupCaption(caption:"District",size: 11,),
            DropdownButton(
              hint: Text('Select District'),
              items: districtList,
              value: _selectedDistrict,
              isExpanded: true,
              onChanged: (value) async {
                var _subDistricts = await loadUpozilla(value);
                setState(() {
                  _selectedSubDistrict = null;
                  _selectedUnion = null;
                  _selectedVillage = null;

                  _selectedDistrict = value;
                  subDistrictList = _subDistricts;
                  unionList = [];
                  villageList = [];
                });
              },
            ),
            GroupCaption(caption:"Upzilla",size: 11,),
            DropdownButton(
              hint: Text('Select Upzilla'),
              items: subDistrictList,
              value: _selectedSubDistrict,
              isExpanded: true,
              onChanged: (value) async {
                var _unions = await loadUnion(value);
                setState(() {
                  _selectedUnion = null;
                  _selectedVillage = null;
                  _selectedSubDistrict = value;
                  unionList = _unions;
                  villageList = [];
                });
              },

            ),
            GroupCaption(caption:"Union",size: 11,),
            DropdownButton(
              hint: Text('Select Union'),
              items: unionList,
              value: _selectedUnion,
              isExpanded: true,
              onChanged: (value) async {
                var _villages = await loadVillage(value);
                setState(() {

                  _selectedVillage = null;
                  _selectedUnion = value;
                  villageList = _villages;

                });
              },
            ),
            GroupCaption(caption:"Village",size: 11,),
            DropdownButton(
              hint: Text('Select Village/ Street'),
              items: villageList,
              value: _selectedVillage,
              isExpanded: true,
              onChanged: (value){
                setState(() {
                  _selectedVillage = value;
                });
              },
            ),
            GroupCaption(caption:"Zip Code",size: 11,),
            TextField(
              controller: zipCodeController,
              decoration: InputDecoration(
                  hintText: 'Zip Code'
              ),
            ),
            GroupCaption(caption:"Address Details",size: 11,),
            TextField(
              controller: presentAddressController,
              decoration: InputDecoration(
                  hintText: 'Address Details'
              ),
            ),

            GroupCaption(caption:"Permanent Address",size: 15,),
            Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Checkbox(
                    tristate: false,
                    value: _selectPermanentAddress,
                    onChanged: (value){
                      setState(() {
//                        print(value);
                        if(value==true){


                          if(_selectedCountry != null &&
                            _selectedDivision != null &&
                            _selectedDistrict != null &&
                            _selectedSubDistrict != null &&
                            _selectedUnion != null &&
                            _selectedVillage != null &&
                            zipCodeController.text != "" &&
                            presentAddressController.text != ""

                          ){
                            _pselectedCountry = _selectedCountry;
                            _pselectedDivision = _selectedDivision;
                            _pselectedDistrict = _selectedDistrict;
                            _pselectedSubDistrict = _selectedSubDistrict;
                            _pselectedUnion = _selectedUnion;
                            _pselectedVillage = _selectedVillage;
                            pzipCodeController.text = zipCodeController.text;
                            permanentAddressController.text = presentAddressController.text;
                            _selectPermanentAddress = value;
                          } else {

                            showErrorMessage("Make sure present address completly selected",context);

                          }
                        }else{
                          _selectPermanentAddress = value;
                          _pselectedCountry = _selectedCountry;
                          _pselectedDivision = null;
                          _pselectedDistrict = null;
                          _pselectedSubDistrict = null;
                          _pselectedUnion = null;
                          _pselectedVillage = null;
                        }
                      });
                    },
                  ),
                ),
                Text(" (Same as Present) ")
              ],
            ),
            GroupCaption(caption:"Country",size: 11,),
            DropdownButton(
              hint: Text('Select Country'),
              items: countryList,
              value: _pselectedCountry,
              isExpanded: true,
              onChanged: (value){
                setState((){
                  _pselectedCountry = value;
                });
              },
            ),
            GroupCaption(caption:"Division",size: 11,),
            DropdownButton(
              hint: Text('Select Division'),
              items: divisionList,
              value: _pselectedDivision,
              isExpanded: true,
              onChanged: (value) async {
                var _districtList = await loadDistrict(value);
                setState(() {

                  _pselectedDistrict=null;
                  _pselectedSubDistrict=null;
                  _pselectedUnion = null;
                  _pselectedVillage = null;

                  _pselectedDivision = value;
                  districtList = _districtList;
                  subDistrictList = [];
                  unionList = [];
                  villageList = [];

                });
              },
            ),
            GroupCaption(caption:"District",size: 11,),
            DropdownButton(
              hint: Text('Select District'),
              items: districtList,
              value: _pselectedDistrict,
              isExpanded: true,
              onChanged: (value) async {
                var _subDistricts = await loadUpozilla(value);
                setState(() {
                  _pselectedSubDistrict = null;
                  _pselectedUnion = null;
                  _pselectedVillage = null;

                  _pselectedDistrict = value;
                  subDistrictList = _subDistricts;
                  unionList = [];
                  villageList = [];
                });
              },
            ),
            GroupCaption(caption:"Upzilla",size: 11,),
            DropdownButton(
              hint: Text('Select Upzilla'),
              items: subDistrictList,
              value: _pselectedSubDistrict,
              isExpanded: true,
              onChanged: (value) async {
                var _unions = await loadUnion(value);
                setState(() {
                  _pselectedUnion = null;
                  _pselectedVillage = null;
                  _pselectedSubDistrict = value;
                  unionList = _unions;
                  villageList = [];
                });
              },
            ),
            GroupCaption(caption:"Union",size: 11,),
            DropdownButton(
              hint: Text('Select Union'),
              items: unionList,
              value: _pselectedUnion,
              isExpanded: true,
              onChanged: (value) async {
                var _villages = await loadVillage(value);
                setState(() {
                  _pselectedVillage = null;
                  _pselectedUnion = value;
                  villageList = _villages;
                });
              },
            ),
            GroupCaption(caption:"Village",size: 11,),
            DropdownButton(
              hint: Text('Select Village/ Street'),
              items: villageList,
              value: _pselectedVillage,
              isExpanded: true,
              onChanged: (value){
                setState(() {
                  _pselectedVillage = value;
                });
              },
            ),
            GroupCaption(caption:"Zip Code",size: 11,),
            TextField(
              controller: pzipCodeController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: 'Zip Code'
              ),
            ),
            GroupCaption(caption:"Address Details",size: 11,),
            TextField(
              controller: permanentAddressController,
              decoration: InputDecoration(
                  hintText: 'Address Details'
              ),
            ),
            GroupCaption(caption: "Identity Information",size: 15,),
            GroupCaption(caption:"National ID",size: 11,),
            TextField(
              controller: nidController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: "NID NO"
              ),
            ),
            GroupCaption(caption:"Smart Card No",size: 11,),
            TextField(
              controller:smartCardNoController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                hintText: "Smart Card No"
              ),
            ),
            GroupCaption(caption: "Other Identity Information",size: 15,),
            GroupCaption(caption:"Identity Type",size: 11,),
            DropdownButton(
              hint: Text("Identity Type"),
              items: identityTypes,
              isExpanded: true,
              value: _selectedIdentityType,
              onChanged: (value){
                setState(() {
                  _selectedIdentityType = value;
                });
              },
            ),
            GroupCaption(caption:"Issue Date",size: 11,),
            TextField(
              controller: issueDateController,
              readOnly: true,
              onTap: (){
                showDatePicker(context: context, initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(DateTime.now().year+1))
                    .then((date){
                  if(date != null) {
                    issueDateController.text =
                        date.toString().substring(0, 11).trim();
                  }else{
                    issueDateController.text = "";
                  }
                });
              },

              decoration: InputDecoration(
                  hintText: "Issue Date"
              ),
            ),
            GroupCaption(caption:"ID/Card Number",size: 11,),
            TextField(
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: "Card Number"
              ),
            ),
            showExpireDate(),
            GroupCaption(caption:"ID Provider Country",size: 11,),
            DropdownButton(
              hint: Text("ID Provider Country"),
              items: countryList,
              isExpanded: true,
              value: _selectedIdentityProviderCountry,
              onChanged: (value){
                setState(() {
                  _selectedIdentityProviderCountry = value;
                });
              },
            ),


            GroupCaption(caption: "Date of Birth",size: 11,),
            TextField(
              controller: dobController,
              onTap: (){
                showDatePicker(context: context, initialDate:dobInitial , firstDate: DateTime(dobStartYear), lastDate: DateTime(dobEndYear))
                    .then((date){
                  if(date != null){
                    dobController.text = (date.toString().substring(0,11).trim());
                    setState(() {
                      dobInitial = DateTime.parse(dobController.text);
                    });
                    getAgeInWords();
                  }else{
                    dobController.text="";
                  }
                });
              },
              readOnly: true,
              decoration: InputDecoration(
                  hintText: 'Date of Birth'
              ),
            ),
            GroupCaption(caption: "Age",size: 11,),
            TextField(
              readOnly: true,
              controller: ageController,
              decoration: InputDecoration(
                  hintText: "Age"
              ),
            ),
            GroupCaption(caption: "Place of Birth",size: 11,),
            DropdownButton(
              hint: Text("Place of Birth"),
              items: birthPlaceList,
              value: _selectedBirthPlace,
              isExpanded: true,
              onChanged: (value){

                setState(() {
                  _selectedBirthPlace = value;
                });
              },
            ),
            GroupCaption(caption: "Citizenship",size: 11,),
            DropdownButton(
              hint: Text("Citizenship"),
              items: citizenshipList,
              value: _selectedCitizen,
              isExpanded: true,
              onChanged: (value){
                setState(() {
                  _selectedCitizen = value;
                });
              },
            ),
            GroupCaption(caption: "Gender",size: 11,),
            DropdownButton(
              hint: Text("Gender"),
              items: genderList,
              value: _selectedGender,
              isExpanded: true,
              onChanged: (value){
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            GroupCaption(caption: "Admission Date",size: 11,),
            TextField(
              readOnly: true,
              onTap: (){
                showDatePicker(context: context, initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(DateTime.now().year+1))
                .then((date){
                  if(date != null) {
                    admitDateController.text =
                        date.toString().substring(0, 19).trim();
                  }else{
                    admitDateController.text = "";
                  }
                });
              },
              controller: admitDateController,
              decoration: InputDecoration(
                  hintText: 'Admission Date'
              ),
            ),
            GroupCaption(caption: "Home Type",size: 11,),
            DropdownButton(
              hint: Text("Select Home Type"),
              items: homeTypeList,
              value: _selectedHomeType,
              isExpanded: true,
              onChanged: (value){
                setState(() {
                  _selectedHomeType = value;
                });
              },
            ),
//            GroupCaption(caption: "Group Type",size: 11,),
//            DropdownButton(
//              hint: Text("Select Group Type"),
//              items: groupTypeList,
//              value: _selectedGroupType,
//              isExpanded: true,
//              onChanged: (value){
//                setState(() {
//                  _selectedGroupType = value;
//                });
//              },
//            ),
            GroupCaption(caption: "Education",size: 11,),
            DropdownButton(
              hint: Text("Select Education"),
              items: educationList,
              value: _selectedEducationType,
              isExpanded: true,
              onChanged: (value){
                setState(() {
                  _selectedEducationType = value;
                });
              },
            ),
            GroupCaption(caption: "Family Member",size: 11,),
            TextField(
              controller: familyMemberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: 'Family Member'
              ),
            ),
            GroupCaption(caption: "Email",size: 11,),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: 'Email'
              ),
            ),
            GroupCaption(caption: "Contact No",size: 11,),
            TextField(
              readOnly: true,
              controller: contactNoController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: 'Contact No'
              ),
            ),
            GroupCaption(caption: "Family Contact No",size: 11,),
            TextField(
              controller: familyContactNoController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: 'Family Contact No'
              ),
            ),
            GroupCaption(caption: "Reference Name",size: 11,),
            TextField(
              controller: referenceNameController,
              decoration: InputDecoration(
                  hintText: 'Reference Name'
              ),
            ),
            GroupCaption(caption: "Co Applicant Name (Family Head)",size: 11,),
            TextField(
              controller: coApplicantController,
              decoration: InputDecoration(
                  hintText: 'Co Applicant Name (Family Head)'
              ),
            ),
            GroupCaption(caption: "Occupation",size: 11,),
            DropdownButton(
              hint: Text("Select Occupation"),
              items: economicActivitiesList,
              isExpanded: true,
              value: _selectedEconomicActivity,
              onChanged: (value){
                setState(() {
                  _selectedEconomicActivity = value;
                });
              },
            ),
            GroupCaption(caption: "Total Wealth",size: 11,),
            TextField(
              controller: totalWealthController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: 'Total Wealth'
              ),
            ),
            GroupCaption(caption: "Member Type",size: 11,),
            DropdownButton(
              hint: Text('Member Type'),
              items: memberTypeList,
              value: _selectedMemberType,
              isExpanded: true,
              onChanged: (value){
                setState(() {
                  _selectedMemberType = value;
                });
              },
            ),
            GroupCaption(caption: "TIN (Tax Idendification Number)",size: 11,),
            TextField(
              controller: tinController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: 'TIN'
              ),
            ),
            GroupCaption(caption: "Tax Amount",size: 11,),
            TextField(
              controller: taxAmountController,
              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                  hintText: 'Tax Amount'
              ),
            ),
            GroupCaption(caption: "Member's use any mobile financial services ?",),
            DropdownButton(
              hint: Text('Answer'),
              items: mobileFinancialServices,
              value: _selectedMobileFinancialServiceAns,
              isExpanded: true,
              onChanged: (value){
                setState(() {
                  _selectedMobileFinancialServiceAns = value;
                });
              },
            ),
            showFinService(),
            GroupCaption(caption: "Transaction Medium",),
            DropdownButton(
              hint: Text('Answer'),
              items: transactionMediums,
              value: _selectedTransactionMedium,
              isExpanded: true,
              onChanged: (value){
                setState(() {
                  _selectedTransactionMedium = value;
                });
              },
            ),
            RaisedButton(
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Text("Save Member",style: TextStyle(color: Colors.white),),
                  (loading)?SizedBox(
                    height: 18.0,
                    width: 28.0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
                    ),
                  ):SizedBox.shrink()
                ],
              ),
              color: Colors.green,
              onPressed: () async {
                if(loading){
                  return;
                }
                setState(() {
                  loading = true;
                });
                saveMember();
              },
            ),
            RaisedButton(
              child: Text("Cancel", style: TextStyle(color: Colors.white),),
              color: Colors.deepOrange,
              onPressed: () async {

                setState(() {
                  pageTitle="Members";
                  loading=false;
                  listViewFlag=true;
                });
                loadMemberList();
              },
            )
          ],
        ),
      )
    );
  }

  Widget showFinService(){
    if(_selectedMobileFinancialServiceAns==1){
      return Column(
        children: <Widget>[
          GroupCaption(caption: "If you use, write down what ?",),
          TextField(
            controller: fServiceNameController,
            decoration: InputDecoration(
                hintText: 'Write Here'
            ),
          ),
          GroupCaption(caption: "What reasons do you use ?",),
          DropdownButton(
            hint: Text('Answer'),
            items: reasons,
            value: _selectedReason,
            isExpanded: true,
            onChanged: (value){
              setState(() {
                _selectedReason = value;
              });
            },
          )
        ],
      );
    }else{
      return Container();
    }
  }

  Widget showExpireDate(){
    if(_selectedIdentityType != 3) {
      return Column(
        children: <Widget>[
          GroupCaption(caption: "Validity Date",size: 11,),
          TextField(
            controller: expireDateController,
            readOnly: true,
            onTap: (){
              showDatePicker(context: context, initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(DateTime.now().year+1))
                  .then((date){
                if(date != null) {
                  expireDateController.text =
                      date.toString().substring(0, 11).trim();
                }else{
                  expireDateController.text = "";
                }
              });
            },
            decoration: InputDecoration(
                hintText: "Expire Date"
            ),
          )
        ],
      );
    }
    return Container();
  }

  Widget showSpouse(){
    if(_selectedMaritalStatus == "married"){
      return Column(
        children: <Widget>[
          GroupCaption(caption:"Spouse Name"),
          TextField(
            controller: spouseController,
            decoration: InputDecoration(
                hintText: 'In English'
            ),
          ),
        ],
      );
    }
    return Container();
  }

  Widget getFloatingButton(){
    FloatingActionButton floatingActionButton = null;
    if(this.listViewFlag && (user != null && user.orgId != 1)) {
      floatingActionButton = FloatingActionButton(
        onPressed: () {
          if(isDownloading){
            showErrorMessage("Please wait to finish download",context);
            return;
          }
          setState(() {
            pageTitle="Create Member";
            phoneNoUniqueStatus = 0;
            contactNoUniqueCheckController.text="";
            identityCheckStatusMsg = "";
            this.listViewFlag = false;
          });
        },
        child: Icon(Icons.add),
      );
    }
    return floatingActionButton;
  }

  Widget showView(){
    if(listViewFlag){

      //loadMemberList();d
      return showListView();
    }else{
      if(phoneNoUniqueStatus>0){
        return showCreateView();
      }else{
        return showIdentityCheckForm();
      }

    }
  }

  Widget showIdentityCheckForm(){
    return Container(
      child: Padding(
      padding: EdgeInsets.all(5),
        child: ListView(
          children: <Widget>[
            Card(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child:GroupCaption(caption: "Member Identity Check",) ,
                    ),
                    TextField(
                      controller: contactNoUniqueCheckController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          hintText: "Type Phone No"
                      ),
                    ),
                    Text(identityCheckStatusMsg,style: TextStyle(color:identityCheckStatusColor),),
                    Center(
                      child: RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Check Phone No"),
                            (loading)?SizedBox(
                              height: 18.0,
                              width: 28.0,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
                              ),
                            ):SizedBox.shrink()
                          ],
                        ),
                        onPressed: () async  {
                          if(loading){
                            return;
                          }
                          setState(() {
                            loading = true;
                          });
                          try {


                            Map<String, dynamic> map = await MemberService
                                .checkUniqueContact(
                                contactNoUniqueCheckController.text);

                            if(map['status']!="false"){
                              if(mounted) {
                                setState(() {
                                    identityCheckStatusMsg="Member already exist with MemberCode ["+map['member']['MemberCode']+"]";
                                    identityCheckStatusColor = Colors.red;
                                });
                              }
                            }else{
                              if(mounted){
                                setState(() {
                                  phoneNoUniqueStatus = 1;
                                  contactNoController.text = contactNoUniqueCheckController.text;
                                });
                              }

                            }
                            setState(() {
                              loading = false;
                            });
                          } on CustomException catch(ex){
                            showErrorMessage(ex.message, context);
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          color: Colors.orange,
                          textColor: Colors.white,
                          child: Text("Cancel"),
                          onPressed: (){
                            setState(() {
                              pageTitle="Members";
                              listViewFlag=true;
                              loading = false;
                            });
                          },
                        ),
                      ))
                  ],
                ),
              ),
            )
          ]
          )
      )
    );
  }

  String getAgeInWords (){
    DateTime _dob = DateTime.parse(dobController.text);
    DateTime _now = DateTime.now();
    int _days = _now.difference(_dob).inDays;
    int _years = 0;
    int _months = 0;
    double days = double.parse(_days.toString());
    int remainDays =0;



    if((days%365) > 0){

        _years = (days/365).round();
        remainDays = (days - (_years * 365)).round();

        if((remainDays%30)>0){
          _months = (remainDays/30).round();
          remainDays = (remainDays - (_months*30)).round();
        }
    }

    String ageInWords = _years.toString()+" years ";
    if(_months>0){
      ageInWords += _months.toString() + " months ";
    }

    ageController.text = ageInWords;

    return ageInWords;
  }

  Future saveMember() async{

    Setting orgIdSetting = await SettingService.getSetting('orgId');

    try {
      Member member = Member(
          centerId: _selectedCenter,

          memberCategoryId: _selectedMemberCategory,
          firstName: fullNameController.text,
          fatherName: fatherNameController.text,
          motherName: motherNameController.text,
          maritalStatus: _selectedMaritalStatus,
          spouseName: spouseController.text,

          nid: nidController.text,
          smartCardNo: smartCardNoController.text,
          identityTypeId: _selectedIdentityType,
          issueDate: issueDateController.text,
          otherIdNo: cardNumberController.text,
          expireDate: expireDateController.text,
          cardProviderCountry: _selectedIdentityProviderCountry,

          dateOfBirth: dobController.text,
          age: ageController.text,
          birthPlaceId: _selectedBirthPlace,
          citizenshipId: _selectedCitizen,
          gender: _selectedGender,
          admissionDate: admitDateController.text,
          homeType: _selectedHomeType,
          educationId: _selectedEducationType,
          familyMember: (familyMemberController.text.length > 0) ? int.parse(
              familyMemberController.text) : 0,
          email: emailController.text,
          contactNo: contactNoController.text,
          familyMemberContactNo: familyContactNoController.text,
          referenceName: referenceNameController.text,
          coApplicantName: coApplicantController.text,
          economicActivityId: _selectedEconomicActivity,
          totalWealth: totalWealthController.text,
          memberTypeId: _selectedMemberType,
          tin: tinController.text,
          taxAmount: (taxAmountController.text.length>0)? double.parse(taxAmountController.text):0,
          isAnyFs: (_selectedMobileFinancialServiceAns != null)? true: false,
          fServiceName: fServiceNameController.text,
          finServiceChoiceId: _selectedReason,
          transactionChoiceId: _selectedTransactionMedium,

          memberAddress: MemberAddress(
              countryId: _selectedCountry,
              divisionId: _selectedDivision,
              districtId: (_selectedDistrict != null)? int.parse(_selectedDistrict):0,
              subDistrictId: _selectedSubDistrict,
              unionId: _selectedUnion,
              villageId: _selectedVillage,
              zipCode: zipCodeController.text,
              perCountryId: _selectedCountry,
              perDivisionId: _selectedDivision,
              perDistrictId: (_selectedDistrict != null)? int.parse(_selectedDistrict):0,
              perSubDistrictId: _selectedSubDistrict,
              perUnionId: _selectedUnion,
              perVillageId: _selectedVillage,
              perZipCode: zipCodeController.text,
              presentAddress: presentAddressController.text,
              permanentAddress: permanentAddressController.text
          )
      );

      int inserted = await MemberService.addNewMember(member);
      setState(() {
        loading = false;
      });

      if(inserted>0){
        showSuccessMessage("Member successfully saved", context);
        setState(() {
          pageTitle = "Members";
          listViewFlag = true;
        });
        loadMemberList();
      }

    }on Exception catch(ex){
//      print(ex);
    }
  }

  Future<void> loadMemberList() async{
//    print("Loading list view ");
    var _members = await MemberService.getMemberList();
    if(mounted) {
      setState(() {
        itemCount = _members.length;
        members = _members;
        tempMembers = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appTitleBar = AppTitleBar(bgColor: ColorList.Colors.primaryColor,
    title: pageTitle,
    actions: [
      Padding(
          padding: EdgeInsets.only(left: 10),
          child:InkWell(

            child: (tempMembers.length>0)? Icon(Icons.clear) : Icon(Icons.search),
            onTap: ()async{
              if(tempMembers.length>0){
                setState(() {
                  members = tempMembers;
                  itemCount = members.length;
                  tempMembers=[];
                });
              }else {
                searchField.text = "";
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(searchField: searchField,
                        searchMemberCodeCallback: this.searchSubmit,);
                  });
              }
            },
          )
      ),
      PopupMenuButton(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.more_vert),
        offset:Offset(0,40),

        itemBuilder: (BuildContext context)=><PopupMenuEntry<int>>[
          PopupMenuItem(
              height: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.cloud_download,color: Colors.black54,),
                  Text(" Download Members")
                ],
              ),
              value: 1,
            ),

          PopupMenuDivider(),
          (user.orgId != 1 )? PopupMenuItem(
            height: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.sync,color: Colors.black54,),
                Text(" Sync Member Images")
              ],
            ),
            value: 2,
          ) : PopupMenuItem(
            child:SizedBox.shrink()
          ),
        ],
        onSelected: (value) async {
//          print("SELECTED : ${value}");
          switch(value){
            case 1:
              setState(() {
                isDownloading = true;
              });
              _refreshIndicatorKey.currentState?.show();
              break;
            case 2:
              try {
                bool synced = await MemberService.syncImages();
                //print(synced);
                if (synced) {
                  showSuccessMessage(
                      "Images synchronized successfully", context);
                  Navigator.of(context).pushReplacementNamed('/members');
                }
              } on CustomException catch(ex){
                showErrorMessage(ex.message, context);
              }
              break;
          }
        },
      )
    ]
    );
    return WillPopScope(
      onWillPop: () async {
        if(listViewFlag==false){
          if(mounted) {
            setState(() {
              listViewFlag = true;
            });
          }
        } else {
          if(!isDownloading)
            Navigator.pushReplacementNamed(context, "/home");
          else
            showErrorMessage("Please wait to finish download", context);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffbbdefb),
          key: Key("members"),
          appBar: appTitleBar.build(context),


          floatingActionButton: getFloatingButton(),
          drawer: SafeArea(child:NavigationDrawer()),
          body:showView()
      ),
    );
  }

  void searchSubmit(String memberCode) async {
    bool found = false;
    int i=0;
    List<Map<String,dynamic>> _members = await MemberService.searchMemberByCode(memberCode);
    tempMembers = members;
    setState(() {
      if(_members !=null && _members.length>0){
        members = _members;
        itemCount = members.length;
      }

    });


    if(_members == null || _members.length==0){
      showErrorMessage("Member Not found with Code [${memberCode}]", context);
    }

    Navigator.of(context).pop();

  }


}