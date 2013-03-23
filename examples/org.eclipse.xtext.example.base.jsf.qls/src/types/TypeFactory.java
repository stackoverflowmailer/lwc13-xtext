package types;

import java.math.BigDecimal;

public class TypeFactory {
  public static Integer createInteger() {
    return 0;
  }

  public static Long createLong() {
    return 0l;
  }

  public static Double createDouble() {
    return 0.0d;
  }

  public static Float createFloat() {
    return 0.0f;
  }

  public static String createString() {
    return "";
  }

  public static Money createMoney() {
    return new Money(new BigDecimal(0));
  }
}
