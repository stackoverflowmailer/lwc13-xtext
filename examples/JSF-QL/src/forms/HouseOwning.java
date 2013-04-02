package forms;

import java.io.Serializable;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;

import types.Money;

@ManagedBean(name = "houseOwning")
@SessionScoped
public class HouseOwning implements Serializable {
  private final static long serialVersionUID = 1L;

  private boolean hasSoldHouse;

  private boolean hasBoughtHouse;

  private boolean hasMaintLoan;

  private Money sellingPrice = types.TypeFactory.createMoney();

  private Money privateDebt = types.TypeFactory.createMoney();

  public boolean isHasSoldHouse() {
    return this.hasSoldHouse;
  }

  public void setHasSoldHouse(final boolean hasSoldHouse) {
    this.hasSoldHouse = hasSoldHouse;
  }

  public boolean isHasBoughtHouse() {
    return this.hasBoughtHouse;
  }

  public void setHasBoughtHouse(final boolean hasBoughtHouse) {
    this.hasBoughtHouse = hasBoughtHouse;
  }

  public boolean isHasMaintLoan() {
    return this.hasMaintLoan;
  }

  public void setHasMaintLoan(final boolean hasMaintLoan) {
    this.hasMaintLoan = hasMaintLoan;
  }

  public Money getSellingPrice() {
    return this.sellingPrice;
  }

  public void setSellingPrice(final Money sellingPrice) {
    this.sellingPrice = sellingPrice;
  }

  public Money getPrivateDebt() {
    return this.privateDebt;
  }

  public void setPrivateDebt(final Money privateDebt) {
    this.privateDebt = privateDebt;
  }

  public Money getValueResidue() {
    Money _minus = this.sellingPrice.operator_minus(this.privateDebt);
    return _minus;
  }

  public boolean isValueResidueVisible() {
    return getValueResidue() != null;
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
