// A shop's pricing rules: the static methods main.adm declares and calls.
//
//   javac Pricing.java
public class Pricing {
    // The price of the items with the customer's discount taken off.
    public static double total(double[] prices, int[] quantities, String customer) {
        double sum = 0;
        for (int i = 0; i < prices.length; i++) sum += prices[i] * quantities[i];
        return sum * (1 - discount(customer));
    }

    // The discount a customer gets, from 0 to 1.
    public static double discount(String customer) {
        if (customer.endsWith("@partner.example")) return 0.15;
        return customer.isEmpty() ? 0 : 0.05;
    }

    // The label of each price, formatted as Java formats money.
    public static String[] labels(double[] prices, String currency) {
        String[] out = new String[prices.length];
        for (int i = 0; i < prices.length; i++) out[i] = String.format("%s %,.2f", currency, prices[i]);
        return out;
    }

    // The coupon a code stands for, or null when there is none.
    public static String coupon(String code) {
        return code.equals("WELCOME") ? "10% off the first order" : null;
    }

    // Refuses an order below the minimum.
    public static void check(double total) {
        if (total < 10) throw new IllegalArgumentException("orders start at 10.00, this one is " + total);
    }
}
