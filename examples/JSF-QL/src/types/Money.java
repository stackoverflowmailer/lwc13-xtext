package types;

import java.io.Serializable;
import java.math.BigDecimal;

public class Money implements Serializable {

	public static Money DEFAULT = new Money();

	private BigDecimal amount;

	public Money() {
		this.amount = BigDecimal.ZERO;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public static Money operator_minus(Money m1, Money m2) {
		// TODO added nullcheck,... :)
		if (m1 == null || m2 == null)
			return DEFAULT;
		Money result = new Money();
		result.amount = m1.amount.subtract(m2.amount);
		return result;
	}

	// TODO: Implement other operators
}
