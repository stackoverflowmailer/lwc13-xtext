package types;

import java.math.BigDecimal;

public class Money {
	private BigDecimal amount;

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	
	public Money operator_minus (Money m1, Money m2) {
		Money result = new Money();
		result.amount = m1.amount.subtract(m2.amount);
		return result;
	}
	
}
