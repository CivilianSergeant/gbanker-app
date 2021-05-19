import 'package:gbanker/persistance/tables/banks_table.dart';
import 'package:gbanker/persistance/tables/birth_places_table.dart';
import 'package:gbanker/persistance/tables/centers_table.dart';
import 'package:gbanker/persistance/tables/citizenships_table.dart';
import 'package:gbanker/persistance/tables/countries_table.dart';
import 'package:gbanker/persistance/tables/districts_table.dart';
import 'package:gbanker/persistance/tables/divisions_table.dart';
import 'package:gbanker/persistance/tables/economic_activities_table.dart';
import 'package:gbanker/persistance/tables/educations_table.dart';
import 'package:gbanker/persistance/tables/genders_table.dart';
import 'package:gbanker/persistance/tables/groups_table.dart';
import 'package:gbanker/persistance/tables/grouptypes_table.dart';
import 'package:gbanker/persistance/tables/guarantors_table.dart';
import 'package:gbanker/persistance/tables/hometypes_table.dart';
import 'package:gbanker/persistance/tables/investors_table.dart';
import 'package:gbanker/persistance/tables/loan_collection_history_table.dart';
import 'package:gbanker/persistance/tables/loan_collections_table.dart';
import 'package:gbanker/persistance/tables/loan_proposals_table.dart';
import 'package:gbanker/persistance/tables/marital_status_table.dart';
import 'package:gbanker/persistance/tables/member_address_table.dart';
import 'package:gbanker/persistance/tables/member_categories_table.dart';
import 'package:gbanker/persistance/tables/member_products_table.dart';
import 'package:gbanker/persistance/tables/member_types_table.dart';
import 'package:gbanker/persistance/tables/menu_permissions_table.dart';
import 'package:gbanker/persistance/tables/menus_table.dart';
import 'package:gbanker/persistance/tables/miscs_table.dart';
import 'package:gbanker/persistance/tables/offices_table.dart';
import 'package:gbanker/persistance/tables/products_table.dart';
import 'package:gbanker/persistance/tables/purposes_table.dart';
import 'package:gbanker/persistance/tables/savings_accounts_table.dart';
import 'package:gbanker/persistance/tables/settings_table.dart';
import 'package:gbanker/persistance/tables/sub_districts_table.dart';
import 'package:gbanker/persistance/tables/unions_table.dart';
import 'package:gbanker/persistance/tables/users_table.dart';
import 'package:gbanker/persistance/tables/villages_table.dart';
import 'package:gbanker/persistance/tables/withdraw_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gbanker/persistance/tables/members_table.dart';

class DbProvider{
  DbProvider._();
  static final DbProvider db = DbProvider._();
  static Database _database;
  static int _dbVersion=6;

  Future<Database> get database async {
    if (_database != null){
      return _database;
    }


    _database = await initDB();
    return _database;
  }

  Future<void> _createTables(Database db) async{
    await db.execute(SettingsTable().createDDL()).then((_){
//      print(SettingsTable().tableName+" Created");
    });
    await db.execute(OfficesTable().createDDL()).then((_){
//      print(OfficesTable().tableName+" Created");
    });
    await db.execute(CentersTable().createDDL()).then((_){
//      print(CentersTable().tableName+" Created");
    });
    await db.execute(GroupsTable().createDDL()).then((_){
//      print(GroupsTable().tableName+" Created");
    });
    await db.execute(MemberCategoriesTable().createDDL()).then((_){
//      print(MemberCategoriesTable().tableName+" Created");
    });
    await db.execute(CountriesTable().createDDL()).then((_){
//      print(CountriesTable().tableName+" Created");
    });
    await db.execute(DivisionsTable().createDDL()).then((_){
//      print(DivisionsTable().tableName+" Created");
    });
    await db.execute(DistrictsTable().createDDL()).then((_){
//      print(DistrictsTable().tableName+" Created");
    });
    await db.execute(SubDistrictsTable().createDDL()).then((_){
//      print(SubDistrictsTable().tableName+" Created");
    });
    await db.execute(UnionsTable().createDDL()).then((_){
//      print(UnionsTable().tableName+" Created");
    });
    await db.execute(VillagesTable().createDDL()).then((_){
//      print(VillagesTable().tableName+" Created");
    });
    await db.execute(BirthPlacesTable().createDDL()).then((_){
//      print(BirthPlacesTable().tableName+" Created");
    });

    await db.execute(CitizenshipTable().createDDL()).then((_){
//      print(CitizenshipTable().tableName+" Created");
    });

    await db.execute(GendersTable().createDDL()).then((_){
//      print(GendersTable().tableName+" Created");
    });

    await db.execute(HomeTypeTable().createDDL()).then((_){
//      print(HomeTypeTable().tableName+" Created");
    });

    await db.execute(GroupTypeTable().createDDL()).then((_){
//      print(GroupTypeTable().tableName+" Created");
    });

    await db.execute(EducationsTable().createDDL()).then((_){
//      print(EducationsTable().tableName+" Created");
    });

    await db.execute(EconomicActivitiesTable().createDDL()).then((_){
//      print(EconomicActivitiesTable().tableName+" Created");
    });

    await db.execute(MaritalStatusTable().createDDL()).then((_){
//      print(MaritalStatusTable().tableName+" Created");
    });

    await db.execute(MemberTypesTable().createDDL()).then((_){
//      print(MemberTypesTable().tableName+" Created");
    });

    await db.execute(MembersTable().createDDL()).then((_){
//      print(MembersTable().tableName+" Created");
    });
    await db.execute(MemberAddressTable().createDDL()).then((_){
//      print(MemberAddressTable().tableName+" Created");
    });
    await db.execute(MemberProductsTable().createDDL()).then((_){
//      print(MemberProductsTable().tableName+" Created");
    });
    await db.execute(UsersTable().createDDL()).then((_){
//      print(UsersTable().tableName+" Created");
    });
    await db.execute(LoanCollectionsTable().createDDL()).then((_){
//      print(LoanCollectionsTable().tableName+" Created");
    });

    await db.execute(LoanCollectionHistoryTable().createDDL()).then((_){
//      print(LoanCollectionHistoryTable().tableName+" Created");
    });
    
    await db.execute(WithdrawalsTable().createDDL()).then((_){
//      print(WithdrawalsTable().tableName+" Created");
    });

    await db.execute(ProductsTable().createDDL()).then((_){
//      print(ProductsTable().tableName+" Created");
    });

    await db.execute(SavingsAccountsTable().createDDL()).then((_){
//      print(SavingsAccountsTable().tableName+ " Created");
    });

    await db.execute(LoanProposalsTable().createDDL()).then((_){
//      print(LoanProposalsTable().tableName + " Created");
    });
    
    await db.execute(InvestorsTable().createDDL()).then((_){
//      print(InvestorsTable().tableName + " Created");
    });
    
    await db.execute(PurposesTable().createDDL()).then((_){
//      print(PurposesTable().tableName + " Created");
    });

    await db.execute(GuarantorsTable().createDDL()).then((_){
//      print(GuarantorsTable().tableName+ " Created");
    });

    await db.execute(BanksTable().createDDL()).then((_){
//      print(BanksTable().tableName+ " Created");
    });

    await db.execute(MiscsTable().createDDL()).then((_){
//      print(MiscsTable().tableName + " Created");
    });
    
    await db.execute(MenusTable().createDDL()).then((_){
//      print(MenusTable().tableName + " Created");
    });

    await db.execute(MenuPermissionsTable().createDDL()).then((_){
//      print(MenuPermissionsTable().tableName + " Created");
    });
//    print('ALL tables created');

  }

  void _createIndexes(Database db) {

    List<String> divisionIndexes = DivisionsTable().createIndexes();
    divisionIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });

    List<String> districtIndexes = DistrictsTable().createIndexes();
    districtIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });

    List<String> subDistrictIndexes = SubDistrictsTable().createIndexes();
    subDistrictIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });

    List<String> unionIndexes = UnionsTable().createIndexes();
    unionIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });

    List<String> villageIndexes = VillagesTable().createIndexes();
    villageIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });

    List<String> birthPlaceIndexes = BirthPlacesTable().createIndexes();
    birthPlaceIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });

    List<String> memberIndexes = MembersTable().createIndexes();
    memberIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });

    List<String> memberAddressIndexes = MemberAddressTable().createIndexes();
    memberAddressIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });

    List<String> memberProductIndexes = MemberProductsTable().createIndexes();
    memberProductIndexes.forEach((String cmd) async{
      await db.execute(cmd);
    });

    List<String> loanCollectionIndexes = LoanCollectionsTable().createIndexes();
    loanCollectionIndexes.forEach((String cmd) async {
      await db.execute(cmd);
    });

    List<String> loanCollectionHistoryIndexes = LoanCollectionHistoryTable().createIndexes();
    loanCollectionHistoryIndexes.forEach((String cmd) async {
      await db.execute(cmd);
    });

    List<String> withdrawalIndexes = WithdrawalsTable().createIndexes();
    withdrawalIndexes.forEach((String cmd) async {
      await db.execute(cmd);
    });

    List<String> productIndexes = ProductsTable().createIndexes();
    productIndexes.forEach((String cmd) async {
      await db.execute(cmd);
    });

    List<String> savingsAccountIndexes = SavingsAccountsTable().createIndexes();
    savingsAccountIndexes.forEach((String cmd) async {
      await db.execute(cmd);
    });

    List<String> loanProposalIndexes = LoanProposalsTable().createIndexes();
    loanProposalIndexes.forEach((String cmd) async {
      await db.execute(cmd);
    });

    List<String> investorIndexes = InvestorsTable().createIndexes();
    investorIndexes.forEach((String cmd) async {
      await db.execute(cmd);
    });

    List<String> purposeIndexes = PurposesTable().createIndexes();
    purposeIndexes.forEach((String cmd) async {
      await db.execute(cmd);
    });

    List<String> guarantorIndexes = GuarantorsTable().createIndexes();
    guarantorIndexes.forEach((String cmd) async {
      await db.execute(cmd);
    });


  }

  Future<void> _dropTables(Database db) async{
    await db.execute(OfficesTable().dropDDL());
    await db.execute(CentersTable().dropDDL());
    await db.execute(GroupsTable().dropDDL());
    await db.execute(MemberCategoriesTable().dropDDL());
    await db.execute(CountriesTable().dropDDL());
    await db.execute(DivisionsTable().dropDDL());
    await db.execute(DistrictsTable().dropDDL());
    await db.execute(SubDistrictsTable().dropDDL());
    await db.execute(UnionsTable().dropDDL());
    await db.execute(VillagesTable().dropDDL());
    await db.execute(BirthPlacesTable().dropDDL());
    await db.execute(MembersTable().dropDDL());
    await db.execute(MemberAddressTable().dropDDL());
    await db.execute(MemberProductsTable().dropDDL());
    await db.execute(UsersTable().dropDDL());
    await db.execute(LoanCollectionsTable().dropDDL());
    await db.execute(LoanCollectionHistoryTable().dropDDL());
    await db.execute(WithdrawalsTable().dropDDL());
    await db.execute(ProductsTable().dropDDL());
    await db.execute(SavingsAccountsTable().dropDDL());
    await db.execute(LoanProposalsTable().dropDDL());
    await db.execute(InvestorsTable().dropDDL());
    await db.execute(PurposesTable().dropDDL());
    await db.execute(GuarantorsTable().dropDDL());
    await db.execute(BanksTable().dropDDL());
    await db.execute(MiscsTable().dropDDL());
    await db.execute(MenusTable().dropDDL());
    await db.execute(MenuPermissionsTable().dropDDL());
//    print('Drop tables done');
  }

  initDB() async {
    String path = join(await getDatabasesPath(), "gbanker_app_storage.db");
    return await openDatabase(path,version: _dbVersion,
      onOpen: (db) {

      },
      onCreate: (Database db, int version) async {
         this._createTables(db).then((_){
           this._createIndexes(db);
         });

      },
      onUpgrade: (Database db, int oldVersion , int newVersion) async{
          this._dropTables(db).then((_){
            this._createTables(db);
          });

      }
    );
  }

}