String showAmount(String money) {
  String price = money;
  String revisedPrice = "";
  String reversedPrice = "";
  int count = 0;


  if(money[0] == '-' && money.length < 5){
    return money;
  }else {
    for (int i = price.length - 1; i >= 0; i--) {
      count += 1;
      revisedPrice += price[i].toString();
      if (count == 3 && price.length > 3) {
        revisedPrice += ',';
      }
    }
    for (int i = revisedPrice.length - 1; i >= 0; i--) {
      reversedPrice += revisedPrice[i].toString();
    }

    return reversedPrice;
  }
}