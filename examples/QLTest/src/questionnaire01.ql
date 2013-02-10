import types.Money

form Box1HouseOwning {
	hasSoldHouse: "Did you sell a house in 2010?" boolean  (hasBoughtHouse2 )
	hasBoughtHouse2: "Did you buy a house in 2010?" boolean
	hasMaintLoan1: "Did you enter a loan for maintenance/reconstruction?" boolean
	
	if (hasSoldHouse && hasBoughtHouse2  ) {
		sellingPrice1: "Price the house was sold for:" Money
		privateDebt6 : "Private debts for the sold house: " Money
		valueResidue1: "Value residue: " Money /*(sellingPrice - privateDebt)*/
	}  
}
