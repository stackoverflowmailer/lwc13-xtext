package forms;

import java.math.BigDecimal;

import types.Money;

public class Box1HouseOwning {
	private boolean hasSoldHouse;

	private boolean hasBoughtHouse;

	private boolean hasMaintLoan;

	private Money sellingPrice;

	private Money privateDebt;

	private Money valueResidue;

	private boolean x;

	private boolean y;

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
		this.valueResidue = this.sellingPrice.operator_minus(this.privateDebt);
		return this.valueResidue;
	}

	public boolean isValueResidueEnabled() {
		return getValueResidue() != null;
	}

	public boolean isX() {
		return this.y;
	}

	public boolean isXEnabled() {
		return false;
	}

	public boolean isY() {
		return this.x;
	}

	public boolean isYEnabled() {
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

	// TODO manually written
	public boolean isGroupValueResidueVisible() {

		return (this.valueResidue != null)
				&& this.valueResidue.getAmount().intValue() != 0;
	}

	// TODO initialization
	public Box1HouseOwning() {
		sellingPrice = new Money(new BigDecimal(0));
		privateDebt = new Money(new BigDecimal(0));
		valueResidue = new Money(new BigDecimal(0));
	}
}
