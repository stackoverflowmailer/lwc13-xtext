package forms;

import java.io.Serializable;
import types.Money;

public class Box1HouseOwning implements Serializable {
  private final static long serialVersionUID = 1L;
  
  private boolean hasSoldHouse;
  
  private boolean hasBoughtHouse;
  
  private boolean hasMaintLoan;
  
  private Money sellingPrice;
  
  private Money privateDebt;
  
  private Money valueResidue;
  
  public boolean isHasSoldHouse() {
    return this.hasSoldHouse;
  }
  
  public void setHasSoldHouse(final boolean hasSoldHouse) {
    this.hasSoldHouse = hasSoldHouse;
  }
  
  public boolean isHasSoldHouseEnabled() {
    return true;
  }
  
  public boolean isHasBoughtHouse() {
    return this.hasBoughtHouse;
  }
  
  public void setHasBoughtHouse(final boolean hasBoughtHouse) {
    this.hasBoughtHouse = hasBoughtHouse;
  }
  
  public boolean isHasBoughtHouseEnabled() {
    return true;
  }
  
  public boolean isHasMaintLoan() {
    return this.hasMaintLoan;
  }
  
  public void setHasMaintLoan(final boolean hasMaintLoan) {
    this.hasMaintLoan = hasMaintLoan;
  }
  
  public boolean isHasMaintLoanEnabled() {
    return true;
  }
  
  public Money getSellingPrice() {
    return this.sellingPrice;
  }
  
  public void setSellingPrice(final Money sellingPrice) {
    this.sellingPrice = sellingPrice;
  }
  
  public boolean isSellingPriceEnabled() {
    return true;
  }
  
  public Money getPrivateDebt() {
    return this.privateDebt;
  }
  
  public void setPrivateDebt(final Money privateDebt) {
    this.privateDebt = privateDebt;
  }
  
  public boolean isPrivateDebtEnabled() {
    return true;
  }
  
  public Money getValueResidue() {
    Money _minus = this.sellingPrice.operator_minus(this.privateDebt);
    return _minus;
  }
  
  public boolean isValueResidueEnabled() {
    return false;
  }
  
  public boolean isGroup0Visible() {
    boolean _and = false;
    if (!this.hasSoldHouse) {
      _and = false;
    } else {
      _and = (this.hasSoldHouse && this.hasBoughtHouse);
    }
    return _and;
  }
}
