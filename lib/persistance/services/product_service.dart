import 'package:gbanker/persistance/db_provider.dart';
import 'package:gbanker/persistance/entities/Product.dart';
import 'package:gbanker/persistance/tables/products_table.dart';
import 'package:sqflite/sqflite.dart';

class ProductService{

  static Future<void> truncateProducts() async {
    final Database db = await DbProvider.db.database;
    await db.execute("DELETE FROM "+ProductsTable().tableName);
  }

  static Future<int> addProducts(List<dynamic> products) async{
    try {
      final Database db = await DbProvider.db.database;
      int i = 0;
      Batch batch = db.batch();
      for (dynamic product in products) {

        batch.insert(ProductsTable().tableName, (Product(
            productId: product['ProductID'],
            productCode: product['ProductCode'],
            productName: product['ProductName'],
            productType: product['ProductType'],
            interestRate: product['InterestRate'],
            duration: product['Duration'],
            mainProductCode: product['MainProductCode'],
            loanInstallment: product['LoanInstallment'],
            interestInstallment: product['InterestInstallment'],
            savingsInstallment: product['SavingsInstallment'],
            minLimit: product['MinLimit'],
            maxLimit: product['MaxLimit'],
            interestCalculationMethod: product['InterestCalculationMethod'],
            paymentFrequency: product['PaymentFrequency'],
            mainItemName: product['MainItemName'],
            gracePeriod: product['GracePeriod'],
            subMainCategory: product['SubMainCategory'],
            isDisbursement: product['IsDisbursement'],
            isActive: (product['IsActive']==true)? 1:0
        )).toMap());
        i++;
      }

      await batch.commit(noResult: true);

      //print("CENTER ADDED");
      return i;
    }on Exception catch(ex){
//      print(ex);
    }
  }

  static Future<double> getInterestRate(int productId) async{
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.query(ProductsTable().tableName,
        columns: ['id','product_id','interest_rate'],
        where:"product_id=?",
        whereArgs:[productId]);
    double interestRate = 0;
    maps.forEach((Map<String,dynamic> map){
      interestRate = map['interest_rate'];
    });

    return interestRate;

  }

  static Future<Product> getProduct(int id) async{

    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps = await db.query(ProductsTable().tableName,
        where: "product_id=?", whereArgs: [id]);
    return Product.fromJson(maps.first);
  }

  static Future<List<Map<String,dynamic>>> getSavingProducts({bool onlySaving}) async {
    final Database db = await DbProvider.db.database;
    List<Map<String,dynamic>> maps;
    if(onlySaving != null && onlySaving == true) {
      maps  = await db.rawQuery('SELECT *'
          'FROM ${ProductsTable().tableName} WHERE product_type=0 AND '
          'substr(product_code,0,3) IS NOT "21" GROUP BY  product_code' );


    }else{
      maps  = await db.query(ProductsTable().tableName, groupBy: "product_code");
    }

    return maps;
  }

  static Future<List<Map<String,dynamic>>> getMainProducts({String paymentFrequency}) async{
    final Database db = await DbProvider.db.database;
    List<Map<String, dynamic>> maps;
    String sql = "SELECT main_product_code,main_item_name FROM ${ProductsTable().tableName} p "
        " WHERE p.is_active=1 AND product_type=1";
    if(paymentFrequency != null){
      sql+=" AND p.payment_frequency='"+paymentFrequency+"'";
    }

    sql += " GROUP BY main_product_code";

    maps = await db.rawQuery(sql);
    return maps;
  }

  static Future<List<Map<String,dynamic>>> getSubMainProducts({String paymentFrequency,String mainProductCode}) async{
    final Database db = await DbProvider.db.database;
    List<Map<String, dynamic>> maps;
    String sql = "SELECT DISTINCT sub_main_category FROM ${ProductsTable().tableName} p "
        " WHERE p.is_active=1";
    if(paymentFrequency != null){
      sql+=" AND p.payment_frequency='"+paymentFrequency+"'";
    }

    if(mainProductCode != null){
      sql += " AND p.main_product_code = '"+mainProductCode+"'";
    }

    sql += " GROUP BY sub_main_category";

    maps = await db.rawQuery(sql);
    return maps;
  }


  static Future<List<Map<String,dynamic>>> getProducts({String paymentFrequency,String mainProductCode, String subMainCategory}) async {
    final Database db = await DbProvider.db.database;
    List<Map<String, dynamic>> maps;
    String sql = "SELECT product_id as id ,product_code || ' ' || product_name as product_name,"
        "duration,loan_installment,savings_installment,min_limit,interest_installment,"
        "max_limit, interest_calculation_method,payment_frequency"
        " FROM ${ProductsTable().tableName} p "
        " WHERE p.is_active=1";

    if(paymentFrequency != null){
      sql+=" AND p.payment_frequency='"+paymentFrequency+"'";
    }

    if(mainProductCode != null){
      sql += " AND p.main_product_code = '"+mainProductCode+"'";
    }

    if(subMainCategory != null){
      sql += " AND p.sub_main_category='"+subMainCategory+"'";
    }

    sql += " GROUP BY product_code";

    maps = await db.rawQuery(sql);
    return maps;
  }

  static Future<List<Map<String,dynamic>>> getMiscProducts() async {
    final Database db = await DbProvider.db.database;
    String sql = "SELECT p.product_id,p.product_code,p.product_name,"
        "duration,loan_installment,savings_installment,min_limit,max_limit,"
        "interest_calculation_method,payment_frequency"
        " FROM ${ProductsTable().tableName} p "
        " WHERE p.is_active=1 AND p.main_product_code='60.00' AND p.product_type = 60"
        " ORDER BY product_code ASC";

    List<Map<String,dynamic>> maps = await db.rawQuery(sql);
    return maps;
  }
}