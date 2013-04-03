package types;

import java.io.Serializable;
import java.math.BigDecimal;

public class Money implements Serializable, Comparable<Money> {
  private static final long serialVersionUID = 1L;
  private BigDecimal amount;

  public Money(BigDecimal amount) {
    this.amount = amount;
  }

  public BigDecimal getAmount() {
    return amount;
  }

  public void setAmount(BigDecimal amount) {
    this.amount = amount;
  }

  // Implement operators
  public Money operator_minus(Money other) {
    return nothingIsNull(this.amount, other.amount) ? TypeFactory
        .createMoney(this.amount.subtract(other.amount)) : null;
  }

  public Money operator_plus(Money other) {
    return nothingIsNull(this.amount, other.amount) ? TypeFactory
        .createMoney(this.amount.add(other.amount)) : null;
  }

  public Money operator_multiply(Money other) {
    return nothingIsNull(this.amount, other.amount) ? TypeFactory
        .createMoney(this.amount.multiply(other.amount)) : null;
  }

  public Money operator_divide(Money other) {
    return nothingIsNull(this.amount, other.amount) ? TypeFactory
        .createMoney(this.amount.divide(other.amount, BigDecimal.ROUND_HALF_UP))
        : null;
  }

  public Money operator_minus(int other) {
    return TypeFactory.createMoney(this.amount.subtract(new BigDecimal(other)));
  }

  public Money operator_plus(int other) {
    return TypeFactory.createMoney(this.amount.add(new BigDecimal(other)));
  }

  public Money operator_multiply(int other) {
    return TypeFactory.createMoney(this.amount.multiply(new BigDecimal(other)));
  }

  public Money operator_divide(int other) {
    return TypeFactory.createMoney(this.amount.divide(new BigDecimal(other),
        BigDecimal.ROUND_HALF_UP));
  }

  @Override
  public int compareTo(Money other) {
    //TODO problamatic if any amount is null?
    return nothingIsNull(this.amount, other.amount) ? this.amount
        .compareTo(other.amount) : -1;
  }

  public boolean operator_equals(int other) {
    return this.amount.equals(new BigDecimal(other));
  }

  public boolean operator_notEquals(int other) {
    return !this.amount.equals(new BigDecimal(other));
  }

  private boolean nothingIsNull(BigDecimal... values) {
    for (BigDecimal bigDecimal : values) {
      if (bigDecimal == null)
        return false;
    }
    return true;
  }

}
