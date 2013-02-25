package types;

import java.math.BigDecimal;

public class Money {
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
		return new Money(this.amount.subtract(other.amount));
	}

	public Money operator_plus(Money other) {
		return new Money(this.amount.add(other.amount));
	}

	public Money operator_multiply(Money other) {
		return new Money(this.amount.multiply(other.amount));
	}

	public Money operator_divide(Money other) {
		return new Money(this.amount.divide(other.amount));
	}
}
