import 'dart:ui';

class Product{

  int id;
  int productId;
  String productCode;
  String productName;
  int productType;
  double interestRate;
  int duration;
  String mainProductCode;
  double loanInstallment;
  double interestInstallment;
  double savingsInstallment;
  double minLimit;
  double maxLimit;
  String interestCalculationMethod;
  String paymentFrequency;
  String mainItemName;
  int gracePeriod;
  String subMainCategory;
  int isDisbursement;
  int isActive;

  Product({this.id,this.productId,this.productCode,this.productName,
  this.productType,this.interestRate,this.duration,this.mainProductCode,
  this.loanInstallment,this.interestInstallment,this.savingsInstallment,
  this.minLimit,this.maxLimit,this.interestCalculationMethod,
  this.paymentFrequency,this.mainItemName,this.gracePeriod,
  this.subMainCategory,this.isDisbursement,this.isActive});

  factory Product.fromJson(Map<String,dynamic> map){
    return Product(

      id: map['id'],
      productId: map['product_id'],
      productCode: map['product_code'],
      productName: map['product_name'],
      productType: map['product_type'],
      interestRate: map['interest_rate'],
      duration: map['duration'],
      mainProductCode: map['main_product_code'],
      loanInstallment: map['loan_installment'],
      interestInstallment: map['interest_installment'],
      savingsInstallment: map['savings_installment'],
      minLimit: map['min_limit'],
      maxLimit: map['max_limit'],
      interestCalculationMethod: map['interest_calculation_method'],
      paymentFrequency: map['payment_frequency'],
      mainItemName: map['main_item_name'],
      gracePeriod: map['grace_period'],
      subMainCategory: map['sub_main_category'],
      isDisbursement: map['is_disbursement'],
      isActive: map['is_active']

    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'product_id': productId,
      'product_code': productCode,
      'product_name': productName,
      'product_type': productType,
      'interest_rate': interestRate,
      'duration': duration,
      'main_product_code':mainProductCode,
      'loan_installment':loanInstallment,
      'interest_installment':interestInstallment,
      'savings_installment':savingsInstallment,
      'min_limit': minLimit,
      'max_limit': maxLimit,
      'interest_calculation_method':interestCalculationMethod,
      'payment_frequency':paymentFrequency,
      'main_item_name':mainItemName,
      'grace_period':gracePeriod,
      'sub_main_category':subMainCategory,
      'is_disbursement': isDisbursement,
      'is_active':isActive
    };
  }
}