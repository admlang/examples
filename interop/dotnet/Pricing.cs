// A shop's pricing rules: the static methods main.adm declares and calls.
//
//   dotnet build interop/dotnet -o interop/dotnet/bin
using System;
using System.Globalization;
using System.Linq;

namespace Shop
{
    public static class Pricing
    {
        // The price of the items with the customer's discount taken off.
        public static double Total(double[] prices, int[] quantities, string customer) =>
            prices.Zip(quantities, (price, quantity) => price * quantity).Sum() * (1 - Discount(customer));

        // The discount a customer gets, from 0 to 1.
        public static double Discount(string customer) =>
            customer.EndsWith("@partner.example") ? 0.15 : customer.Length == 0 ? 0 : 0.05;

        // The label of each price, formatted as .NET formats money.
        public static string[] Labels(double[] prices, string currency) =>
            prices.Select(price => currency + " " + price.ToString("N2", CultureInfo.InvariantCulture)).ToArray();

        // The coupon a code stands for, or null when there is none.
        public static string? Coupon(string code) => code == "WELCOME" ? "10% off the first order" : null;

        // Refuses an order below the minimum.
        public static void Check(double total)
        {
            if (total < 10) throw new ArgumentException("orders start at 10.00, this one is " + total.ToString(CultureInfo.InvariantCulture));
        }
    }
}
