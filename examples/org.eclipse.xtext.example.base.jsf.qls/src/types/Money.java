package types;

import java.io.Serializable;
import java.math.BigDecimal;

public class Money implements Serializable, Comparable<Money> {
  private static final long serialVersionUID = 1L;
  private BigDecimal amount;

  public Money(BigDecimal amount) {
    setAmount(amount);
  }

  public BigDecimal getAmount() {
    return amount;
  }

  public void setAmount(BigDecimal amount) {
    this.amount = amount;
    this.amount.setScale(2);
  }

  // Implement operators
  public Money operator_minus(Money other) {
    return new Money(this.amount.subtract(other.amount));
  }

  public Money operator_plus(Money other) {
    return new Money(this.amount.add(other.amount));
  }

  public Money operator_multiply(Money other) {
    return new Money(this.amount.multiply(other.amount));
  }

  public Money operator_divide(Money other) {
    return new Money(this.amount.divide(other.amount, BigDecimal.ROUND_HALF_UP));
  }

  public Money operator_minus(int other) {
    return new Money(this.amount.subtract(new BigDecimal(other)));
  }

  public Money operator_plus(int other) {
    return new Money(this.amount.add(new BigDecimal(other)));
  }

  public Money operator_multiply(int other) {
    return new Money(this.amount.multiply(new BigDecimal(other)));
  }

  public Money operator_divide(int other) {
    return new Money(this.amount.divide(new BigDecimal(other),
        BigDecimal.ROUND_HALF_UP));
  }

  @Override
  public int compareTo(Money other) {
    return this.amount.compareTo(other.amount);
  }

  public boolean operator_equals(int other) {
    return this.amount.equals(new BigDecimal(other));
  }

  public boolean operator_notEquals(int other) {
    return !this.amount.equals(new BigDecimal(other));
  }
}
