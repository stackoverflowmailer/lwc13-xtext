package forms;

import java.io.Serializable;

import types.Money;

public class Box1HouseOwning implements Serializable {
	private boolean hasSoldHouse;

	private boolean hasBoughtHouse;

	private boolean hasMaintLoan;

	private Money sellingPrice;

	private Money privateDebt;

	private Money valueResidue;

	public Box1HouseOwning() {
		sellingPrice = new Money();
		privateDebt = new Money();
		valueResidue = new Money();
	}

	public boolean isHasSoldHouse() {
		return this.hasBoughtHouse;
	}

	public boolean isHasSoldHouseEnabled() {
		return false;
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

	public void setValueResidue(final Money valueResidue) {
		this.valueResidue = valueResidue;
	}

	public boolean isValueResidueEnabled() {
		return true;
	}

	public boolean isGroupHasSoldHouseAndHasBoughtHouseVisible() {
		boolean _and = false;
		if (!this.hasSoldHouse) {
			_and = false;
		} else {
			_and = (this.hasSoldHouse && this.hasBoughtHouse);
		}
		return _and;
	}

	// TODO undecided
	public boolean isGroupValueResidueVisible() {

		return (this.valueResidue != null)
				&& this.valueResidue.getAmount().intValue() != 0;
	}

	public void setHasSoldHouse(boolean hasSoldHouse) {
		this.hasSoldHouse = hasSoldHouse;
	}

	public Money getValueResidue() {
		// TODO general, not jsf specific
		this.valueResidue = Money.operator_minus(getSellingPrice(),
				getPrivateDebt());
		return valueResidue;
	}

}
