package converter;

import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;
import javax.faces.convert.FacesConverter;

import types.Money;

@FacesConverter("converter.Money")
public class MoneyConverter implements Converter {

	@Override
	public Object getAsObject(FacesContext ctx, UIComponent ui, String value) {
		Money money = new Money(value);
		return money;
	}

	@Override
	public String getAsString(FacesContext ctx, UIComponent ui, Object value) {
		return ((Money) value).getAmount().toString();
	}

}